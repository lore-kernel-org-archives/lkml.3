Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaENOqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:46:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:44648 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaENOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:46:22 -0400
Date: Wed, 14 May 2014 16:46:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <6811994.pqkAjrM8xH@wuerfel>
Message-ID: <alpine.DEB.2.02.1405141628130.6261@ionos.tec.linutronix.de>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <8468354.y2kUZdOz9e@wuerfel> <alpine.DEB.2.02.1405141359460.6261@ionos.tec.linutronix.de> <6811994.pqkAjrM8xH@wuerfel>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Arnd Bergmann wrote:

> On Wednesday 14 May 2014 14:21:48 Thomas Gleixner wrote:
> > 
> > So in the 32-on-64 case we'll have two compat variants:
> > 
> > SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
> >                 struct timespec __user *, utime, u32 __user *, uaddr2,
> >                 u32, val3)
> > 
> > COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
> >                 struct compat_timespec __user *, utime, u32 __user *, uaddr2,
> >                 u32, val3)
> > 
> > COMPAT_SYSCALL_DEFINE6(futex64, u32 __user *, uaddr, int, op, u32, val,
> >                 struct timespec64 __user *, utime, u32 __user *, uaddr2,
> >                 u32, val3)
> > 
> > The native 64bit futex64 syscall is mapped to futex.
> 
> I was actually hoping that we could map the compat futex64 to futex
> as well here, since 64-bit timespec and compat timespec64 would be
> the same structure.

Right, that might work with this one, but not for anything which has a
pointer to a timespec and some other argument based on long.

> > I'm curious, whether quite some code, like high frequency timestamps
> > wouldn't be better of with a strict 64 bit nanosecond granular time
> > represenation.
> 
> At least in the kernel, I think ktime_t is already the right type
> to use on both 64-bit and 32-bit architectures as it can be slow to
> extract the seconds portion of 64-bit nanoseconds on a 32-bit machine.

On some of them yes. On i386 the u64 nsec ktime_t variant is way more
efficient.

> FWIW, 64-bit ns gives us 584 years worth of nanoseconds, which
> means none of us or the people we know will be around before this
> becomes a problem ;-)

Indeed.
 
> For the user interface, we can decide which representation to use
> for each syscall individually depending on the needs. We should just
> not have to many different variants. I was going for timespec64
> just because that would allow us to keep the 64-bit kernel ABI
> unchanged.

Right. It's the way of least resistance.

If there are desires from user space to have a new format instead of
blindly timespec64 for certain syscalls, we should really think
discuss that on a case by case basis.

Thanks,

	tglx

 
