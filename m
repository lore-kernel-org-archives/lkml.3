Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaDNQEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:04:44 -0400
Received: from verein.lst.de ([213.95.11.211]:49476 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbaDNQEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:04:41 -0400
Date: Mon, 14 Apr 2014 18:04:38 +0200
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v3 01/03]: hwrng: provide an injection point for pure
	hardware randomness
Message-ID: <20140414160438.GA29351@lst.de>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de> <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com> <20140414160211.GE711@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414160211.GE711@lst.de>
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
