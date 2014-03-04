Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbaCDWkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:40:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:62908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbaCDWkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:40:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,588,1389772800"; 
   d="scan'208";a="494106885"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 2/3] random: Use arch_get_random_seed*() at init time and once a second
Date: Tue,  4 Mar 2014 14:40:14 -0800
Message-Id: <1393972815-16689-3-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
References: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Use arch_get_random_seed*() in two places in the Linux random
driver (drivers/char/random.c):

1. During entropy pool initialization, use RDSEED in favor of RDRAND,
   with a fallback to the latter.  Entropy exhaustion is unlikely to
   happen there on physical hardware as the machine is single-threaded
   at that point, but could happen in a virtual machine.  In that
   case, the fallback to RDRAND will still provide more than adequate
   entropy pool initialization.

2. Once a second, issue RDSEED and, if successful, feed it to the
   entropy pool.  To ensure an extra layer of security, only credit
   half the entropy just in case.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/char/random.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75b..b1d5ae2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -844,6 +844,8 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	cycles_t		cycles = random_get_entropy();
 	__u32			input[4], c_high, j_high;
 	__u64			ip;
+	unsigned long		seed;
+	int			credit;
 
 	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
 	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
@@ -862,20 +864,33 @@ void add_interrupt_randomness(int irq, int irq_flags)
 
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
+
 	/*
 	 * If we don't have a valid cycle counter, and we see
 	 * back-to-back timer interrupts, then skip giving credit for
-	 * any entropy.
+	 * any entropy, otherwise credit 1 bit.
 	 */
+	credit = 1;
 	if (cycles == 0) {
 		if (irq_flags & __IRQF_TIMER) {
 			if (fast_pool->last_timer_intr)
-				return;
+				credit = 0;
 			fast_pool->last_timer_intr = 1;
 		} else
 			fast_pool->last_timer_intr = 0;
 	}
-	credit_entropy_bits(r, 1);
+
+	/*
+	 * If we have architectural seed generator, produce a seed and
+	 * add it to the pool.  For the sake of paranoia count it as
+	 * 50% entropic.
+	 */
+	if (arch_get_random_seed_long(&seed)) {
+		__mix_pool_bytes(r, &seed, sizeof(seed), NULL);
+		credit += sizeof(seed) * 4;
+	}
+
+	credit_entropy_bits(r, credit);
 }
 
 #ifdef CONFIG_BLOCK
@@ -1238,7 +1253,8 @@ static void init_std_data(struct entropy_store *r)
 	r->last_pulled = jiffies;
 	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
-		if (!arch_get_random_long(&rv))
+		if (!arch_get_random_seed_long(&rv) &&
+		    !arch_get_random_long(&rv))
 			rv = random_get_entropy();
 		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
 	}
-- 
1.8.3.1

