Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaHMU1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:27:53 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49301 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaHMU1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:27:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: ksummit-discuss@lists.linuxfoundation.org
Cc: John Stultz <john.stultz@linaro.org>, josh@joshtriplett.org,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-discuss] (Resend) 2038 Kernel Summit Discussion Fodder
Date: Wed, 13 Aug 2014 22:27:46 +0200
Message-ID: <2616114.Ne3BsHa212@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53EADF3F.20909@linaro.org>
References: <53EAAC95.7080301@linaro.org> <20140813013342.GB6783@cloud> <53EADF3F.20909@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:uNuupULPUMhEToltZjGSDZbvYpeDCb92y2Ne7ZpZ0iP
 jBqtinH58C6axLdSVLNP9k7O0gGX/DUcARiXDj9DyNxE2BG8Gy
 YF1KZ9aJwdLtgPgpH6Gbs0c6pNTK2Lsyz1oCkaddz7elTMQFbO
 vTIaAB5e7kPr+1q/poKG+5tIlrQtBbH/jMztjVBRJ/LPPVmg5c
 o/DGa2KGAQlp6pRWB+smVDanxg8B+xf0PLBgs1SOj+g8RyE1zo
 rxLWIxOH6xnvcE/cXAxtpBCrfXvmkbhPFmeLlRE0EDDDgFo66g
 ejVi3svBYWsLJJk656JwfgqrK2NCsb/BsTGx2YlWW2wT+9bHB0
 INdADZXPFAe5Yh2vPsXw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2014 20:45:03 John Stultz wrote:
> On 08/12/2014 06:33 PM, josh@joshtriplett.org wrote:
> > On Tue, Aug 12, 2014 at 05:08:53PM -0700, John Stultz wrote:
> >> Also, just to clarify, as time related discussions can bring out a laundry
> >> list of issues, I would like to focus this discussion on providing a 2038
> >> solution for existing interfaces and applications in a way that ideally
> >> doesn't require modifying application source code.  While there will be
> >> plenty of places where applications have cast or stored time_t values
> >> explicitly as longs, and for those applications, deep modifications will be
> >> necessary. But I’d like to avoid getting into new-interface discussions,
> >> like exporting ktime_t like nanosecond interfaces instead of timepsecs,
> >> unifying time-stamping formats, or methods for avoiding leapseconds. Those
> >> are all interesting issues, and I’d be up for discussing them separately,
> >> but those issue apply equally to 32bit and 64bit systems, and really aren't
> >> 2038 specific, so I think its best to separate them out.
> > That's understandable.  However, I wonder to what extent we could
> > support unmodified source code via libc wrappers (since code calling
> > syscalls directly can't work completely unmodified), while using better
> > interfaces for new syscalls.  Given syscalls written in terms of (for
> > instance) nanoseconds rather than timespec values, it seems
> > straightforward enough for libc to provide compatibility interfaces.
> 
> So we'd be then introducing new syscalls not just for 32bit but 64bit
> systems as well, and its a fairly substantial list:
>     http://kernelnewbies.org/y2038
> 
> Again, I worry that just getting time_t to be 64bits is a big enough
> problem to solve without trying to mix in interface preference
> discussions along, adding totally new interfaces, coordinating all the
> libcs out there to provide wrappers, and then deprecating the old
> interfaces.
> 
> If there are more desirable interfaces wanted, I really think that needs
> to be a separate topic from fixing the ones we have.

Agreed. I originally argued the same ways as Josh in the conversations
we had a few weeks ago, but I think you are right.

It essentially comes down to the question what code paths we want to
change. Introducing completely new syscall ABIs means we also have to
change all 64-bit architectures to support those, while the plain
1:1 replacement means we only impact the 32-bit native and compat
(under a 64-bit kernel) cases that actually want this change.

> > If we go this route, we should also provide a "depends on EMBEDDED"
> > Kconfig option that omits all of the compatibility support, for systems
> > that have fully migrated to new userspace.
> 
> Right, though I think for any of the solutions, having methods to
> actually remove support for the 2038 unsafe interfaces is important to
> help ensure systems are completely converted.

Yes. The way I'd do this is to introduce a new 'CONFIG_COMPAT_TIME' symbol
that initially designates the architectures that are have assigned syscall
numbers to the newly introduced calls, turning e.g.

SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
                const struct timespec __user *, rqtp,
                struct timespec __user *, rmtp)
{
	...
}

into this:

#if defined(CONFIG_COMPAT_TIME) || defined(CONFIG_64BIT)
#define __kernel_timespec __kernel_timespec64
#else
#define __kernel_timespec __kernel_timespec32
#endif

#ifdef CONFIG_COMPAT_TIME
SYSCALL_DEFINE4(compat_clock_nanosleep, const clockid_t, which_clock, int, flags,
                const struct __kernel_timespec32 __user *, rqtp,
                struct __kernel_timespec32 __user *, rmtp)
{
	...
}
#endif

SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
                const struct __kernel_timespec __user *, rqtp,
                struct __kernel_timespec __user *, rmtp)
{
	...
}

Each 32-bit architecture (one at a time) has to change its syscall table
so the __NR_clock_nanosleep entry points to the sys_compat_clock_nanosleep
function, and it needs to assign a new number for sys_clock_nanosleep,
and also do the same thing for all other syscalls involving time, and then
set CONFIG_COMPAT_TIME unconditionally.

Once all architectures do this, we can turn CONFIG_COMPAT_TIME into a
user-selectable option and turn it off for any system that wants to ensure
it either works now or doesn't work, but does not break in 24 years from
now.

> > I wonder: could we make this new architecture effectively use the
> > signatures of the 64-bit syscalls (similar to x32), just with a 32-bit
> > calling convention?
> 
> So if you mean on 64bit systems, having the 2038-safe 32bit compat use
> the same 64bit entry-points, I think that would be possible for some of
> the syscalls, but there's some where other data fields in structures
> won't be expected to be 64bit. But I might not be understanding what
> your suggesting.

Of the syscalls I've looked at, all would be able to do it this way:
you already have to introduce a new data structure at the libc-kernel
interface, with the libc potentially translating it into a different
format at least for legacy applications. An interesting case is 'struct
stat': All architectures that don't use the asm-generic/stat.h file
have their own incompatible definition of this structure, and the
asm-generic one gets it wrong too (this is my fault I admit). For the
existing 32-bit architectures that also come with a 64-bit counterpart,
we have the choice to make each one use whatever their 64-bit ABI
uses, or alternatively make them all use the same structure. Either
way makes sense to me.

	Arnd
