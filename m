Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab3BLRau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:30:50 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34573 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab3BLRat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <511A7892.4020407@zytor.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
	<tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
	<CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
	<5119C34B.70207@zytor.com>
	<CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com>
	<CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com>
	<511A7892.4020407@zytor.com>
Date: Tue, 12 Feb 2013 09:30:48 -0800
Message-ID: <CAMe9rOrqDjBQjLyDRWJqRKdzQf1zMXHwXxFk2DekC+EeCHa8UA@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user() warnings
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 9:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/12/2013 09:00 AM, Linus Torvalds wrote:
>> On Tue, Feb 12, 2013 at 8:38 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
>>>
>>> Can you do something similar to what we did in glibc:
>>
>> No. Because we use macros to be type-independent (i e"get_user()"
>> works *regardless* of type), so casting to "uintptr_t" doesn't work.
>> It throws away the type information, and truncates 64-bit values on
>> 32-bit architectures.
>>
>> The whole point of the bitmask thing is that it doesn't have that
>> issue, and gets the size correct automatically. It's not pretty, but
>> it allows the rest of the sources to be readable.
>>
>
> No, I think what he is talking about it this bit:
>
> /* 1 if 'type' is a pointer type, 0 otherwise.  */
> # define __pointer_type(type) (__builtin_classify_type ((type) 0) == 5)
>
> /* __intptr_t if P is true, or T if P is false.  */
> # define __integer_if_pointer_type_sub(T, P) \
>   __typeof__ (*(0 ? (__typeof__ (0 ? (T *) 0 : (void *) (P))) 0 \
>                   : (__typeof__ (0 ? (__intptr_t *) 0 : (void *)(!(P)))) 0))
>
> /* __intptr_t if EXPR has a pointer type, or the type of EXPR otherwise.  */
> # define __integer_if_pointer_type(expr) \
>   __integer_if_pointer_type_sub(__typeof__ ((__typeof__ (expr)) 0), \
>                                 __pointer_type (__typeof__ (expr)))
>
> /* Cast an integer or a pointer VAL to integer with proper type.  */
> # define cast_to_integer(val) ((__integer_if_pointer_type (val)) (val))
>
> Good grief, this makes the bitfield look like Mona Lisa.  On the other
> hand, it relies on the *entirely* undocumented __builtin_classify_type()
> -- there appears to be absolutely no reference to it in gcc documentation.
>
> H.J., do you know what the bounds on the __builtin_classify_type() are
> (gcc versions available and so on)?  Sadly I don't think one can use
> __builtin_types_compatible_p() instead.
>
>         -hpa
>

__builtin_classify_type is documented in "info gccint".  typeclass.h has

/* Values returned by __builtin_classify_type.  */

enum type_class
{
  no_type_class = -1,
  void_type_class, integer_type_class, char_type_class,
  enumeral_type_class, boolean_type_class,
  pointer_type_class, reference_type_class, offset_type_class,
  real_type_class, complex_type_class,
  function_type_class, method_type_class,
  record_type_class, union_type_class,
  array_type_class, string_type_class,
  lang_type_class
};

__builtin_classify_type ((type) 0) == 5 is compatible with all GCCs,
dating back as far as the first checkin when GCC was switched
to CVS from RCS in 1989, which predates the current Linux kernel:

commit 17cf341d65a3766f6451fe3bc20b9c010d38ba3b
Author: mycroft <mycroft@138bc75d-0d04-0410-961f-82ee72b054a4>
Date:   Sun Aug 13 19:24:27 1989 +0000

    entered into RCS


    git-svn-id: svn+ssh://gcc.gnu.org/svn/gcc/trunk@3
138bc75d-0d04-0410-961f-82ee72b054a4

diff --git a/gcc/typeclass.h b/gcc/typeclass.h
new file mode 100644
index 0000000..b166042
--- /dev/null
+++ b/gcc/typeclass.h
@@ -0,0 +1,14 @@
+/* Values returned by __builtin_classify_type.  */
+
+enum type_class
+{
+  no_type_class = -1,
+  void_type_class, integer_type_class, char_type_class,
+  enumeral_type_class, boolean_type_class,
+  pointer_type_class, reference_type_class, offset_type_class,
+  real_type_class, complex_type_class,
+  function_type_class, method_type_class,
+  record_type_class, union_type_class,
+  array_type_class, string_type_class, set_type_class, file_type_class,
+  lang_type_class
+};


-- 
H.J.
