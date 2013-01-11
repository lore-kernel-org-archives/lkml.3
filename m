Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3AKVtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:49:32 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43942 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3AKVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:49:18 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 2/2] staging: alarm-dev: Implement compat_ioctl support
Date: Fri, 11 Jan 2013 13:48:38 -0800
Message-Id: <1357940918-14941-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357940918-14941-1-git-send-email-john.stultz@linaro.org>
References: <1357940918-14941-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement compat_ioctl support for the alarm-dev ioctl.

The only really iffy bit here is that the ANDROID_ALARM_SET_OLD
and ANDROID_ALARM_SET_AND_WAIT_OLD support, which is there for
older Android compatability uses a time_t. On 64bit, this size
matches the compat_timespec size, causing ioctl number aliasing.

However, since the _OLD ioctls are only there to support existing
Android applications (all of which I'm assuming are 32bit), I've
made the _OLD ioctls 32bit only (so on 64bit we only support the
compat implementation).

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/alarm-dev.c     |   48 +++++++++++++++++++++++++++++++
 drivers/staging/android/android_alarm.h |   19 ++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 12c570d..c8589bf 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -42,9 +42,15 @@ do {									\
 	ANDROID_ALARM_RTC_WAKEUP_MASK | \
 	ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP_MASK)
 
+#ifdef CONFIG_COMPAT
+/* Compat only on 64bit! */
+#define ANDROID_ALARM_SET_OLD               _IOW('a', 2, compat_time_t)
+#define ANDROID_ALARM_SET_AND_WAIT_OLD      _IOW('a', 3, compat_time_t)
+#else
 /* support old userspace code */
 #define ANDROID_ALARM_SET_OLD               _IOW('a', 2, time_t) /* set alarm */
 #define ANDROID_ALARM_SET_AND_WAIT_OLD      _IOW('a', 3, time_t)
+#endif
 
 static int alarm_opened;
 static DEFINE_SPINLOCK(alarm_slock);
@@ -288,6 +294,45 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	return rv;
 }
+#ifdef CONFIG_COMPAT
+static long alarm_compat_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+
+	struct timespec ts;
+	int rv;
+
+	switch (ANDROID_ALARM_BASE_CMD(cmd)) {
+	case ANDROID_ALARM_SET_OLD:
+	case ANDROID_ALARM_SET_AND_WAIT_OLD:
+		if (get_user(ts.tv_sec, (int __user *)arg))
+			return -EFAULT;
+
+		ts.tv_nsec = 0;
+		break;
+	case ANDROID_ALARM_SET_AND_WAIT_COMPAT(0):
+	case ANDROID_ALARM_SET_COMPAT(0):
+	case ANDROID_ALARM_SET_RTC_COMPAT:
+		if (compat_get_timespec(&ts, (void __user *)arg))
+			return -EFAULT;
+		/* fall through */
+	case ANDROID_ALARM_GET_TIME_COMPAT(0):
+		cmd = ANDROID_ALARM_COMPAT_TO_NORM(cmd);
+		break;
+	}
+
+	rv = alarm_do_ioctl(file, cmd, &ts);
+
+	switch (ANDROID_ALARM_BASE_CMD(cmd)) {
+	case ANDROID_ALARM_GET_TIME(0): /* NOTE: we modified cmd above */
+		if (compat_put_timespec(&ts, (void __user *)arg))
+			return -EFAULT;
+		break;
+	}
+
+	return rv;
+}
+#endif
 
 static int alarm_open(struct inode *inode, struct file *file)
 {
@@ -369,6 +414,9 @@ static const struct file_operations alarm_fops = {
 	.unlocked_ioctl = alarm_ioctl,
 	.open = alarm_open,
 	.release = alarm_release,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = alarm_compat_ioctl,
+#endif
 };
 
 static struct miscdevice alarm_device = {
diff --git a/drivers/staging/android/android_alarm.h b/drivers/staging/android/android_alarm.h
index d0cafd6..4fd32f3 100644
--- a/drivers/staging/android/android_alarm.h
+++ b/drivers/staging/android/android_alarm.h
@@ -18,6 +18,7 @@
 
 #include <linux/ioctl.h>
 #include <linux/time.h>
+#include <linux/compat.h>
 
 enum android_alarm_type {
 	/* return code bit numbers or set alarm arg */
@@ -59,4 +60,22 @@ enum android_alarm_return_flags {
 #define ANDROID_ALARM_BASE_CMD(cmd)         (cmd & ~(_IOC(0, 0, 0xf0, 0)))
 #define ANDROID_ALARM_IOCTL_TO_TYPE(cmd)    (_IOC_NR(cmd) >> 4)
 
+
+#ifdef CONFIG_COMPAT
+#define ANDROID_ALARM_SET_COMPAT(type)		ALARM_IOW(2, type, \
+							struct compat_timespec)
+#define ANDROID_ALARM_SET_AND_WAIT_COMPAT(type)	ALARM_IOW(3, type, \
+							struct compat_timespec)
+#define ANDROID_ALARM_GET_TIME_COMPAT(type)	ALARM_IOW(4, type, \
+							struct compat_timespec)
+#define ANDROID_ALARM_SET_RTC_COMPAT		_IOW('a', 5, \
+							struct compat_timespec)
+#define ANDROID_ALARM_IOCTL_NR(cmd)		(_IOC_NR(cmd) & ((1<<4)-1))
+#define ANDROID_ALARM_COMPAT_TO_NORM(cmd)  \
+				ALARM_IOW(ANDROID_ALARM_IOCTL_NR(cmd), \
+					ANDROID_ALARM_IOCTL_TO_TYPE(cmd), \
+					struct timespec)
+
+#endif
+
 #endif
-- 
1.7.10.4

