Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaLSAdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:33:19 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:50162 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaLSAdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <20141219003044.GA2804333@devbig257.prn2.facebook.com>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com> <20141219003044.GA2804333@devbig257.prn2.facebook.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 18 Dec 2014 16:32:55 -0800
Message-ID: <CALCETrXTMa9A+iF--C9TV=fuC_twV9=RU++aZ1s6YzB-H=xxPw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
To: Shaohua Li <shli@fb.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 4:30 PM, Shaohua Li <shli@fb.com> wrote:
> On Thu, Dec 18, 2014 at 04:22:59PM -0800, Andy Lutomirski wrote:
>> On Thu, Dec 18, 2014 at 3:30 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Wed, Dec 17, 2014 at 3:12 PM, Shaohua Li <shli@fb.com> wrote:
>> >> This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..). We
>> >> use the following method to compute the thread cpu time:
>> >>
>> >>     t0 = process start
>> >>     t1 = most recent context switch time
>> >>     t2 = time at which the vsyscall is invoked
>> >>
>> >>     thread_cpu_time = sum(time slices between t0 to t1) + (t2 - t1)
>> >>                 = current->se.sum_exec_runtime + now - sched_clock()
>> >>
>> >> At context switch time We stash away
>> >>
>> >>     adj_sched_time = sum_exec_runtime - sched_clock()
>> >>
>> >> in a per-cpu struct in the VVAR page and then compute
>> >>
>> >>     thread_cpu_time = adj_sched_time + now
>> >>
>> >> All computations are done in nanosecs on systems where TSC is stable. If
>> >> TSC is unstable, we fallback to a regular syscall.
>> >>     Benchmark data:
>> >>
>> >>     for (i = 0; i < 100000000; i++) {
>> >>             clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
>> >>             sum += ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
>> >>     }
>> >
>> > A bunch of the time spent processing a CLOCK_THREAD_CPUTIME_ID syscall
>> > is spent taking various locks, and I think it could be worth adding a
>> > fast path for the read-my-own-clock case in which we just disable
>> > preemption and read the thing without any locks.
>> >
>> > If we're actually going to go the vdso route, I'd like to make the
>> > scheduler hooks clean.  Peterz and/or John, what's the right way to
>> > get an arch-specific callback with sum_exec_runtime and an up to date
>> > sched_clock value during a context switch?  I'd much rather not add
>> > yet another rdtsc instruction to the scheduler.
>>
>> Bad news: this patch is incorrect, I think.  Take a look at
>> update_rq_clock -- it does fancy things involving irq time and
>> paravirt steal time.  So this patch could result in extremely
>> non-monotonic results.
>
> Yes, it's not precise. But bear in mind, CONFIG_IRQ_TIME_ACCOUNTING is a
> optional feature. Actually it's added not long time ago. I thought it's
> acceptable the time isn't precise just like what we have before the
> feature is added.
>

Nonetheless, I think that the vdso accelerated functions should be
careful to remain interchangeable with the syscall equivalents.  If
that means that some kconfig magic needs to be added to prevent this
code from being enabled when it won't work, then so be it.  But it
might be better to use a different clock id entirely, and I don't
really understand the logic behind all the clock ids.

John?

--Andy

> Thanks,
> Shaohua



-- 
Andy Lutomirski
AMA Capital Management, LLC
