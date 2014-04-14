Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaDNPuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:50:35 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65263 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaDNPua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:50:30 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Greg Price <price@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH resend 1/2] random: Add add_drbg_randomness to safely seed urandom from crypto hw
Date: Mon, 14 Apr 2014 08:49:59 -0700
Message-Id: <0404bf073ae281deffbff0235d497abd8f8f0ba4.1397487345.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1397487345.git.luto@amacapital.net>
References: <cover.1397487345.git.luto@amacapital.net>
In-Reply-To: <cover.1397487345.git.luto@amacapital.net>
References: <cover.1397487345.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has been a longstanding debate as to how devices such as TPMs
should be used to seed the kernel's RNG.  Arguments in this debate
include:

 - The TPM is untrustworthy and possibly malicious, so we shouldn't use
   it.

 - The TPM almost certainly supplies no real entropy, so we shouldn't
   credit any entropy from it.

The upshot is that we don't use TPM-like devices at all as entropy
sources, unless CONFIG_HW_RANDOM_TPM is set, in which case we use it in
a way that looks rather wrong to me.

Let's resolve this problem by calling these devices what they are:
DRBGs, aka deterministic random bit generators.  They may be broken,
they may be backdoored, they're probably deterministic, they arguably
shouldn't supply any entropy credits, but they're still valuable sources
of cryptographic data to mix into at least the urandom pool.

This adds add_drbg_randomness to allow these devices to safely seed
urandom.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/random.c         | 56 +++++++++++++++++++++++++++++++++++++------
 include/linux/random.h        |  1 +
 include/trace/events/random.h | 19 +++++++++++++++
 3 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6b75713..8c18722 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -125,12 +125,24 @@
  * The current exported interfaces for gathering environmental noise
  * from the devices are:
  *
+ *	void add_drbg_randomness(const void *buf, unsigned int size);
  *	void add_device_randomness(const void *buf, unsigned int size);
  * 	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
  *	void add_interrupt_randomness(int irq, int irq_flags);
  * 	void add_disk_randomness(struct gendisk *disk);
  *
+ * add_drbg_randomness() adds data from a so-called hardware rng.  These
+ * devices can include TPMs, hypervisors, and similar sources of
+ * hopefully cryptographically secure bits of uncertain quality.
+ * add_drbg_randomness() should not be called for
+ * arch_get_random_long-style RNGs, as the core random code does that
+ * automatically.  There is no requirement that add_drbg_randomness be
+ * provided with any actual entropy.  In cases where the number of bits
+ * provided is easy to adjust and where security could realistically
+ * depend on the number of bits provided, 256 bits or more should be
+ * used.
+ *
  * add_device_randomness() is for adding data to the random pool that
  * is likely to differ between two devices (or possibly even per boot).
  * This would be things like MAC addresses or serial numbers, or the
@@ -466,6 +478,12 @@ static struct entropy_store nonblocking_pool = {
 					push_to_pool),
 };
 
+/*
+ * Tracks total bits supplied to add_drbg_randomness.  Protected by
+ * nonblocking_pool.lock.
+ */
+static __u64 total_drbg_input;
+
 static __u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
@@ -654,11 +672,12 @@ retry:
 	r->entropy_total += nbits;
 	if (!r->initialized && r->entropy_total > 128) {
 		r->initialized = 1;
-		r->entropy_total = 0;
 		if (r == &nonblocking_pool) {
 			prandom_reseed_late();
-			pr_notice("random: %s pool is initialized\n", r->name);
+			pr_notice("random: %s pool is initialized with %d bits of entropy and %llu bits of DRBG data\n",
+				  r->name, r->entropy_total, total_drbg_input);
 		}
+		r->entropy_total = 0;
 	}
 
 	trace_credit_entropy_bits(r->name, nbits,
@@ -725,6 +744,23 @@ struct timer_rand_state {
 #define INIT_TIMER_RAND_STATE { INITIAL_JIFFIES, };
 
 /*
+ * Add DRBG randomness.  This type of input is not trusted enough to go
+ * to the blocking pool, and no entropy is credited, but it can substantially
+ * strengthen the nonblocking pool, especially during and shortly after
+ * boot.
+ */
+void add_drbg_randomness(const void *buf, unsigned int size)
+{
+	unsigned long flags;
+	trace_add_drbg_randomness(size, _RET_IP_);
+	spin_lock_irqsave(&nonblocking_pool.lock, flags);
+	_mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
+	total_drbg_input += size * 8;
+	spin_unlock_irqrestore(&nonblocking_pool.lock, flags);
+}
+EXPORT_SYMBOL(add_drbg_randomness);
+
+/*
  * Add device- or boot-specific data to the input and nonblocking
  * pools to help initialize them to unique values.
  *
@@ -1246,16 +1282,22 @@ static void init_std_data(struct entropy_store *r)
 	int i;
 	ktime_t now = ktime_get_real();
 	unsigned long rv;
+	__u64 drbg_bits = 0;
 
 	r->last_pulled = jiffies;
 	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
+		if (arch_get_random_seed_long(&rv) ||
+		    arch_get_random_long(&rv))
+			drbg_bits += sizeof(unsigned long) * 8;
+		else
 			rv = random_get_entropy();
 		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
 	}
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
+
+	if (r == &nonblocking_pool && drbg_bits)
+		total_drbg_input += drbg_bits;
 }
 
 /*
@@ -1367,9 +1409,9 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	int ret;
 
 	if (unlikely(nonblocking_pool.initialized == 0))
-		printk_once(KERN_NOTICE "random: %s urandom read "
-			    "with %d bits of entropy available\n",
-			    current->comm, nonblocking_pool.entropy_total);
+		printk_once(KERN_NOTICE "random: %s urandom read with %d bits of entropy available and %llu bits of DRBG data\n",
+			    current->comm, nonblocking_pool.entropy_total,
+			    total_drbg_input);
 
 	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
 
diff --git a/include/linux/random.h b/include/linux/random.h
index 57fbbff..2e202a0 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -8,6 +8,7 @@
 
 #include <uapi/linux/random.h>
 
+extern void add_drbg_randomness(const void *, unsigned int);
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 805af6d..8a81e49 100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -7,6 +7,25 @@
 #include <linux/writeback.h>
 #include <linux/tracepoint.h>
 
+TRACE_EVENT(add_drbg_randomness,
+	TP_PROTO(int bytes, unsigned long IP),
+
+	TP_ARGS(bytes, IP),
+
+	TP_STRUCT__entry(
+		__field(	  int,	bytes			)
+		__field(unsigned long,	IP			)
+	),
+
+	TP_fast_assign(
+		__entry->bytes		= bytes;
+		__entry->IP		= IP;
+	),
+
+	TP_printk("bytes %d caller %pF",
+		__entry->bytes, (void *)__entry->IP)
+);
+
 TRACE_EVENT(add_device_randomness,
 	TP_PROTO(int bytes, unsigned long IP),
 
-- 
1.9.0

