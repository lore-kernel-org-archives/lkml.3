Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaJ0XL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:11:57 -0400
Received: from down.free-electrons.com ([37.187.137.238]:55611 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752862AbaJ0XKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:10:00 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 5/8] power: reset: at91-reset: use at91_ramc_shutdown
Date: Tue, 28 Oct 2014 00:09:34 +0100
Message-Id: <1414451377-11053-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all SoCs are registering the atmel-sdramc driver, use the
at91_ramc_shutdown() function to shutdown the sdram.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/power/reset/at91-reset.c | 122 +++++----------------------------------
 1 file changed, 14 insertions(+), 108 deletions(-)

diff --git a/drivers/power/reset/at91-reset.c b/drivers/power/reset/at91-reset.c
index 3cb36693343a..1c210e53f784 100644
--- a/drivers/power/reset/at91-reset.c
+++ b/drivers/power/reset/at91-reset.c
@@ -19,8 +19,7 @@
 
 #include <asm/system_misc.h>
 
-#include <mach/at91sam9_ddrsdr.h>
-#include <mach/at91sam9_sdramc.h>
+#include <soc/atmel/memory.h>
 
 #define AT91_RSTC_CR	0x00		/* Reset Controller Control Register */
 #define AT91_RSTC_PROCRST	BIT(0)		/* Processor Reset */
@@ -47,76 +46,20 @@ enum reset_type {
 	RESET_TYPE_USER		= 4,
 };
 
-static void __iomem *at91_ramc_base[2], *at91_rstc_base;
+static void __iomem *at91_rstc_base;
 
 /*
 * unless the SDRAM is cleanly shutdown before we hit the
 * reset register it can be left driving the data bus and
 * killing the chance of a subsequent boot from NAND
 */
-static void at91sam9260_restart(enum reboot_mode mode, const char *cmd)
+static void at91_restart(enum reboot_mode mode, const char *cmd)
 {
-	asm volatile(
-		/* Align to cache lines */
-		".balign 32\n\t"
-
-		/* Disable SDRAM accesses */
-		"str	%2, [%0, #" __stringify(AT91_SDRAMC_TR) "]\n\t"
-
-		/* Power down SDRAM */
-		"str	%3, [%0, #" __stringify(AT91_SDRAMC_LPR) "]\n\t"
-
-		/* Reset CPU */
-		"str	%4, [%1, #" __stringify(AT91_RSTC_CR) "]\n\t"
-
-		"b	.\n\t"
-		:
-		: "r" (at91_ramc_base[0]),
-		  "r" (at91_rstc_base),
-		  "r" (1),
-		  "r" (AT91_SDRAMC_LPCB_POWER_DOWN),
-		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST));
-}
-
-static void at91sam9g45_restart(enum reboot_mode mode, const char *cmd)
-{
-	asm volatile(
-		/*
-		 * Test wether we have a second RAM controller to care
-		 * about.
-		 *
-		 * First, test that we can dereference the virtual address.
-		 */
-		"cmp	%1, #0\n\t"
-		"beq	1f\n\t"
-
-		/* Then, test that the RAM controller is enabled */
-		"ldr	r0, [%1]\n\t"
-		"cmp	r0, #0\n\t"
-
-		/* Align to cache lines */
-		".balign 32\n\t"
-
-		/* Disable SDRAM0 accesses */
-		"1:	str	%3, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
-		/* Power down SDRAM0 */
-		"	str	%4, [%0, #" __stringify(AT91_DDRSDRC_LPR) "]\n\t"
-		/* Disable SDRAM1 accesses */
-		"	strne	%3, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
-		/* Power down SDRAM1 */
-		"	strne	%4, [%1, #" __stringify(AT91_DDRSDRC_LPR) "]\n\t"
-		/* Reset CPU */
-		"	str	%5, [%2, #" __stringify(AT91_RSTC_CR) "]\n\t"
-
-		"	b	.\n\t"
-		:
-		: "r" (at91_ramc_base[0]),
-		  "r" (at91_ramc_base[1]),
-		  "r" (at91_rstc_base),
-		  "r" (1),
-		  "r" (AT91_DDRSDRC_LPCB_POWER_DOWN),
-		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST)
-		: "r0");
+	if (at91_ramc_shutdown)
+		at91_ramc_shutdown(at91_rstc_base + AT91_RSTC_CR,
+				   AT91_RSTC_KEY | AT91_RSTC_PERRST |
+				   AT91_RSTC_PROCRST);
+	BUG();
 }
 
 static void __init at91_reset_status(struct platform_device *pdev)
