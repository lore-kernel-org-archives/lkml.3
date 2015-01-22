Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbbAVNGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:06:47 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54782 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbAVNGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:06:45 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2] sched_clock: Avoid deadlock during read from NMI
Date: Thu, 22 Jan 2015 13:06:37 +0000
Message-Id: <1421931997-13609-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421859236-19782-1-git-send-email-daniel.thompson@linaro.org>
References: <1421859236-19782-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is possible for an NMI (or FIQ on ARM) to come in and
read sched_clock() whilst update_sched_clock() has locked the seqcount
for writing. This results in the NMI handler locking up when it calls
raw_read_seqcount_begin().

This patch fixes that problem by providing banked clock data in a
similar manner to Thomas Gleixner's 4396e058c52e("timekeeping: Provide
fast and NMI safe access to CLOCK_MONOTONIC").

Changing the mode of operation of the seqcount away from the traditional
LSB-means-interrupted-write to a banked approach also revealed a good deal
of "fake" write locking within sched_clock_register(). This is likely
to be a latent issue because sched_clock_register() is typically called
before we enable interrupts. Nevertheless the issue has been eliminated
by increasing the scope of the read locking performed by sched_clock().

Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    Tested on i.MX6 with perf drowning the system in FIQs and using the perf
    handler to check that sched_clock() returns monotonic values. At the
    same time I forcefully reduced kt_wrap so that update_sched_clock()
    is being called at >1000Hz.
    
    Without the patch the above system is grossly unstable, surviving
    [9K,115K,25K] perf event cycles during three separate runs. With the
    patch I ran for over 11M perf event cycles before getting bored.
    
    v2:
    
    * Extended the scope of the read lock in sched_clock() so we can bank
      all data consumed there (John Stultz)
    

 kernel/time/sched_clock.c | 157 +++++++++++++++++++++++++++++-----------------
 1 file changed, 100 insertions(+), 57 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 01d2d15aa662..a2ea66944bc1 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -18,28 +18,28 @@
 #include <linux/seqlock.h>
 #include <linux/bitops.h>

