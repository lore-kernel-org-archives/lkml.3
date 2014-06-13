Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaFMEPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 00:15:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:37750 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaFMEPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 00:15:04 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: John Whitmore <arigead@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 3/3] RFC: timekeeping: rtc: remove CONFIG_RTC_HCTOSYS and RTC_HCTOSYS_DEVICE
Date: Fri, 13 Jun 2014 06:13:26 +0200
Message-Id: <1402632806-6369-3-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402632806-6369-1-git-send-email-holler@ahsoftware.de>
References: <20140612151505.03defe29@linux.lan.towertech.it>
 <1402632806-6369-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those config options don't make sense anymore with the new hctosys
mechanism introduced with the previous patch.

That means two things:

- If a (hardware) clock is available it will be used to set the time at
  boot. This was already the case for system which have a "persistent"
  clock, e.g. most x86 systems. The only way to specify the device used
  for hctosys is now by using the kernel parameter hctosys= introduced
  with a previous patch.

- If a hardware clock was used for hctosys before suspend, this clock
  will be used to adjust the clock at resume. Again, this doesn't change
  anything on systems with a "persistent" clock.

What's missing:

I don't know much about those "persistent" clocks and I haven't had a
deep look at them. That's especially true for the suspend/resume
mechanism used by them. The mechanism I want to use is the following:
The RTC subsystem now maintains the ID of the RTC device which was used
for hctosys (in rtc_hctosys_dev_id) and therefor specifies the device
which should be used to adjust the time after resume. Additionaly the
(new) flag systime_was_set will be set to false at suspend and on resume
this flag will be set to true if either the clock will be adjusted by
the device used for hctosys or by userspace (through do_settimeofday()).

That all should already work as expected for RTCs, what's missing for
"persistent" clocks is that the flag systime_was_set is set to false on
suspend and set to true on resume. Currently it just stays at true
(which is set through hctosys if a "persistent" clock is found.
But because "persistent" clocks don't go away (as it is possible with
RTCs by removing the driver or the RTC itself), nor do "persistent"
clocks might have two instances, this shouldn't be a problem at all.

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

 Documentation/rtc.txt   |  8 +++---
 drivers/rtc/Kconfig     | 35 ++---------------------
 drivers/rtc/Makefile    |  1 -
 drivers/rtc/class.c     | 30 ++++++++++++-------
 drivers/rtc/hctosys.c   | 76 -------------------------------------------------
 drivers/rtc/rtc-proc.c  | 25 ++--------------
 drivers/rtc/rtc-sysfs.c |  6 +---
 drivers/rtc/systohc.c   |  5 +++-
 include/linux/rtc.h     |  7 ++---
 9 files changed, 34 insertions(+), 159 deletions(-)
 delete mode 100644 drivers/rtc/hctosys.c

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 596b60c..76e031b 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -121,8 +121,9 @@ three different userspace interfaces:
 
     *	/proc/driver/rtc ... the system clock RTC may expose itself
 	using a procfs interface. If there is no RTC for the system clock,
-	rtc0 is used by default. More information is (currently) shown
-	here than through sysfs.
+	or a "persistent" clock is used to set the system clock,
+	/proc/driver/rtc will not exist.
+	More information is (currently) shown here than through sysfs.
 
 The RTC Class framework supports a wide variety of RTCs, ranging from those
 integrated into embeddable system-on-chip (SOC) processors to discrete chips
@@ -144,8 +145,7 @@ rtc attributes without requiring the use of ioctls. All dates and times
 are in the RTC's timezone, rather than in system time.
 
 date:  	   	 RTC-provided date
-hctosys:   	 1 if the RTC provided the system time at boot via the
-		 CONFIG_RTC_HCTOSYS kernel option, 0 otherwise
+hctosys:   	 1 if the RTC provided the system time at boot, 0 otherwise
 max_user_freq:	 The maximum interrupt rate an unprivileged user may request
 		 from this RTC.
 name:		 The name of the RTC corresponding to this sysfs directory
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 2e565f8..bce8625 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -17,44 +17,13 @@ menuconfig RTC_CLASS
 
 if RTC_CLASS
 
-config RTC_HCTOSYS
-	bool "Set system time from RTC on startup and resume"
-	default y
-	help
-	  If you say yes here, the system time (wall clock) will be set using
-	  the value read from a specified RTC device. This is useful to avoid
-	  unnecessary fsck runs at boot time, and to network better.
-
 config RTC_SYSTOHC
 	bool "Set the RTC time based on NTP synchronization"
 	default y
 	help
 	  If you say yes here, the system time (wall clock) will be stored
