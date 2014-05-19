Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971AbaESRi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:38:27 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45331 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858AbaESRg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:36:56 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/7] pinctrl: berlin: add the BG2CD pinctrl driver
Date: Mon, 19 May 2014 19:36:32 +0200
Message-Id: <1400520995-27365-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>

Add the pin-controller driver for the Berlin BG2Q SoC, with definition
of its groups and functions. Pin control registers are part of chip/
system control registers, which will be represented by a single node.
Until a proper driver for the chip/system control is available,
register the corresponding regmap in pinctrl driver probe.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v3->v4:
- change compatible to the settled name of the chip/system control
  nodes and register a regmap for the core driver instead.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: zmxu@marvell.com
Cc: jszhang@marvell.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/berlin/Kconfig        |   4 +
 drivers/pinctrl/berlin/Makefile       |   1 +
 drivers/pinctrl/berlin/berlin-bg2cd.c | 217 ++++++++++++++++++++++++++++++++++
 3 files changed, 222 insertions(+)
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2cd.c

diff --git a/drivers/pinctrl/berlin/Kconfig b/drivers/pinctrl/berlin/Kconfig
index 381f46347c51..b18322bc7bf9 100644
--- a/drivers/pinctrl/berlin/Kconfig
+++ b/drivers/pinctrl/berlin/Kconfig
@@ -9,6 +9,10 @@ config PINCTRL_BERLIN_BG2
 	bool
 	select PINCTRL_BERLIN
 
+config PINCTRL_BERLIN_BG2CD
+	bool
+	select PINCTRL_BERLIN
+
 config PINCTRL_BERLIN_BG2Q
 	bool
 	select PINCTRL_BERLIN
diff --git a/drivers/pinctrl/berlin/Makefile b/drivers/pinctrl/berlin/Makefile
index e37e4e7a8838..deb0c6baf316 100644
--- a/drivers/pinctrl/berlin/Makefile
+++ b/drivers/pinctrl/berlin/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_PINCTRL_BERLIN)		+= berlin.o
 obj-$(CONFIG_PINCTRL_BERLIN_BG2)	+= berlin-bg2.o
+obj-$(CONFIG_PINCTRL_BERLIN_BG2CD)	+= berlin-bg2cd.o
 obj-$(CONFIG_PINCTRL_BERLIN_BG2Q)	+= berlin-bg2q.o
