Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKUTor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:44:47 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49248 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKUToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:44 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 08/12] time: Expose get_monotonic_corase64() for in-kernel uses
Date: Fri, 21 Nov 2014 11:44:14 -0800
Message-Id: <1416599058-13836-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a timespec64 based get_monotonic_coarse64() implementation
that can be used as we convert internal users of
get_monotonic_corase away from usingtimespecs.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeping.h | 11 ++++++++++-
 kernel/time/timekeeping.c   |  4 ++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index e40a8d6..8cab4b7 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -25,7 +25,7 @@ struct timespec __current_kernel_time(void);
 /*
  * timespec based interfaces
  */
-struct timespec get_monotonic_coarse(void);
+struct timespec64 get_monotonic_coarse64(void);
 extern void getrawmonotonic64(struct timespec64 *ts);
 extern void ktime_get_ts64(struct timespec64 *ts);
 
@@ -66,6 +66,10 @@ static inline void getrawmonotonic(struct timespec *ts)
 	getrawmonotonic64(ts);
 }
 
+static inline struct timespec get_monotonic_coarse(void)
+{
+	return get_monotonic_coarse64();
+}
 #else
 /**
  * Deprecated. Use do_settimeofday64().
@@ -118,6 +122,11 @@ static inline void getrawmonotonic(struct timespec *ts)
 	getrawmonotonic64(&ts64);
 	*ts = timespec64_to_timespec(ts64);
 }
+
+static inline struct timespec get_monotonic_coarse(void)
+{
+	return timespec64_to_timespec(get_monotonic_coarse64());
+}
 #endif
 
 extern void getboottime(struct timespec *ts);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b329586..62440b1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1644,7 +1644,7 @@ struct timespec current_kernel_time(void)
 }
 EXPORT_SYMBOL(current_kernel_time);
 
-struct timespec get_monotonic_coarse(void)
+struct timespec64 get_monotonic_coarse64(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 now, mono;
@@ -1660,7 +1660,7 @@ struct timespec get_monotonic_coarse(void)
 	set_normalized_timespec64(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
 
-	return timespec64_to_timespec(now);
+	return now;
 }
 
 /*
-- 
1.9.1