-	  in the RTC specified by RTC_HCTOSYS_DEVICE approximately every 11
-	  minutes if userspace reports synchronized NTP status.
-
-config RTC_HCTOSYS_DEVICE
-	string "RTC used to set the system time"
-	depends on RTC_HCTOSYS = y || RTC_SYSTOHC = y
-	default "rtc0"
-	help
-	  The RTC device that will be used to (re)initialize the system
-	  clock, usually rtc0. Initialization is done when the system
-	  starts up, and when it resumes from a low power state. This
-	  device should record time in UTC, since the kernel won't do
-	  timezone correction.
-
-	  The driver for this RTC device must be loaded before late_initcall
-	  functions run, so it must usually be statically linked.
-
-	  This clock should be battery-backed, so that it reads the correct
-	  time when the system boots from a power-off state. Otherwise, your
-	  system will need an external clock source (like an NTP server).
-
-	  If the clock you specify here is not battery backed, it may still
-	  be useful to reinitialize system time when resuming from system
-	  sleep states. Do not specify an RTC here unless it stays powered
-	  during all this system's supported sleep states.
+	  in the RTC used to set the time at boot or resume approximately
+	  every 11 minutes if userspace reports synchronized NTP status.
 
 config RTC_DEBUG
 	bool "RTC debug support"
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 40a0991..9ef9ad1 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -5,7 +5,6 @@
 ccflags-$(CONFIG_RTC_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_RTC_LIB)		+= rtc-lib.o
-obj-$(CONFIG_RTC_HCTOSYS)	+= hctosys.o
 obj-$(CONFIG_RTC_SYSTOHC)	+= systohc.o
 obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
 rtc-core-y			:= class.o interface.o
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 18c47b0..c1bc700 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -27,6 +27,9 @@
 static DEFINE_IDA(rtc_ida);
 struct class *rtc_class;
 
+/* The ID of the RTC device used to set the system clock */
+int __read_mostly rtc_hctosys_dev_id = -1;
+
 static void rtc_device_release(struct device *dev)
 {
 	struct rtc_device *rtc = to_rtc_device(dev);
@@ -34,12 +37,7 @@ static void rtc_device_release(struct device *dev)
 	kfree(rtc);
 }
 
-#ifdef CONFIG_RTC_HCTOSYS_DEVICE
-/* Result of the last RTC to system clock attempt. */
-int rtc_hctosys_ret = -ENODEV;
-#endif
-
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
+#if defined(CONFIG_PM_SLEEP)
 /*
  * On suspend(), measure the delta between one RTC and the
  * system's wall clock; restore it on resume().
@@ -54,12 +52,18 @@ static int rtc_suspend(struct device *dev)
 	struct rtc_time		tm;
 	struct timespec		delta, delta_delta;
 
+
+	if (!systime_was_set)
+		return 0;
+
 	if (has_persistent_clock())
 		return 0;
 
-	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
+	if (rtc->id != rtc_hctosys_dev_id)
 		return 0;
 
+	systime_was_set = false;
+
 	/* snapshot the current RTC and system time at suspend*/
 	rtc_read_time(rtc, &tm);
 	getnstimeofday(&old_system);
@@ -95,11 +99,13 @@ static int rtc_resume(struct device *dev)
 	struct timespec		new_system, new_rtc;
 	struct timespec		sleep_time;
 
+	if (systime_was_set)
+		return 0;
+
 	if (has_persistent_clock())
 		return 0;
 
-	rtc_hctosys_ret = -ENODEV;
-	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
+	if (rtc->id != rtc_hctosys_dev_id)
 		return 0;
 
 	/* snapshot the current rtc and system time at resume */
@@ -132,7 +138,7 @@ static int rtc_resume(struct device *dev)
 
 	if (sleep_time.tv_sec >= 0)
 		timekeeping_inject_sleeptime(&sleep_time);
-	rtc_hctosys_ret = 0;
+	systime_was_set = true;
 	return 0;
 }
 
@@ -171,13 +177,15 @@ static void hctosys(struct rtc_device *rtc)
 		dev_err(rtc->dev.parent,
 			"rtc core: error setting system clock: %d\n", rc);
 		return;
