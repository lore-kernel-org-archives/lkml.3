Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaFMEO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 00:14:29 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:37715 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaFMEO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 00:14:28 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: John Whitmore <arigead@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/3] RFC: timekeeping: rtc: Introduce new kernel parameter hctosys
Date: Fri, 13 Jun 2014 06:13:25 +0200
Message-Id: <1402632806-6369-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402632806-6369-1-git-send-email-holler@ahsoftware.de>
References: <20140612151505.03defe29@linux.lan.towertech.it>
 <1402632806-6369-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hctosys= specifies the driver (RTC) name which sets the system clock at
boot, if and only if userspace hasn't set the time before the driver will
be loaded.

If hctosys will not be specified, the first available hardware clock
with a valid time will be used (again, if and only if ...).

If you don't want that the system clock will be set by any hardware clock,
just specify a non-existent RTC driver name, e.g. with hctosys=none.

Currently there exist a special name "persistent" for the persistent clock
found on some systems (e.g. the CMOS clock on x86 platforms which might be
handled by the driver named rtc_cmos too).

This will replace the existent driver/mechanism hctosys and the kernel
config options CONFIG_RTC_HCTOSYS and CONFIG_RTC_HCTOSYS_DEVICE (done
with one of the following patches)

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

 Documentation/kernel-parameters.txt | 12 +++++++++
 drivers/rtc/class.c                 | 42 +++++++++++++++++++++++++++++
 include/linux/time.h                |  6 +++++
 kernel/time/timekeeping.c           | 53 ++++++++++++++++++++++++++++---------
 4 files changed, 101 insertions(+), 12 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 30a8ad0d..77a36ba 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1110,6 +1110,18 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	hcl=		[IA-64] SGI's Hardware Graph compatibility layer
 
+	hctosys=	[KNL] Specifies the driver (RTC) name which sets the
+			time at	boot, if and only if userspace hasn't set the
+			time before the driver will be loaded. If hctosys will
+			not be specified, the first available hardware clock
+			with a valid time will be used.
+			Use a non-existent name (e.g. hctosys=none) if you want
+			to avoid that a hardware clock will set the time.
+			Currently there exist a special name "persistent" for
+			the persistent clock found on some systems (e.g. the
+			CMOS clock on x86 platforms which might be handled
+			by the driver named rtc_cmos too).
+
 	hd=		[EIDE] (E)IDE hard drive subsystem geometry
 			Format: <cyl>,<head>,<sect>
 
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 589351e..18c47b0 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -143,6 +143,43 @@ static SIMPLE_DEV_PM_OPS(rtc_class_dev_pm_ops, rtc_suspend, rtc_resume);
 #endif
 
 
+static void hctosys(struct rtc_device *rtc)
+{
+	struct rtc_time now;
+	struct timespec ts = {
+		.tv_nsec = NSEC_PER_SEC >> 1,
+	};
+	int rc;
+
+	rc = rtc_read_time(rtc, &now);
+	if (unlikely(rc)) {
+		dev_err(rtc->dev.parent,
+			"rtc core: error reading time from RTC: %d\n", rc);
+		return;
+	}
+	rc = rtc_valid_tm(&now);
+	if (unlikely(rc)) {
+		dev_err(rtc->dev.parent,
+			"rtc core: timestamp from RTC is invalid\n");
+		return;
+	}
+	rtc_tm_to_time(&now, &ts.tv_sec);
+	if (systime_was_set)
+		return;
+	rc = do_settimeofday(&ts);
+	if (unlikely(rc)) {
+		dev_err(rtc->dev.parent,
+			"rtc core: error setting system clock: %d\n", rc);
+		return;
+	} else if (systime_was_set)
+		dev_info(rtc->dev.parent,
+			"rtc core: setting system clock to "
+			"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+			now.tm_year + 1900, now.tm_mon + 1, now.tm_mday,
+			now.tm_hour, now.tm_min, now.tm_sec,
+			(unsigned int) ts.tv_sec);
+}
+
 /**
  * rtc_device_register - register w/ RTC class
  * @dev: the device to register
@@ -159,6 +196,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	struct rtc_device *rtc;
 	struct rtc_wkalrm alrm;
 	int of_id = -1, id = -1, err;
+	const char *hctosys_name = get_hctosys_name();
 
 	if (dev->of_node)
 		of_id = of_alias_get_id(dev->of_node, "rtc");
@@ -213,6 +251,10 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	rtc->pie_timer.function = rtc_pie_update_irq;
 	rtc->pie_enabled = 0;
 
+	if (!systime_was_set &&
+		(!hctosys_name[0] || !strcasecmp(name, hctosys_name)))
+		hctosys(rtc);
+
 	/* Check to see if there is an ALARM already set in hw */
 	err = __rtc_read_alarm(rtc, &alrm);
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 888280f..e5f644c 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -135,6 +135,12 @@ extern int timekeeping_suspended;
  */
 extern bool systime_was_set;
 
