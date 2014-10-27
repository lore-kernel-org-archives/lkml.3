Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaJ0XJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:09:58 -0400
Received: from down.free-electrons.com ([37.187.137.238]:55580 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752787AbaJ0XJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:09:54 -0400
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
Subject: [PATCH v2 1/8] memory: atmel-sdramc: export a shutdown function
Date: Tue, 28 Oct 2014 00:09:30 +0100
Message-Id: <1414451377-11053-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is necessary to shutdown the SDRAM before resetting the SoC to avoid having
issue with NAND boot.

Export a function that does exactly that.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/memory/atmel-sdramc.c | 103 ++++++++++++++++++++++++++++++++++++++++++
 include/soc/atmel/memory.h    |   6 +++
 2 files changed, 109 insertions(+)
 create mode 100644 include/soc/atmel/memory.h

diff --git a/drivers/memory/atmel-sdramc.c b/drivers/memory/atmel-sdramc.c
index fed04e8efe75..d89ed0af44d9 100644
--- a/drivers/memory/atmel-sdramc.c
+++ b/drivers/memory/atmel-sdramc.c
@@ -21,24 +21,114 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 
+#include <soc/atmel/memory.h>
+
+#define AT91_SDRAMC_TR		0x04	/* SDRAM Controller Refresh Timer Register */
+#define AT91_SDRAMC_LPR		0x10	/* SDRAM Controller Low Power Register */
+#define			AT91_SDRAMC_LPCB_POWER_DOWN		2
+
+#define AT91_DDRSDRC_RTR	0x04	/* Refresh Timer Register */
+#define AT91_DDRSDRC_LPR	0x1C	/* Low Power Register */
+#define			AT91_DDRSDRC_LPCB_POWER_DOWN		2
+
+static void __iomem *at91_ramc_base[2];
+
+void (*at91_ramc_shutdown)(void __iomem *rstc_cr, u32 value);
+
 struct at91_ramc_caps {
 	bool has_ddrck;
 	bool has_mpddr_clk;
+	void (*shutdown)(void __iomem *rstc_cr, u32 value);
 };
 
+static void at91sam9260_shutdown(void __iomem *rstc_cr, u32 value)
+{
+	asm volatile(
+		/* Align to cache lines */
+		".balign 32\n\t"
+
+		/* Disable SDRAM accesses */
+		"str	%1, [%0, #" __stringify(AT91_SDRAMC_TR) "]\n\t"
+
+		/* Power down SDRAM */
+		"str	%2, [%0, #" __stringify(AT91_SDRAMC_LPR) "]\n\t"
+
+		/* Reset CPU */
+		"str	%4, [%3]\n\t"
+
+		"b	.\n\t"
+
+		:
+		: "r" (at91_ramc_base[0]),
+		  "r" (1),
+		  "r" (AT91_SDRAMC_LPCB_POWER_DOWN),
+		  "r" (rstc_cr),
+		  "r" (value));
+}
+
+static void at91sam9g45_shutdown(void __iomem *rstc_cr, u32 value)
+{
+	asm volatile(
+		/*
+		 * Test wether we have a second RAM controller to care
+		 * about.
+		 *
+		 * First, test that we can dereference the virtual address.
+		 */
+		"cmp	%1, #0\n\t"
+		"beq	1f\n\t"
+
+		/* Then, test that the RAM controller is enabled */
+		"ldr	r0, [%1]\n\t"
+		"cmp	r0, #0\n\t"
+
+		/* Align to cache lines */
+		".balign 32\n\t"
+
+		/* Disable SDRAM0 accesses */
+		"1:	str	%2, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
+		/* Power down SDRAM0 */
+		"	str	%3, [%0, #" __stringify(AT91_DDRSDRC_LPR) "]\n\t"
+		/* Disable SDRAM1 accesses */
+		"	strne	%2, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
+		/* Power down SDRAM1 */
+		"	strne	%3, [%1, #" __stringify(AT91_DDRSDRC_LPR) "]\n\t"
+
+		/* Reset CPU */
+		"str	%5, [%4]\n\t"
+
+		"b	.\n\t"
+
+		:
+		: "r" (at91_ramc_base[0]),
+		  "r" (at91_ramc_base[1]),
+		  "r" (1),
+		  "r" (AT91_DDRSDRC_LPCB_POWER_DOWN),
+		  "r" (rstc_cr),
+		  "r" (value)
+		: "r0");
+}
+
 static const struct at91_ramc_caps at91rm9200_caps = { };
 
+static const struct at91_ramc_caps at91sam9260_caps = {
+	.shutdown = at91sam9260_shutdown,
+};
+
 static const struct at91_ramc_caps at91sam9g45_caps = {
 	.has_ddrck = 1,
 	.has_mpddr_clk = 0,
+	.shutdown = at91sam9g45_shutdown,
 };
 
 static const struct at91_ramc_caps sama5d3_caps = {
 	.has_ddrck = 1,
 	.has_mpddr_clk = 1,
+	.shutdown = at91sam9g45_shutdown,
 };
 
 static const struct of_device_id atmel_ramc_of_match[] = {
@@ -54,7 +144,9 @@ static int atmel_ramc_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 	const struct at91_ramc_caps *caps;
+	struct device_node *np;
 	struct clk *clk;
+	int idx = 0;
 
 	match = of_match_device(atmel_ramc_of_match, &pdev->dev);
 	caps = match->data;
@@ -75,6 +167,17 @@ static int atmel_ramc_probe(struct platform_device *pdev)
 		clk_prepare_enable(clk);
 	}
 
+	for_each_matching_node(np, atmel_ramc_of_match) {
+		at91_ramc_base[idx] = of_iomap(np, 0);
+		if (!at91_ramc_base[idx]) {
+			dev_err(&pdev->dev, "Could not map ram controller address\n");
+			return -ENODEV;
+		}
+		idx++;
+	}
+
+	at91_ramc_shutdown = caps->shutdown;
+
 	return 0;
 }
 
diff --git a/include/soc/atmel/memory.h b/include/soc/atmel/memory.h
new file mode 100644
index 000000000000..93f75fecf9bf
--- /dev/null
+++ b/include/soc/atmel/memory.h
@@ -0,0 +1,6 @@
+#ifndef __INCLUDE_ATMEL_MEMORY_H
+#define __INCLUDE_ATMEL_MEMORY_H
+
+extern void (*at91_ramc_shutdown)(void __iomem *rstc_cr, u32 value);
+
+#endif /* __INCLUDE_ATMEL_MEMORY_H */
-- 
1.9.1

