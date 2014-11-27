Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaK0MDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:03:36 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57762 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaK0MDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:03:32 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        Xunlei Pang <pang.xunlei@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [RFC PATCH 3/4] rtc/lib: Provide interfaces to map between 32bit hardware and 64bit time
Date: Thu, 27 Nov 2014 20:02:39 +0800
Message-Id: <1417089760-26848-4-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To attack the 32bit rtc hardware limitations which will bring about
y2106 issues to their rtc drivers as those marked "y2106 issue" tags
in the former patch, this patch adds a common rtc epoch offset, and
provides two interfaces to map between 32bit rtc hardware and 64bit
time using this rtc epoch offset. These two interfaces can be used
to write rtc drivers for 32-bit rtc hardware.

- Add "rtc_epoch" boot parameter, default offset value is hardcoded
  to 1970 for consistency with Unix epoch. This default value can be
  overrided through boot command if you have problematic rtc hardware.
  Once you are doing this, should be aware of following side effects:
    a) Can't set time before your rtc epoch.
    b) Can't boot into different OSes relying on the same rtc hardware.
  "rtc epoch" must stay invariable once finalized on one machine.
- Add rtc_time64_to_hw32(): This interface converts 64-bit seconds
  since unix 1970 epoch to 32bit seconds since rtc epoch which can
  be maintained by 32-bit rtc hardware.
- Add rtc_hw32_to_time64(): This interface converts 32bit seconds
  since rtc epoch which can be used by 32-bit rtc hardware to 64bit
  seconds since unix 1970 epoch.

There're also other ways to implement this function: For example,
some driver(vr41xx) implements the same logic using RTC_EPOCH_SET
ioctl and an rtc epoch offset variable. But the approach in this
patch is more flexible and common than that.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/class.c   |   25 +++++++++++++++++++++++++
 drivers/rtc/rtc-lib.c |   28 ++++++++++++++++++++++++++++
 include/linux/rtc.h   |    3 +++
 3 files changed, 56 insertions(+)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 38e26be..7f1950f8 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -358,6 +358,29 @@ void devm_rtc_device_unregister(struct device *dev, struct rtc_device *rtc)
 }
 EXPORT_SYMBOL_GPL(devm_rtc_device_unregister);
 
+/* Rtc epoch year, can be overrided by command line */
+static unsigned int rtc_epoch = 1970;
+time64_t rtc_epoch_secs_since_1970;
+
+static int __init
+set_rtc_epoch(char *str)
+{
+	unsigned int epoch;
+
+	if (kstrtou32(str, 0, &epoch) != 0) {
+		printk(KERN_WARNING "Invalid setup epoch %u!\n", epoch);
+		return 1;
+	}
+
+	if (rtc_epoch < 1970)
+		printk(KERN_WARNING "Epoch %u is smaller than 1970!\n", epoch);
+	else
+		rtc_epoch = epoch;
+
+	return 1;
+}
+__setup("rtc_epoch=", set_rtc_epoch);
+
 static int __init rtc_init(void)
 {
 	rtc_class = class_create(THIS_MODULE, "rtc");
@@ -366,6 +389,8 @@ static int __init rtc_init(void)
 		return PTR_ERR(rtc_class);
 	}
 	rtc_class->pm = RTC_CLASS_DEV_PM_OPS;
+
+	rtc_epoch_secs_since_1970 = mktime64(rtc_epoch, 1, 1, 0, 0, 0);
 	rtc_dev_init();
 	rtc_sysfs_init(rtc_class);
 	return 0;
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index e6bfb9c..d26814c 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -124,6 +124,34 @@ time64_t rtc_tm_to_time64(struct rtc_time *tm)
 EXPORT_SYMBOL(rtc_tm_to_time64);
 
 /*
+ * Convert seconds since rtc epoch to seconds since Unix epoch.
+ */
+time64_t rtc_hw32_to_time64(u32 hwtime)
+{
+	return (rtc_epoch_secs_since_1970 + hwtime);
+}
+EXPORT_SYMBOL_GPL(rtc_hw32_to_time64);
+
+/*
+ * Convert seconds since Unix epoch to seconds since rtc epoch.
+ */
+int rtc_time64_to_hw32(time64_t time, u32 *hwtime)
+{
+	/* time must be after rtc epoch */
+	if (time < rtc_epoch_secs_since_1970)
+		return -EINVAL;
+
+	/* rtc epoch may be too small? */
+	if (time - rtc_epoch_secs_since_1970 > UINT_MAX)
+		return -EOVERFLOW;
+
+	*hwtime = time - rtc_epoch_secs_since_1970;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rtc_time64_to_hw32);
+
+/*
  * Convert rtc_time to ktime
  */
 ktime_t rtc_tm_to_ktime(struct rtc_time tm)
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index d080606..32f7c22 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -16,11 +16,14 @@
 #include <linux/interrupt.h>
 #include <uapi/linux/rtc.h>
 
+extern time64_t rtc_epoch_secs_since_1970;
 extern int rtc_month_days(unsigned int month, unsigned int year);
 extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year);
 extern int rtc_valid_tm(struct rtc_time *tm);
 extern time64_t rtc_tm_to_time64(struct rtc_time *tm);
 extern void rtc_time64_to_tm(time64_t time, struct rtc_time *tm);
+extern int rtc_time64_to_hw32(time64_t time, u32 *hwtime);
+extern time64_t rtc_hw32_to_time64(u32 hwtime);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
 struct rtc_time rtc_ktime_to_tm(ktime_t kt);
 
-- 
1.7.9.5