+/*
+ * Returns a pointer to the string specified with
+ * hctosys= at the kernel command line.
+ */
+const char *get_hctosys_name(void);
+
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6be8b72..c8992e4 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -18,6 +18,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
+#include <linux/rtc.h>
 #include <linux/time.h>
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
@@ -46,6 +47,22 @@ bool __read_mostly persistent_clock_exist = false;
 /* Flag for if the system time was set at least once */
 bool __read_mostly systime_was_set;
 
+static char hctosys_name[RTC_DEVICE_NAME_SIZE];
+
+static int __init hctosys_setup(char *line)
+{
+	strlcpy(hctosys_name, line, sizeof(hctosys_name));
+	return 1;
+}
+
+__setup("hctosys=", hctosys_setup);
+
+const char *get_hctosys_name(void)
+{
+	return hctosys_name;
+}
+EXPORT_SYMBOL_GPL(get_hctosys_name);
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -796,18 +813,19 @@ void __init timekeeping_init(void)
 	struct timekeeper *tk = &timekeeper;
 	struct clocksource *clock;
 	unsigned long flags;
-	struct timespec now, boot, tmp;
-
-	read_persistent_clock(&now);
-
-	if (!timespec_valid_strict(&now)) {
-		pr_warn("WARNING: Persistent clock returned invalid value!\n"
-			"         Check your CMOS/BIOS settings.\n");
-		now.tv_sec = 0;
-		now.tv_nsec = 0;
-	} else if (now.tv_sec || now.tv_nsec) {
-		persistent_clock_exist = true;
-		systime_was_set = true;
+	struct timespec now = {0, 0}, boot, tmp;
+
+	if (!hctosys_name[0] || !strcasecmp(hctosys_name, "persistent")) {
+		read_persistent_clock(&now);
+		if (!timespec_valid_strict(&now)) {
+			pr_warn("WARNING: Persistent clock returned invalid value!\n"
+				"         Check your CMOS/BIOS settings.\n");
+			now.tv_sec = 0;
+			now.tv_nsec = 0;
+		} else if (now.tv_sec || now.tv_nsec) {
+			persistent_clock_exist = true;
+			systime_was_set = true;
+		}
 	}
 
 	read_boot_clock(&boot);
@@ -844,6 +862,17 @@ void __init timekeeping_init(void)
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+
+	if (systime_was_set) {
+		/* print a msg like if the time was set by a RTC */
+		struct tm now_tm;
+		time_to_tm(now.tv_sec, 0, &now_tm);
+		pr_info("persistent clock: setting system clock to "
+			"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+			(int)now_tm.tm_year + 1900, now_tm.tm_mon + 1,
+			now_tm.tm_mday,	now_tm.tm_hour, now_tm.tm_min,
+			now_tm.tm_sec, (unsigned int) now.tv_sec);
+	}
 }
 
 /* time in seconds when suspend began */
-- 
1.8.3.2

