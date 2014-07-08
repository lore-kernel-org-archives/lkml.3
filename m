Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaGHQVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:21:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753887AbaGHQV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:21:27 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 2/6] memory: add a driver for atmel ram controllers
Date: Tue,  8 Jul 2014 18:21:12 +0200
Message-Id: <1404836476-23787-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404836476-23787-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404836476-23787-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel SoCs have one or multiple RAM controllers that need one or multiple clocks
to run.
This driver handle those clocks.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/memory/Kconfig        | 10 +++++
 drivers/memory/Makefile       |  1 +
 drivers/memory/atmel-sdramc.c | 98 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+)
 create mode 100644 drivers/memory/atmel-sdramc.c

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index c59e9c96e86d..257061c3c816 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -7,6 +7,16 @@ menuconfig MEMORY
 
 if MEMORY
 
+config ATMEL_SDRAMC
+	bool "Atmel (Multi-port DDR-)SDRAM Controller"
+	default y
+	depends on ARCH_AT91 && OF
+	help
+	  This driver is for Atmel SDRAM Controller or Atmel Multi-port
+	  DDR-SDRAM Controller available on Atmel AT91SAM9 and SAMA5 SoCs.
+	  Starting with the at91sam9g45, this controller supports SDR, DDR and
+	  LP-DDR memories.
+
 config TI_AEMIF
 	tristate "Texas Instruments AEMIF driver"
 	depends on (ARCH_DAVINCI || ARCH_KEYSTONE) && OF
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 71160a2b7313..b8637261e1a1 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -5,6 +5,7 @@
 ifeq ($(CONFIG_DDR),y)
 obj-$(CONFIG_OF)		+= of_memory.o
 endif
+obj-$(CONFIG_ATMEL_SDRAMC)	+= atmel-sdramc.o
 obj-$(CONFIG_TI_AEMIF)		+= ti-aemif.o
 obj-$(CONFIG_TI_EMIF)		+= emif.o
 obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
diff --git a/drivers/memory/atmel-sdramc.c b/drivers/memory/atmel-sdramc.c
new file mode 100644
index 000000000000..fed04e8efe75
--- /dev/null
+++ b/drivers/memory/atmel-sdramc.c
@@ -0,0 +1,98 @@
+/*
+ * Atmel (Multi-port DDR-)SDRAM Controller driver
+ *
+ * Copyright (C) 2014 Atmel
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+struct at91_ramc_caps {
+	bool has_ddrck;
+	bool has_mpddr_clk;
+};
+
+static const struct at91_ramc_caps at91rm9200_caps = { };
+
+static const struct at91_ramc_caps at91sam9g45_caps = {
+	.has_ddrck = 1,
+	.has_mpddr_clk = 0,
+};
+
+static const struct at91_ramc_caps sama5d3_caps = {
+	.has_ddrck = 1,
+	.has_mpddr_clk = 1,
+};
+
+static const struct of_device_id atmel_ramc_of_match[] = {
+	{ .compatible = "atmel,at91rm9200-sdramc", .data = &at91rm9200_caps, },
+	{ .compatible = "atmel,at91sam9260-sdramc", .data = &at91rm9200_caps, },
+	{ .compatible = "atmel,at91sam9g45-ddramc", .data = &at91sam9g45_caps, },
+	{ .compatible = "atmel,sama5d3-ddramc", .data = &sama5d3_caps, },
+	{},
+};
+MODULE_DEVICE_TABLE(of, atmel_ramc_of_match);
+
+static int atmel_ramc_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	const struct at91_ramc_caps *caps;
+	struct clk *clk;
+
+	match = of_match_device(atmel_ramc_of_match, &pdev->dev);
+	caps = match->data;
+
+	if (caps->has_ddrck) {
+		clk = devm_clk_get(&pdev->dev, "ddrck");
+		if (IS_ERR(clk))
+			return PTR_ERR(clk);
+		clk_prepare_enable(clk);
+	}
+
+	if (caps->has_mpddr_clk) {
+		clk = devm_clk_get(&pdev->dev, "mpddr");
+		if (IS_ERR(clk)) {
+			pr_err("AT91 RAMC: couldn't get mpddr clock\n");
+			return PTR_ERR(clk);
+		}
+		clk_prepare_enable(clk);
+	}
+
+	return 0;
+}
+
+static struct platform_driver atmel_ramc_driver = {
+	.probe		= atmel_ramc_probe,
+	.driver		= {
+		.name	= "atmel-ramc",
+		.owner	= THIS_MODULE,
+		.of_match_table = atmel_ramc_of_match,
+	},
+};
+
+static int __init atmel_ramc_init(void)
+{
+	return platform_driver_register(&atmel_ramc_driver);
+}
+module_init(atmel_ramc_init);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
+MODULE_DESCRIPTION("Atmel (Multi-port DDR-)SDRAM Controller");
-- 
1.9.1

