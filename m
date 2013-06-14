Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3FNQz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:55:29 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50257 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3FNQz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:55:27 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 7/9] RFC: rtc: implement rtc_read_timeval()
Date: Fri, 14 Jun 2013 18:52:10 +0200
Message-Id: <1371228732-5749-8-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
References: <51BA1FF7.4000206@ahsoftware.de>
 <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some RTCs offer a higher resolution than seconds. To support reading such
high resolution timestamps from inside the kernel implement
rtc_read_timeval() and add a read_timeval to the rtc-ops.

This is done to support high precision read-only clocks (like radio- or
GPS-clocks) from inside the kernel (mainly hctosys). Therfor there is
currently no need to set the clock or to extend the (rtc-)userspace api to
support high precision timestamps.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/interface.c | 28 ++++++++++++++++++++++++++++
 include/linux/rtc.h     |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 42bd57d..f09f384 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -48,6 +48,34 @@ int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 }
 EXPORT_SYMBOL_GPL(rtc_read_time);
 
+static int __rtc_read_timeval(struct rtc_device *rtc, struct timeval *tv)
+{
+	int err;
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->read_timeval)
+		err = -EINVAL;
+	else {
+		memset(tv, 0, sizeof(struct timeval));
+		err = rtc->ops->read_timeval(rtc->dev.parent, tv);
+	}
+	return err;
+}
+
+int rtc_read_timeval(struct rtc_device *rtc, struct timeval *tv)
+{
+	int err;
+
+	err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return err;
+
+	err = __rtc_read_timeval(rtc, tv);
+	mutex_unlock(&rtc->ops_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(rtc_read_timeval);
+
 int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
 	int err;
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 50caf0d..863f916 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <uapi/linux/rtc.h>
+#include <uapi/linux/time.h>
 
 extern int rtc_month_days(unsigned int month, unsigned int year);
 extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year);
@@ -63,6 +64,7 @@ struct rtc_class_ops {
 	int (*set_mmss)(struct device *, unsigned long secs);
 	int (*read_callback)(struct device *, int data);
 	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
+	int (*read_timeval)(struct device *, struct timeval *);
 };
 
 #define RTC_DEVICE_NAME_SIZE 20
@@ -143,6 +145,7 @@ extern void devm_rtc_device_unregister(struct device *dev,
 
 extern int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm);
+extern int rtc_read_timeval(struct rtc_device *rtc, struct timeval *tv);
 extern int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs);
 extern int rtc_set_ntp_time(struct timespec now);
 int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm);
-- 
1.8.1.4