diff --git a/drivers/pinctrl/berlin/berlin-bg2cd.c b/drivers/pinctrl/berlin/berlin-bg2cd.c
new file mode 100644
index 000000000000..1f08ec2d8a57
--- /dev/null
+++ b/drivers/pinctrl/berlin/berlin-bg2cd.c
@@ -0,0 +1,217 @@
+/*
+ * Marvell Berlin BG2CD pinctrl driver.
+ *
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+#include "berlin.h"
+
+static const struct berlin_desc_group berlin2cd_soc_pinctrl_groups[] = {
+	/* G */
+	BERLIN_PINCTRL_GROUP("G0", 0x00, 0x1, 0x00,
+		BERLIN_PINCTRL_FUNCTION(0x0, "jtag"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "gpio"),
+		BERLIN_PINCTRL_FUNCTION(0x2, "led"),
+		BERLIN_PINCTRL_FUNCTION(0x3, "pwm")),
+	BERLIN_PINCTRL_GROUP("G1", 0x00, 0x2, 0x01,
+		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
+		BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
+		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
+	BERLIN_PINCTRL_GROUP("G2", 0x00, 0x2, 0x02,
+		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
+		BERLIN_PINCTRL_FUNCTION(0x2, "fe"),
+		BERLIN_PINCTRL_FUNCTION(0x3, "pll"),
+		BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
+		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
+	BERLIN_PINCTRL_GROUP("G3", 0x00, 0x2, 0x04,
+		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
+		BERLIN_PINCTRL_FUNCTION(0x2, "twsi2"),
+		BERLIN_PINCTRL_FUNCTION(0x3, "pll"),
+		BERLIN_PINCTRL_FUNCTION(0x4, "fe"),
+		BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
+		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
+	BERLIN_PINCTRL_GROUP("G4", 0x00, 0x2, 0x06,
+		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
+		BERLIN_PINCTRL_FUNCTION(0x2, "twsi3"),
+		BERLIN_PINCTRL_FUNCTION(0x3, "pll"),
+		BERLIN_PINCTRL_FUNCTION(0x4, "pwm"),
+		BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
+		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
+	BERLIN_PINCTRL_GROUP("G5", 0x00, 0x3, 0x08,
+		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
+		BERLIN_PINCTRL_FUNCTION(0x2, "twsi3"),
+		BERLIN_PINCTRL_FUNCTION(0x3, "arc"),
+		BERLIN_PINCTRL_FUNCTION(0x4, "pwm"),
+		BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
+		BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
+	BERLIN_PINCTRL_GROUP("G6", 0x00, 0x2, 0x0b,
+		BERLIN_PINCTRL_FUNCTION(0x0, "uart0"),	/* RX/TX */
+		BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
+	BERLIN_PINCTRL_GROUP("G7", 0x00, 0x3, 0x0d,
+		BERLIN_PINCTRL_FUNCTION(0x0, "eddc"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "twsi1"),
+		BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
+	BERLIN_PINCTRL_GROUP("G8", 0x00, 0x3, 0x10,
+		BERLIN_PINCTRL_FUNCTION(0x0, "ss0"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
+	BERLIN_PINCTRL_GROUP("G9", 0x00, 0x3, 0x13,
+		BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "spi1"),
+		BERLIN_PINCTRL_FUNCTION(0x2, "twsi0")),
+	BERLIN_PINCTRL_GROUP("G10", 0x00, 0x2, 0x16,
+		BERLIN_PINCTRL_FUNCTION(0x0, "spi1"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
+	BERLIN_PINCTRL_GROUP("G11", 0x00, 0x2, 0x18,
+		BERLIN_PINCTRL_FUNCTION(0x0, "spi1"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
+	BERLIN_PINCTRL_GROUP("G12", 0x00, 0x3, 0x1a,
+		BERLIN_PINCTRL_FUNCTION(0x0, "usb1"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
+	BERLIN_PINCTRL_GROUP("G13", 0x04, 0x3, 0x00,
+		BERLIN_PINCTRL_FUNCTION(0x0, "nand"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "usb0_dbg"),
+		BERLIN_PINCTRL_FUNCTION(0x2, "usb1_dbg")),
+	BERLIN_PINCTRL_GROUP("G14", 0x04, 0x1, 0x03,
+		BERLIN_PINCTRL_FUNCTION(0x0, "nand"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
+	BERLIN_PINCTRL_GROUP("G15", 0x04, 0x2, 0x04,
+		BERLIN_PINCTRL_FUNCTION(0x0, "jtag"),
+		BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
+	BERLIN_PINCTRL_GROUP("G16", 0x04, 0x3, 0x06,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G17", 0x04, 0x3, 0x09,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G18", 0x04, 0x1, 0x0c,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G19", 0x04, 0x1, 0x0d,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G20", 0x04, 0x1, 0x0e,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G21", 0x04, 0x3, 0x0f,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G22", 0x04, 0x3, 0x12,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G23", 0x04, 0x3, 0x15,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G24", 0x04, 0x2, 0x18,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G25", 0x04, 0x2, 0x1a,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G26", 0x04, 0x1, 0x1c,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G27", 0x04, 0x1, 0x1d,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("G28", 0x04, 0x2, 0x1e,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+};
+
+static const struct berlin_desc_group berlin2cd_sysmgr_pinctrl_groups[] = {
+	/* GSM */
+	BERLIN_PINCTRL_GROUP("GSM0", 0x40, 0x2, 0x00,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM1", 0x40, 0x2, 0x02,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM2", 0x40, 0x2, 0x04,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM3", 0x40, 0x2, 0x06,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM4", 0x40, 0x2, 0x08,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM5", 0x40, 0x2, 0x0a,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM6", 0x40, 0x2, 0x0c,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM7", 0x40, 0x1, 0x0e,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM8", 0x40, 0x1, 0x0f,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM9", 0x40, 0x1, 0x10,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM10", 0x40, 0x1, 0x11,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+	BERLIN_PINCTRL_GROUP("GSM11", 0x40, 0x1, 0x12,
+		BERLIN_PINCTRL_FUNCTION_UNKNOWN),
+};
+
+static const struct berlin_pinctrl_desc berlin2cd_soc_pinctrl_data = {
+	.groups = berlin2cd_soc_pinctrl_groups,
+	.ngroups = ARRAY_SIZE(berlin2cd_soc_pinctrl_groups),
+};
+
+static const struct berlin_pinctrl_desc berlin2cd_sysmgr_pinctrl_data = {
+	.groups = berlin2cd_sysmgr_pinctrl_groups,
+	.ngroups = ARRAY_SIZE(berlin2cd_sysmgr_pinctrl_groups),
+};
+
+static const struct of_device_id berlin2cd_pinctrl_match[] = {
+	{
+		.compatible = "marvell,berlin2cd-chip-ctrl",
+		.data = &berlin2cd_soc_pinctrl_data
+	},
+	{
+		.compatible = "marvell,berlin2cd-system-ctrl",
+		.data = &berlin2cd_sysmgr_pinctrl_data
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(of, berlin2cd_pinctrl_match);
+
+static int berlin2cd_pinctrl_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match =
+		of_match_device(berlin2cd_pinctrl_match, &pdev->dev);
+	struct regmap_config *rmconfig;
+	struct regmap *regmap;
+	struct resource *res;
+	void __iomem *base;
+
+	rmconfig = devm_kzalloc(&pdev->dev, sizeof(*rmconfig), GFP_KERNEL);
+	if (!rmconfig)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!base)
+		return -EADDRNOTAVAIL;
+
+	rmconfig->reg_bits = 32,
+	rmconfig->val_bits = 32,
+	rmconfig->reg_stride = 4,
+	rmconfig->max_register = resource_size(res);
+
+	regmap = devm_regmap_init_mmio(&pdev->dev, base, rmconfig);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	return berlin_pinctrl_probe(pdev, match->data);
+}
+
+static struct platform_driver berlin2cd_pinctrl_driver = {
+	.probe	= berlin2cd_pinctrl_probe,
+	.driver	= {
+		.name = "berlin-bg2cd-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = berlin2cd_pinctrl_match,
+	},
+};
+module_platform_driver(berlin2cd_pinctrl_driver);
+
+MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
+MODULE_DESCRIPTION("Marvell Berlin BG2CD pinctrl driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

