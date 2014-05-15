Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaEOUjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:39:14 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:57336 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaEOUjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:39:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Thu, 15 May 2014 22:38:29 +0200
Message-ID: <9236147.lyD24Zv5SZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <4706636.rTYoqSXXOR@wuerfel> <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iJWcIzoQGMK3QdBunWBecMsUVh/cTIu8dXP+ixSCAkp
 qEl7ZiKhxgkWId9EyWkPLWkZiSqr1vEc/axnlexvPVifWBt84M
 Y3cHW3MZHNWqkhmA4bIp/8hsqDM0kiVeiwLOTXDFeKpJZWo+fx
 D+f3e1MYZDVXPHMSTJRkWV+SGY+qnb4PaEcflaSREyEBm+Uc+O
 g+7pgoYaqzzlAVE+AQl8pm7uQpcFxm0Ukk1B11qMKI33h4c2Fx
 CLAk/M1sYhj5pCAAXouPs2O/BN34u+2cufUCcZbsWmr78ccpHl
 gf0npg8KIYLpbFTgkgeZEGei8J4PMhSZ2w/b4WbC4lJYmH59I/
 A4DrjzJh0j0oFf+hW47o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 20:10:05 Joseph S. Myers wrote:
> On Thu, 15 May 2014, Arnd Bergmann wrote:
> 
> > Earlier in the thread there seemed to be a rough consensus that
> > _TIME_BITS=64 wouldn't be a good idea because we wouldn't get everything
> > changed to use it. For _FILE_OFFSET_BITS=64 that's ok because most
> > user space doesn't ever want to deal with large files.
> 
> Well, I'm coming into this in the middle since it isn't on linux-api and 
> noone has tried to work out on libc-alpha what things should look like 
> from the glibc side.  _TIME_BITS seemed to make sense when I thought about 
> this previously, however.
> 
> > Can you elaborate on how the switch to the new default would work?
> 
> At some appropriate release (probably after _TIME_BITS=64 is widely used 
> in distributions), the glibc headers would change so that _TIME_BITS=64 is 
> the default and _TIME_BITS=32 can be set to get the old interfaces.  At 
> some later point _TIME_BITS=32 API support might be removed, leaving the 
> old symbols as compat symbols for existing binaries.

Ok.

> > If it's easy, why hasn't it been done for _FILE_OFFSET_BITS already
> > and what's stopping us from changing the default as soon as the interfaces
> > are there? If it's hard, what would need to happen before the default
> > time_t can be set?
> 
> The distribution side of the change for _FILE_OFFSET_BITS (i.e., moving to 
> building libraries that way so a glibc change to the default wouldn't 
> cause issues for other libraries' ABIs) has gradually been done.  The 
> discussion in March on libc-alpha about changing the default tailed off.  
> This is something that needs someone to take the lead with a *careful and 
> detailed analysis of the information from the previous discussion* in 
> order to present a properly reasoned proposal for a change to the default 
> - not scattergun patches, not patches with brief or no analysis of the 
> environment in which glibc is used, not dismissing concerns, but a 
> properly reasoned argument for why the change should be made, along with 
> details of how distributions can determine whether ABI issues would arise 
> from rebuilding a particular library against newer glibc.

Ok, I see. I wasn't aware that distributions actually set _FILE_OFFSET_BITS
globally for building packages. I guess the effect (from the distro point
of view) of that is similar to having a configure option when building glibc
as I expected to be the normal way to do it.

> > > Obviously 64-bit time_t syscalls would be an appropriately narrow set of 
> > > syscalls like those in the generic ABI (so glibc would implement stat for 
> > > _TIME_BITS=64 using fstatat64_time64 or whatever the syscall is called, 
> > > just as the stat functions for generic ABI architectures are implemented 
> > > with newfstatat / fstatat64 rather than lots of separate syscalls.
> > 
> > This assumes that we'd leave the kernel time_t/timespec/timeval using 'long'
> > and introduce a new timespec64 using a signed 64-bit type, rather than
> > changing the kernel headers to the new syscalls and data structures with
> > new names for the existing ones, right?
> 
> Yes.  I consider it simply common sense that new kernel headers should 
> continue to work with much older glibc, meaning that the API (syscall 
> names etc.) presented by the headers from headers_install should not 
> change incompatibly.

Right. we have done it both ways in the past, but it seems that renaming
syscalls hasn't been done in some time. I can only find definitions for
oldfstat, oldlstat, oldolduname, olduname, oldumount, vm86old and oldwait4.
It's possible they all predate libc6.

> (64-bit type only for time_t, of course.  There's no need for a 64-bit 
> type for nanoseconds and tv_nsec is explicitly "long" in POSIX, meaning 
> that if the kernel uses a 64-bit type for nanoseconds on systems where 
> "long" is 32-bit in userspace, either it needs to treat the high word as 
> padding or glibc needs to wrap all interfaces passing a struct timespec 
> into the kernel so they clear the padding field.  There's even less need 
> for a 64-bit type for microseconds.)

For practical purposes in the kernel, we may still want to use 64-bit
nanoseconds: if we use a 96 bit struct timespec, that would be incompatible
with the native type on 64-bit kernels, thus complicating the syscall
emulation layer.

I don't know why timespec on x32 uses 'long tv_nsec', it does seem
problematic.

What could work is a type that has explicit padding:

struct timespec {
	__s64 tv_sec;
#ifdef BIG_ENDIAN_32BIT
	u32 __pad;
#endif
	long tv_nsec;
#ifdef LITTLE_ENDIAN_32BIT
	u32 __pad;
#endif
};

For timeval, I think we don't care about the padding, because we wouldn't
use it on new interfaces when the kernel uses nanosecond resolution
internally.

	Arnd