-struct clock_data {
-	ktime_t wrap_kt;
+struct clock_data_banked {
 	u64 epoch_ns;
 	u64 epoch_cyc;
-	seqcount_t seq;
-	unsigned long rate;
+	u64 (*read_sched_clock)(void);
+	u64 sched_clock_mask;
 	u32 mult;
 	u32 shift;
 	bool suspended;
 };

+struct clock_data {
+	ktime_t wrap_kt;
+	seqcount_t seq;
+	unsigned long rate;
+	struct clock_data_banked bank[2];
+};
+
 static struct hrtimer sched_clock_timer;
 static int irqtime = -1;

 core_param(irqtime, irqtime, int, 0400);

-static struct clock_data cd = {
-	.mult	= NSEC_PER_SEC / HZ,
-};
-
-static u64 __read_mostly sched_clock_mask;
-
 static u64 notrace jiffy_sched_clock_read(void)
 {
 	/*
@@ -49,7 +49,14 @@ static u64 notrace jiffy_sched_clock_read(void)
 	return (u64)(jiffies - INITIAL_JIFFIES);
 }

-static u64 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
+static struct clock_data cd = {
+	.bank = {
+		[0] = {
+			.mult	= NSEC_PER_SEC / HZ,
+			.read_sched_clock = jiffy_sched_clock_read,
+		},
+	},
+};

 static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
@@ -58,50 +65,82 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)

 unsigned long long notrace sched_clock(void)
 {
-	u64 epoch_ns;
-	u64 epoch_cyc;
 	u64 cyc;
 	unsigned long seq;
-
-	if (cd.suspended)
-		return cd.epoch_ns;
+	struct clock_data_banked *b;
+	u64 res;

 	do {
-		seq = raw_read_seqcount_begin(&cd.seq);
-		epoch_cyc = cd.epoch_cyc;
-		epoch_ns = cd.epoch_ns;
+		seq = raw_read_seqcount(&cd.seq);
+		b = cd.bank + (seq & 1);
+		if (b->suspended) {
+			res = b->epoch_ns;
+		} else {
+			cyc = b->read_sched_clock();
+			cyc = (cyc - b->epoch_cyc) & b->sched_clock_mask;
+			res = b->epoch_ns + cyc_to_ns(cyc, b->mult, b->shift);
+		}
 	} while (read_seqcount_retry(&cd.seq, seq));

-	cyc = read_sched_clock();
-	cyc = (cyc - epoch_cyc) & sched_clock_mask;
-	return epoch_ns + cyc_to_ns(cyc, cd.mult, cd.shift);
+	return res;
+}
+
+/*
+ * Start updating the banked clock data.
+ *
+ * sched_clock will never observe mis-matched data even if called from
+ * an NMI. We do this by maintaining an odd/even copy of the data and
+ * steering sched_clock to one or the other using a sequence counter.
+ * In order to preserve the data cache profile of sched_clock as much
+ * as possible the system reverts back to the even copy when the update
+ * completes; the odd copy is used *only* during an update.
+ *
+ * The caller is responsible for avoiding simultaneous updates.
+ */
+static struct clock_data_banked *update_bank_begin(void)
+{
+	/* update the backup (odd) bank and steer readers towards it */
+	memcpy(cd.bank + 1, cd.bank, sizeof(struct clock_data_banked));
+	raw_write_seqcount_latch(&cd.seq);
+
+	return cd.bank;
+}
+
+/*
+ * Finalize update of banked clock data.
+ *
+ * This is just a trivial switch back to the primary (even) copy.
+ */
+static void update_bank_end(void)
+{
+	raw_write_seqcount_latch(&cd.seq);
 }

 /*
  * Atomically update the sched_clock epoch.
  */
-static void notrace update_sched_clock(void)
+static void notrace update_sched_clock(bool suspended)
 {
-	unsigned long flags;
+	struct clock_data_banked *b;
 	u64 cyc;
 	u64 ns;

-	cyc = read_sched_clock();
-	ns = cd.epoch_ns +
-		cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
-			  cd.mult, cd.shift);
-
-	raw_local_irq_save(flags);
-	raw_write_seqcount_begin(&cd.seq);
-	cd.epoch_ns = ns;
-	cd.epoch_cyc = cyc;
-	raw_write_seqcount_end(&cd.seq);
-	raw_local_irq_restore(flags);
+	b = update_bank_begin();
+
+	cyc = b->read_sched_clock();
+	ns = b->epoch_ns + cyc_to_ns((cyc - b->epoch_cyc) & b->sched_clock_mask,
+				     b->mult, b->shift);
+
+	b->epoch_ns = ns;
+	b->epoch_cyc = cyc;
+	b->suspended = suspended;
+
+	update_bank_end();
 }

 static enum hrtimer_restart sched_clock_poll(struct hrtimer *hrt)
 {
-	update_sched_clock();
+	update_sched_clock(false);
 	hrtimer_forward_now(hrt, cd.wrap_kt);
 	return HRTIMER_RESTART;
 }
@@ -111,9 +150,9 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 {
 	u64 res, wrap, new_mask, new_epoch, cyc, ns;
 	u32 new_mult, new_shift;
-	ktime_t new_wrap_kt;
 	unsigned long r;
 	char r_unit;
+	struct clock_data_banked *b;

 	if (cd.rate > rate)
 		return;
@@ -122,29 +161,30 @@ void __init sched_clock_register(u64 (*read)(void), int bits,

 	/* calculate the mult/shift to convert counter ticks to ns. */
 	clocks_calc_mult_shift(&new_mult, &new_shift, rate, NSEC_PER_SEC, 3600);
+	cd.rate = rate;

 	new_mask = CLOCKSOURCE_MASK(bits);

 	/* calculate how many ns until we wrap */
 	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask);
-	new_wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
+	cd.wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
+
+	b = update_bank_begin();

 	/* update epoch for new counter and update epoch_ns from old counter*/
 	new_epoch = read();
-	cyc = read_sched_clock();
-	ns = cd.epoch_ns + cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
-			  cd.mult, cd.shift);
+	cyc = b->read_sched_clock();
+	ns = b->epoch_ns + cyc_to_ns((cyc - b->epoch_cyc) & b->sched_clock_mask,
+				     b->mult, b->shift);

-	raw_write_seqcount_begin(&cd.seq);
-	read_sched_clock = read;
-	sched_clock_mask = new_mask;
-	cd.rate = rate;
-	cd.wrap_kt = new_wrap_kt;
-	cd.mult = new_mult;
-	cd.shift = new_shift;
-	cd.epoch_cyc = new_epoch;
-	cd.epoch_ns = ns;
-	raw_write_seqcount_end(&cd.seq);
+	b->read_sched_clock = read;
+	b->sched_clock_mask = new_mask;
+	b->mult = new_mult;
+	b->shift = new_shift;
+	b->epoch_cyc = new_epoch;
+	b->epoch_ns = ns;
+
+	update_bank_end();

 	r = rate;
 	if (r >= 4000000) {
@@ -175,10 +215,10 @@ void __init sched_clock_postinit(void)
 	 * If no sched_clock function has been provided at that point,
 	 * make it the final one one.
 	 */
-	if (read_sched_clock == jiffy_sched_clock_read)
+	if (cd.bank[0].read_sched_clock == jiffy_sched_clock_read)
 		sched_clock_register(jiffy_sched_clock_read, BITS_PER_LONG, HZ);

-	update_sched_clock();
+	update_sched_clock(false);

 	/*
 	 * Start the timer to keep sched_clock() properly updated and
@@ -191,17 +231,20 @@ void __init sched_clock_postinit(void)

 static int sched_clock_suspend(void)
 {
-	update_sched_clock();
+	update_sched_clock(true);
 	hrtimer_cancel(&sched_clock_timer);
-	cd.suspended = true;
 	return 0;
 }

 static void sched_clock_resume(void)
 {
-	cd.epoch_cyc = read_sched_clock();
+	struct clock_data_banked *b;
+
+	b = update_bank_begin();
+	b->epoch_cyc = b->read_sched_clock();
 	hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
-	cd.suspended = false;
+	b->suspended = false;
+	update_bank_end();
 }

 static struct syscore_ops sched_clock_ops = {
--
1.9.3

