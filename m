Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaEMFN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:13:27 -0400
Received: from ns.horizon.com ([71.41.210.147]:36753 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751912AbaEMFN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:13:26 -0400
Date: 13 May 2014 01:13:24 -0400
Message-ID: <20140513051324.7993.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: john.stultz@linaro.org, linux@horizon.com
Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping seqlock
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com
In-Reply-To: <537193DB.3010802@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 2) Using wait-free coding techniques where readers help the writer if
>>    they notice a stall.  This is much hairier internal code, but makes
>>    life easier on the callers.  The basic procedure is:
>>
>>    - A conventionally locked writer decides that the frequency is to be
>>      adjusted, effective at the current time (or perhaps slightly in the
>>      future).
>>    - It publishes its idea of the effective time, and that an update is
>>      in progress.
>>    - A reader comes in, reads the hardware clock, and checks:
>>      - Is a rate update in progress, and is the effective time *before*
>>        the time I just read?
>>      - If so, I'm going to force a postponement to the time I just read,
>>        using compare-and-swap trickery.
>>      - Then it proceeds to use the old timekeeper rate information.
>>    - When the writer finishes figuring out the new timekeeper state,
>>      as part of the atomic installation of a new state, it checks to
>>      see if a reader has forced a postponement.  If so, it goes back and
>>      recomputes the state with the later effective time and tries again.
> 
> Hrm.. So basically during the update you lock readers to the counter
> value read at the beginning of the update. So readers don't block, but
> time doesn't progress while the update is being made. Sounds promising!

Er... no.  I guess my explanation didn't work.  I thought of that (it's
quite simple, after all), but I was worried that the stuttering would
mess up fine accounting for e.g. interrupt handlers.

Also, it's not implementable.  The writer must pick a rate-change moment,
then announce it.  If it stalls between those two operations (and there's
no way to make them atomic), then it might announce a moment already in
the past, causing a later reader to return the stalled time, while an
earlier reader that didn't see the announcement has already returned
a later time.

Inseate, the writer announces a *proposed* rate-change time, but a number
of conditions can cause that time to be postponed.  (Basically, the writer
loops back to the beginning and applies the rate change later.)

One condition is enforced by the writer itself: it reads the time again
after making the announcement, and if the announced time has already
passed, loops.

But this is also checked by all readers.  If an update is in progress,
with a proposed time earlier than the reader is in the process of reading,
the writer is told to try again later.


One trick that can minimize the number of retries is to add a very small
time delta (equal to the typical write update cycle) to the writer's
effective time.  If the writer completes before that time happens (the
common case), readers happily use the old time values during the update.
Only if the writer is delayed more than expected will a reader notice
a problem.  "Hey, I read the hardware at tick x, but the writer is trying
to update tick-to-seconds translations for times later than tick y < x.
Hey, writer, recompute with a higher y!"


There is also the issue of a reader coming along after the change-over
and wanting to translate a time x < y.  There are several ways to
handle this.  Either the old parameters have to be kept around until
time y has passed, or the readers must wait until time y.

(They may not return early reporting time y or there may be race conditions.)

> Oh.. so its actually more like the update is canceled if a reader can
> complete a read and set a flag while the update is in flight? Hrm.. I
> worry with the number and frequency of time reads on many systems, you'd
> end up with update starvation (something which use to be a problem back
> when timekeeping was managed with just spinlocks, and SMP wasn't that
> common - so I suspect it can only be worse now).

The solution, mentioned above, is to have the effective time of the
update set to the predicted write completion time.  Then the readers will
never see an effective time less than their time and need to postpone
the writer.

Only if the writer is delayed unexpectedly does that happen.

> Further, the write in the read path would cause problems for VDSO time,
> where everything is computed on read-only data in userspace.

Ah!  Now *that* poses a potential problem.  I didn't think of that.
Arrgh, that's going to take some work.

Two possibilities:
1) The VDSO code could just spin.  It's not holding any kernel locks,
   so there's not much problem.
2) Possibly after some optimistic spinning, the VDSO code could
   trap to the kernel as a fallback.

> Yea. It definitely gets complex. But timekeeping is always a very
> hotpath, so complexity for performance is a normal trade. So there may
> be a way to make it work. But finding a way to make it easier to
> comprehend (even just having a clear metaphor for what's being done)
> would be excellent.

I'll try.
