Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaKUTrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:47:47 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50670 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaKUTok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:40 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 05/12] time: Provide y2038 safe timekeeping_inject_sleeptime() replacement
Date: Fri, 21 Nov 2014 11:44:11 -0800
Message-Id: <1416599058-13836-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "pang.xunlei" <pang.xunlei@linaro.org>

As part of addressing "y2038 problem" for in-kernel uses, this
patch adds timekeeping_inject_sleeptime64() using timespec64.

After this patch, timekeeping_inject_sleeptime() is deprecated
and all its call sites will be fixed using the new interface,
after that it can be removed.

NOTE: timekeeping_inject_sleeptime() is safe actually, but we
want to eliminate timespec eventually, so comes this patch.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeping.h | 13 ++++++++++++-
 kernel/time/timekeeping.c   | 10 ++++------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 071ad7e..6d76c65 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -201,7 +201,18 @@ static inline void timekeeping_clocktai(struct timespec *ts)
 /*
  * RTC specific
  */
-extern void timekeeping_inject_sleeptime(struct timespec *delta);
+extern void timekeeping_inject_sleeptime64(struct timespec64 *delta);
+
+/**
+ * Deprecated. Use timekeeping_inject_sleeptime64().
+ */
+static inline void timekeeping_inject_sleeptime(struct timespec *delta)
+{
+	struct timespec64 delta64;
+
+	delta64 = timespec_to_timespec64(*delta);
+	timekeeping_inject_sleeptime64(&delta64);
+}
 
 /*
  * PPS accessor
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1d33550..d37f775 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1067,8 +1067,8 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 }
 
 /**
- * timekeeping_inject_sleeptime - Adds suspend interval to timeekeeping values
- * @delta: pointer to a timespec delta value
+ * timekeeping_inject_sleeptime64 - Adds suspend interval to timeekeeping values
+ * @delta: pointer to a timespec64 delta value
  *
  * This hook is for architectures that cannot support read_persistent_clock
  * because their RTC/persistent clock is only accessible when irqs are enabled.
@@ -1076,10 +1076,9 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
  * This function should only be called by rtc_resume(), and allows
  * a suspend offset to be injected into the timekeeping values.
  */
-void timekeeping_inject_sleeptime(struct timespec *delta)
+void timekeeping_inject_sleeptime64(struct timespec64 *delta)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec64 tmp;
 	unsigned long flags;
 
 	/*
@@ -1094,8 +1093,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	timekeeping_forward_now(tk);
 
-	tmp = timespec_to_timespec64(*delta);
-	__timekeeping_inject_sleeptime(tk, &tmp);
+	__timekeeping_inject_sleeptime(tk, delta);
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-- 
1.9.1

