Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3LBVUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:20:11 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47321 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3LBTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:46 -0500
Message-ID: <529CDBAB.60402@linaro.org>
Date: Mon, 02 Dec 2013 11:12:43 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
CC: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: Clock control algorithms (Re: [RFC][PATCH 5/7] x86: Use latch
 data structure for cyc2ns)
References: <CALCETrXUZe9xmUyDHgZRRe2TBP7CXSVpXkvH61qiLLxcANicUg@mail.gmail.com>
In-Reply-To: <CALCETrXUZe9xmUyDHgZRRe2TBP7CXSVpXkvH61qiLLxcANicUg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2013 09:29 AM, Andy Lutomirski wrote:
> [Subject changed because this isn't relevant to the patches in
> question any more.]
>
> On Sat, Nov 30, 2013 at 1:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, Nov 29, 2013 at 03:22:45PM -0800, Andy Lutomirski wrote:
>>> I've occasionally wondered whether it would be possible to make a
>>> monotonicity-preserving version of this and use it for clock_gettime.
>>> One approach: have the writer set the time for the update to be a bit
>>> in the future and have the reader compare the current raw time to the
>>> cutoff to see which set of frequency/offset to use.  (This requires
>>> having some kind of bound on how long it takes to update the data
>>> structures.)
>>>
>>> The advantage: clock_gettime would never block.
>>> The disadvantage: complicated, potentially nasty to implement, and it
>>> would get complicated if anyone tried to allow multiple updates in
>>> rapid succession.


So yea, I talked a bit with Mathieu Desnoyers during plumbers about
this, since he was working with Peter and proposing a very similar idea.

Unfortunately, in the timekeeping case, since we are changing the
clock's frequency there's a number of corner cases where if the clock
updating logic is delayed for some reason (long NMI or more
realistically, quirky scheduling on the host of a VM), we could observe
time inconsistencies in the readers (Peter's comment in the patch
mentions this).

If you care for the details, the case in question is when the update
decides to slow the clock frequency down. So we go from (F) originally
set at time T_0 to (F-adj) at a given time T_1.  But should this update
be delayed mid-operation, readers on other cpus will continue to use
frequency F. Then at some time T_2, the update completes, and thus we
have a potential time inconsistency.

T_2(old) = cycles(T_2 - T_0)*F + base_time(T_0)

T_2(new) = cycles(T_2 - T_1)*(F-adj) + base_time(T_1)

Where base_time(T_1) = base_time(T_0) + cycles(T_1-T_0)*(F)

Thus if adj is large enough, and T_2-T_1 is long enough, we would see
time go backwards.

We can bound adj, which makes it so we'd need longer cycle intervals to
observe a ns inconsistency, but with things like VM scheduling, the
delay could be essentially unbounded. I've discussed ideas for what I
call "valid intervals", which I think is similar to what Peter is
calling the "chained linear segments", where each update has a cycle
interval it would be valid for, and readers would have to wait if that
interval has expired, but that basically re-introduces the seqlock style
waiting, and complicates things further, as we don't want to have the
update cpu is delayed beyond the interval, then when the hrtimer fires
and we check the time, have it deadlock waiting for itself to do the
update. :(




>> Yes, that way you can chain a number of linear segments in various
>> slots, but you're indeed right in that it will limit the update
>> frequency. More slots will give you more room, but eventually you're
>> limited.
>>
>> I suppose NTP is the primary updater in that case, does that have a
>> limit on the updates? All the other updates we can artificially limit,
>> that shouldn't really matter.
>>
>> But yeah in my case we pretty much assume the TSC is complete crap and a
>> little more crap simply doesn't matter.
>>
>> For the 'stable' tsc on modern machines we never set the frequency and
>> it doesn't matter anyway.
> I assume that NTP works by filddling with the frequency and offset on
> a regular basis to preserve monotonicity while still controlling the
> clock.
>
> TBH, I've never understood why the NTP code is so integrated into the
> kernel's timing infrastucture or, for that matter, lives in the kernel
> at all.

It is a bit historical, though with the exception of the offset
adjustments, the adjtimex interface isn't particularly ntp exclusive.


>   Shouldn't the core interface be something more like "starting
> at time t_1, change the frequency to f_1, then at time t_2, change the
> frequency to f_2"?  That would give the ability to manage a control
> loop in userspace (or some kernel thread) and to reliably slew the
> clock by a small, fixed amount.  I suppose this could be elaborated to
> allow more than two adjustments to be scheduled in advance, but I
> really don't see the need for anything much fancier.

The difficult part with that is time t_1 and t_2 in your case may not be
aligned with timer interrupts. So we'd have to do reader-side clock
manipulation, which would add overhead, or accept the tick granular
error. Its a very similar problem to the leap-second edge issue, where
we apply leapseconds at the timer tick, instead of the actual
leap-second edge.


> Benefits:
>  - Comprehensible without reading the entire NTP spec and all the
> various addenda.
>  - No need for any timing code at all in the tick handler -- the whole
> thing could presumably be done with hrtimers and a bit fancier data
> structure that lets clock_gettime figure out when to update*.
>  - Things like PTP don't need to pretend to be NTP.
>
> Disadvantages: No clue, since I don't know why NTP works the way it
> does right now.

Well, we'd have to still preserve the existing adjtimex behavior. So we
have to live with that.

But I think something like this could be added on as an extended mode to
adjtimex, and I have heard some folks wish for similar before, so it
might be worth investigating.


> * vclock_gettime on x86_64 already has a branch that depends on the
> time.  I think that good implementation could do all of this fancy
> stuff with exactly one branch, resulting in the fast path being just
> as fast.

Does it? I don't know if I see that.... maybe I'm not looking closely
enough? Again, this would be important if we want to fix the leap-second
edge issue as well.

thanks
-john

