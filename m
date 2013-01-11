Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3AKXqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 18:46:40 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:48985 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab3AKXqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 18:46:38 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 3/3] staging: alarm-dev: Implement compat_ioctl support
Date: Fri, 11 Jan 2013 15:46:24 -0800
Message-Id: <1357947984-15611-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357947984-15611-1-git-send-email-john.stultz@linaro.org>
References: <1357947984-15611-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement compat_ioctl support for the alarm-dev ioctl.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Colin Cross <ccross@google.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/alarm-dev.c     |   35 +++++++++++++++++++++++++++++++
 drivers/staging/android/android_alarm.h |   19 +++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 43af3b3..ceb1c64 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -274,6 +274,38 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
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
@@ -355,6 +387,9 @@ static const struct file_operations alarm_fops = {
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

