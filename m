Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbbAUQye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:54:34 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:42286 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbbAUQyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:54:23 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH] sched_clock: Avoid tearing during read from NMI
Date: Wed, 21 Jan 2015 16:53:56 +0000
Message-Id: <1421859236-19782-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is possible for an NMI (or FIQ on ARM) to come in and
read sched_clock() whilst update_sched_clock() has half updated the
state. This results in a bad time value being observed.

This patch fixes that problem in a similar manner to Thomas Gleixner's
4396e058c52e("timekeeping: Provide fast and NMI safe access to
CLOCK_MONOTONIC").

Note that ripping out the seqcount lock from sched_clock_register() and
replacing it with a large comment is not nearly as bad as it looks! The
locking here is actually pretty useless since most of the variables
modified within the write lock are not covered by the read lock. As a
result a big comment and the sequence bump implicit in the call
to update_epoch() should work pretty much the same.

Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    This patch has only had fairly light testing at this point. However it
    survives basic tests. In particular I am running perf from FIQ/NMI and
    have instrumented it with some monotonicity tests none of which have
    reported any problem.
    

 kernel/time/sched_clock.c | 63 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 13 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 01d2d15aa662..485d5070259c 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -27,6 +27,10 @@ struct clock_data {
 	u32 mult;
 	u32 shift;
 	bool suspended;
+
+	/* Used only temporarily whilst we are updating the primary copy */
+	u64 old_epoch_ns;
+	u64 old_epoch_cyc;
 };

 static struct hrtimer sched_clock_timer;
@@ -67,9 +71,14 @@ unsigned long long notrace sched_clock(void)
 		return cd.epoch_ns;

 	do {
-		seq = raw_read_seqcount_begin(&cd.seq);
-		epoch_cyc = cd.epoch_cyc;
-		epoch_ns = cd.epoch_ns;
+		seq = raw_read_seqcount(&cd.seq);
+		if (likely(0 == (seq & 1))) {
+			epoch_cyc = cd.epoch_cyc;
+			epoch_ns = cd.epoch_ns;
+		} else {
+			epoch_cyc = cd.old_epoch_cyc;
+			epoch_ns = cd.old_epoch_ns;
+		}
 	} while (read_seqcount_retry(&cd.seq, seq));

 	cyc = read_sched_clock();
@@ -78,6 +87,35 @@ unsigned long long notrace sched_clock(void)
 }

 /*
+ * Update the epoch without allowing sched_clock to observe
+ * a mismatched epoch pair even if called from NMI.
+ *
+ * We do this by maintaining and odd/even copy of the epoch data and
+ * steering sched_clock to one or the other using a sequence counter.
+ * In order to preserve the (average case) data cache profile of
+ * sched_clock the system reverts back to the even copy as soon as
+ * possible; the odd copy is used *only* during an update.
+ *
+ * The caller is responsible for avoiding simultaneous updates.
+ */
+static void notrace update_epoch(u64 cyc, u64 ns)
+{
+	/* Update the backup copy */
+	cd.old_epoch_cyc = cd.epoch_cyc;
+	cd.old_epoch_ns = cd.epoch_ns;
+
+	/* Force readers to use the backup (odd) copy */
+	raw_write_seqcount_latch(&cd.seq);
+
+	/* Update the primary copy */
+	cd.epoch_cyc = cyc;
+	cd.epoch_ns = ns;
+
+	/* Steer readers back the primary (even) copy */
+	raw_write_seqcount_latch(&cd.seq);
+}
+
+/*
  * Atomically update the sched_clock epoch.
  */
 static void notrace update_sched_clock(void)
@@ -91,12 +129,7 @@ static void notrace update_sched_clock(void)
 		cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
 			  cd.mult, cd.shift);

-	raw_local_irq_save(flags);
-	raw_write_seqcount_begin(&cd.seq);
-	cd.epoch_ns = ns;
-	cd.epoch_cyc = cyc;
-	raw_write_seqcount_end(&cd.seq);
-	raw_local_irq_restore(flags);
+	update_epoch(cyc, ns);
 }

 static enum hrtimer_restart sched_clock_poll(struct hrtimer *hrt)
@@ -135,16 +168,20 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 	ns = cd.epoch_ns + cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
 			  cd.mult, cd.shift);

-	raw_write_seqcount_begin(&cd.seq);
+	/*
+	 * sched_clock will report a bad value if it executes
+	 * concurrently with the following code. No locking exists to
+	 * prevent this; we rely mostly on this function being called
+	 * early during kernel boot up before we have lots of other
+	 * stuff going on.
+	 */
 	read_sched_clock = read;
 	sched_clock_mask = new_mask;
 	cd.rate = rate;
 	cd.wrap_kt = new_wrap_kt;
 	cd.mult = new_mult;
 	cd.shift = new_shift;
-	cd.epoch_cyc = new_epoch;
-	cd.epoch_ns = ns;
-	raw_write_seqcount_end(&cd.seq);
+	update_epoch(new_epoch, ns);

 	r = rate;
 	if (r >= 4000000) {
--
1.9.3