-	} else if (systime_was_set)
+	} else if (systime_was_set) {
+		rtc_hctosys_dev_id = rtc->id;
 		dev_info(rtc->dev.parent,
 			"rtc core: setting system clock to "
 			"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
 			now.tm_year + 1900, now.tm_mon + 1, now.tm_mday,
 			now.tm_hour, now.tm_min, now.tm_sec,
 			(unsigned int) ts.tv_sec);
+	}
 }
 
 /**
diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
deleted file mode 100644
index 4aa60d7..0000000
--- a/drivers/rtc/hctosys.c
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * RTC subsystem, initialize system time on startup
- *
- * Copyright (C) 2005 Tower Technologies
- * Author: Alessandro Zummo <a.zummo@towertech.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#include <linux/rtc.h>
-
-/* IMPORTANT: the RTC only stores whole seconds. It is arbitrary
- * whether it stores the most close value or the value with partial
- * seconds truncated. However, it is important that we use it to store
- * the truncated value. This is because otherwise it is necessary,
- * in an rtc sync function, to read both xtime.tv_sec and
- * xtime.tv_nsec. On some processors (i.e. ARM), an atomic read
- * of >32bits is not possible. So storing the most close value would
- * slow down the sync API. So here we have the truncated value and
- * the best guess is to add 0.5s.
- */
-
-static int __init rtc_hctosys(void)
-{
-	int err = -ENODEV;
-	struct rtc_time tm;
-	struct timespec tv = {
-		.tv_nsec = NSEC_PER_SEC >> 1,
-	};
-	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
-
-	if (rtc == NULL) {
-		pr_err("%s: unable to open rtc device (%s)\n",
-			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
-		goto err_open;
-	}
-
-	err = rtc_read_time(rtc, &tm);
-	if (err) {
-		dev_err(rtc->dev.parent,
-			"hctosys: unable to read the hardware clock\n");
-		goto err_read;
-
-	}
-
-	err = rtc_valid_tm(&tm);
-	if (err) {
-		dev_err(rtc->dev.parent,
-			"hctosys: invalid date/time\n");
-		goto err_invalid;
-	}
-
-	rtc_tm_to_time(&tm, &tv.tv_sec);
-
-	err = do_settimeofday(&tv);
-
-	dev_info(rtc->dev.parent,
-		"setting system clock to "
-		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
-		tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
-		tm.tm_hour, tm.tm_min, tm.tm_sec,
-		(unsigned int) tv.tv_sec);
-
-err_invalid:
-err_read:
-	rtc_class_close(rtc);
-
-err_open:
-	rtc_hctosys_ret = err;
-
-	return err;
-}
-
-late_initcall(rtc_hctosys);
diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index ffa69e1..fd59c1b 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -18,27 +18,6 @@
 
 #include "rtc-core.h"
 
-#define NAME_SIZE	10
-
-#if defined(CONFIG_RTC_HCTOSYS_DEVICE)
-static bool is_rtc_hctosys(struct rtc_device *rtc)
-{
-	int size;
-	char name[NAME_SIZE];
-
-	size = scnprintf(name, NAME_SIZE, "rtc%d", rtc->id);
-	if (size > NAME_SIZE)
-		return false;
-
-	return !strncmp(name, CONFIG_RTC_HCTOSYS_DEVICE, NAME_SIZE);
-}
-#else
-static bool is_rtc_hctosys(struct rtc_device *rtc)
-{
-	return (rtc->id == 0);
-}
-#endif
-
 static int rtc_proc_show(struct seq_file *seq, void *offset)
 {
 	int err;
@@ -137,12 +116,12 @@ static const struct file_operations rtc_proc_fops = {
 
 void rtc_proc_add_device(struct rtc_device *rtc)
 {
-	if (is_rtc_hctosys(rtc))
+	if (rtc->id == rtc_hctosys_dev_id)
 		proc_create_data("driver/rtc", 0, NULL, &rtc_proc_fops, rtc);
 }
 
 void rtc_proc_del_device(struct rtc_device *rtc)
 {
-	if (is_rtc_hctosys(rtc))
+	if (rtc->id == rtc_hctosys_dev_id)
 		remove_proc_entry("driver/rtc", NULL);
 }
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index babd43b..c15ee78 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -111,13 +111,9 @@ static DEVICE_ATTR_RW(max_user_freq);
 static ssize_t
 hctosys_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-#ifdef CONFIG_RTC_HCTOSYS_DEVICE
-	if (rtc_hctosys_ret == 0 &&
-			strcmp(dev_name(&to_rtc_device(dev)->dev),
-				CONFIG_RTC_HCTOSYS_DEVICE) == 0)
+	if (to_rtc_device(dev)->id == rtc_hctosys_dev_id)
 		return sprintf(buf, "1\n");
 	else
-#endif
 		return sprintf(buf, "0\n");
 }
 static DEVICE_ATTR_RO(hctosys);
diff --git a/drivers/rtc/systohc.c b/drivers/rtc/systohc.c
index bf3e242..1962f4c 100644
--- a/drivers/rtc/systohc.c
+++ b/drivers/rtc/systohc.c
@@ -25,13 +25,16 @@ int rtc_set_ntp_time(struct timespec now)
 	struct rtc_device *rtc;
 	struct rtc_time tm;
 	int err = -ENODEV;
+	char rtc_hctosys_name[10];
 
 	if (now.tv_nsec < (NSEC_PER_SEC >> 1))
 		rtc_time_to_tm(now.tv_sec, &tm);
 	else
 		rtc_time_to_tm(now.tv_sec + 1, &tm);
 
-	rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
+	scnprintf(rtc_hctosys_name, sizeof(rtc_hctosys_name), "rtc%d",
+		rtc_hctosys_dev_id);
+	rtc = rtc_class_open(rtc_hctosys_name);
 	if (rtc) {
 		/* rtc_hctosys exclusively uses UTC, so we call set_time here,
 		 * not set_mmss. */
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c2897..50caf0d 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -191,10 +191,7 @@ static inline bool is_leap_year(unsigned int year)
 	return (!(year % 4) && (year % 100)) || !(year % 400);
 }
 
-#ifdef CONFIG_RTC_HCTOSYS_DEVICE
-extern int rtc_hctosys_ret;
-#else
-#define rtc_hctosys_ret -ENODEV
-#endif
+/* The ID of the RTC device used to set the system clock */
+extern int rtc_hctosys_dev_id;
 
 #endif /* _LINUX_RTC_H_ */
-- 
1.8.3.2

