Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaEEF1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:27:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35605 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754354AbaEEF1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:27:36 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] pinctrl: berlin: add the BG2CD pinctrl driver
Date: Mon,  5 May 2014 07:27:26 +0200
Message-Id: <1399267649-20218-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the pin-controller driver for the Berlin BG2CD SoC, with definition
of its groups and functions. This uses the core Berlin pinctrl driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
 drivers/pinctrl/berlin/Kconfig        |   4 +
 drivers/pinctrl/berlin/Makefile       |   1 +
 drivers/pinctrl/berlin/berlin-bg2cd.c | 194 ++++++++++++++++++++++++++++++++++
 3 files changed, 199 insertions(+)
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2cd.c

diff --git a/drivers/pinctrl/berlin/Kconfig b/drivers/pinctrl/berlin/Kconfig
index 1b34943bef1c..b2cee6f71ccd 100644
--- a/drivers/pinctrl/berlin/Kconfig
+++ b/drivers/pinctrl/berlin/Kconfig
@@ -8,6 +8,10 @@ config PINCTRL_BERLIN_BG2
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
index 000000000000..9613b6a8134b
--- /dev/null
+++ b/drivers/pinctrl/berlin/berlin-bg2cd.c
@@ -0,0 +1,194 @@
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
+		.compatible = "marvell,berlin2cd-soc-pinctrl",
+		.data = &berlin2cd_soc_pinctrl_data
+	},
+	{
+		.compatible = "marvell,berlin2cd-sysmgr-pinctrl",
+		.data = &berlin2cd_sysmgr_pinctrl_data
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(of, berlin2cd_pinctrl_match);
+
+static int berlin2cd_pinctrl_probe(struct platform_device *pdev)
+{
+	const struct of_device_id
+		*device = of_match_device(berlin2cd_pinctrl_match, &pdev->dev);
+
+	return berlin_pinctrl_probe(pdev, device->data);
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
1.8.3.2

