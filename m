Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaEaPLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:11:10 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:54438 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaEaPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:11:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 02/32] uapi: add struct __kernel_timespec{32,64}
Date: Sat, 31 May 2014 17:09:25 +0200
Message-ID: <5129309.tUSSHZWN3t@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5388E7A5.90308@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-3-git-send-email-arnd@arndb.de> <5388E7A5.90308@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PTLxkFYwmS63YcQxAKRXu9YlCWQF+Fp7flG4ajwRAJN
 fOvLz8QM4SGDz6Ox1e0QxGJ5CDJWv6hjDXgnpRuSsey2dgNJAe
 IBbkwGqkpwp3fln5QL4oASr1PuWOxhSQgnXW81diFHOdcntTBc
 kad28T44JlUzoTqyLn+K5r3DVOrwhjs6Tji3QjHrgXAzNyt5Fe
 aG7eV6l5FVQL6JZ0kwXm79AVbDQh5R0wwethO1hq1GzU7PzAmr
 meiIVHvpmfUHnwcOGiErzOnY1FoY2Di0109fJCdDmNoAYOthlr
 M/xpsW0naKJBgX34Z5dtB6/33FVy/NgOSQK4kwOCl+vod9nG92
 /mFOV6oQbtTCB5hAMjfQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2014 13:18:45 H. Peter Anvin wrote:
> On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
> > We cannot use time_t or any derived structures beyond the year
> > 2038 in interfaces between kernel and user space, on 32-bit
> > machines.
> > 
> > This is my suggestion for how to migrate syscall and ioctl
> > interfaces: We completely phase out time_t, timeval and timespec
> > from the uapi header files and replace them with types that are
> > either explicitly safe (__kernel_timespec64), or explicitly
> > unsafe (e.g. __kernel_timespec32). For each unsafe interface,
> > there needs to be a safe replacement interface.
> > 
> 
> This gets really messy for structures where this is ABI-dependent.  I'm
> not sure this is a net win.

We could have an extra '__kernel_oldtimespec' type that we can
use for all ABIs that are today defined in terms of timespec.

What I was mostly trying to avoid here is leaving any 'struct timespec'
in header files, because glibc may define that type differently
depending on a __TIME_BITS macro. This is more of a problem for
ioctls than for system calls.

> > +/*
> > + * __kernel_timespec64 is the general type to be used for
> > + * new user space interfaces passing a time argument.
> > + * 64-bit nanoseconds is a bit silly, but the advantage is
> > + * that it is compatible with the native 'struct timespec'
> > + * on 64-bit user space. This simplifies the compat code.
> > + */
> > +struct __kernel_timespec64 {
> > +	long long tv_sec;
> > +	long long tv_nsec;
> > +};
> 
> So it seems that it is not just POSIX that is drain bramaged with this,
> but the "long" type for tv_nsec idiocy has made it into the C11
> standard.  This unfortunately means that now there are two standards
> bodies involved, at least one of which moves very slowly.

My feeling is that our best hope is to completely isolate the kernel
interfaces from what user space wants to have as time_t. glibc for
instance may have a different idea about standards compliance than
android or klibc.

> This makes me wonder if we don't need to deal with the problem in the
> case of 32-bit ABIs with 64-bit time_t.  The logical thing seems to be
> to EITHER:
> 
> a. ALWAYS ignore the upper 32 bits of tv_nsec when read from user space,
>    but always set them to zero, or
> b. Only ignore the upper 32 bits of tv_nsec when we are known to come
>    from a 32-bit ABI context, but still always return zero.  These bits
>    are already only used for validity checking.
> 
>    This most likely introduces a whole lot of new tests in deep paths,
>    although we probably can centralize this in a single function, which
>    otherwise ends up looking a lot like compat_get_timespec().
> 
> Getting rid of struct timespec on the kernel/user boundary is probably
> not really feasible.

My approach was based on the discussion with Joseph, who would like glibc
to support both 32 and 64 bit time_t using the same libc binary and 
versioned symbols. I don't see how that could work when you build a
user space program that sees a timespec in kernel headers and tries
to pass that into a non-translated kernel interface (e.g. ioctl) but
use the same timespec for a glibc-provided function like gettimeofday().

	Arnd
