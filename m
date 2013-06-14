Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3FNQxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:53:46 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50172 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3FNQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:53:44 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 4/9 RESEND] RFC: timekeeping: introduce flag systime_was_set
Date: Fri, 14 Jun 2013 18:52:07 +0200
Message-Id: <1371228732-5749-5-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
References: <51BA1FF7.4000206@ahsoftware.de>
 <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to let an RTC set the time at boot without the problem that a
second RTC overwrites it, the flag systime_was_set is introduced.

systime_was_set will be true, if a persistent clock sets the time at boot,
or if do_settimeofday() is called (e.g. by the RTC subsystem or userspace).

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 include/linux/time.h      |  6 ++++++
 kernel/time/timekeeping.c | 10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..888280f 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -129,6 +129,12 @@ extern int update_persistent_clock(struct timespec now);
 void timekeeping_init(void);
 extern int timekeeping_suspended;
 
+/*
+ * Will be true if the system time was set at least once by
+ * a persistent clock, RTC or userspace.
+ */
+extern bool systime_was_set;
+
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index baeeb5c..07d8531 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -37,6 +37,9 @@ int __read_mostly timekeeping_suspended;
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;
 
+/* Flag for if the system time was set at least once */
+bool __read_mostly systime_was_set;
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -498,6 +501,9 @@ int do_settimeofday(const struct timespec *tv)
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
+	systime_was_set = true;
+
+
 	timekeeping_forward_now(tk);
 
 	xt = tk_xtime(tk);
@@ -781,8 +787,10 @@ void __init timekeeping_init(void)
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
 		now.tv_nsec = 0;
-	} else if (now.tv_sec || now.tv_nsec)
+	} else if (now.tv_sec || now.tv_nsec) {
 		persistent_clock_exist = true;
+		systime_was_set = true;
+	}
 
 	read_boot_clock(&boot);
 	if (!timespec_valid_strict(&boot)) {
-- 
1.8.1.4

