Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab3BMWWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:22:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965072Ab3BMWWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:22:11 -0500
Message-ID: <511C1204.9040608@redhat.com>
Date: Wed, 13 Feb 2013 17:21:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org> <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com> <511BE4A3.8050607@redhat.com> <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
In-Reply-To: <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 02:36 PM, Linus Torvalds wrote:
> On Wed, Feb 13, 2013 at 11:08 AM, Rik van Riel <riel@redhat.com> wrote:
>> The spinlock backoff code prevents these last cases from
>> experiencing large performance regressions when the hardware
>> is upgraded.
>
> I still want *numbers*.
>
> There are real cases where backoff does exactly the reverse, and makes
> things much much worse. The tuning of the backoff delays are often
> *very* hardware sensitive, and upgrading hardware can turn out to do
> exactly what you say - but for the backoff, not the regular spinning
> code.

What kind of numbers would you like?

Numbers showing that the common case is not affected by this
code?

Or numbers showing that performance of something is improved
with this code?

Of course, the latter would point out a scalability issue,
that may be fixable by changing the data structures and code
involved :)

> And we have hardware that actually autodetects some cacheline bouncing
> patterns and may actually do a better job than software. It's *hard*
> for software to know whether it's bouncing within the L1 cache between
> threads, or across fabric in a large machine.

If we have just a few CPUs bouncing the cache line around, we
have no real performance issues and the loop with cpu_relax
seems to be doing fine.

Real issues arise when we have a larger number of CPUs contending
on the same lock. At that point we know we are no longer bouncing
between sibling cores.

>> As a car analogy, think of this not as an accelerator, but
>> as an airbag. Spinlock backoff (or other scalable locking
>> code) exists to keep things from going horribly wrong when
>> we hit a scalability wall.
>>
>> Does that make more sense?
>
> Not without tons of numbers from many different platforms, it doesn't.

That makes sense, especially if you are looking to make sure these
patches do not introduce regressions.

> And not without explaining which spinlock it is that is so contended
> in the first place.

This patch series is not as much for the spinlocks we know about
(we can probably fix those), but to prevent catastrophic
performance degradation when users run into contention on spinlocks
we do NOT know about.

> So I claim:
>
>   - it's *really* hard to trigger in real loads on common hardware.

This is definitely true.  However, with many millions of Linux
users out there, there will always be users who encounter a
performance problem, upgrade their hardware, and then run into
an even worse performance problem because they run into a
scalability issue.

The object of these patches is to go from:

"We doubled the number of CPUs, and now things go even slower.", to

"We doubled the number of CPUs, but things aren't going any faster."

The first is a real disaster for Linux users. Especially when the
workload consists of multiple things, some of which run faster on
the upgraded hardware, and others which run slower. What makes it
worse is that these kinds of issues always seem to happen on the
users' most expensive servers, running their most important
workloads...

The second case is something users can temporarily tolerate, while
we fix the underlying issue.

>   - if it does trigger in any half-way reasonably common setup
> (hardware/software), we most likely should work really hard at fixing
> the underlying problem, not the symptoms.

Agreed.

>   - we absolutely should *not* pessimize the common case for this

Agreed. Are there any preferred benchmarks you would absolutely like
to see, to show that these patches do not introduce regressions?

> Hurting the 99.99% even a tiny amount should be something we should
> never ever do. This is why I think the fast case is so important (and
> I had another email about possibly making it acceptable), but I think
> the *slow* case should be looked at a lot too. Because "back-off" is
> absolutely *not* necessarily hugely better than plain spinning, and it
> needs numbers. How many times do you spin before even looking at
> back-off? How much do you back off?

Whether or not we go into back-off at all depends on a number
of factors, including how many waiters there are ahead of us
waiting for the same ticket spinlock, and whether we have spun
a lot of time on this lock in the past.

> Btw, the "notice busy loops and turn it into mwait" is not some
> theoretical magic thing. And it's exactly the kind of thing that
> back-off *breaks* by making the loop too complex for hardware to
> understand. Even just adding counters with conditionals that are *not*
> about just he value loaded from memory suddently means that hardware
> has a lot harder time doing things like that.

> I don't know if you perhaps had some future plans of looking at using
> mwait in the backoff code itself,

I looked at mwait, but the documentation suggests it only ever
works at cache line granularity (or larger). That means every
time another CPU adds itself to the queue for the ticket lock,
or every time the lock holder writes to something else in the
cache line the lock is in, mwait'ing cpus get woken up.

It looks like mwait is designed for the case of a lock being
on its own cache line, with nothing else. However, Linux does
not seem to have many of those locks left, and the contention
issues I see the most seem to involve locks embedded in data
structures, sharing the cache line with data that the lock
holder modifies.

In fact, it looks like going to mwait has the potential to
increase, rather than decrease, memory traffic.

> but the patch I did see looked like
> it might be absolutely horrible. How long does a "cpu_relax()" wait?
> Do you know? How does "cpu_relax()" interface with the rest of the
> CPU? Do you know? Because I've heard noises about cpu_relax() actually
> affecting the memory pipe behavior of cache accesses of the CPU, and
> thus the "cpu_relax()" in a busy loop that does *not* look at the
> value (your "backoff delay loop") may actually work very very
> differently from the cpu_relax() in the actual "wait for the value to
> change" loop.
>
> And how does that account for two different microarchitectures doing
> totally different things? Maybe one uarch makes cpu_relax() just shut
> down the front-end for a while, while another does something much
> fancier and gives hints to in-flight memory accesses etc?

You summed up all the reasons for doing auto-tuning, aggressively
collapsing the back-off if we overslept, and starting out from 1
if we do not find a cached value.

> When do you start doing mwait vs just busy-looping with cpu_relax? How
> do you tune it to do the right thing for different architectures?

Mwait seems like the wrong thing to do, because the spinlocks where
we tend to see contention, tend to be the ones embedded in data
structures, with other things sharing the same cache line.

> So I think this is complex. At many different levels. And it's *all*
> about the details. No handwaving about how "back-off is like a air
> bag". Because the big picture is entirely and totally irrelevant, when
> the details are almost all that actually matter.

The details can vary a lot from CPU to CPU. I would argue that we
need code that does not break down, regardless of those details.

I agree that the code could use more regression testing, and will
get you test results. Please let me know if there are any particular
scenarios you would like to see tested.

That will also let us determine whether or not the call overhead (in
case we are waiting for a contended lock anyway) is an issue that
needs fixing.

-- 
All rights reversed
