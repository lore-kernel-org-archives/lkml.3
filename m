Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab3GRPpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:45:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59185 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362Ab3GRPpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:45:01 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH] RTC: Add an alarm disable quirk
Date: Thu, 18 Jul 2013 17:44:54 +0200
Message-Id: <1374162294-29726-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

41c7f7424259f ("rtc: Disable the alarm in the hardware (v2)") added the
functionality to disable the RTC wake alarm when shutting down the box.

However, there are at least two b0rked BIOSes we know about:

https://bugzilla.novell.com/show_bug.cgi?id=812592
https://bugzilla.novell.com/show_bug.cgi?id=805740

where, when wakeup alarm is enabled in the BIOS, the machine reboots
automatically right after shutdown, regardless of what wakeup time is
programmed.

Bisecting the issue lead to this patch so disable its functionality with
a DMI quirk only for those boxes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/rtc/class.c     | 24 ++++++++++++++++++++++++
 drivers/rtc/interface.c |  8 ++++++++
 include/linux/rtc.h     |  1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 02426812bebc..f3006db26125 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -19,6 +19,8 @@
 #include <linux/idr.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/dmi.h>
+#include <linux/mod_devicetable.h>
 
 #include "rtc-core.h"
 
@@ -26,6 +28,25 @@
 static DEFINE_IDA(rtc_ida);
 struct class *rtc_class;
 
+static int __init clear_disable_alarm(const struct dmi_system_id *id)
+{
+	rtc_disable_alarm = false;
+	return 0;
+}
+
+static const struct dmi_system_id rtc_quirks[] __initconst = {
+	/* https://bugzilla.novell.com/show_bug.cgi?id=805740 */
+	{
+		.callback = clear_disable_alarm,
+		.ident    = "IBM Truman",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "4852570"),
+		},
+	},
+	{}
+};
+
 static void rtc_device_release(struct device *dev)
 {
 	struct rtc_device *rtc = to_rtc_device(dev);
@@ -340,6 +361,9 @@ static int __init rtc_init(void)
 	rtc_class->pm = RTC_CLASS_DEV_PM_OPS;
 	rtc_dev_init();
 	rtc_sysfs_init(rtc_class);
+
+	dmi_check_system(rtc_quirks);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 72c5cdbe0791..0d944d1c02b8 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -17,6 +17,11 @@
 #include <linux/log2.h>
 #include <linux/workqueue.h>
 
+/*
+ * Do not disable RTC alarm on shutdown - workaround for b0rked BIOSes.
+ */
+bool rtc_disable_alarm = true;
+
 static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
 static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
 
@@ -787,6 +792,9 @@ static void rtc_alarm_disable(struct rtc_device *rtc)
 	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
 		return;
 
+	if (!rtc_disable_alarm)
+		return;
+
 	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
 }
 
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c28975293c..124de6ca4e94 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -185,6 +185,7 @@ int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 			ktime_t expires, ktime_t period);
 int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer);
 void rtc_timer_do_work(struct work_struct *work);
+extern bool rtc_disable_alarm;
 
 static inline bool is_leap_year(unsigned int year)
 {
-- 
1.8.3

