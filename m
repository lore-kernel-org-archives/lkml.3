Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbaCUOcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:32:35 -0400
Received: from verein.lst.de ([213.95.11.211]:40342 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbaCUOcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:32:33 -0400
Date: Fri, 21 Mar 2014 15:32:30 +0100
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: [Patch v2 01/03]: provide an injection point for pure hardware
	randomness
Message-ID: <20140321143230.GJ1763@lst.de>
References: <20140321142950.GI1763@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321142950.GI1763@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to the random pool for feeding entropy in-kernel.
It may serve as a destination for dedicated HWRNGs.

It resembles -- and could be merged with -- the ioctl(RNDADDENTROPY) code, plus 
a sleep condition for eager writers.

Signed-off-by: Torsten Duwe <duwe@suse.de>

---
 include/linux/hw_random.h |    2 ++
 drivers/char/random.c     |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -47,5 +47,7 @@ struct hwrng {
 extern int hwrng_register(struct hwrng *rng);
 /** Unregister a Hardware Random Number Generator driver. */
 extern void hwrng_unregister(struct hwrng *rng);
+/** Feed random bits into the pool. */
+extern void add_hwgenerator_randomness(const char *buffer, size_t count, size_t entropy);
 
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
@@ -1347,3 +1347,25 @@ randomize_range(unsigned long start, uns
 		return 0;
 	return PAGE_ALIGN(get_random_int() % range + start);
 }
+
+/* Interface for in-kernel drivers of true hardware RNGs.
+ * Those devices may produce endless random bits and will be throttled
+ * when our pool is full.
+ */
+void add_hwgenerator_randomness(const char *buffer, size_t count,
+				 size_t entropy)
+{
+	struct entropy_store *poolp = &input_pool;
+
+	/* Suspend writing if we're above the trickle threshold.
+	 * We'll be woken up again once below random_write_wakeup_thresh,
+	 * or when the calling thread is about to terminate.
+	 */
+	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+				 input_pool.entropy_count
+					 <= random_write_wakeup_thresh);
+	mix_pool_bytes(poolp, buffer, count, NULL);
+	credit_entropy_bits(poolp, entropy);
+}
+EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
+
