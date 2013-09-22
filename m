Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3IVUjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:39:20 -0400
Received: from imap.thunk.org ([74.207.234.97]:35973 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3IVUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 07/12] random: allow architectures to optionally define random_get_entropy()
Date: Sun, 22 Sep 2013 16:38:53 -0400
Message-Id: <1379882338-7209-8-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow architectures which have a disabled get_cycles() function to
provide a random_get_entropy() function which provides a fine-grained,
rapidly changing counter that can be used by the /dev/random driver.

For example, an architecture might have a rapidly changing register
used to control random TLB cache eviction, or DRAM refresh that
doesn't meet the requirements of get_cycles(), but which is good
enough for the needs of the random driver.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c |  8 ++++----
 include/linux/timex.h | 17 +++++++++++++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9564144..ba23d5c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -707,7 +707,7 @@ struct timer_rand_state {
  */
 void add_device_randomness(const void *buf, unsigned int size)
 {
-	unsigned long time = get_cycles() ^ jiffies;
+	unsigned long time = random_get_entropy() ^ jiffies;
 	unsigned long flags;
 
 	trace_add_device_randomness(size, _RET_IP_);
@@ -751,7 +751,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		goto out;
 
 	sample.jiffies = jiffies;
-	sample.cycles = get_cycles();
+	sample.cycles = random_get_entropy();
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
@@ -818,7 +818,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
-	__u32			input[4], cycles = get_cycles();
+	__u32			input[4], cycles = random_get_entropy();
 
 	input[0] = cycles ^ jiffies;
 	input[1] = irq;
@@ -1580,7 +1580,7 @@ unsigned int get_random_int(void)
 
 	hash = get_cpu_var(get_random_int_hash);
 
-	hash[0] += current->pid + jiffies + get_cycles();
+	hash[0] += current->pid + jiffies + random_get_entropy();
 	md5_transform(hash, random_int_secret);
 	ret = hash[0];
 	put_cpu_var(get_random_int_hash);
diff --git a/include/linux/timex.h b/include/linux/timex.h
index b3726e6..f9780cc 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -64,6 +64,23 @@
 
 #include <asm/timex.h>
 
+#ifndef random_get_entropy
+/*
+ * The random_get_entropy() function is used by the /dev/random driver
+ * in order to extract entropy via the relative unpredictability of
+ * when an interrupt takes places versus a high speed, fine-grained
+ * timing source or cycle counter.  Since it will be occurred on every
+ * single interrupt, it must have a very low cost/overhead.
+ *
+ * By default we use get_cycles() for this purpose, but individual
+ * architectures may override this in their asm/timex.h header file.
+ */
+static inline cycles_t random_get_entropy(void)
+{
+	return get_cycles();
+}
+#endif
+
 /*
  * SHIFT_PLL is used as a dampening factor to define how much we
  * adjust the frequency correction for a given offset in PLL mode.
-- 
1.7.12.rc0.22.gcdd159b

