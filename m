Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaFOCUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 22:20:08 -0400
Received: from imap.thunk.org ([74.207.234.97]:39302 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaFOCUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 22:20:07 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>
Subject: [PATCH] random: use an improved fast_mix() function
Date: Sat, 14 Jun 2014 22:19:57 -0400
Message-Id: <1402798797-26251-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more efficient fast_mix() function.  Thanks to George Spelvin for
doing the leg work to find a more efficient mixing function.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>
---
 drivers/char/random.c | 92 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 68 insertions(+), 24 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7ff6dd4..b19edad 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -267,6 +267,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>
 
+/* #define ADD_INTERRUPT_BENCH */
+
 /*
  * Configuration information
  */
@@ -558,25 +560,29 @@ struct fast_pool {
  * collector.  It's hardcoded for an 128 bit pool and assumes that any
  * locks that might be needed are taken by the caller.
  */
-static void fast_mix(struct fast_pool *f, __u32 input[4])
+static void fast_mix(struct fast_pool *f)
 {
-	__u32		w;
-	unsigned	input_rotate = f->rotate;
-
-	w = rol32(input[0], input_rotate) ^ f->pool[0] ^ f->pool[3];
-	f->pool[0] = (w >> 3) ^ twist_table[w & 7];
-	input_rotate = (input_rotate + 14) & 31;
-	w = rol32(input[1], input_rotate) ^ f->pool[1] ^ f->pool[0];
-	f->pool[1] = (w >> 3) ^ twist_table[w & 7];
-	input_rotate = (input_rotate + 7) & 31;
-	w = rol32(input[2], input_rotate) ^ f->pool[2] ^ f->pool[1];
-	f->pool[2] = (w >> 3) ^ twist_table[w & 7];
-	input_rotate = (input_rotate + 7) & 31;
-	w = rol32(input[3], input_rotate) ^ f->pool[3] ^ f->pool[2];
-	f->pool[3] = (w >> 3) ^ twist_table[w & 7];
-	input_rotate = (input_rotate + 7) & 31;
-
-	f->rotate = input_rotate;
+	__u32 a = f->pool[0],	b = f->pool[1];
+	__u32 c = f->pool[2],	d = f->pool[3];
+
+	a += b;			c += d;
+	b = rol32(a, 6);	d = rol32(c, 27);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(a, 16);	d = rol32(c, 14);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(a, 6);	d = rol32(c, 27);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(a, 16);	d = rol32(c, 14);
+	d ^= a;			b ^= c;
+
+	f->pool[0] = a;  f->pool[1] = b;
+	f->pool[2] = c;  f->pool[3] = d;
 	f->count++;
 }
 
@@ -829,6 +835,27 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
+#ifdef ADD_INTERRUPT_BENCH
+static unsigned long avg_cycles, avg_deviation;
+
+#define AVG_SHIFT 8     /* Exponential average factor k=1/256 */
+#define FIXED_1_2 (1 << (AVG_SHIFT-1))
+
+static void add_interrupt_bench(cycles_t start)
+{
+        long delta = random_get_entropy() - start;
+
+        /* Use a weighted moving average */
+        delta = delta - ((avg_cycles + FIXED_1_2) >> AVG_SHIFT);
+        avg_cycles += delta;
+        /* And average deviation */
+        delta = abs(delta) - ((avg_deviation + FIXED_1_2) >> AVG_SHIFT);
+        avg_deviation += delta;
+}
+#else
+#define add_interrupt_bench(x)
+#endif
+
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
@@ -836,22 +863,23 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
 	cycles_t		cycles = random_get_entropy();
-	__u32			input[4], c_high, j_high;
+	__u32			c_high, j_high;
 	__u64			ip;
 	unsigned long		seed;
 	int			credit = 0;
 
 	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
 	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
-	input[0] = cycles ^ j_high ^ irq;
-	input[1] = now ^ c_high;
+	fast_pool->pool[0] ^= cycles ^ j_high ^ irq;
+	fast_pool->pool[1] ^= now ^ c_high;
 	ip = regs ? instruction_pointer(regs) : _RET_IP_;
-	input[2] = ip;
-	input[3] = ip >> 32;
+	fast_pool->pool[2] ^= ip;
+	fast_pool->pool[3] ^= ip >> 32;
 
-	fast_mix(fast_pool, input);
+	fast_mix(fast_pool);
 	if ((irq_flags & __IRQF_TIMER) == 0)
 		fast_pool->notimer_count++;
+	add_interrupt_bench(cycles);
 
 	if (cycles) {
 		if ((fast_pool->count < 64) &&
@@ -1648,6 +1676,22 @@ struct ctl_table random_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_do_uuid,
 	},
+#ifdef ADD_INTERRUPT_BENCH
+	{
+		.procname	= "add_interrupt_avg_cycles",
+		.data		= &avg_cycles,
+		.maxlen		= sizeof(avg_cycles),
+		.mode		= 0444,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "add_interrupt_avg_deviation",
+		.data		= &avg_deviation,
+		.maxlen		= sizeof(avg_deviation),
+		.mode		= 0444,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#endif
 	{ }
 };
 #endif 	/* CONFIG_SYSCTL */
-- 
2.0.0

