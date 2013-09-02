Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3IBQtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:49:53 -0400
Received: from verein.lst.de ([213.95.11.211]:34206 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab3IBQtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:49:41 -0400
Date: Mon, 2 Sep 2013 18:42:38 +0200 (CEST)
From: Torsten Duwe <duwe@lst.de>
Reply-To: Torsten Duwe <duwe@lst.de>
To: tytso@mit.edu
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] add direct interface for true hardware RNGs
Message-ID: <alpine.LNX.2.00.1309021841440.2540@linux.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: LST e.V.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds an interface to the random pool for feeding entropy in-kernel.
It might be dangerous when some driver writers think they have "good"
randomness when really they haven't.

Signed-off-by: Torsten Duwe <duwe@lst.de>

---
 include/linux/hw_random.h |    2 ++
 drivers/char/random.c     |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -47,5 +47,7 @@ struct hwrng {
 extern int hwrng_register(struct hwrng *rng);
 /** Unregister a Hardware Random Number Generator driver. */
 extern void hwrng_unregister(struct hwrng *rng);
+/** Feed random bits into the pool. */
+extern void add_hwgenerator_randomness(const char *buffer, size_t count);
 
 #endif /* LINUX_HWRANDOM_H_ */
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -250,6 +250,7 @@
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/spinlock.h>
+#include <linux/kthread.h>
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
 #include <linux/fips.h>
@@ -796,6 +797,25 @@ add_disk_randomness(
 }
 #endif
 
+/* Interface for in-kernel drivers of true hardware RNGs.
+ * Those devices may produce endless random bits and will be throttled
+ * when our pool is full.
+ */
+void add_hwgenerator_randomness(const char *buffer, size_t count)
+{
+	struct entropy_store *poolp = &input_pool;
+
+	/* Suspend writing if we're above the trickle threshold.
+	 * We'll be woken up again once below random_write_wakeup_thresh,
+	 * or when the calling thread is about to terminate.
+	 */
+	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+				 input_pool.entropy_count <= trickle_thresh);
+	mix_pool_bytes(poolp, buffer, count, NULL);
+	credit_entropy_bits(poolp, count*8);
+}
+EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
+
 /*********************************************************************
  *
  * Entropy extraction routines
