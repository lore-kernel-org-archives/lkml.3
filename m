Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbaD1O7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:59:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49137 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756405AbaD1O7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:59:46 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 3/7] mfd: add support for sun6i PRCM (Power/Reset/Clock Management) unit
Date: Mon, 28 Apr 2014 16:58:46 +0200
Message-Id: <1398697130-8338-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PRCM (Power/Reset/Clock Management) block exposes several subdevices
in different subsystems (clk, reset ...)

Add basic support for the PRCM unit with clk (AR100, AHB0, and APB0 clks)
and reset controller subdevices.

Other subdevices might be added later (if needed).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/mfd/Kconfig      |   8 +++
 drivers/mfd/Makefile     |   1 +
 drivers/mfd/sun6i-prcm.c | 163 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 drivers/mfd/sun6i-prcm.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2d347c9..0a9220d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -731,6 +731,14 @@ config MFD_STA2X11
 	select MFD_CORE
 	select REGMAP_MMIO
 
+config MFD_SUN6I_PRCM
+	bool "Allwinner PRCM controller"
+	depends on ARCH_SUNXI
+	select MFD_CORE
+	help
+	  Support for the PRCM (Power/Reset/Clock Management) unit available
+	  in A31 SoC.
+
 config MFD_SYSCON
 	bool "System Controller Register R/W Based on Regmap"
 	select REGMAP_MMIO
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 1efecf2..df7823c 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_MFD_STA2X11)	+= sta2x11-mfd.o
 obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
 obj-$(CONFIG_STMPE_I2C)		+= stmpe-i2c.o
 obj-$(CONFIG_STMPE_SPI)		+= stmpe-spi.o
+obj-$(CONFIG_MFD_SUN6I_PRCM)	+= sun6i-prcm.o
 obj-$(CONFIG_MFD_TC3589X)	+= tc3589x.o
 obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
new file mode 100644
index 0000000..e05d92d
--- /dev/null
+++ b/drivers/mfd/sun6i-prcm.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (C) 2014 Free Electrons
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * Allwinner PRCM (Power/Reset/Clock Management) driver
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/irq.h>
+#include <linux/jiffies.h>
+#include <linux/bitops.h>
+#include <linux/fs.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/mfd/core.h>
+
+struct prcm_data {
+	int nsubdevs;
+	const struct mfd_cell *subdevs;
+};
+
+static const struct resource sun6i_a31_ar100_clk_res[] = {
+	{
+		.start = 0x0,
+		.end = 0x3,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static const struct resource sun6i_a31_apb0_clk_res[] = {
+	{
+		.start = 0xc,
+		.end = 0xf,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static const struct resource sun6i_a31_apb0_gates_clk_res[] = {
+	{
+		.start = 0x28,
+		.end = 0x2b,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static const struct resource sun6i_a31_apb0_rstc_res[] = {
+	{
+		.start = 0xb0,
+		.end = 0xb3,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static const struct mfd_cell sun6i_a31_prcm_subdevs[] = {
+	{
+		.name = "sun6i-a31-ar100-mux-clk",
+		.of_compatible = "allwinner,sun6i-a31-ar100-mux-clk",
+		.num_resources = ARRAY_SIZE(sun6i_a31_ar100_clk_res),
+		.resources = sun6i_a31_ar100_clk_res,
+	},
+	{
+		.name = "sun6i-a31-ar100-clk",
+		.of_compatible = "allwinner,sun6i-a31-ar100-clk",
+		.num_resources = ARRAY_SIZE(sun6i_a31_ar100_clk_res),
+		.resources = sun6i_a31_ar100_clk_res,
+	},
+	{
+		.name = "sun6i-a31-ar100-div-clk",
+		.of_compatible = "allwinner,sun6i-a31-ar100-div-clk",
+		.num_resources = ARRAY_SIZE(sun6i_a31_ar100_clk_res),
+		.resources = sun6i_a31_ar100_clk_res,
+	},
+	{
+		.name = "sun6i-a31-apb0-clk",
+		.of_compatible = "allwinner,sun6i-a31-apb0-clk",
+		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_clk_res),
+		.resources = sun6i_a31_apb0_clk_res,
+	},
+	{
+		.name = "sun6i-a31-apb0-gates-clk",
+		.of_compatible = "allwinner,sun6i-a31-apb0-gates-clk",
+		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_gates_clk_res),
+		.resources = sun6i_a31_apb0_gates_clk_res,
+	},
+	{
+		.name = "sun6i-a31-apb0-clock-reset",
+		.of_compatible = "allwinner,sun6i-a31-clock-reset",
+		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_rstc_res),
+		.resources = sun6i_a31_apb0_rstc_res,
+	},
+};
+
+static const struct prcm_data sun6i_a31_prcm_data = {
+	.nsubdevs = ARRAY_SIZE(sun6i_a31_prcm_subdevs),
+	.subdevs = sun6i_a31_prcm_subdevs,
+};
+
+static const struct of_device_id sun6i_prcm_dt_ids[] = {
+	{
+		.compatible = "allwinner,sun6i-a31-prcm",
+		.data = &sun6i_a31_prcm_data,
+	},
+	{ /* sentinel */ },
+};
+
+static int sun6i_prcm_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
+	const struct prcm_data *data;
+	struct resource *res;
+	int ret;
+
+	match = of_match_node(sun6i_prcm_dt_ids, np);
+	if (!match)
+		return -EINVAL;
+
+	data = match->data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no prcm memory region provided\n");
+		return -ENOENT;
+	}
+
+	ret = mfd_add_devices(&pdev->dev, 0, data->subdevs, data->nsubdevs,
+			      res, -1, NULL);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add subdevices\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "PRCM initialized\n");
+
+	return 0;
+}
+
+static struct platform_driver sun6i_prcm_driver = {
+	.driver = {
+		.name = "sun6i-prcm",
+		.owner = THIS_MODULE,
+		.of_match_table = sun6i_prcm_dt_ids,
+	},
+	.probe = sun6i_prcm_probe,
+};
+module_platform_driver(sun6i_prcm_driver);
+
+MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com>");
+MODULE_DESCRIPTION("Allwinner sun6i PRCM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