@@ -148,51 +91,27 @@ static void __init at91_reset_status(struct platform_device *pdev)
 	pr_info("AT91: Starting after %s\n", reason);
 }
 
-static struct of_device_id at91_ramc_of_match[] = {
-	{ .compatible = "atmel,at91sam9260-sdramc", },
-	{ .compatible = "atmel,at91sam9g45-ddramc", },
-	{ .compatible = "atmel,sama5d3-ddramc", },
-	{ /* sentinel */ }
-};
-
 static struct of_device_id at91_reset_of_match[] = {
-	{ .compatible = "atmel,at91sam9260-rstc", .data = at91sam9260_restart },
-	{ .compatible = "atmel,at91sam9g45-rstc", .data = at91sam9g45_restart },
+	{ .compatible = "atmel,at91sam9260-rstc", },
+	{ .compatible = "atmel,at91sam9g45-rstc", },
 	{ /* sentinel */ }
 };
 
 static int at91_reset_of_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
-	struct device_node *np;
-	int idx = 0;
-
 	at91_rstc_base = of_iomap(pdev->dev.of_node, 0);
 	if (!at91_rstc_base) {
 		dev_err(&pdev->dev, "Could not map reset controller address\n");
 		return -ENODEV;
 	}
 
-	for_each_matching_node(np, at91_ramc_of_match) {
-		at91_ramc_base[idx] = of_iomap(np, 0);
-		if (!at91_ramc_base[idx]) {
-			dev_err(&pdev->dev, "Could not map ram controller address\n");
-			return -ENODEV;
-		}
-		idx++;
-	}
-
-	match = of_match_node(at91_reset_of_match, pdev->dev.of_node);
-	arm_pm_restart = match->data;
-
 	return 0;
 }
 
+
 static int at91_reset_platform_probe(struct platform_device *pdev)
 {
-	const struct platform_device_id *match;
 	struct resource *res;
-	int idx = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	at91_rstc_base = devm_ioremap_resource(&pdev->dev, res);
@@ -201,20 +120,6 @@ static int at91_reset_platform_probe(struct platform_device *pdev)
 		return PTR_ERR(at91_rstc_base);
 	}
 
-	for (idx = 0; idx < 2; idx++) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, idx + 1 );
-		at91_ramc_base[idx] = devm_ioremap(&pdev->dev, res->start,
-						   resource_size(res));
-		if (IS_ERR(at91_ramc_base[idx])) {
-			dev_err(&pdev->dev, "Could not map ram controller address\n");
-			return PTR_ERR(at91_ramc_base[idx]);
-		}
-	}
-
-	match = platform_get_device_id(pdev);
-	arm_pm_restart = (void (*)(enum reboot_mode, const char*))
-		match->driver_data;
-
 	return 0;
 }
 
@@ -230,14 +135,15 @@ static int at91_reset_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	arm_pm_restart = at91_restart;
 	at91_reset_status(pdev);
 
 	return 0;
 }
 
 static struct platform_device_id at91_reset_plat_match[] = {
-	{ "at91-sam9260-reset", (unsigned long)at91sam9260_restart },
-	{ "at91-sam9g45-reset", (unsigned long)at91sam9g45_restart },
+	{ "at91-sam9260-reset",  },
+	{ "at91-sam9g45-reset",  },
 	{ /* sentinel */ }
 };
 
-- 
1.9.1

