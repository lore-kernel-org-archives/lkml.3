Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaGGLvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:51:20 -0400
Received: from coyote.quickmin.net ([217.14.112.24]:64734 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaGGLvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:51:06 -0400
From: Roman Fietze <roman.fietze@telemotive.de>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 2/2] Allow to override the hctosys RTC using a kernel parameter
Date: Mon, 07 Jul 2014 13:50:12 +0200
Message-ID: <2398890.hEQ05gdLB8@rfietze>
Organization: Telemotive AG
User-Agent: KMail/4.13.2 (Linux/3.11.10-17-default; KDE/4.13.2; x86_64; ; )
In-Reply-To: <5132579.sMfE4ssjXf@rfietze>
References: <5132579.sMfE4ssjXf@rfietze>
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.5.3FP6HF107 | January 23, 2014) at
 07.07.2014 13:50:11,
	Serialize by Router on muc/Telemotive(Release 8.5.3FP6HF107 | January 23, 2014) at
 07.07.2014 13:50:11,
	Serialize complete at 07.07.2014 13:50:11
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list members,

And here the second part.


>From e523006a34db26c274d3b71de5b914f476fb029e Mon Sep 17 00:00:00 2001
From: Roman Fietze <roman.fietze@telemotive.de>
Date: Fri, 4 Jul 2014 10:05:08 +0200
Subject: [PATCH 2/2] rtc: add kernel parameter hctosys, use it instead of
 CONFIG_RTC_HCTOSYS_DEVICE

This change allows to overwrite the default of the hctosys RTC
specified in the kernnel configuration by using a kernel parameter in
the form of

  hctosys=rtc<n>

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 Documentation/kernel-parameters.txt |  2 ++
 drivers/rtc/class.c                 | 23 +++++++++++++++++++++--
 drivers/rtc/hctosys.c               |  4 ++--
 drivers/rtc/rtc-sysfs.c             |  2 +-
 drivers/rtc/systohc.c               |  2 +-
 include/linux/rtc.h                 |  1 +
 6 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 30a8ad0d..ab1672f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1110,6 +1110,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	hcl=		[IA-64] SGI's Hardware Graph compatibility layer
 
+	hctosys=	[RTC_HCTOSYS_DEVICE] Sets the hctosys RTC
+
 	hd=		[EIDE] (E)IDE hard drive subsystem geometry
 			Format: <cyl>,<head>,<sect>
 
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 589351e..b39434d 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -34,7 +34,26 @@ static void rtc_device_release(struct device *dev)
 	kfree(rtc);
 }
 
+
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
+
+char rtc_hctosys_device[RTC_HCTOSYS_DEVICE_SIZE] = CONFIG_RTC_HCTOSYS_DEVICE;
+
+static int __init parse_hctosys(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (strlen(str) >= RTC_HCTOSYS_DEVICE_SIZE)
+		return -ENOMEM;
+
+	strcpy(rtc_hctosys_device, str);
+
+	return 0;
+}
+
+__setup("hctosys=", parse_hctosys);
+
 /* Result of the last RTC to system clock attempt. */
 int rtc_hctosys_ret = -ENODEV;
 #endif
@@ -57,7 +76,7 @@ static int rtc_suspend(struct device *dev)
 	if (has_persistent_clock())
 		return 0;
 
-	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
+	if (strcmp(dev_name(&rtc->dev), rtc_hctosys_device) != 0)
 		return 0;
 
 	/* snapshot the current RTC and system time at suspend*/
@@ -99,7 +118,7 @@ static int rtc_resume(struct device *dev)
 		return 0;
 
 	rtc_hctosys_ret = -ENODEV;
-	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
+	if (strcmp(dev_name(&rtc->dev), rtc_hctosys_device) != 0)
 		return 0;
 
 	/* snapshot the current rtc and system time at resume */
diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index 4aa60d7..ea79018 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -29,11 +29,11 @@ static int __init rtc_hctosys(void)
 	struct timespec tv = {
 		.tv_nsec = NSEC_PER_SEC >> 1,
 	};
-	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
+	struct rtc_device *rtc = rtc_class_open(rtc_hctosys_device);
 
 	if (rtc == NULL) {
 		pr_err("%s: unable to open rtc device (%s)\n",
-			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
+			__FILE__, rtc_hctosys_device);
 		goto err_open;
 	}
 
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index babd43b..69c6a9f 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -114,7 +114,7 @@ hctosys_show(struct device *dev, struct device_attribute *attr, char *buf)
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
 	if (rtc_hctosys_ret == 0 &&
 			strcmp(dev_name(&to_rtc_device(dev)->dev),
-				CONFIG_RTC_HCTOSYS_DEVICE) == 0)
+				rtc_hctosys_device) == 0)
 		return sprintf(buf, "1\n");
 	else
 #endif
diff --git a/drivers/rtc/systohc.c b/drivers/rtc/systohc.c
index bf3e242..db9e74a 100644
--- a/drivers/rtc/systohc.c
+++ b/drivers/rtc/systohc.c
@@ -31,7 +31,7 @@ int rtc_set_ntp_time(struct timespec now)
 	else
 		rtc_time_to_tm(now.tv_sec + 1, &tm);
 
-	rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
+	rtc = rtc_class_open(rtc_hctosys_device);
 	if (rtc) {
 		/* rtc_hctosys exclusively uses UTC, so we call set_time here,
 		 * not set_mmss. */
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 0a115b5..6feb68a 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -194,6 +194,7 @@ static inline bool is_leap_year(unsigned int year)
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
 #define RTC_HCTOSYS_DEVICE_SIZE	10
 extern int rtc_hctosys_ret;
+extern char rtc_hctosys_device[RTC_HCTOSYS_DEVICE_SIZE];
 #else
 #define rtc_hctosys_ret -ENODEV
 #endif
-- 
1.8.4.5



-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49 7335 18493-45          http://www.telemotive.de

