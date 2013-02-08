Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946625Ab3BHP3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:29:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38375 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946522Ab3BHP3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:29:11 -0500
Date: Fri, 8 Feb 2013 15:28:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sound/pci/asihpi/hpioctl.c:125:6: warning: cast to pointer
	from integer of different size
Message-ID: <20130208152858.GU17833@n2100.arm.linux.org.uk>
References: <51143ca4.bNX7TobZ2rDrz0zj%fengguang.wu@intel.com> <511460B7.4030007@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511460B7.4030007@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 06:19:35PM -0800, H. Peter Anvin wrote:
> On 02/07/2013 03:45 PM, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/mm
> > head:   6fcddf474ae1c8e2fb5f14c850c8aa018e7a5034
> > commit: 6fcddf474ae1c8e2fb5f14c850c8aa018e7a5034 x86-32: Add support for 64bit get_user()
> > date:   2 hours ago
> > config: make ARCH=i386 allmodconfig
> >
> > All warnings:
> >
> >    sound/pci/asihpi/hpioctl.c: In function 'asihpi_hpi_ioctl':
> >>> sound/pci/asihpi/hpioctl.c:125:6: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >>> sound/pci/asihpi/hpioctl.c:126:6: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> > --
> >    net/atm/resources.c: In function 'atm_dev_ioctl':
> >>> net/atm/resources.c:223:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >>> net/atm/resources.c:274:7: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> > --
>
> [... and so on ...]
>
> Now I remember this problem.  I believe I discussed it with rmk in the
> context of ARM, too.  Russell, did we ever find any way to implement
> 8-byte get_user() on 32 bits without massive warning spewage?

My last attempt for ARM that I can find (though it wasn't my last email)
was:

#define __get_user_x(__r2,__p,__e,__s,__i...)				\
	   __asm__ __volatile__ (					\
		"bl	__get_user_" #__s				\
		: "=&r" (__e), "=r" (__r2)				\
		: "0" (__p)						\
		: __i, "cc")

#ifdef BIG_ENDIAN
#define __get_user_xb(__r2,__p,__e,__s,__i...)				\
	__get_user_x(__r2,(uintptr_t)__p + 4,__s,__i)
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
			if (sizeof((x)) < 8)				\
				__get_user_xb(__r2, __p, __e, 4, "lr"); \
			else						\
				__get_user_x(__r2, __p, __e, 8, "lr");	\
			break;						\
		default: __e = __get_user_bad(); break; 		\
		}							\
		x = (typeof(*(__p))) __r2;				\
		__e;							\
	})

which I claimed did work for ARM, but I doubted it'd work everywhere
because it relies upon there being no 8-bit or 16-bit "registers" being
available - iow, it replies upon a register for byte and half-word
variables being a full register where the value gets sign-extended to
the full register.

This is important because of the "typeof(x) __r2 asm("r2")" which may
end up being a char, short or int-sized, but __get_user_x() effectively
writing to the whole word.

Consider the case where 'x' and '*p' are two different sizes.

Whether that's safe for x86 or not, I don't know, but my suspicions are
that it's unsafe on x86 as it's possible to refer to the various bytes/
half-words of eax separately.

So, I came to the conclusion that if x86 remains a problem, there's
little point supporting it on ARM.
