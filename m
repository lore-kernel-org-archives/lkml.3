Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaJCR7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 13:59:40 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41841 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaJCR7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 13:59:37 -0400
MIME-Version: 1.0
In-Reply-To: <20141003174141.GR2342@redhat.com>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <20141003174141.GR2342@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 3 Oct 2014 10:59:15 -0700
Message-ID: <CALCETrWP7QSb4dFh_phUK+7P-XookgL8UXgvHi-e4icukUF2Og@mail.gmail.com>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC filtering
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Erik Bosman <ebn310@few.vu.nl>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc's re-added]

On Fri, Oct 3, 2014 at 10:41 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Hi,
>
> On Fri, Oct 03, 2014 at 10:18:14AM -0700, Andy Lutomirski wrote:
>> Weakness 2: On most configurations, most or all userspace processes
>> have unrestricted access to RDPMC, which is even better than RDTSC
>> for exploiting timing attacks.
>
> "User access of the RDPMC instruction is not guaranteed. Like RDTSC,
> user access is controlled by a bit in CR4. CR4.PCE (bit-8) controls
> whether or not a user program can execute the RDPMC instruction
> without faulting"
>
> I don't think there's was a seccomp leak of RDPMC because of this, the
> rdtsc and rdpmc seems to be linked to the same cr4 tweak.

RDPMC is controlled by CR4.PCE, whereas RDTSC is controlled by
CR4.TSD, so, unless there's magic that I'm unaware of, seccomp never
blocked RDPMC access.  I don't know whether circa-2008 kernels set PCE
(or perhaps left it set if BIOS set it) at boot, but certainly almost
everyone on any kernel for the last few years has RDPMC enabled in
ring 3.

>
> The vsyscall data was leaked right, but you can't compare the
> two. Sure it's better to block that too but it's not comparable to
> give tsc access to apps running under seccomp.
>
> The time of the day isn't secret either (ok it could be an issue if
> you intend to run the system on some secret time in the past or future
> but this sounds not a practical issue).
>
> What's not public info and should never be leaked to seccomp
> sandboxes, is the tsc at that kind of cycle count granularity (and the
> various gettimeofday variants with nanosecond granularity). I thought
> RDPMC was blocked too with the same CR4 tweak... if that wasn't the
> case and you could get tsc granular information into a seccomp
> sandbox, that's not ok because it allows for covert channel attacks.

The HPET very fine granularity.  It's slow to access, but that isn't
necessarily a problem for attackers.

I agree that this is problematic, and I want to fix it.  The trouble
is that I'm not sure it's fixable in a sane manner with the current
semantics.  CR4.PCE, in particular, will need to be a function of both
per-thread state (PR_TSC_SIGSEGV) and per-mm state (whether perf_event
self-monitoring is on).  Getting the context switching logic correct
without hurting the common case too much will be quite complicated.

On top of this, supporting something like PR_TSC_SIGSEGV per-thread
using seccomp mode 2 should really be done by redirecting vdso-based
timing to use syscalls, and that's fundamentally per mm.

Hence my proposal of removing the current insecure model so that
adding a secure variant will be straightforward, rather than trying to
shoehorn a fix on top of the current ABI.

The eventual fix could still disable the TSC in a strict seccomp task
by default if the task is single threaded.  Yes, that won't quite
cover old Chromium-style sandboxes, but those are rapidly being
replaced by new designs using seccomp mode 2 anyway.

Also, keep in mind that multithreaded attackers can exploit timing
attacks without hardware help at all: one thread can just run a timing
loop.

--Andy
