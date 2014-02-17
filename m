Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaBQV65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:58:57 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38034 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaBQV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:58:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 02/14] staging: android: Split uapi out of android_alarm.h
Date: Mon, 17 Feb 2014 13:58:30 -0800
Message-Id: <1392674322-9036-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Move the userspace interface of android_alarm.h to
drivers/staging/android/uapi/android_alarm.h

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: minor commit msg tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/android_alarm.h      | 44 +-------------------
 drivers/staging/android/uapi/android_alarm.h | 62 ++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 42 deletions(-)
 create mode 100644 drivers/staging/android/uapi/android_alarm.h

diff --git a/drivers/staging/android/android_alarm.h b/drivers/staging/android/android_alarm.h
index 4fd32f3..495b20c 100644
--- a/drivers/staging/android/android_alarm.h
+++ b/drivers/staging/android/android_alarm.h
@@ -16,50 +16,10 @@
 #ifndef _LINUX_ANDROID_ALARM_H
 #define _LINUX_ANDROID_ALARM_H
 
-#include <linux/ioctl.h>
-#include <linux/time.h>
 #include <linux/compat.h>
+#include <linux/ioctl.h>
 
-enum android_alarm_type {
-	/* return code bit numbers or set alarm arg */
-	ANDROID_ALARM_RTC_WAKEUP,
-	ANDROID_ALARM_RTC,
-	ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP,
-	ANDROID_ALARM_ELAPSED_REALTIME,
-	ANDROID_ALARM_SYSTEMTIME,
-
-	ANDROID_ALARM_TYPE_COUNT,
-
-	/* return code bit numbers */
-	/* ANDROID_ALARM_TIME_CHANGE = 16 */
-};
-
-enum android_alarm_return_flags {
-	ANDROID_ALARM_RTC_WAKEUP_MASK = 1U << ANDROID_ALARM_RTC_WAKEUP,
-	ANDROID_ALARM_RTC_MASK = 1U << ANDROID_ALARM_RTC,
-	ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP_MASK =
-				1U << ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP,
-	ANDROID_ALARM_ELAPSED_REALTIME_MASK =
-				1U << ANDROID_ALARM_ELAPSED_REALTIME,
-	ANDROID_ALARM_SYSTEMTIME_MASK = 1U << ANDROID_ALARM_SYSTEMTIME,
-	ANDROID_ALARM_TIME_CHANGE_MASK = 1U << 16
-};
-
-/* Disable alarm */
-#define ANDROID_ALARM_CLEAR(type)           _IO('a', 0 | ((type) << 4))
-
-/* Ack last alarm and wait for next */
-#define ANDROID_ALARM_WAIT                  _IO('a', 1)
-
-#define ALARM_IOW(c, type, size)            _IOW('a', (c) | ((type) << 4), size)
-/* Set alarm */
-#define ANDROID_ALARM_SET(type)             ALARM_IOW(2, type, struct timespec)
-#define ANDROID_ALARM_SET_AND_WAIT(type)    ALARM_IOW(3, type, struct timespec)
-#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOW(4, type, struct timespec)
-#define ANDROID_ALARM_SET_RTC               _IOW('a', 5, struct timespec)
-#define ANDROID_ALARM_BASE_CMD(cmd)         (cmd & ~(_IOC(0, 0, 0xf0, 0)))
-#define ANDROID_ALARM_IOCTL_TO_TYPE(cmd)    (_IOC_NR(cmd) >> 4)
-
+#include "uapi/android_alarm.h"
 
 #ifdef CONFIG_COMPAT
 #define ANDROID_ALARM_SET_COMPAT(type)		ALARM_IOW(2, type, \
diff --git a/drivers/staging/android/uapi/android_alarm.h b/drivers/staging/android/uapi/android_alarm.h
new file mode 100644
index 0000000..aa013f6
--- /dev/null
+++ b/drivers/staging/android/uapi/android_alarm.h
@@ -0,0 +1,62 @@
+/* drivers/staging/android/uapi/android_alarm.h
+ *
+ * Copyright (C) 2006-2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _UAPI_LINUX_ANDROID_ALARM_H
+#define _UAPI_LINUX_ANDROID_ALARM_H
+
+#include <linux/ioctl.h>
+#include <linux/time.h>
+
+enum android_alarm_type {
+	/* return code bit numbers or set alarm arg */
+	ANDROID_ALARM_RTC_WAKEUP,
+	ANDROID_ALARM_RTC,
+	ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP,
+	ANDROID_ALARM_ELAPSED_REALTIME,
+	ANDROID_ALARM_SYSTEMTIME,
+
+	ANDROID_ALARM_TYPE_COUNT,
+
+	/* return code bit numbers */
+	/* ANDROID_ALARM_TIME_CHANGE = 16 */
+};
+
+enum android_alarm_return_flags {
+	ANDROID_ALARM_RTC_WAKEUP_MASK = 1U << ANDROID_ALARM_RTC_WAKEUP,
+	ANDROID_ALARM_RTC_MASK = 1U << ANDROID_ALARM_RTC,
+	ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP_MASK =
+				1U << ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP,
+	ANDROID_ALARM_ELAPSED_REALTIME_MASK =
+				1U << ANDROID_ALARM_ELAPSED_REALTIME,
+	ANDROID_ALARM_SYSTEMTIME_MASK = 1U << ANDROID_ALARM_SYSTEMTIME,
+	ANDROID_ALARM_TIME_CHANGE_MASK = 1U << 16
+};
+
+/* Disable alarm */
+#define ANDROID_ALARM_CLEAR(type)           _IO('a', 0 | ((type) << 4))
+
+/* Ack last alarm and wait for next */
+#define ANDROID_ALARM_WAIT                  _IO('a', 1)
+
+#define ALARM_IOW(c, type, size)            _IOW('a', (c) | ((type) << 4), size)
+/* Set alarm */
+#define ANDROID_ALARM_SET(type)             ALARM_IOW(2, type, struct timespec)
+#define ANDROID_ALARM_SET_AND_WAIT(type)    ALARM_IOW(3, type, struct timespec)
+#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOW(4, type, struct timespec)
+#define ANDROID_ALARM_SET_RTC               _IOW('a', 5, struct timespec)
+#define ANDROID_ALARM_BASE_CMD(cmd)         (cmd & ~(_IOC(0, 0, 0xf0, 0)))
+#define ANDROID_ALARM_IOCTL_TO_TYPE(cmd)    (_IOC_NR(cmd) >> 4)
+
+#endif
-- 
1.8.3.2

