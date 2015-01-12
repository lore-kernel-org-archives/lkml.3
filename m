Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbbALPjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:39:52 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54906 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752287AbbALPhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:37:09 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v3 3/8] watchdog: at91rm9200: use the regmap from mfd
Date: Mon, 12 Jan 2015 16:36:58 +0100
Message-Id: <1421077023-30954-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system timer MFD driver is providing a regmap. Use it to access the
registers.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/watchdog/Kconfig          |  2 +-
 drivers/watchdog/at91rm9200_wdt.c | 25 ++++++++++++-------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 08f41add1461..18c73bc159fc 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -154,7 +154,7 @@ config ARM_SP805_WATCHDOG
 
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
-	depends on SOC_AT91RM9200
+	depends on SOC_AT91RM9200 && MFD_ATMEL_ST
 	help
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index d244112d5b6f..a4ac88e450a2 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -17,22 +17,24 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/mfd/atmel-st.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 #include <linux/uaccess.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <mach/at91_st.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
 #define WDT_MAX_TIME		256	/* seconds */
 
 static int wdt_time = WDT_DEFAULT_TIME;
 static bool nowayout = WATCHDOG_NOWAYOUT;
+static struct regmap *regmap_st;
 
 module_param(wdt_time, int, 0);
 MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
@@ -55,7 +57,7 @@ static unsigned long at91wdt_busy;
  */
 static inline void at91_wdt_stop(void)
 {
-	at91_st_write(AT91_ST_WDMR, AT91_ST_EXTEN);
+	regmap_write(regmap_st, AT91_ST_WDMR, AT91_ST_EXTEN);
 }
 
 /*
@@ -63,9 +65,9 @@ static inline void at91_wdt_stop(void)
  */
 static inline void at91_wdt_start(void)
 {
-	at91_st_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN |
+	regmap_write(regmap_st, AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN |
 				(((65536 * wdt_time) >> 8) & AT91_ST_WDV));
-	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
+	regmap_write(regmap_st, AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /*
@@ -73,7 +75,7 @@ static inline void at91_wdt_start(void)
  */
 static inline void at91_wdt_reload(void)
 {
-	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
+	regmap_write(regmap_st, AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /* ......................................................................... */
@@ -209,6 +211,10 @@ static int at91wdt_probe(struct platform_device *pdev)
 		return -EBUSY;
 	at91wdt_miscdev.parent = &pdev->dev;
 
+	regmap_st = dev_get_drvdata(pdev->dev.parent);
+	if (!regmap_st)
+		return -ENODEV;
+
 	res = misc_register(&at91wdt_miscdev);
 	if (res)
 		return res;
@@ -254,12 +260,6 @@ static int at91wdt_resume(struct platform_device *pdev)
 #define at91wdt_resume	NULL
 #endif
 
-static const struct of_device_id at91_wdt_dt_ids[] = {
-	{ .compatible = "atmel,at91rm9200-wdt" },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, at91_wdt_dt_ids);
-
 static struct platform_driver at91wdt_driver = {
 	.probe		= at91wdt_probe,
 	.remove		= at91wdt_remove,
@@ -267,8 +267,7 @@ static struct platform_driver at91wdt_driver = {
 	.suspend	= at91wdt_suspend,
 	.resume		= at91wdt_resume,
 	.driver		= {
-		.name	= "at91_wdt",
-		.of_match_table = at91_wdt_dt_ids,
+		.name	= "atmel_st_watchdog",
 	},
 };
 
-- 
2.1.0

