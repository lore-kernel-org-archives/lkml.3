Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaENMVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:21:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:43064 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaENMVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:21:39 -0400
Date: Wed, 14 May 2014 14:21:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <8468354.y2kUZdOz9e@wuerfel>
Message-ID: <alpine.DEB.2.02.1405141359460.6261@ionos.tec.linutronix.de>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <8399002.IIyBoyEHox@wuerfel> <CAMuHMdW5HSVyXpz9HFcrDDYq=zOFrBr6d8jOd8i_FMkXsEpr2Q@mail.gmail.com> <8468354.y2kUZdOz9e@wuerfel>
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
> On Tuesday 13 May 2014 22:35:08 Geert Uytterhoeven wrote:
> > 
> > On Tue, May 13, 2014 at 9:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > I think we have three categories:
> > 
> > Thanks for the list!
> > 
> > > a) interfaces that uses relative time_t/timespec/timeval:
> > > b) interfaces that don't make sense for times in the past:
> > 
> > > c) interfaces that require absolute times:
> > >    - stat/lstat/fstatat/
> > >    - utime/utimes/futimesat
> > >
> > > These absolutely have to use something better than time_t
> > > both in user space and in the kernel so we can deal with
> > > old files. A lot of file systems need to be fixed as well so
> > > we can actually store the times, regardless of whether we
> > > are running a 32 or 64 bit kernel.
> > 
> > So these are the ones we have to worry about.
> > It looks like they all involve I/O? Apart from the case of using block data
> > from the buffer cache, the 64-bit operations should disappear in the
> > actual I/O noise, right?
> 
> Right. Also there have been proposals for a better 'stat' replacement
> for years, which would solve half of the interface problem for the
> file system interfaces.
> 
> However, we also need to find a solution for category b), I only put
> them into a different category above because we can treat them
> differently in the kernel. For instance, we could use ktime_t for
> the kernel code in category b) and a new struct timespec64 for
> the times in struct inode.
> On the user interface side, using timespec64 would be a reasonable
> choice for both categories, because we already have two implementations
> of all those syscalls in order to handle 32-on-64 compat tasks,
> and we could use the same set of syscall implementations for time64-on-32.

So in the 32-on-64 case we'll have two compat variants:

SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
       	   	struct timespec __user *, utime, u32 __user *, uaddr2,
                u32, val3)

COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
                u32, val3)

COMPAT_SYSCALL_DEFINE6(futex64, u32 __user *, uaddr, int, op, u32, val,
		struct timespec64 __user *, utime, u32 __user *, uaddr2,
                u32, val3)

The native 64bit futex64 syscall is mapped to futex.

And for a 32bit kernel you have two

SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
       	   	struct timespec __user *, utime, u32 __user *, uaddr2,
                u32, val3)

SYSCALL_DEFINE6(futex64, u32 __user *, uaddr, int, op, u32, val,
		struct timespec64 __user *, utime, u32 __user *, uaddr2,
                u32, val3)

Fine with me, but we really need to discuss the timespec64 with user
space folks.

I'm curious, whether quite some code, like high frequency timestamps
wouldn't be better of with a strict 64 bit nanosecond granular time
represenation.

I often enough cursed timespec for clock_nanosleep on an absolute
timeline. I need to go through all that normalizing stuff instead of
just doing next_event += 500000;

Thanks,

	tglx
