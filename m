Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaFNEz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 00:55:26 -0400
Received: from ns.horizon.com ([71.41.210.147]:11661 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750824AbaFNEzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 00:55:21 -0400
Date: 14 Jun 2014 00:55:20 -0400
Message-ID: <20140614045520.12333.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: [RFC] random: is the IRQF_TIMER test working as intended?
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140613155241.GA4265@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to understand the entropy credit computation in
add_interrupt_randomness.  A few things confuse me, and I'm
wondering if it's intended to be that way.

1) Since the number of samples between spills to the input pool is
   variable (with > 64 samples now possible due to the trylock), wouldn't
   it make more sense to accumulate an entropy estimate?
2) Why only deny entropy credit for back-to-back timer interrupts?
   If both both t2 - x and x - t1 are worth credit, why  not for t2 - t1?
   It seems a lot better (not to mention simpler) to not credit any
   timer interrupt, so x - t1 will get credit but not t2 - x.
3) Why only consider the status of the interrupts when spills occur?
   This is the most confusing. The whole __IRQF_TIMER and last_timer_intr
   logic simply skips over the intermediate samples, so it actually
   detects timer interrupts 64 interrupt (or 1 second) apart.
   Shouldn't that sort of thing actually be looking at *consecutive*
   calls to add_interrupt_randomness?
4) If the above logic denies credit, why deny credit for
   arch_get_random_seed_long as well?

For discussion, here's an example of a change that fixes all of the
above, in patch form.  (The credit_entropy_frac function is omitted but
hopefully obvious.)

The amount of entropy credit particularly needs thought.  I'm currently
using 1/8 of a bit per sample to keep the patch as simple as possible.
This is 8x the current credit if interrupts are frequent, but less if they
occur at less than 8 Hz.  That actually seems on the conservative side
of reasonable to me (1/8 of a bit is odds of 1 in 58.3817), particularly
if there's a cycle timer.


diff --git a/drivers/char/random.c b/drivers/char/random.c
index 03c385f5..c877cb65 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -548,9 +548,8 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 struct fast_pool {
 	__u32		pool[4];
 	unsigned long	last;
-	unsigned short	count;
+	unsigned short	entropy;	/* Entropy, in fractional bits */
 	unsigned char	rotate;
-	unsigned char	last_timer_intr;
 };
 
 /*
@@ -577,7 +576,6 @@ static void fast_mix(struct fast_pool *f, __u32 input[4])
 	input_rotate = (input_rotate + 7) & 31;
 
 	f->rotate = input_rotate;
-	f->count++;
 }
 
 /*
@@ -851,15 +849,33 @@ void add_interrupt_randomness(int irq, int irq_flags)
 
 	fast_mix(fast_pool, input);
 
-	if ((fast_pool->count & 63) && !time_after(now, fast_pool->last + HZ))
+	/*
+	 * If we don't have a vaid cycle counter, don't give credit for
+	 * timer interrupts.  Otherwise, credit 1/8 bit per interrupt.
+	 * (Should there be a difference if there's a cycle counter?)
+	 */
+	if (cycles || (irq_flags & IRQF_TIMER == 0))
+		credit = 1;	/* 1/8 bit */
+	else
+		credit = 0;
+
+	credit += fast_pool->entropy;
+
+	if (credit < 8 << ENTROPY_SHIFT &&
+	    !time_after(now, fast_pool->last + HZ)) {
+		fast_pool->entropy = credit;
 		return;
+	}
+
+	credit = min_t(int, credit, 32 << ENTROPY_SHIFT);
 
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
 	if (!spin_trylock(&r->lock)) {
-		fast_pool->count--;
+		fast_pool->entropy = credit;
 		return;
 	}
 	fast_pool->last = now;
+	fast_pool->entropy = 0;
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
 
 	/*
@@ -867,28 +883,13 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	 * add it to the pool.  For the sake of paranoia count it as
 	 * 50% entropic.
 	 */
-	credit = 1;
 	if (arch_get_random_seed_long(&seed)) {
 		__mix_pool_bytes(r, &seed, sizeof(seed));
-		credit += sizeof(seed) * 4;
+		credit += sizeof(seed) * 4 << entropy_shift;
 	}
 	spin_unlock(&r->lock);
 
-	/*
-	 * If we don't have a valid cycle counter, and we see
-	 * back-to-back timer interrupts, then skip giving credit for
-	 * any entropy, otherwise credit 1 bit.
-	 */
-	if (cycles == 0) {
-		if (irq_flags & __IRQF_TIMER) {
-			if (fast_pool->last_timer_intr)
-				credit = 0;
-			fast_pool->last_timer_intr = 1;
-		} else
-			fast_pool->last_timer_intr = 0;
-	}
-
-	credit_entropy_bits(r, credit);
+	credit_entropy_frac(r, credit);
 }
 
 #ifdef CONFIG_BLOCK
