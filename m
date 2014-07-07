Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaGGLg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:36:58 -0400
Received: from coyote.quickmin.net ([217.14.112.24]:56604 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaGGLg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:36:57 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2014 07:36:56 EDT
From: Roman Fietze <roman.fietze@telemotive.de>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 1/2] Allow to override the hctosys RTC using a kernel parameter
Date: Mon, 07 Jul 2014 13:30:08 +0200
Message-ID: <5132579.sMfE4ssjXf@rfietze>
Organization: Telemotive AG
User-Agent: KMail/4.13.2 (Linux/3.11.10-17-default; KDE/4.13.2; x86_64; ; )
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.5.3FP6HF107 | January 23, 2014) at
 07.07.2014 13:30:08,
	Serialize by Router on muc/Telemotive(Release 8.5.3FP6HF107 | January 23, 2014) at
 07.07.2014 13:30:08,
	Serialize complete at 07.07.2014 13:30:08
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello RTC maintainers and list members,

I would like to hear your criticism about the following two small
patches.

These patches allow to overwrite the hctosys RTC specified in the
kernel config using CONFIG_RTC_HCTOSYS_DEVICE.

The background ist, that we have two almost identical x86 boards from
MEN in Nuernberg. The first one buffers the CMOS RTC, the other one
buffers an additional Epson RX8581 I2C RTC. We would like to use the
same kernel, but the only parameter we could not overwrite when
starting the kernel or system was the RTC used to initialize the
system clock.


>From 1e302072919594da0f5e71b38e7254ebfa4243f7 Mon Sep 17 00:00:00 2001
From: Roman Fietze <roman.fietze@telemotive.de>
Date: Thu, 3 Jul 2014 14:20:40 +0200
Subject: [PATCH 1/2] rtc: define maximum size of RTC device name in rtc.h

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 drivers/rtc/rtc-proc.c | 10 ++++------
 include/linux/rtc.h    |  1 +
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index ffa69e1..a77ca46 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -18,19 +18,17 @@
 
 #include "rtc-core.h"
 
-#define NAME_SIZE	10
-
 #if defined(CONFIG_RTC_HCTOSYS_DEVICE)
 static bool is_rtc_hctosys(struct rtc_device *rtc)
 {
 	int size;
-	char name[NAME_SIZE];
+	char name[RTC_HCTOSYS_DEVICE_SIZE];
 
-	size = scnprintf(name, NAME_SIZE, "rtc%d", rtc->id);
-	if (size > NAME_SIZE)
+	size = scnprintf(name, RTC_HCTOSYS_DEVICE_SIZE, "rtc%d", rtc->id);
+	if (size > RTC_HCTOSYS_DEVICE_SIZE)
 		return false;
 
-	return !strncmp(name, CONFIG_RTC_HCTOSYS_DEVICE, NAME_SIZE);
+	return !strncmp(name, rtc_hctosys_device, RTC_HCTOSYS_DEVICE_SIZE);
 }
 #else
 static bool is_rtc_hctosys(struct rtc_device *rtc)
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c2897..0a115b5 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -192,6 +192,7 @@ static inline bool is_leap_year(unsigned int year)
 }
 
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
+#define RTC_HCTOSYS_DEVICE_SIZE	10
 extern int rtc_hctosys_ret;
 #else
 #define rtc_hctosys_ret -ENODEV
-- 
1.8.4.5



Roman

-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49 7335 18493-45          http://www.telemotive.de

