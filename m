Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaFNHXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 03:23:14 -0400
Received: from ns.horizon.com ([71.41.210.147]:24561 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754448AbaFNHXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 03:23:13 -0400
Date: 14 Jun 2014 03:23:12 -0400
Message-ID: <20140614072312.27656.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [RFC] random: is the IRQF_TIMER test working as intended?
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140614064330.GE6447@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In general, yes.  It's intended this way.  I'm trying to be extremely
> conservative with my entropy measurements, and part of it is because
> there is generally a huge amount of interrupts available, at least on
> desktop systems, and I'd much rather be very conservative than not.

To be absolutely clear: being more aggressive is not the point.

Using 1/8 of a bit per sample was simply for convenience, to keep the
patch smaller.  It can be easily adapted to be strictly more conservative.

Consider the changes that make it more conservative:
- Allow credit of less than 1 bit
- If we get interrupts very rarely, credit *less* entropy.
- Only allow credit for one side of a timer interrupt, not both.  If t2-t1
  is too predictable, then x-t1 has all of the entropy that's available.
  t2-x provides no new information.

> What I'd probably do instead is to count the number of timer
> interrupts, and if it's more than 50% time interrupts, give 0 bits of
> credit, else give 1 bit of credit each time we push from the fast pool
> to the input pool.  Yes, that's being super conservative.

If we're down in the 0/1 range, I really like the idea of allowing
fractional credit.  How about crediting 1/64 of a bit per non-timer
interrupt?  Equivalent result, but more linear.

(Sorry if my digression about the sanity of 1/8 bit per sample confused
things.  I was just trying to say "it's not totally crazy", not "you should
do this".)

>> 1) Since the number of samples between spills to the input pool is
>>    variable (with > 64 samples now possible due to the trylock), wouldn't
>>    it make more sense to accumulate an entropy estimate?

> In general, we probably will only retry a few times, so it's not
> worth it.

I'm not actually worrying about the "too many samples" case, but the
"too few".  The worrisome case is when someone on an energy-saving quest
succeeds in tuning the kernel (or just this particular processor) so it
gets less than 1 interrupt per second.  Every interrupt credits 1 bit
of entropy.  Is *that* super-conservative?

I agree that longer delays have more jitter, so it's worth a little
bit more, but shouldn't we try to get a curve the same shape as reality
and *then* apply the safety factors?  Surely the presence or absence of
intermediate samples makes *some* difference?
