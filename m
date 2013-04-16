Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3DPHov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:44:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60305 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab3DPHot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:44:49 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] RTC: rtc-twl: Convert to module_platform_driver() and relocate reg_map init
Date: Tue, 16 Apr 2013 09:44:22 +0200
Message-ID: <1366098262-20726-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to use module_platform_driver() to register the platform
driver and relocate the rtc_reg_map initialization to platform driver's
probe function.
In this way we can make sure that the twl-core has been already probed since
the core driver will create the device at the end of it's probe function.

Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi Tony, Alessandro, Christoph,

I think this patch is the correct solution for the issue Christoph reported:
http://www.spinics.net/lists/linux-omap/msg89980.html

We can make sure that the twl-core has been already probed and initialized when
the RTC driver tries to pick the correct register map.

Regards,
Peter

 drivers/rtc/rtc-twl.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 8bc6c80..22b2fd6 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -469,6 +469,12 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	if (irq <= 0)
 		goto out1;
 
+	/* Initialize the register map */
+	if (twl_class_is_4030())
+		rtc_reg_map = (u8 *)twl4030_rtc_reg_map;
+	else
+		rtc_reg_map = (u8 *)twl6030_rtc_reg_map;
+
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
 		goto out1;
@@ -612,22 +618,7 @@ static struct platform_driver twl4030rtc_driver = {
 	},
 };
 
-static int __init twl_rtc_init(void)
-{
-	if (twl_class_is_4030())
-		rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
-	else
-		rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
-
-	return platform_driver_register(&twl4030rtc_driver);
-}
-module_init(twl_rtc_init);
-
-static void __exit twl_rtc_exit(void)
-{
-	platform_driver_unregister(&twl4030rtc_driver);
-}
-module_exit(twl_rtc_exit);
+module_platform_driver(twl4030rtc_driver);
 
 MODULE_AUTHOR("Texas Instruments, MontaVista Software");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

