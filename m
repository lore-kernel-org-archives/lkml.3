Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaESVSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:18:52 -0400
Received: from longford.logfs.org ([213.229.74.203]:43342 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaESVSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:18:50 -0400
Date: Mon, 19 May 2014 17:17:19 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140519211719.GA14563@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/char/random.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75bb60e8..b4a8968fe28d 100644
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
@@ -835,6 +837,61 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
+/*
+ * Ratelimit to a steady state of about once per jiffy.  A naïve approach
+ * would be to return 1 every time jiffies changes.  But we want to avoid
+ * being closely coupled to the timer interrupt.  So instead we increment
+ * a counter on every call and shift it right every time jiffies changes.
+ * If the counter is a power of two, return false;
+ *
+ * Effect is that some time after a jiffies change and cutting the counter
+ * in half we reach another power of two and return false.  But the
+ * likelihood of this happening is about the same at any time within a
+ * jiffies interval.
+ */
+static inline int ratelimited(struct fast_pool *p)
+{
+	int ret = !(p->regs_count == 0 || is_power_of_2(p->regs_count));
+
+	p->regs_count++;
+	if (p->last_shift != (u32)jiffies) {
+		p->regs_count >>= min(31u, (u32)jiffies - p->last_shift);
+		p->last_shift = (u32)jiffies;
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
@@ -845,13 +902,14 @@ void add_interrupt_randomness(int irq, int irq_flags)
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

