Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab3BLR5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:57:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41275 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab3BLR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:57:33 -0500
Date: Tue, 12 Feb 2013 17:57:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance
	get_user() warnings
Message-ID: <20130212175709.GU17833@n2100.arm.linux.org.uk>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org> <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com> <5119C34B.70207@zytor.com> <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com> <CA+55aFwMr8pDfj+wuv=-tUFqZQOhnqkwC7tVq-S=4MGGWiqz1A@mail.gmail.com> <511A7892.4020407@zytor.com> <CA+55aFz=OnntmRvi6geuL7ccC6ncwQ7NvURDcwu87BkpS3H0TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz=OnntmRvi6geuL7ccC6ncwQ7NvURDcwu87BkpS3H0TQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 09:32:54AM -0800, Linus Torvalds wrote:
> On Tue, Feb 12, 2013 at 9:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > No, I think what he is talking about it this bit:
> 
> Ok, I agree that the bitfield code actually looks cleaner.
> 
> That said, maybe gcc has an easier time using a few odd builtins and
> magic typeof's. But at least the bitfield trick looks half-way
> portable..

I've just been trying hpa's solution on ARM, and I can't get it to work,
because the compiler refuses to put the struct { unsigned long long ... }
into the register(s) we need for the out of line assembly:

#define get_user(x,p)							\
	({								\
		register const typeof(*(p)) __user *__p asm("r0") = (p);\
		register int __e asm("r0");				\
		register struct {					\
			unsigned long long __r2:8 * sizeof(*(__p));	\
		} __v asm("r2");					\
		switch (sizeof(*(__p))) {				\
		case 1: 						\
			__get_user_x(__v.__r2, __p, __e, 1, "lr");	\
			break;						\
		case 2: 						\
			__get_user_x(__v.__r2, __p, __e, 2, "r3", "lr");\
			break;						\
		case 4: 						\
			__get_user_x(__v.__r2, __p, __e, 4, "lr");	\
			break;						\
		case 8: 						\
			__get_user_x(__v.__r2, __p, __e, 8, "lr");	\
			break;						\
		default: __e = __get_user_bad(); break; 		\
		}							\
		x = (typeof(*(__p))) __v.__r2;				\
		__e;							\
	})

This ends up with __v.__r2 ending up in r1/(r2) not r2/(r3).

However, I do have a working solution for 32-bit ARM which seems to work
fine with my test cases here, though as I mentioned to hpa, it may not
be portable to other 32-bit architectures:

#ifdef BIG_ENDIAN
#define __get_user_xb(__r2,__p,__e,__s,__i...)				\
	__get_user_x(__r2,(unsigned)__p+4,__e,__s,__i)
#else
#define __get_user_xb __get_user_x
#endif

#define get_user(x,p)							\
	({								\
		register const typeof(*(p)) __user *__p asm("r0") = (p);\
		register int __e asm("r0");				\
		register typeof(x) __r2 asm("r2");			\
		switch (sizeof(*(__p))) {				\
		case 1: 						\
			__get_user_x(__r2, __p, __e, 1, "lr");		\
			break;						\
		case 2: 						\
			__get_user_x(__r2, __p, __e, 2, "r3", "lr");	\
			break;						\
		case 4: 						\
			__get_user_x(__r2, __p, __e, 4, "lr");		\
			break;						\
		case 8: 						\
			{						\
			if (sizeof((x)) < 8)				\
				__get_user_xb(__r2, __p, __e, 4, "lr"); \
			else						\
				__get_user_x(__r2, __p, __e, 8, "lr");	\
			}						\
			break;						\
		default: __e = __get_user_bad(); break; 		\
		}							\
		x = (typeof(*(__p))) __r2;				\
		__e;							\
	})

It's risky because it relies upon a "register" being allocated as 32-bits
even if typeof(x) is 8-bit or 16-bit.
