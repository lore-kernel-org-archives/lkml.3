Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3FERRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:17:01 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:37727 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab3FERRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:17:00 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/3] RFC: timekeeping: rtc: Introduce new kernel parameter hctosys
Date: Wed,  5 Jun 2013 19:15:39 +0200
Message-Id: <1370452540-3319-3-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1370452540-3319-1-git-send-email-holler@ahsoftware.de>
References: <51ADEE76.7090504@ahsoftware.de>
 <1370452540-3319-1-git-send-email-holler@ahsoftware.de>
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
 Documentation/kernel-parameters.txt | 12 ++++++++++++
 drivers/rtc/class.c                 | 32 ++++++++++++++++++++++++++++++++
 include/linux/time.h                |  6 ++++++
 kernel/time/timekeeping.c           | 31 ++++++++++++++++++++++++++++++-
 4 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6e3b18a..a8b7a9c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -983,6 +983,18 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
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
index 6638540..841d4e9 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -141,6 +141,33 @@ static int rtc_resume(struct device *dev)
 #endif
 
 
+static void hctosys(struct rtc_device *rtc)
+{
+	struct rtc_time now;
+	struct timespec tv = {
+		.tv_nsec = NSEC_PER_SEC >> 1,
+	};
+	int err;
+
+	err = rtc_read_time(rtc, &now);
+	if (err)
+		return;
+	err = rtc_valid_tm(&now);
+	if (err)
+		return;
+	rtc_tm_to_time(&now, &tv.tv_sec);
+	if (systime_was_set)
+		return;
+	err = do_settimeofday(&tv);
+	if (!err && systime_was_set)
+		dev_info(rtc->dev.parent,
+			"setting system clock to "
+			"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+			now.tm_year + 1900, now.tm_mon + 1, now.tm_mday,
+			now.tm_hour, now.tm_min, now.tm_sec,
+			(unsigned int) tv.tv_sec);
+}
+
 /**
  * rtc_device_register - register w/ RTC class
  * @dev: the device to register
@@ -157,6 +184,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	struct rtc_device *rtc;
 	struct rtc_wkalrm alrm;
 	int id, err;
+	const char *hctosys_name = get_hctosys_name();
 
 	id = ida_simple_get(&rtc_ida, 0, 0, GFP_KERNEL);
 	if (id < 0) {
@@ -196,6 +224,10 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
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
index 07f151f..1de734c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -22,6 +22,7 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
+#include <linux/rtc.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
@@ -40,6 +41,22 @@ bool __read_mostly persistent_clock_exist = false;
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
@@ -780,7 +797,8 @@ void __init timekeeping_init(void)
 	unsigned long flags;
 	struct timespec now, boot, tmp;
 
-	read_persistent_clock(&now);
+	if (!hctosys_name[0] || !strcasecmp(hctosys_name, "persistent"))
+		read_persistent_clock(&now);
 
 	if (!timespec_valid_strict(&now)) {
 		pr_warn("WARNING: Persistent clock returned invalid value!\n"
@@ -826,6 +844,17 @@ void __init timekeeping_init(void)
 
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
1.8.1.5

