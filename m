Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab3J1PHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:07:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab3J1Osr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 11/64] random: allow architectures to optionally define random_get_entropy()
Date: Mon, 28 Oct 2013 14:47:30 +0000
Message-Id: <1382971703-17393-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 61875f30daf60305712e25b209ef41ced2635bad upstream.

Allow architectures which have a disabled get_cycles() function to
provide a random_get_entropy() function which provides a fine-grained,
rapidly changing counter that can be used by the /dev/random driver.

For example, an architecture might have a rapidly changing register
used to control random TLB cache eviction, or DRAM refresh that
doesn't meet the requirements of get_cycles(), but which is good
enough for the needs of the random driver.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/random.c |  8 ++++----
 include/linux/timex.h | 14 ++++++++++++++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e0b3680..08b4e70 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -646,7 +646,7 @@ struct timer_rand_state {
  */
 void add_device_randomness(const void *buf, unsigned int size)
 {
-	unsigned long time = get_cycles() ^ jiffies;
+	unsigned long time = random_get_entropy() ^ jiffies;
 
 	mix_pool_bytes(&input_pool, buf, size, NULL);
 	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
@@ -683,7 +683,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		goto out;
 
 	sample.jiffies = jiffies;
-	sample.cycles = get_cycles();
+	sample.cycles = random_get_entropy();
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
@@ -750,7 +750,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
-	__u32			input[4], cycles = get_cycles();
+	__u32			input[4], cycles = random_get_entropy();
 
 	input[0] = cycles ^ jiffies;
 	input[1] = irq;
@@ -1470,7 +1470,7 @@ unsigned int get_random_int(void)
 
 	hash = get_cpu_var(get_random_int_hash);
 
-	hash[0] += current->pid + jiffies + get_cycles();
+	hash[0] += current->pid + jiffies + random_get_entropy();
 	md5_transform(hash, random_int_secret);
 	ret = hash[0];
 	put_cpu_var(get_random_int_hash);
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 99bc88b..a647f36 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -173,6 +173,20 @@ struct timex {
 
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
+#define random_get_entropy()	get_cycles()
+#endif
+
 /*
  * SHIFT_PLL is used as a dampening factor to define how much we
  * adjust the frequency correction for a given offset in PLL mode.
-- 
1.8.3.2

