Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaFNHPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 03:15:44 -0400
Received: from imap.thunk.org ([74.207.234.97]:38709 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaFNHPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 03:15:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>
Subject: [PATCH-v2 4/4] random: clean up interrupt entropy accounting for archs w/o cycle counters
Date: Sat, 14 Jun 2014 03:15:18 -0400
Message-Id: <1402730118-23122-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402730118-23122-1-git-send-email-tytso@mit.edu>
References: <1402730118-23122-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For architectures that don't have cycle counters, the algorithm for
deciding when to avoid giving entropy credit due to back-to-back timer
interrupts didn't make any sense, since we were checking every 64
interrupts.  Change it so that we only give an entropy credit if the
majority of the interrupts are not based on the timer.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>
---
 drivers/char/random.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9a59101..60eecfc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -548,9 +548,9 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 struct fast_pool {
 	__u32		pool[4];
 	unsigned long	last;
-	unsigned short	count;
+	unsigned char	count;
+	unsigned char	notimer_count;
 	unsigned char	rotate;
-	unsigned char	last_timer_intr;
 };
 
 /*
@@ -850,6 +850,8 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	input[3] = ip >> 32;
 
 	fast_mix(fast_pool, input);
+	if ((irq_flags & __IRQF_TIMER) == 0)
+		fast_pool->notimer_count++;
 
 	if ((fast_pool->count & 63) && !time_after(now, fast_pool->last + HZ))
 		return;
@@ -874,19 +876,15 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	spin_unlock(&r->lock);
 
 	/*
-	 * If we don't have a valid cycle counter, and we see
-	 * back-to-back timer interrupts, then skip giving credit for
-	 * any entropy, otherwise credit 1 bit.
+	 * If we have a valid cycle counter or if the majority of
+	 * interrupts collected were non-timer interrupts, then give
+	 * an entropy credit of 1 bit.  Yes, this is being very
+	 * conservative.
 	 */
-	credit++;
-	if (cycles == 0) {
-		if (irq_flags & __IRQF_TIMER) {
-			if (fast_pool->last_timer_intr)
-				credit--;
-			fast_pool->last_timer_intr = 1;
-		} else
-			fast_pool->last_timer_intr = 0;
-	}
+	if (cycles || (fast_pool->notimer_count >= 32))
+		credit++;
+
+	fast_pool->count = fast_pool->notimer_count = 0;
 
 	credit_entropy_bits(r, credit);
 }
-- 
2.0.0

