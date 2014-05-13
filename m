Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaEMDjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:39:12 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40891 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaEMDjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:39:10 -0400
Message-ID: <537193DB.3010802@linaro.org>
Date: Mon, 12 May 2014 20:39:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping
 seqlock
References: <20140513024417.31530.qmail@ns.horizon.com>
In-Reply-To: <20140513024417.31530.qmail@ns.horizon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 07:44 PM, George Spelvin wrote:
> On Mon, 12 May 2014, John Stultz wrote:
>> First: My apologies, for some reason your mail got tagged as spam, so I
>> only saw it just now looking for another missing email.
> No problem; it happens to everyone.  Curse you, Canter & Siegel!
>
>>> One misfeature in the timekeeping seqlock code I noticed is that
>>>  read_seqcount_begin returns "unsigned int", not "unsigned long".
>>>
>> Casting to a larger type is harmless, but inefficient.
>> Thanks for pointing this out. If you want to spin up a patch for this,
>> I'd be fine applying it. Otherwise I'll try to clean this up sometime soon.
> Appended.  And a second one that you may or may not like.
>
>> So this has been suggested before (and I've spent some time awhile back
>> trying to implement it).  The problem is that should the update be
>> significantly delayed (by for instance, the host preempting a VM's cpu
>> for some extended period), and a frequency adjustment slowing the clock
>> was being applied to the new timekeeper, the continued use of the old
>> timekeeper could cause the current time to over-shoot the new
>> timekeeper, causing time to go backwards when we finally made the switch. :(
> Thank you very much!  "I'd like to, but it's very very tricky" is encouraging,
> if daunting.
>
>> I would very much like to have a non-blocking implementation! We've also
>> looked at variants where we keep a valid-interval range in the structure
>> so readers can be sure the timekeeper they're using is still active
>> (sort of an expiration date), so we would only block if an update was
>> delayed. However this is problematic, since there are a number of
>> timekeeping calls in the hrtimer logic required to trigger the
>> timekeeping update. So if the update interrupt was delayed, those reads
>> would block, deadlocking the box.
>> So maybe you can come up with a tweak to make it possible, but when
>> discussing this at length w/ Matheiu Desnoyers, it seemed like the main
>> problem was there was no way to atomically validate that we hadn't been
>> delayed and update the pointer to the new structure without stopping all
>> the cpus with some sort of serializing lock.
> Okay, two approaches come to mind:
>
> 1) Dividing the "get the time" calls into "strictly monotonic, but
>    blocking", and "only approximately non-monotonic".  Debugging/printk
>    would use the latter.  The downside is API complexity pushed onto the
>    users.

So the printk/debugging is covered by sched_clock which uses a
completely separate code path. So if I'm following along I think this
divide is already in place.


> 2) Using wait-free coding techniques where readers help the writer if
>    they notice a stall.  This is much hairier internal code, but makes
>    life easier on the callers.  The basic procedure is:
>
>    - A conventionally locked writer decides that the frequency is to be
>      adjusted, effective at the current time (or perhaps slightly in the
>      future).
>    - It publishes its idea of the effective time, and that an update is
>      in progress.
>    - A reader comes in, reads the hardware clock, and checks:
>      - Is a rate update in progress, and is the effective time *before*
>        the time I just read?
>      - If so, I'm going to force a postponement to the time I just read,
>        using compare-and-swap trickery.
>      - Then it proceeds to use the old timekeeper rate information.
>    - When the writer finishes figuring out the new timekeeper state,
>      as part of the atomic installation of a new state, it checks to
>      see if a reader has forced a postponement.  If so, it goes back and
>      recomputes the state with the later effective time and tries again.

Hrm.. So basically during the update you lock readers to the counter
value read at the beginning of the update. So readers don't block, but
time doesn't progress while the update is being made. Sounds promising!
Though I worry it rhymes a bit with an idea Matheiu and I were throwing
around during plumbers last year, but didn't work out. I think the
concern with this sort of approach is: how do you prevent a race between
a reader and the update thread such that a reader doesn't sneak in and
read a counter value that is after the value the updater read, but
before the value is stored locking the structure?

You can imagine the updater reads the counter value, then is immediately
stalled for some very long time by a hyper-visor. Various readers on
other cpus read time that continues to increase. Then when the updater
finally returns, he locks the time to that value in the past. Following
readers then see time that appears to go backwards.

I have to admit its getting late and I'm not sure I'm completely
following the bit about the update restarting depending on a forced
postponement.

>    Going down a level to how to implement this, one way (I may be biased
>    because my mind is already on this track) is to extend the technique
>    of using the seqlock counter to control ping-pong between 2 states:
>
>    - The writer publishes the effective time in a global variable (and
>      does an smp_wmb) before setting the lsbit of the sequence.
>    - Readers, if they see the lsbit set, check the effective time,
>      and if they see a conflict, atomically clear the lsbit, forcing
>      the final write-unlock to abort.
>    - If a reader loses the race to clear the lsbit, the reader recomputes
>      using the new state.
>    - When the writer tries to complete the update, it does an atomic update
>      of the sequence counter and notices that someone has messed with it.
>      Then it retries, recomputing the rate update with a later effective
>      time.
>      (Rather than a compare-and-swap, it could simply do an atomic
>      increment which releases the lock if there was no race, and starts
>      a new write if there was one).

Oh.. so its actually more like the update is canceled if a reader can
complete a read and set a flag while the update is in flight? Hrm.. I
worry with the number and frequency of time reads on many systems, you'd
end up with update starvation (something which use to be a problem back
when timekeeping was managed with just spinlocks, and SMP wasn't that
common - so I suspect it can only be worse now).

Further, the write in the read path would cause problems for VDSO time,
where everything is computed on read-only data in userspace.



>    This approach has some horrible complexity inside the (already quite
>    convoluted) timekeeper code, but allows all the read operations to
>    be wait-free.
>
>    The question is whether this can be implemented in a way that's
>    comprehensible to anyone but Paul McKenney.
>
> Does that make sense, or am I hallucinating?

Yea. It definitely gets complex. But timekeeping is always a very
hotpath, so complexity for performance is a normal trade. So there may
be a way to make it work. But finding a way to make it easier to
comprehend (even just having a clear metaphor for whats being done)
would be excellent.

thanks
-john


