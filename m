Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaFMEOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 00:14:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:37694 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaFMEOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 00:14:05 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: John Whitmore <arigead@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/3] RFC: timekeeping: introduce flag systime_was_set
Date: Fri, 13 Jun 2014 06:13:24 +0200
Message-Id: <1402632806-6369-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140612151505.03defe29@linux.lan.towertech.it>
References: <20140612151505.03defe29@linux.lan.towertech.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to let an RTC set the time at boot without the problem that a
second RTC overwrites it, the flag systime_was_set is introduced.

systime_was_set will be true, if a persistent clock sets the time at boot,
or if do_settimeofday() is called (e.g. by the RTC subsystem or userspace).

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---

 I've based these patches on 3.15, an older version can be found at LKML,

 Besides discussing possible *real* bugs, I don't care what any person
 (including maintainers) will request. I'm fine with these patches (I'm
 using them since a year) and I don't play remote keyboard or
 patch ping-pong. If someone want changes I suggest he gets responsible
 for them himself and just puts a patch on top of my patches. And in any
 case, feel free to completely ignore these patches.

 (This note will destroy itself when using git am.)

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
index f7df8ea..6be8b72 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -43,6 +43,9 @@ int __read_mostly timekeeping_suspended;
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;
 
+/* Flag for if the system time was set at least once */
+bool __read_mostly systime_was_set;
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -505,6 +508,9 @@ int do_settimeofday(const struct timespec *tv)
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
+	systime_was_set = true;
+
+
 	timekeeping_forward_now(tk);
 
 	xt = tk_xtime(tk);
@@ -799,8 +805,10 @@ void __init timekeeping_init(void)
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
1.8.3.2

