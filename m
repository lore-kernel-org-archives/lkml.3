Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaFLU1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:27:33 -0400
Received: from longford.logfs.org ([213.229.74.203]:43527 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaFLU1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:27:32 -0400
Date: Thu, 12 Jun 2014 16:25:29 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140612202529.GB16012@logfs.org>
References: <20140519211719.GA14563@logfs.org>
 <20140610161401.GC12104@thunk.org>
 <20140611001009.GA24626@logfs.org>
 <20140611152742.GC27151@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140611152742.GC27151@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 June 2014 11:27:42 -0400, Theodore Ts'o wrote:
> On Tue, Jun 10, 2014 at 08:10:09PM -0400, Jörn Engel wrote:
> > > I'm also concerned about how much overhead this might eat up.  I've
> > > already had someone who was benchmarking a high performance storage
> > > array where the increased interrupt latency before adding something
> > > like this was something he noticed, and kvetched to me about.  The
> > > pt_regs structure is going to be larger than the fast_pool (which is
> > > only 16 bytes), and we're going to be doing it once every jiffy, which
> > > means between 100 and 1000 times per second.
> > 
> > Would that someone be me? ;)
> > 
> > The reason I prefer doing it once every jiffy is that it doesn't
> > change with interrupt load.  You get 10k interrupts per second?
> > You pay once per jiffy.  100k interrupts per second?  Pay once per
> > jiffy.
> 
> No, actually, it was someone who was worried about tail latency.  So
> even if the average overhead was small, if once a jiffy we had a much
> larger time spent in the interrupt handler, that's something that
> would a big concern for someone who was worried about big storage
> array performance.
> 
> I'd be happier if we used fast_mix() and mixed the registers into the
> fast pool.  That's much lighter weight than using mix_pool_bytes(),
> which involves many more memory accesses, MUCH higher probably of
> cache line bouncing between CPU's, etc.
> 
> And there has been some proposals that I've been looking at to make
> fast_mix to be use even less overhead, so if we use fast_mix, any
> changes we make to improve that will help here too.

That makes sense to me.  It would require replacing current fast_mix()
with somethat doesn't doesn't assume __u32 input[4] as the only
possible parameter.  In a previous incarnation of my patch I was using
a single round of siphash to condense the registers and added that to
our fast_pool.

While siphash is fairly fast, doing that for every interrupt seemed
too much for me, hence the current ratelimit approach.  But if people
care more about maximum latency than amortized cost, we can combine
siphash (or something similar) with the ratelimit.

At any rate, here is a slightly updated patch that is independent of
CONFIG_HZ.

Jörn

--
"Error protection by error detection and correction."
-- from a university class

>From 867d62e0165723f9d8dc568d0cb9d8898948ddaa Mon Sep 17 00:00:00 2001
From: Joern Engel <joern@logfs.org>
Date: Sat, 15 Feb 2014 16:29:28 -0800
Subject: [PATCH] random: mix all saved registers into entropy pool

The single biggest entropy source is a high-resolution timer running
asynchronous to the triggering event.  That leaves systems without a
useful get_cycles() implementation with significantly less entropy.
Significant means orders of magnitude, not a few percent.

An alternate high-resolution timer is the register content at the time
of an interrupt.  While not monotonic, it is guaranteed to change every
few clock cycles and very unlikely to repeat the same pattern.  Not
useful for interpretation as time, but we only care about some bits
of the "clock" flipping in an unpredictable fashion.

Experimentation show this to be an excellent entropy source.  Doing 1000
boottests with kvm and dumping a hash of the registers for the first
1024 interrupts each, >40% of all hashes were unique and >80% of all
hashes occurred less than once 1% of the time.

Even assuming that only unique register hashes yield any entropy at all
and only one bit each, we would gather >400 bits of entropy early in
boot and another 40 bits/s from the timer interrupt during runtime.  I
would feel confident with this amount of entropy in the absence of any
other source.

Repeating the test on real hardware, albeit with fewer repetitions
yields roughly the same results, slightly above 40% unique hashes.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/char/random.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75bb60e8..8e9f6274cf76 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -553,6 +553,8 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 
 struct fast_pool {
 	__u32		pool[4];
+	u32		last_shift;
+	u32		regs_count;
 	unsigned long	last;
 	unsigned short	count;
 	unsigned char	rotate;
@@ -835,6 +837,64 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
+/*
+ * Ratelimit to a steady state of about 50Hz.  A naïve approach would be
+ * to return 1 every time jiffies changes.  But we want to avoid being
+ * closely coupled to the timer interrupt.  So instead we increment a
+ * counter on every call and shift it right every time jiffies increments
+ * by 20ms.
+ * 20ms or 50Hz is chosen to work well for all options of CONFIG_HZ.
+ * If the counter is a power of two, return false.
+ *
+ * Effect is that some time after a jiffies change and cutting the counter
+ * in half we reach another power of two and return false.  But the
+ * likelihood of this happening is about the same at any time within a
+ * jiffies interval.
+ */
+static inline int ratelimited(struct fast_pool *p)
+{
+	int ret = !(p->regs_count == 0 || is_power_of_2(p->regs_count));
+	u32 jiffies_low = (u32)jiffies;
+
+	p->regs_count++;
+	if (p->last_shift > jiffies_low || p->last_shift + HZ/50 <= jiffies_low) {
+		p->regs_count >>= 1;
+		p->last_shift = jiffies_low;
+	}
+	return ret;
+}
+
+#define BOOT_IRQS 1024
+
+/*
+ * The single biggest entropy source is a high-resolution timer running
+ * asynchronous to the triggering event.  That leaves systems without a
+ * useful get_cycles() implementation with significantly less entropy.
+ * Significant means orders of magnitude, not a few percent.
+ *
+ * An alternate high-resolution timer is the register content at the time
+ * of an interrupt.  While not monotonic, it is guaranteed to change every
+ * few clock cycles and very unlikely to repeat the same pattern.  Not
+ * useful for interpretation as time, but we only care about some bits
+ * of the "clock" flipping in an unpredictable fashion.
+ */
+static void mix_regs(struct pt_regs *regs, struct fast_pool *fast_pool)
+{
+	struct entropy_store	*r;
+	/* Two variables avoid decrementing by two without using atomics */
+	static int boot_count = BOOT_IRQS;
+	int in_boot = boot_count;
+
+	if (in_boot) {
+		boot_count = in_boot - 1;
+	} else if (ratelimited(fast_pool))
+		return;
+
+	/* During bootup we alternately feed both pools */
+	r = (in_boot & 1) ? &nonblocking_pool : &input_pool;
+	__mix_pool_bytes(r, regs, sizeof(*regs), NULL);
+}
+
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
@@ -845,13 +905,14 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	__u32			input[4], c_high, j_high;
 	__u64			ip;
 
+	mix_regs(regs, fast_pool);
 	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
 	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
-	input[0] = cycles ^ j_high ^ irq;
-	input[1] = now ^ c_high;
+	input[0] ^= cycles ^ j_high ^ irq;
+	input[1] ^= now ^ c_high;
 	ip = regs ? instruction_pointer(regs) : _RET_IP_;
-	input[2] = ip;
-	input[3] = ip >> 32;
+	input[2] ^= ip;
+	input[3] ^= ip >> 32;
 
 	fast_mix(fast_pool, input);
 
-- 
2.0.0.rc0.1.g7b2ba98

