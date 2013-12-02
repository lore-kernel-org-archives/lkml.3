Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab3LBUaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:30:15 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47231 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab3LBU2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:28:54 -0500
MIME-Version: 1.0
In-Reply-To: <529CDBAB.60402@linaro.org>
References: <CALCETrXUZe9xmUyDHgZRRe2TBP7CXSVpXkvH61qiLLxcANicUg@mail.gmail.com>
 <529CDBAB.60402@linaro.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 2 Dec 2013 12:28:33 -0800
Message-ID: <CALCETrXBivBbt+17pL_=AUZqDywUHuaxS==aqJn5nrwz9WJZow@mail.gmail.com>
Subject: Re: Clock control algorithms (Re: [RFC][PATCH 5/7] x86: Use latch
 data structure for cyc2ns)
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 11:12 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 11/30/2013 09:29 AM, Andy Lutomirski wrote:
>> [Subject changed because this isn't relevant to the patches in
>> question any more.]
>>
>> On Sat, Nov 30, 2013 at 1:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> On Fri, Nov 29, 2013 at 03:22:45PM -0800, Andy Lutomirski wrote:
>>>> I've occasionally wondered whether it would be possible to make a
>>>> monotonicity-preserving version of this and use it for clock_gettime.
>>>> One approach: have the writer set the time for the update to be a bit
>>>> in the future and have the reader compare the current raw time to the
>>>> cutoff to see which set of frequency/offset to use.  (This requires
>>>> having some kind of bound on how long it takes to update the data
>>>> structures.)
>>>>
>>>> The advantage: clock_gettime would never block.
>>>> The disadvantage: complicated, potentially nasty to implement, and it
>>>> would get complicated if anyone tried to allow multiple updates in
>>>> rapid succession.
>
>
> So yea, I talked a bit with Mathieu Desnoyers during plumbers about
> this, since he was working with Peter and proposing a very similar idea.
>
> Unfortunately, in the timekeeping case, since we are changing the
> clock's frequency there's a number of corner cases where if the clock
> updating logic is delayed for some reason (long NMI or more
> realistically, quirky scheduling on the host of a VM), we could observe
> time inconsistencies in the readers (Peter's comment in the patch
> mentions this).
>
> If you care for the details, the case in question is when the update
> decides to slow the clock frequency down. So we go from (F) originally
> set at time T_0 to (F-adj) at a given time T_1.  But should this update
> be delayed mid-operation, readers on other cpus will continue to use
> frequency F. Then at some time T_2, the update completes, and thus we
> have a potential time inconsistency.
>
> T_2(old) = cycles(T_2 - T_0)*F + base_time(T_0)
>
> T_2(new) = cycles(T_2 - T_1)*(F-adj) + base_time(T_1)
>
> Where base_time(T_1) = base_time(T_0) + cycles(T_1-T_0)*(F)
>
> Thus if adj is large enough, and T_2-T_1 is long enough, we would see
> time go backwards.
>
> We can bound adj, which makes it so we'd need longer cycle intervals to
> observe a ns inconsistency, but with things like VM scheduling, the
> delay could be essentially unbounded. I've discussed ideas for what I
> call "valid intervals", which I think is similar to what Peter is
> calling the "chained linear segments", where each update has a cycle
> interval it would be valid for, and readers would have to wait if that
> interval has expired, but that basically re-introduces the seqlock style
> waiting, and complicates things further, as we don't want to have the
> update cpu is delayed beyond the interval, then when the hrtimer fires
> and we check the time, have it deadlock waiting for itself to do the
> update. :(
>
>

Maybe the vdso variant could fall back to a real syscall if the update
gets delayed, and that syscall could do something intelligent (like
blocking).  This would be more complicated than the current setup, but
I doubt that any new deadlocks could be introduced, since the current
timing code already blocks for an unbounded amount of time if the
updater lags out.

>
>
>>> Yes, that way you can chain a number of linear segments in various
>>> slots, but you're indeed right in that it will limit the update
>>> frequency. More slots will give you more room, but eventually you're
>>> limited.
>>>
>>> I suppose NTP is the primary updater in that case, does that have a
>>> limit on the updates? All the other updates we can artificially limit,
>>> that shouldn't really matter.
>>>
>>> But yeah in my case we pretty much assume the TSC is complete crap and a
>>> little more crap simply doesn't matter.
>>>
>>> For the 'stable' tsc on modern machines we never set the frequency and
>>> it doesn't matter anyway.
>> I assume that NTP works by filddling with the frequency and offset on
>> a regular basis to preserve monotonicity while still controlling the
>> clock.
>>
>> TBH, I've never understood why the NTP code is so integrated into the
>> kernel's timing infrastucture or, for that matter, lives in the kernel
>> at all.
>
> It is a bit historical, though with the exception of the offset
> adjustments, the adjtimex interface isn't particularly ntp exclusive.
>
>
>>   Shouldn't the core interface be something more like "starting
>> at time t_1, change the frequency to f_1, then at time t_2, change the
>> frequency to f_2"?  That would give the ability to manage a control
>> loop in userspace (or some kernel thread) and to reliably slew the
>> clock by a small, fixed amount.  I suppose this could be elaborated to
>> allow more than two adjustments to be scheduled in advance, but I
>> really don't see the need for anything much fancier.
>
> The difficult part with that is time t_1 and t_2 in your case may not be
> aligned with timer interrupts. So we'd have to do reader-side clock
> manipulation, which would add overhead, or accept the tick granular
> error. Its a very similar problem to the leap-second edge issue, where
> we apply leapseconds at the timer tick, instead of the actual
> leap-second edge.

I still think that (the VM / NMI latency issue aside) the reader-side
manipulation would be essentially free, in that it could replace the
current check for negative times (see below).

>
>
>> Benefits:
>>  - Comprehensible without reading the entire NTP spec and all the
>> various addenda.
>>  - No need for any timing code at all in the tick handler -- the whole
>> thing could presumably be done with hrtimers and a bit fancier data
>> structure that lets clock_gettime figure out when to update*.
>>  - Things like PTP don't need to pretend to be NTP.
>>
>> Disadvantages: No clue, since I don't know why NTP works the way it
>> does right now.
>
> Well, we'd have to still preserve the existing adjtimex behavior. So we
> have to live with that.
>
> But I think something like this could be added on as an extended mode to
> adjtimex, and I have heard some folks wish for similar before, so it
> might be worth investigating.

Is it currently guaranteed that CLOCK_REALTIME and CLOCK_MONOTONIC
advance at exactly the same rate except when the time is stepped?  If
so, and if extended adjtimex things are being considered, I think that
a lot of userspace code could benefit from the ability to directly
read the realtime-monotonic offset (especially combined with the
timerfd settimeofday detection stuff).

>
>
>> * vclock_gettime on x86_64 already has a branch that depends on the
>> time.  I think that good implementation could do all of this fancy
>> stuff with exactly one branch, resulting in the fast path being just
>> as fast.
>
> Does it? I don't know if I see that.... maybe I'm not looking closely
> enough? Again, this would be important if we want to fix the leap-second
> edge issue as well.

It's this thing in vread_tsc:

        if (likely(ret >= last))
                return ret;

as long as the frequencies and offsets are chosen such that a little
bit of TSC skew won't overflow, then I think this can go away and get
replaced by a similar branch to do reader-side frequency switching at
predefined times.

Some day I'd like to see the vdso clock reading code be unified with
the in-kernel code.  It does essentially the same thing.

--Andy
