Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3ETXVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:21:42 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:44003 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3ETXVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:21:40 -0400
From: Sergey Yanovich <ynvich@gmail.com>
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: Sergey Yanovich <ynvich@gmail.com>, Marc Zyngier <maz@misterjones.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] rtc-ds1302: handle write protection
Date: Tue, 21 May 2013 03:21:30 +0400
Message-Id: <1369092090-5384-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This chip has a control register and can prevent altering saved clock.
Without this patch we could have:
----8<----
(arm)root@pac14:~# date
Tue May 21 03:08:27 MSK 2013
(arm)root@pac14:~# /etc/init.d/hwclock.sh show
Tue May 21 11:13:58 2013  -0.067322 seconds
(arm)root@pac14:~# /etc/init.d/hwclock.sh stop
[info] Saving the system clock.
[info] Hardware Clock updated to Tue May 21 03:09:01 MSK 2013.
(arm)root@pac14:~# /etc/init.d/hwclock.sh show
Tue May 21 11:14:15 2013  -0.624272 seconds
----8<----

Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
---
 drivers/rtc/rtc-ds1302.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index 73eafb9..626aec2 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -23,8 +23,12 @@
 #define	RTC_CMD_READ	0x81		/* Read command */
 #define	RTC_CMD_WRITE	0x80		/* Write command */
 
+#define	RTC_CMD_WRITE_ENABLE	0x00		/* Write enable */
+#define	RTC_CMD_WRITE_DISABLE	0x80		/* Write disable */
+
 #define RTC_ADDR_RAM0	0x20		/* Address of RAM0 */
 #define RTC_ADDR_TCR	0x08		/* Address of trickle charge register */
+#define	RTC_ADDR_CTRL	0x07		/* Address of control register */
 #define	RTC_ADDR_YEAR	0x06		/* Address of year register */
 #define	RTC_ADDR_DAY	0x05		/* Address of day of week register */
 #define	RTC_ADDR_MON	0x04		/* Address of month register */
@@ -313,6 +317,7 @@ static int __init ds1302_rtc_probe(struct platform_device *pdev)
 		return PTR_ERR(rtc);
 
 	platform_set_drvdata(pdev, rtc);
+	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_ENABLE);
 
 	return 0;
 }
@@ -321,6 +326,7 @@ static int ds1302_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
+	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_DISABLE);
 	rtc_device_unregister(rtc);
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.10.4

