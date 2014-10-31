Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbaJaUqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:46:08 -0400
Received: from down.free-electrons.com ([37.187.137.238]:44805 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751457AbaJaUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:46:05 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/2] watchdog: at91rm9200 remove mach/ header dependency
Date: Fri, 31 Oct 2014 21:45:59 +0100
Message-Id: <1414788359-15759-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the mach/ header dependency by including the necessary macros and taking
the appropriate resources from the system timer.

Also allow to compile both the at91rm920 and at91sam9 watchdog drivers at the
same time.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/watchdog/Kconfig          |  4 ++--
 drivers/watchdog/at91rm9200_wdt.c | 45 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index d0107d424ee4..0592db68f3a8 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -154,14 +154,14 @@ config ARM_SP805_WATCHDOG
 
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
-	depends on ARCH_AT91RM9200
+	depends on ARCH_AT91 || COMPILE_TEST
 	help
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.
 
 config AT91SAM9X_WATCHDOG
 	tristate "AT91SAM9X / AT91CAP9 watchdog"
-	depends on ARCH_AT91 && !ARCH_AT91RM9200
+	depends on ARCH_AT91
 	select WATCHDOG_CORE
 	help
 	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index dee6cc21d270..776cb3b313d9 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -26,11 +26,28 @@
 #include <linux/uaccess.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <mach/at91_st.h>
+#include <linux/of_address.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
 #define WDT_MAX_TIME		256	/* seconds */
 
+static void __iomem *at91_st_base;
+
+#define at91_st_read(field) \
+	readl(at91_st_base + field)
+
+#define at91_st_write(field, value) \
+	writel(value, at91_st_base + field)
+
+#define AT91_ST_CR	0x00		/* Control Register */
+#define AT91_ST_WDRST	(1 << 0)	/* Watchdog Timer Restart */
+
+#define AT91_ST_WDMR	0x08		/* Watchdog Mode Register */
+#define AT91_ST_WDV	(0xffff <<  0)	/* Watchdog Counter Value */
+#define AT91_ST_RSTEN	(1	<< 16)	/* Reset Enable */
+#define AT91_ST_EXTEN	(1	<< 17)	/* External Signal Assertion Enable */
+
+
 static int wdt_time = WDT_DEFAULT_TIME;
 static bool nowayout = WATCHDOG_NOWAYOUT;
 
@@ -201,14 +218,38 @@ static struct miscdevice at91wdt_miscdev = {
 	.fops		= &at91wdt_fops,
 };
 
+static struct of_device_id at91rm9200_st_timer_ids[] = {
+	{ .compatible = "atmel,at91rm9200-st" },
+	{ /* sentinel */ }
+};
+
 static int at91wdt_probe(struct platform_device *pdev)
 {
+	struct resource *regs;
+	struct resource _regs;
 	int res;
 
 	if (at91wdt_miscdev.parent)
 		return -EBUSY;
 	at91wdt_miscdev.parent = &pdev->dev;
 
+	if (pdev->dev.of_node) {
+		struct device_node *np;
+
+		np = of_find_matching_node(NULL, at91rm9200_st_timer_ids);
+		if (!np)
+			return -ENXIO;
+		if (of_address_to_resource(np, 0, &_regs))
+			return -ENXIO;
+		regs = &_regs;
+	} else {
+		regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	}
+
+	at91_st_base = devm_ioremap_resource(&pdev->dev, regs);
+	if (!at91_st_base)
+		return -ENXIO;
+
 	res = misc_register(&at91wdt_miscdev);
 	if (res)
 		return res;
@@ -267,7 +308,7 @@ static struct platform_driver at91wdt_driver = {
 	.suspend	= at91wdt_suspend,
 	.resume		= at91wdt_resume,
 	.driver		= {
-		.name	= "at91_wdt",
+		.name	= "at91rm9200_wdt",
 		.owner	= THIS_MODULE,
 		.of_match_table = at91_wdt_dt_ids,
 	},
-- 
2.1.0

