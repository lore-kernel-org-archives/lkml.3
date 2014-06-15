Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaFOVTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 17:19:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:39933 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbaFOVTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 17:19:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: linux@horizon.com, "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>
Subject: [PATCH] random: use registers from interrupted code for CPU's w/o a cycle counter
Date: Sun, 15 Jun 2014 17:19:25 -0400
Message-Id: <1402867165-15464-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For CPU's that don't have a cycle counter, or something equivalent
which can be used for random_get_entropy(), random_get_entropy() will
always return 0.  In that case, substitute with the saved interrupt
registers to add a bit more unpredictability.

Some folks have suggested hashing all of the registers
unconditionally, but this would increase the overhead of
add_interrupt_randomness() by at least an order of magnitude, and this
would very likely be unacceptable.

The changes in this commit have been benchmarked as mostly unaffecting
the overhead of add_interrupt_randomness() if the entropy counter is
present, and doubling the overhead if it is not present.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Jörn Engel <joern@logfs.org>
---
 drivers/char/random.c | 47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 07b82cb..13c4da4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -551,9 +551,8 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 struct fast_pool {
 	__u32		pool[4];
 	unsigned long	last;
+	unsigned short	reg_idx;
 	unsigned char	count;
-	unsigned char	notimer_count;
-	unsigned char	rotate;
 };
 
 /*
@@ -857,6 +856,17 @@ static void add_interrupt_bench(cycles_t start)
 #define add_interrupt_bench(x)
 #endif
 
+static __u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
+{
+	__u32 *ptr = (__u32 *) regs;
+
+	if (regs == 0)
+		return 0;
+	if (f->reg_idx >= sizeof(struct pt_regs) / sizeof(__u32))
+		f->reg_idx = 0;
+	return *(ptr + f->reg_idx++);
+}
+
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
@@ -869,28 +879,23 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	unsigned long		seed;
 	int			credit = 0;
 
+	if (cycles == 0)
+		cycles = get_reg(fast_pool, regs);
 	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
 	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
 	fast_pool->pool[0] ^= cycles ^ j_high ^ irq;
 	fast_pool->pool[1] ^= now ^ c_high;
 	ip = regs ? instruction_pointer(regs) : _RET_IP_;
 	fast_pool->pool[2] ^= ip;
-	fast_pool->pool[3] ^= ip >> 32;
+	fast_pool->pool[3] ^= (sizeof(ip) > 4) ? ip >> 32 :
+		get_reg(fast_pool, regs);
 
 	fast_mix(fast_pool);
-	if ((irq_flags & __IRQF_TIMER) == 0)
-		fast_pool->notimer_count++;
 	add_interrupt_bench(cycles);
 
-	if (cycles) {
-		if ((fast_pool->count < 64) &&
-		    !time_after(now, fast_pool->last + HZ))
-			return;
-	} else {
-		/* CPU does not have a cycle counting register :-( */
-		if (fast_pool->count < 64)
-			return;
-	}
+	if ((fast_pool->count < 64) &&
+	    !time_after(now, fast_pool->last + HZ))
+		return;
 
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
 	if (!spin_trylock(&r->lock))
@@ -910,18 +915,10 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	}
 	spin_unlock(&r->lock);
 
-	/*
-	 * If we have a valid cycle counter or if the majority of
-	 * interrupts collected were non-timer interrupts, then give
-	 * an entropy credit of 1 bit.  Yes, this is being very
-	 * conservative.
-	 */
-	if (cycles || (fast_pool->notimer_count >= 32))
-		credit++;
-
-	fast_pool->count = fast_pool->notimer_count = 0;
+	fast_pool->count = 0;
 
-	credit_entropy_bits(r, credit);
+	/* award one bit for the contents of the fast pool */
+	credit_entropy_bits(r, credit + 1);
 }
 
 #ifdef CONFIG_BLOCK
-- 
2.0.0

