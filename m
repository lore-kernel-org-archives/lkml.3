Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaEMCoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:44:20 -0400
Received: from ns.horizon.com ([71.41.210.147]:33885 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751921AbaEMCoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:44:19 -0400
Date: 12 May 2014 22:44:17 -0400
Message-ID: <20140513024417.31530.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: john.stultz@linaro.org, linux@horizon.com
Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping seqlock
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com
In-Reply-To: <537109AB.8010609@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, John Stultz wrote:
> First: My apologies, for some reason your mail got tagged as spam, so I
> only saw it just now looking for another missing email.

No problem; it happens to everyone.  Curse you, Canter & Siegel!

>> One misfeature in the timekeeping seqlock code I noticed is that
>>  read_seqcount_begin returns "unsigned int", not "unsigned long".
>>
> Casting to a larger type is harmless, but inefficient.

> Thanks for pointing this out. If you want to spin up a patch for this,
> I'd be fine applying it. Otherwise I'll try to clean this up sometime soon.

Appended.  And a second one that you may or may not like.

> So this has been suggested before (and I've spent some time awhile back
> trying to implement it).  The problem is that should the update be
> significantly delayed (by for instance, the host preempting a VM's cpu
> for some extended period), and a frequency adjustment slowing the clock
> was being applied to the new timekeeper, the continued use of the old
> timekeeper could cause the current time to over-shoot the new
> timekeeper, causing time to go backwards when we finally made the switch. :(

Thank you very much!  "I'd like to, but it's very very tricky" is encouraging,
if daunting.

> I would very much like to have a non-blocking implementation! We've also
> looked at variants where we keep a valid-interval range in the structure
> so readers can be sure the timekeeper they're using is still active
> (sort of an expiration date), so we would only block if an update was
> delayed. However this is problematic, since there are a number of
> timekeeping calls in the hrtimer logic required to trigger the
> timekeeping update. So if the update interrupt was delayed, those reads
> would block, deadlocking the box.

> So maybe you can come up with a tweak to make it possible, but when
> discussing this at length w/ Matheiu Desnoyers, it seemed like the main
> problem was there was no way to atomically validate that we hadn't been
> delayed and update the pointer to the new structure without stopping all
> the cpus with some sort of serializing lock.

Okay, two approaches come to mind:

1) Dividing the "get the time" calls into "strictly monotonic, but
   blocking", and "only approximately non-monotonic".  Debugging/printk
   would use the latter.  The downside is API complexity pushed onto the
   users.
2) Using wait-free coding techniques where readers help the writer if
   they notice a stall.  This is much hairier internal code, but makes
   life easier on the callers.  The basic procedure is:

   - A conventionally locked writer decides that the frequency is to be
     adjusted, effective at the current time (or perhaps slightly in the
     future).
   - It publishes its idea of the effective time, and that an update is
     in progress.
   - A reader comes in, reads the hardware clock, and checks:
     - Is a rate update in progress, and is the effective time *before*
       the time I just read?
     - If so, I'm going to force a postponement to the time I just read,
       using compare-and-swap trickery.
     - Then it proceeds to use the old timekeeper rate information.
   - When the writer finishes figuring out the new timekeeper state,
     as part of the atomic installation of a new state, it checks to
     see if a reader has forced a postponement.  If so, it goes back and
     recomputes the state with the later effective time and tries again.

   Going down a level to how to implement this, one way (I may be biased
   because my mind is already on this track) is to extend the technique
   of using the seqlock counter to control ping-pong between 2 states:

   - The writer publishes the effective time in a global variable (and
     does an smp_wmb) before setting the lsbit of the sequence.
   - Readers, if they see the lsbit set, check the effective time,
     and if they see a conflict, atomically clear the lsbit, forcing
     the final write-unlock to abort.
   - If a reader loses the race to clear the lsbit, the reader recomputes
     using the new state.
   - When the writer tries to complete the update, it does an atomic update
     of the sequence counter and notices that someone has messed with it.
     Then it retries, recomputing the rate update with a later effective
     time.
     (Rather than a compare-and-swap, it could simply do an atomic
     increment which releases the lock if there was no race, and starts
     a new write if there was one).

   This approach has some horrible complexity inside the (already quite
   convoluted) timekeeper code, but allows all the read operations to
   be wait-free.

   The question is whether this can be implemented in a way that's
   comprehensible to anyone but Paul McKenney.

Does that make sense, or am I hallucinating?
