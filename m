Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab3ECP5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:57:05 -0400
Received: from nm11-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.124]:44676
	"EHLO nm11-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932986Ab3ECP5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:57:02 -0400
X-Yahoo-Newman-Id: 930187.27409.bm@smtp109.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hl8QZswVM1lqTVbzQR.iFTVNjjWhtsRqzOnYdzQYRyCrWRa
 D5K2JHxcSqNrd_Hb7582Dvy2QMtRE3N9ATMVTZhoN2_bIGXkjXvb1QRsuE1.
 Wdro7izbaErER24AuySMFULVv_zTGE1RwYBAkBRS40TeI_l8S_7CEyqQzZtr
 D7EZL9OxLCYBj1ZRJuqSqlHLW5Vnhpc7A1QpzQBAXvSgcyuiA07k7GxFfycn
 YzyWh59UF8TBWxJkIQ37GYF4SSsLfy5ABsPV5PAjinWASvBOBh26BQ2Cj5Fy
 n3u.JUMU6plAqACNMjbnGkSCAVihe92MW2ecnFQ1JPjmgxZMrLss3.HUBdeK
 XRiGNbcLiNwOvABsadajZmDkKtL5xyGKDwoQVn8fgN4jhYW9vR_n3MDBBWRp
 CAZlYSK8GWMNRJxJlWCVxmtI1G1aj_Z9rY9nldCh5QexUSBOZudr9CXbPauy
 8EOe9O.jDXp21T8UOik_fyQghVVo.mMCkGms0GP8syBrSlhDBQNi6Uzs-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp109.sbc.mail.gq1.yahoo.com with SMTP; 03 May 2013 08:57:00 -0700 PDT
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Dirk Eibach <dirk.eibach@gdsys.cc>
Subject: [RFC PATCH 1/2] watchdog: booke: Convert to platform driver
Date: Fri,  3 May 2013 08:56:45 -0700
Message-Id: <1367596606-22476-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required to be able to add device tree support

Cc: Dirk Eibach <dirk.eibach@gdsys.cc>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Compile tested only. I'll test it on a real system over the weekend
or early next week.

 drivers/watchdog/booke_wdt.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index a8dbceb3..9b066b9 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/smp.h>
 #include <linux/watchdog.h>
+#include <linux/platform_device.h>
 
 #include <asm/reg_booke.h>
 #include <asm/time.h>
@@ -218,17 +219,24 @@ static struct watchdog_device booke_wdt_dev = {
 	.max_timeout = 0xFFFF
 };
 
-static void __exit booke_wdt_exit(void)
+static int booke_wdt_remove(struct platform_device *pdev)
 {
 	watchdog_unregister_device(&booke_wdt_dev);
+	return 0;
+}
+
+static void booke_wdt_shutdown(struct platform_device *pdev)
+{
+	booke_wdt_stop(&booke_wdt_dev);
 }
 
-static int __init booke_wdt_init(void)
+static int booke_wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 	bool nowayout = WATCHDOG_NOWAYOUT;
 
-	pr_info("powerpc book-e watchdog driver loaded\n");
+	dev_info(&pdev->dev, "powerpc book-e watchdog driver loaded\n");
+
 	booke_wdt_info.firmware_version = cur_cpu_spec->pvr_value;
 	booke_wdt_set_timeout(&booke_wdt_dev,
 			      period_to_sec(CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT));
@@ -241,8 +249,18 @@ static int __init booke_wdt_init(void)
 	return ret;
 }
 
-module_init(booke_wdt_init);
-module_exit(booke_wdt_exit);
+static struct platform_driver booke_wdt_driver = {
+	.probe = booke_wdt_probe,
+	.remove = booke_wdt_remove,
+	.shutdown = booke_wdt_shutdown,
+	.driver = {
+		.owner  = THIS_MODULE,
+		.name = "booke_wdt",
+	},
+};
+
+module_platform_driver(booke_wdt_driver);
 
 MODULE_DESCRIPTION("PowerPC Book-E watchdog driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:booke_wdt");
-- 
1.7.9.7

