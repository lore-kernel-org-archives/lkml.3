Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbbAIJyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:54:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38090 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756293AbbAIJvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:51:39 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 3/8] watchdog: at91rm9200: use the regmap from mfd
Date: Fri,  9 Jan 2015 10:51:29 +0100
Message-Id: <1420797094-9444-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system timer MFD driver is providing a regmap. Use it to access the
registers.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/watchdog/Kconfig          |  2 +-
 drivers/watchdog/at91rm9200_wdt.c | 27 +++++++++------------------
 2 files changed, 10 insertions(+), 19 deletions(-)

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
index d244112d5b6f..a493fe4b0dfc 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -14,25 +14,22 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/mfd/atmel-st.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
-#include <linux/types.h>
+#include <linux/regmap.h>
 #include <linux/watchdog.h>
 #include <linux/uaccess.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
-#include <mach/at91_st.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
 #define WDT_MAX_TIME		256	/* seconds */
 
 static int wdt_time = WDT_DEFAULT_TIME;
 static bool nowayout = WATCHDOG_NOWAYOUT;
+static struct regmap *regmap_st;
 
 module_param(wdt_time, int, 0);
 MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
@@ -55,7 +52,7 @@ static unsigned long at91wdt_busy;
  */
 static inline void at91_wdt_stop(void)
 {
-	at91_st_write(AT91_ST_WDMR, AT91_ST_EXTEN);
+	regmap_write(regmap_st, AT91_ST_WDMR, AT91_ST_EXTEN);
 }
 
 /*
@@ -63,9 +60,9 @@ static inline void at91_wdt_stop(void)
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
@@ -73,7 +70,7 @@ static inline void at91_wdt_start(void)
  */
 static inline void at91_wdt_reload(void)
 {
-	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
+	regmap_write(regmap_st, AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /* ......................................................................... */
@@ -204,6 +201,7 @@ static struct miscdevice at91wdt_miscdev = {
 static int at91wdt_probe(struct platform_device *pdev)
 {
 	int res;
+	regmap_st = dev_get_drvdata(pdev->dev.parent);
 
 	if (at91wdt_miscdev.parent)
 		return -EBUSY;
@@ -254,12 +252,6 @@ static int at91wdt_resume(struct platform_device *pdev)
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
@@ -267,8 +259,7 @@ static struct platform_driver at91wdt_driver = {
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

