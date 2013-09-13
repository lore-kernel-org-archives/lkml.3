Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3IMT3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:29:22 -0400
Received: from imap.thunk.org ([74.207.234.97]:59807 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab3IMT3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:29:20 -0400
Date: Fri, 13 Sep 2013 15:29:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Thorsten Glaser <tg@mirbsd.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130913192915.GC15366@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Thorsten Glaser <tg@mirbsd.de>, linux-kernel@vger.kernel.org
References: <10005394.BRCyBMYWy3@tauon>
 <522F984C.2070909@linaro.org>
 <20130912213148.GE3809@logfs.org>
 <1974157.PE35U8AyTG@tauon>
 <loom.20130913T134347-937@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <loom.20130913T134347-937@post.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 11:54:40AM +0000, Thorsten Glaser wrote:
> 
> That’s why you also use a (faster, less powerful) mixing function
> on input.
> 
> I was wondering: why not use Jenkins’ one-at-a-time hash there?
> I’ve worked with it a bit, and it has good avalanche behaviour;
> I didn’t measure any cycles though.

One of the primary requirements for the mixing function is that it
should not lose entropy in the course of doing the mixing.  For
example, if someone does the equivalent of "dd if=/dev/zero
of=/dev/random", and mixes in a whole series of zero values, we should
not lose any information.  That's another way of saying that the
mixing function:

	POOL' = MIX(POOL, entropy_input)

must be reversible.  This guarantees that:

	POOL' = MIX(POOL, 0)

will not lose any information.

The second requirement of the mixing function is that we want to make
sure any entropy we do have is distributed evenly across the pool.
This must be true even if the input is highly structured (i.e., if we
are feeding timestamps into the entropy pool, where the high bits are
always the same, and the entropy is in the low bits), successive
timestamps should not just affect certain bits in the pool.

This is why using a simple XOR into the pool is not a good idea, and
why we rotate the input byte by different amounts during each mixing
operation.

However, when we extract information from the pool, this is where we
want to make sure the pool gets peturbed in such a way that if the
attacker has partial knowledge of the pool, that knowledge gets harder
to use very quickly.  And here the paper "The Linux Pseudorandom
Number Generator Revisited", by Lacharme, Rock, Strubel, and Videau
has some good points that I am seriously considering.  I am still
thinking about it, but what I am thinking about doing is doing more
mixing at each extract operation to so that there is more
avalanche-style stiring happening each time we extract information
from the pool.  Right now we mix in a SHA hash at each extract
operation; but if we call mix_pool_bytes() with a zero buffer, then we
will smear that SHA hash across more of the pool, which makes it
harder for an attacker to try to reverse engineer the pool while
having partial knowledge of an earlier state of the pool.

> > Oh yes, it hurts, if you update the entropy estimator on those 
> > predictable bits. Because then you get a deterministic RNG like 
> 
> I’ve seen Theodore apply exponential backoff to any estimation,
> which is probably a good thing. But yes, you probably will want
> to guess the entropy of the bytes added and not count things
> where you’re not too sure of. (In the interrupt case, we have
> jiffies, cycles and num, so we’d probably best estimate how
> often interrupts are called, base a number of “timing” bits
> on that, and account for num; this may very well be less than
> 8 bit “credited” for a long and two u_int added to the pool,
> but as long as you get that right and don’t blindly credit
> a byte as 8 bit, you’re safe. To quote the author of RANDOM.SYS
> for DOS: “Every bit counts.” It adds uncertainty to the pool,
> at least by stirring around the already-existing entropy without
> adding any new (creditable) entropy.)

So let me be blunt.  The entropy estimator we have sucks.  It's pretty
much impossible to automatically estimate given an arbitrary input
stream how much entropy is present.  The best example I can give is
the aforementioned:

	AES_ENCRYPT(i++, NSA_KEY)

Let's assume the starting vaue of i is an unknown 32-bit number.  The
resulting stream will pass all statistical randomness tests, but no
matter how may times you turn the crank and generate more "random"
numbers, the amount of entropy in that stream is only 32 bits --- at
least to someone who knows the NSA_KEY.  For someone who knows that
this is how the input stream was generated, but not the 256-bit NSA
KEY, then the amount of entropy in the stream would be 32 + 256 = 288
bit.  And this is true even if you generate several gigabytes worth
numbers using the above CRNG.

Now, if you know that the input stream is a series of timestamps, as
we do in add_timer_randomness() we can do something slightly better
by looking at the deltas between successive timestamps, but if there
is a strong 50 or 60 Hz component to the timestamp values, perhaps due
to how the disk drive motor is powered from the AC mains, a simple
delta estimator is not going to catch this.

So the only really solid way we can get a strong entropy estimation is
by knowing the details of the entropy source, and how it might fail to
be random (i.e., if it is microphone hooked up to gather room noise,
there might be some regular frequency patterns generated by the HVAC
equipment; so examining the input in the frequency domain and looking
for any spikes might be a good idea).

The one saving grace in all of this is there is plenty of
unpredictable information which we mix in for which we give no entropy
credit for whatsoever.  But please don't assume that just because you
can read 8192 bits out of /dev/random, that you are guaranteed to get
8192 bits of pure "true random bits".  For one thing, the input pool
is only 4096 bits, plus a 1024 bit output pool.  Even if both of the
pools are filled with pure unpredictable bits, that's only 5120 bits.
Sure, as you extract those bits, some more entropy will trickle in,
but it won't be a full 8192 bits in all likelihood.

At the end of the day, there is no real replacement for a real HWRNG.
And I've never had any illusions that the random driver could be a
replacement for a real HWRNG.  The problem is though is that most
HWRNG can't be audited, because they are not open, and most users
aren't going to be able to grab a wirewrap gun and make their own ---
and even if they did, it's likely they will screw up in some
embarassing way.  Really, the best you can do is hopefull have
multiple sources of entropy.  RDRAND, plus the random number generator
in the TPM, etc. and hope that mixing all of this plus some OS-level
entropy, that this is enough to frustrate the attacker enough that
it's no longer the easist way to comrpomise your security.

Regards,

							- Ted
