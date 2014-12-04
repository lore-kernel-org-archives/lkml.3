Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbaLDQrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:47:25 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:45929 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaLDQrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:47:22 -0500
Date: Thu, 4 Dec 2014 11:47:17 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] optimize ktime_divns for constant divisors
In-Reply-To: <2362381.LDAGLC19vb@wuerfel>
Message-ID: <alpine.LFD.2.11.1412041136050.470@knanqh.ubzr>
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr> <2165831.DQoLFmGhIf@wuerfel> <alpine.LFD.2.11.1412040837130.470@knanqh.ubzr> <2362381.LDAGLC19vb@wuerfel>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014, Arnd Bergmann wrote:

> On Thursday 04 December 2014 08:46:27 Nicolas Pitre wrote:
> > On Thu, 4 Dec 2014, Arnd Bergmann wrote:
> > Note the above code is for 32-bit architectures that support a 32x32=64 
> > bit multiply instruction.  And even then, what kills performances is the 
> > inhability to efficiently deal with carry bits from C code.  Hence the 
> > far better output from do_div() on ARM.
> > 
> > If x86-64 has a 64x64=128 bit multiply instruction then the above may 
> > greatly be simplified to a single multiply and a shift.  That would 
> > possibly outperform do_div().
> 
> I was trying this in 32-bit mode to see how it would work in x86-32
> kernels. Since that architecture has a 64-by-32 divide instruction,
> that gets used here.
> 
> x86-64 has a 64x64=128 multiply instruction and gcc uses that for
> any 64-bit division by constant, so that's what already happens
> in do_div. I assume for any 64-bit architecture, the result will
> be similar.

OK.  In that case x86-64 will also benefit from the patch at the 
beginning of this thread.

> I guess the only architectures that would benefit from your implementation
> above are the ones that do not have any optimization for constant
> 64-by-32-bit division and just call do_div.

And then it would be best to optimize do_div() directly so all users 
would benefit.

> > > On a related note, I wonder if we can come up with a more efficient
> > > implementation for do_div on ARMv7ve, and I think we should add the
> > > Makefile logic to build with -march=armv7ve when we know that we do
> > > not need to support processors without idiv.
> > 
> > Multiplications will always be faster than divisions.  However the idiv 
> > instruction would come very handy in the slow path when the divisor is 
> > not constant.
> 
> Makes sense. I also just checked the gcc sources and it seems that the
> idiv/udiv instructions on ARM are not even used for implementing
> __aeabi_uldivmod there. Not sure if that's intentional, but we probably
> don't need to bother optimizing this in the kernel before user space
> does.

I wouldn't say so.  There are many precedents where we optimized those 
things in the kernel before gcc caught up.  In a few cases I contributed 
the same optimized arithmetic routines to both gcc and the kernel.

> Building with -march=armv7ve still sounds helpful to avoid the
> __aeabi_uidiv calls though.

Yep.


Nicolas
