Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbbAMPrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:47:35 -0500
Received: from m15-111.126.com ([220.181.15.111]:37349 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbbAMPqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:39 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 2/9] time: Provide y2106 safe get_seconds() replacement
Date: Tue, 13 Jan 2015 23:44:50 +0800
Message-Id: <1421163897-8020-3-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1421163897-8020-1-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7trWxWrWUKryxXF4fGFykKrg_yoW8ZrWrpF
	ZrCwn8GF4xZFyfCws7Wwsxu34aqw4DAF4xGFyxGw1Fvr1jqFnYqr40934Yqry2yFWruFsr
	AayIvFyYv34UZa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jQUUUUUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbimhaAv1GfUwd18QAAst
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

As part of addressing "y2038 problem" for in-kernel uses, this
patch adds safe get_seconds64() using time64_t.

After this patch, get_seconds() is deprecated and all its call sites
will be fixed using get_seconds64(), after that it can be removed.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 include/linux/timekeeping.h | 10 +++++++++-
 kernel/time/timekeeping.c   |  4 ++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 9b63d13..384d101 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -17,7 +17,7 @@ extern int do_sys_settimeofday(const struct timespec *tv,
 /*
  * Kernel time accessors
  */
-unsigned long get_seconds(void);
+extern time64_t get_seconds64(void);
 struct timespec current_kernel_time(void);
 /* does not take xtime_lock */
 struct timespec __current_kernel_time(void);
@@ -34,6 +34,14 @@ extern time64_t ktime_get_real_seconds(void);
 extern int __getnstimeofday64(struct timespec64 *tv);
 extern void getnstimeofday64(struct timespec64 *tv);
 
+/**
+ * Deprecated. Use get_seconds64().
+ */
+static inline unsigned long get_seconds(void)
+{
+	return (unsigned long)get_seconds64();
+}
+
 #if BITS_PER_LONG == 64
 /**
  * Deprecated. Use do_settimeofday64().
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a93185..ab021a3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1678,13 +1678,13 @@ void getboottime(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(getboottime);
 
-unsigned long get_seconds(void)
+time64_t get_seconds64(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 
 	return tk->xtime_sec;
 }
-EXPORT_SYMBOL(get_seconds);
+EXPORT_SYMBOL(get_seconds64);
 
 struct timespec __current_kernel_time(void)
 {
-- 
1.9.1


