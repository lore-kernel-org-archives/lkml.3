Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3KYNyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:54:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58890 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab3KYNxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:43 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.716979797@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 58/87] random: allow architectures to optionally
 define random_get_entropy()
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c |  8 ++++----
 include/linux/timex.h | 14 ++++++++++++++
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -668,7 +668,7 @@ static void set_timer_rand_state(unsigne
  */
 void add_device_randomness(const void *buf, unsigned int size)
 {
-	unsigned long time = get_cycles() ^ jiffies;
+	unsigned long time = random_get_entropy() ^ jiffies;
 
 	mix_pool_bytes(&input_pool, buf, size, NULL);
 	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
@@ -705,7 +705,7 @@ static void add_timer_randomness(struct
 		goto out;
 
 	sample.jiffies = jiffies;
-	sample.cycles = get_cycles();
+	sample.cycles = random_get_entropy();
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
@@ -772,7 +772,7 @@ void add_interrupt_randomness(int irq, i
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
-	__u32			input[4], cycles = get_cycles();
+	__u32			input[4], cycles = random_get_entropy();
 
 	input[0] = cycles ^ jiffies;
 	input[1] = irq;
@@ -1503,7 +1503,7 @@ unsigned int get_random_int(void)
 
 	hash = get_cpu_var(get_random_int_hash);
 
-	hash[0] += current->pid + jiffies + get_cycles();
+	hash[0] += current->pid + jiffies + random_get_entropy();
 	md5_transform(hash, random_int_secret);
 	ret = hash[0];
 	put_cpu_var(get_random_int_hash);
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

