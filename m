Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbbATJSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:18:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:54671 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbbATJSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:18:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442631561"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Date: Tue, 20 Jan 2015 11:18:22 +0200
Message-Id: <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TUSB1210 ULPI PHY has vendor specific register for eye
diagram tuning. On some platforms the system firmware has
set optimized value to it. In order to not loose the
optimized value, the driver stores it during probe and
restores it every time the PHY is powered back on.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/phy/ulpi/Kconfig    |  11 ++++
 drivers/phy/ulpi/Makefile   |   2 +
 drivers/phy/ulpi/tusb1210.c | 131 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)
 create mode 100644 drivers/phy/ulpi/tusb1210.c

diff --git a/drivers/phy/ulpi/Kconfig b/drivers/phy/ulpi/Kconfig
index 8007df2..7cd6f82 100644
--- a/drivers/phy/ulpi/Kconfig
+++ b/drivers/phy/ulpi/Kconfig
@@ -7,3 +7,14 @@ config ULPI_PHY
 	  Say yes if you have ULPI PHY attached to your USB controller.
 
 	  If unsure, say N.
+
+if ULPI_PHY
+
+config ULPI_TUSB1210
+	tristate "TI TUSB1210 USB PHY module"
+	depends on POWER_SUPPLY
+	select USB_PHY
+	help
+	  Support for TI TUSB1210 USB ULPI PHY.
+
+endif
diff --git a/drivers/phy/ulpi/Makefile b/drivers/phy/ulpi/Makefile
index 59e61cb..7ee6679 100644
--- a/drivers/phy/ulpi/Makefile
+++ b/drivers/phy/ulpi/Makefile
@@ -1,2 +1,4 @@
 ulpiphy-y			:= ulpi.o
 obj-$(CONFIG_ULPI_PHY)		+= ulpiphy.o
+
+obj-$(CONFIG_ULPI_TUSB1210)	+= tusb1210.o
diff --git a/drivers/phy/ulpi/tusb1210.c b/drivers/phy/ulpi/tusb1210.c
new file mode 100644
index 0000000..ac77f98
--- /dev/null
+++ b/drivers/phy/ulpi/tusb1210.c
@@ -0,0 +1,131 @@
+/**
+ * tusb1210.c - TUSB1210 USB ULPI PHY driver
+ *
+ * Copyright (C) 2015 Intel Corporation
+ *
+ * Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/phy/ulpi/driver.h>
+#include <linux/phy/ulpi/regs.h>
+#include <linux/gpio/consumer.h>
+
+#include "ulpi_phy.h"
+
+struct tusb1210 {
+	struct ulpi *ulpi;
+	struct phy *phy;
+	struct gpio_desc *gpio_reset;
+	struct gpio_desc *gpio_cs;
+	u8 ctx[1];
+};
+
+static int tusb1210_power_on(struct phy *phy)
+{
+	struct tusb1210 *tusb = phy_get_drvdata(phy);
+
+	gpiod_set_value_cansleep(tusb->gpio_reset, 1);
+	gpiod_set_value_cansleep(tusb->gpio_cs, 1);
+
+	/* Restore eye optimisation value */
+	ulpi_write(tusb->ulpi, ULPI_EXT_VENDOR_SPECIFIC, tusb->ctx[0]);
+
+	return 0;
+}
+
+static int tusb1210_power_off(struct phy *phy)
+{
+	struct tusb1210 *tusb = phy_get_drvdata(phy);
+
+	gpiod_set_value_cansleep(tusb->gpio_reset, 0);
+	gpiod_set_value_cansleep(tusb->gpio_cs, 0);
+
+	return 0;
+}
+
+static struct phy_ops phy_ops = {
+	.power_on = tusb1210_power_on,
+	.power_off = tusb1210_power_off,
+	.init = tusb1210_power_on,
+	.exit = tusb1210_power_off,
+	.owner = THIS_MODULE,
+};
+
+static int tusb1210_probe(struct ulpi *ulpi)
+{
+	struct gpio_desc *gpio;
+	struct tusb1210 *tusb;
+	int ret;
+
+	tusb = devm_kzalloc(&ulpi->dev, sizeof(*tusb), GFP_KERNEL);
+	if (!tusb)
+		return -ENOMEM;
+
+	gpio = devm_gpiod_get(&ulpi->dev, "reset");
+	if (!IS_ERR(gpio)) {
+		ret = gpiod_direction_output(gpio, 0);
+		if (ret)
+			return ret;
+		tusb->gpio_reset = gpio;
+	}
+
+	gpio = devm_gpiod_get(&ulpi->dev, "cs");
+	if (!IS_ERR(gpio)) {
+		ret = gpiod_direction_output(gpio, 0);
+		if (ret)
+			return ret;
+		tusb->gpio_cs = gpio;
+	}
+
+	/* Store initial eye diagram optimisation value */
+	ret = ulpi_read(ulpi, ULPI_EXT_VENDOR_SPECIFIC);
+	if (ret < 0)
+		return ret;
+
+	tusb->ctx[0] = ret;
+
+	tusb->phy = ulpi_phy_create(ulpi, &phy_ops);
+	if (IS_ERR(tusb->phy))
+		return PTR_ERR(tusb->phy);
+
+	tusb->ulpi = ulpi;
+
+	phy_set_drvdata(tusb->phy, tusb);
+	dev_set_drvdata(&ulpi->dev, tusb);
+	return 0;
+}
+
+static void tusb1210_remove(struct ulpi *ulpi)
+{
+	struct tusb1210 *tusb = dev_get_drvdata(&ulpi->dev);
+
+	ulpi_phy_destroy(ulpi, tusb->phy);
+}
+
+#define TI_VENDOR_ID 0x0451
+
+static struct ulpi_device_id tusb1210_ulpi_id[] = {
+	{ TI_VENDOR_ID, 0x1508, },
+	{ },
+};
+MODULE_DEVICE_TABLE(ulpi, tusb1210_ulpi_id);
+
+static struct ulpi_driver tusb1210_driver = {
+	.id_table = tusb1210_ulpi_id,
+	.probe = tusb1210_probe,
+	.remove = tusb1210_remove,
+	.driver = {
+		.name = "tusb1210",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_ulpi_driver(tusb1210_driver);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("TUSB1210 ULPI PHY driver");
-- 
2.1.4

