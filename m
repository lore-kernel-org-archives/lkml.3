Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbaJUV4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:56:13 -0400
Received: from down.free-electrons.com ([37.187.137.238]:52048 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933686AbaJUV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:56:08 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/8] memory: atmel-sdramc: export a shutdown function
Date: Tue, 21 Oct 2014 23:55:33 +0200
Message-Id: <1413928540-27099-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413928540-27099-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1413928540-27099-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is necessary to shutdown the SDRAM before resetting the SoC to avoid having
issue with NAND boot.

Export a function that does exactly that.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/memory/atmel-sdramc.c | 90 +++++++++++++++++++++++++++++++++++++++++++
 include/soc/atmel/memory.h    |  6 +++
 2 files changed, 96 insertions(+)
 create mode 100644 include/soc/atmel/memory.h

diff --git a/drivers/memory/atmel-sdramc.c b/drivers/memory/atmel-sdramc.c
index fed04e8efe75..148906dabe55 100644
--- a/drivers/memory/atmel-sdramc.c
+++ b/drivers/memory/atmel-sdramc.c
@@ -21,24 +21,101 @@
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
+void (*at91_ramc_shutdown)(void);
+
 struct at91_ramc_caps {
 	bool has_ddrck;
 	bool has_mpddr_clk;
+	void (*shutdown)(void);
 };
 
+void at91sam9260_shutdown(void)
+{
+	pr_err("%s +%d %s\n", __FILE__, __LINE__, __func__);
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
+		:
+		: "r" (at91_ramc_base[0]),
+		  "r" (1),
+		  "r" (AT91_SDRAMC_LPCB_POWER_DOWN));
+}
+
+void at91sam9g45_shutdown(void)
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
+		:
+		: "r" (at91_ramc_base[0]),
+		  "r" (at91_ramc_base[1]),
+		  "r" (1),
+		  "r" (AT91_DDRSDRC_LPCB_POWER_DOWN)
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
@@ -54,7 +131,9 @@ static int atmel_ramc_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 	const struct at91_ramc_caps *caps;
+	struct device_node *np;
 	struct clk *clk;
+	int idx = 0;
 
 	match = of_match_device(atmel_ramc_of_match, &pdev->dev);
 	caps = match->data;
@@ -75,6 +154,17 @@ static int atmel_ramc_probe(struct platform_device *pdev)
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
index 000000000000..04cc1261e636
--- /dev/null
+++ b/include/soc/atmel/memory.h
@@ -0,0 +1,6 @@
+#ifndef __INCLUDE_ATMEL_MEMORY_H
+#define __INCLUDE_ATMEL_MEMORY_H
+
+extern void (*at91_ramc_shutdown)(void);
+
+#endif /* __INCLUDE_ATMEL_MEMORY_H */
-- 
1.9.1

