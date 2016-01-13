;;;===================================================================
;;; This file was generated by Org. Do not edit it directly.
;;; Instead, edit Lodox.org in Emacs and call org-babel-tangle.
;;;===================================================================

(defmodule lodox-p
  (export (clauses? 1) (clause? 1)
          (arglist? 1) (arg? 1)
          (string? 1)
          (null? 1)))

(defun clauses? (forms)
  "Return `true` iff `forms` is a list of items that satisfy [[clause?/1]]."
  (andalso (lists:all #'clause?/1 forms)
           (let ((arity (length (caar forms))))
             (lists:all (lambda (form) (=:= (length (car form)) arity)) forms))))

(defun clause?
  "Given a term, return `true` iff it is a list whose head satisfies [[arglist?/1]]."
  ([`(,_)]      'false)
  ([`([] . ,_)] 'false)
  ([`(,h . ,_)] (arglist? h))
  ([_]          'false))

(defun arglist?
  "Given a term, return `true` iff it is either the empty list or a list
such that all elements satisfy [[arg?/1]]."
  (['()]                      'true)
  ([lst] (when (is_list lst)) (lists:all #'arg?/1 lst))
  ([_]                        'false))

(defun arg?
  "Return `true` iff `x` seems like a valid item in an arglist."
  ([(= x `(,h . ,_t))]
   (orelse (string? x)
           (lists:member h '(= () backquote quote binary list map tuple))
           (andalso (is_atom h) (lists:prefix "match-" (atom_to_list h)))))
  ([x]
   (lists:any (lambda (p) (funcall p x))
              (list #'is_atom/1
                    #'is_binary/1
                    #'is_bitstring/1
                    #'is_number/1
                    #'is_map/1
                    #'is_tuple/1
                    #'string?/1))))

(defun string? (data)
  "Return `true` iff `data` is a flat list of printable characters."
  (io_lib:printable_list data))

(defun null?
  "Return `true` iff `data` is the empty list."
  (['()] 'true)
  ([_]   'false))
