Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbbAWPNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:13:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:30550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbbAWPNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:13:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="666509003"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 8/8] phy: add driver for TI TUSB1210 ULPI PHY
Date: Fri, 23 Jan 2015 17:12:58 +0200
Message-Id: <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TUSB1210 ULPI PHY has vendor specific register for eye
diagram tuning. On some platforms the system firmware has
set optimized value to it. In order to not loose the
optimized value, the driver stores it during probe and
restores it every time the PHY is powered back on.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig        |   6 ++
 drivers/phy/Makefile       |   1 +
 drivers/phy/phy-tusb1210.c | 133 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+)
 create mode 100644 drivers/phy/phy-tusb1210.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 26a7623..52ee720 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -284,4 +284,10 @@ config PHY_QCOM_UFS
 	help
 	  Support for UFS PHY on QCOM chipsets.
 
+config PHY_TUSB1210
+	tristate "TI TUSB1210 ULPI PHY module"
+	depends on USB_ULPI_BUS
+	help
+	  Support for TI TUSB1210 USB ULPI PHY.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index cfbb720..03f3d85 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -37,3 +37,4 @@ obj-$(CONFIG_PHY_STIH41X_USB)		+= phy-stih41x-usb.o
 obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs.o
 obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs-qmp-20nm.o
 obj-$(CONFIG_PHY_QCOM_UFS) 	+= phy-qcom-ufs-qmp-14nm.o
+obj-$(CONFIG_PHY_TUSB1210)		+= phy-tusb1210.o
diff --git a/drivers/phy/phy-tusb1210.c b/drivers/phy/phy-tusb1210.c
new file mode 100644
index 0000000..1551ae8
--- /dev/null
+++ b/drivers/phy/phy-tusb1210.c
@@ -0,0 +1,133 @@
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
+#include <linux/ulpi/driver.h>
+#include <linux/gpio/consumer.h>
+
+#include "ulpi_phy.h"
+
+#define TUSB1210_VENDOR_SPECIFIC2 0x80
+
+struct tusb1210 {
+	struct ulpi *ulpi;
+	struct phy *phy;
+	struct gpio_desc *gpio_reset;
+	struct gpio_desc *gpio_cs;
+	u8 eye_diagram_tuning;
+};
+
+static int tusb1210_power_on(struct phy *phy)
+{
+	struct tusb1210 *tusb = phy_get_drvdata(phy);
+
+	gpiod_set_value_cansleep(tusb->gpio_reset, 1);
+	gpiod_set_value_cansleep(tusb->gpio_cs, 1);
+
+	/* Restore eye diagram optimisation value */
+	ulpi_write(tusb->ulpi, TUSB1210_VENDOR_SPECIFIC2,
+		   tusb->eye_diagram_tuning);
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
+	ret = ulpi_read(ulpi, TUSB1210_VENDOR_SPECIFIC2);
+	if (ret < 0)
+		return ret;
+
+	tusb->eye_diagram_tuning = ret;
+
+	tusb->phy = ulpi_phy_create(ulpi, &phy_ops);
+	if (IS_ERR(tusb->phy))
+		return PTR_ERR(tusb->phy);
+
+	tusb->ulpi = ulpi;
+
+	phy_set_drvdata(tusb->phy, tusb);
+	ulpi_set_drvdata(ulpi, tusb);
+	return 0;
+}
+
+static void tusb1210_remove(struct ulpi *ulpi)
+{
+	struct tusb1210 *tusb = ulpi_get_drvdata(ulpi);
+
+	ulpi_phy_destroy(ulpi, tusb->phy);
+}
+
+#define TI_VENDOR_ID 0x0451
+
+static const struct ulpi_device_id tusb1210_ulpi_id[] = {
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
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("TUSB1210 ULPI PHY driver");
-- 
2.1.4

