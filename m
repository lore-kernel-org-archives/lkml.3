Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaGPVTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:19:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:59653 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaGPVEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:12 -0400
Message-Id: <20140716205053.440679744@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 15/64] timekeeping: Provide internal ktime_t based data
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-provide-internal-ktime-based-data.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ktime_t based interfaces are used a lot in performance critical
code pathes. Add ktime_t based data so the interfaces don't have to
convert from the xtime/timespec based data.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |    3 +++
 kernel/time/timekeeping.c           |   22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -36,6 +36,9 @@ struct timekeeper {
 	/* Clock shifted nano seconds */
 	u64			xtime_nsec;
 
+	/* Monotonic base time */
+	ktime_t			base_mono;
+
 	/* Current CLOCK_REALTIME time in seconds */
 	u64			xtime_sec;
 	/* CLOCK_REALTIME to CLOCK_MONOTONIC offset */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -291,6 +291,26 @@ int pvclock_gtod_unregister_notifier(str
 }
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
+/*
+ * Update the ktime_t based scalar nsec members of the timekeeper
+ */
+static inline void tk_update_ktime_data(struct timekeeper *tk)
+{
+	s64 nsec;
+
+	/*
+	 * The xtime based monotonic readout is:
+	 *	nsec = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec + now();
+	 * The ktime based monotonic readout is:
+	 *	nsec = base_mono + now();
+	 * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
+	 */
+	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
+	nsec *= NSEC_PER_SEC;
+	nsec += tk->wall_to_monotonic.tv_nsec;
+	tk->base_mono = ns_to_ktime(nsec);
+}
+
 /* must hold timekeeper_lock */
 static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 {
@@ -301,6 +321,8 @@ static void timekeeping_update(struct ti
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
 
+	tk_update_ktime_data(tk);
+
 	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &tk_core.timekeeper,
 		       sizeof(tk_core.timekeeper));


