Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab3BLRPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:15:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51763 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458Ab3BLRPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:15:47 -0500
Message-ID: <511A7892.4020407@zytor.com>
Date: Tue, 12 Feb 2013 09:14:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
 warnings
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org> <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com> <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com> <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com>
In-Reply-To: <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 09:00 AM, Linus Torvalds wrote:
> On Tue, Feb 12, 2013 at 8:38 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
>>
>> Can you do something similar to what we did in glibc:
> 
> No. Because we use macros to be type-independent (i e"get_user()"
> works *regardless* of type), so casting to "uintptr_t" doesn't work.
> It throws away the type information, and truncates 64-bit values on
> 32-bit architectures.
> 
> The whole point of the bitmask thing is that it doesn't have that
> issue, and gets the size correct automatically. It's not pretty, but
> it allows the rest of the sources to be readable.
> 

No, I think what he is talking about it this bit:

/* 1 if 'type' is a pointer type, 0 otherwise.  */
# define __pointer_type(type) (__builtin_classify_type ((type) 0) == 5)

/* __intptr_t if P is true, or T if P is false.  */
# define __integer_if_pointer_type_sub(T, P) \
  __typeof__ (*(0 ? (__typeof__ (0 ? (T *) 0 : (void *) (P))) 0 \
		  : (__typeof__ (0 ? (__intptr_t *) 0 : (void *)(!(P)))) 0))

/* __intptr_t if EXPR has a pointer type, or the type of EXPR otherwise.  */
# define __integer_if_pointer_type(expr) \
  __integer_if_pointer_type_sub(__typeof__ ((__typeof__ (expr)) 0), \
				__pointer_type (__typeof__ (expr)))

/* Cast an integer or a pointer VAL to integer with proper type.  */
# define cast_to_integer(val) ((__integer_if_pointer_type (val)) (val))

Good grief, this makes the bitfield look like Mona Lisa.  On the other
hand, it relies on the *entirely* undocumented __builtin_classify_type()
-- there appears to be absolutely no reference to it in gcc documentation.

H.J., do you know what the bounds on the __builtin_classify_type() are
(gcc versions available and so on)?  Sadly I don't think one can use
__builtin_types_compatible_p() instead.

	-hpa

