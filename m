Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3IJLbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:31:48 -0400
Received: from mail.eperm.de ([89.247.134.16]:51063 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab3IJLbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:31:47 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Cc: dave.taht@bufferbloat.net
Subject: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Tue, 10 Sep 2013 13:31:41 +0200
Message-ID: <10005394.BRCyBMYWy3@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

/dev/random uses the get_cycles() function to obtain entropy in addition to jiffies and the event value of hardware events.

Typically the high-resolution timer of get_cycles delivers the majority of entropy, because the event value is quite deterministic and jiffies are very coarse.

However, on the following architectures, get_cycles will return 0:

- MIPS

- User mode Linux

- Sparc 32 bit

- M68K

- M32R

- Hexagon

- H8/300

- FR-V

- CRIS

- AVR32

- ARC

- METAG

- Microblaze

- SCORE

- SH

- Unicore32

That means that on those architectures, /dev/random will not deliver as much entropy as you would hope.

The following patch uses the clocksource clock for a time value in case get_cycles returns 0. As clocksource may not be available during boot time, a flag is introduced which allows random.c to check the availability of clocksource.

Patch tested with disabled call to get_cycles on an x86_64 system to verify that clocksource delivers data.

Ciao
Stephan

Signed-off-by: Stephan Mueller <smueller@chronox.de>

---
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0d91fe5..d2d14a1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -255,6 +255,7 @@
 #include <linux/fips.h>
 #include <linux/ptrace.h>
 #include <linux/kmemcheck.h>
+#include <linux/time.h>
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 # include <linux/irq.h>
@@ -633,6 +634,23 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
+static inline __u64 get_nstime(void)
+{
+	struct timespec ts;
+	__u64 tmp = 0;
+
+	tmp = get_cycles();
+
+	if((0 == tmp) &&
+	   timekeeping_initialized() &&
+	   (0 == __getnstimeofday(&ts)))
+	{
+		tmp = ts.tv_sec;
+		tmp = tmp << 32;
+		tmp = tmp | ts.tv_nsec;
+	}
+	return tmp;
+}
 /*
  * Add device- or boot-specific data to the input and nonblocking
  * pools to help initialize them to unique values.
@@ -643,7 +661,7 @@ struct timer_rand_state {
  */
 void add_device_randomness(const void *buf, unsigned int size)
 {
-	unsigned long time = get_cycles() ^ jiffies;
+	unsigned long time = get_nstime() ^ jiffies;
 
 	mix_pool_bytes(&input_pool, buf, size, NULL);
 	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
@@ -680,7 +698,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		goto out;
 
 	sample.jiffies = jiffies;
-	sample.cycles = get_cycles();
+	sample.cycles = get_nstime();
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
@@ -747,7 +765,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
-	__u32			input[4], cycles = get_cycles();
+	__u32			input[4], cycles = get_nstime();
 
 	input[0] = cycles ^ jiffies;
 	input[1] = irq;
@@ -1486,7 +1504,7 @@ unsigned int get_random_int(void)
 
 	hash = get_cpu_var(get_random_int_hash);
 
-	hash[0] += current->pid + jiffies + get_cycles();
+	hash[0] += current->pid + jiffies + get_nstime();
 	md5_transform(hash, random_int_secret);
 	ret = hash[0];
 	put_cpu_var(get_random_int_hash);
diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..0922661 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -180,6 +180,7 @@ extern int timekeeping_inject_offset(struct timespec *ts);
 extern s32 timekeeping_get_tai_offset(void);
 extern void timekeeping_set_tai_offset(s32 tai_offset);
 extern void timekeeping_clocktai(struct timespec *ts);
+extern bool timekeeping_initialized(void);
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 48b9fff..75b1613 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -35,6 +35,7 @@ static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
 static seqcount_t timekeeper_seq;
 static struct timekeeper shadow_timekeeper;
+static bool timekeeper_enabled = 0;
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
@@ -833,8 +834,15 @@ void __init timekeeping_init(void)
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+	timekeeper_enabled = 1;
 }
 
+bool timekeeping_initialized(void)
+{
+	return timekeeper_enabled;
+}
+EXPORT_SYMBOL(timekeeping_initialized);
+
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
 

