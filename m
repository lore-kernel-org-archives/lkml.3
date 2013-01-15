Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3AOQJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:09:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:56384 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3AOQJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:09:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="scan'208";a="191395587"
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 1/3] timekeeping: Add persistent_clock_exist flag
Date: Wed, 16 Jan 2013 00:09:47 +0800
Message-Id: <1358266189-8812-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current kernel, there are several places which need to check
whether there is a persistent clock for the platform. Current check
is done by calling the read_persistent_clock() and validating its
return value.

So one optimization is to do the check only once in timekeeping_init(),
and use a flag persistent_clock_exist to record it.

v2: Add a has_persistent_clock() helper function, as suggested by John.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 include/linux/time.h      |    6 ++++++
 kernel/time/timekeeping.c |   16 +++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 4d358e9..2f58603 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -115,6 +115,12 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 	return true;
 }
 
+extern bool persistent_clock_exist;
+static inline bool has_persistent_clock(void)
+{
+	return persistent_clock_exist;
+}
+
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cbc6acb..2fd3aed 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -29,6 +29,9 @@ static struct timekeeper timekeeper;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
+/* Flag for if there is a persistent clock on this platform */
+bool __read_mostly persistent_clock_exist = false;
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -640,12 +643,14 @@ void __init timekeeping_init(void)
 	struct timespec now, boot, tmp;
 
 	read_persistent_clock(&now);
+
 	if (!timespec_valid_strict(&now)) {
 		pr_warn("WARNING: Persistent clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
 		now.tv_nsec = 0;
-	}
+	} else if (now.tv_sec || now.tv_nsec)
+		persistent_clock_exist = true;
 
 	read_boot_clock(&boot);
 	if (!timespec_valid_strict(&boot)) {
@@ -718,11 +723,12 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
-	struct timespec ts;
 
-	/* Make sure we don't set the clock twice */
-	read_persistent_clock(&ts);
-	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
+	/*
+	 * Make sure we don't set the clock twice, as timekeeping_resume()
+	 * already did it
+	 */
+	if (has_persistent_clock())
 		return;
 
 	write_seqlock_irqsave(&tk->lock, flags);
-- 
1.7.9.5

