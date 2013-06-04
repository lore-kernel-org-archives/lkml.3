Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3FDJhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:37:17 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38713 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3FDJfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:35:44 -0400
From: Ferruh Yigit <fery@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: ttdrivers@cypress.com, Javier Martinez Canillas <javier@dowhile0.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Simon Budig <simon.budig@kernelconcepts.de>,
        Alexander Shiyan <shc_work@mail.ru>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Ferruh Yigit <fery@cypress.com>
Subject: [PATCH v3 3/4] Input: cyttsp4 - I2C driver for Cypress TMA4XX touchscreen devices
Date: Tue,  4 Jun 2013 12:34:43 +0300
Message-Id: <1370338484-26573-4-git-send-email-fery@cypress.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370338484-26573-1-git-send-email-fery@cypress.com>
References: <1370338484-26573-1-git-send-email-fery@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cypress TrueTouch(tm) Standard Product controllers,
Generation4 devices, I2C adapter module.

This driver adds communication support with TTSP controller
using I2C bus.

Signed-off-by: Ferruh Yigit <fery@cypress.com>
---
 drivers/input/touchscreen/Kconfig       |    9 ++++
 drivers/input/touchscreen/Makefile      |    1 +
 drivers/input/touchscreen/cyttsp4_i2c.c |   90 +++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)
 create mode 100644 drivers/input/touchscreen/cyttsp4_i2c.c

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 66df8df..1645e8e 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -179,6 +179,15 @@ config TOUCHSCREEN_CYTTSP4_CORE
 
 	  To compile this driver as a module, choose M here.
 
+config TOUCHSCREEN_CYTTSP4_I2C
+	tristate "support I2C bus connection"
+	depends on TOUCHSCREEN_CYTTSP4_CORE && I2C
+	help
+	  Say Y here if the touchscreen is connected via I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cyttsp4_i2c.
+
 config TOUCHSCREEN_DA9034
 	tristate "Touchscreen support for Dialog Semiconductor DA9034"
 	depends on PMIC_DA903X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index f445006..1ef807c 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)	+= cyttsp_core.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_I2C)	+= cyttsp_i2c.o cyttsp_i2c_common.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_SPI)	+= cyttsp_spi.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP4_CORE)	+= cyttsp4_core.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP4_I2C)	+= cyttsp4_i2c.o cyttsp_i2c_common.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
 obj-$(CONFIG_TOUCHSCREEN_DA9052)	+= da9052_tsi.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
diff --git a/drivers/input/touchscreen/cyttsp4_i2c.c b/drivers/input/touchscreen/cyttsp4_i2c.c
new file mode 100644
index 0000000..8e2012c
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp4_i2c.c
@@ -0,0 +1,90 @@
+/*
+ * cyttsp_i2c.c
+ * Cypress TrueTouch(TM) Standard Product (TTSP) I2C touchscreen driver.
+ * For use with Cypress  Txx4xx parts.
+ * Supported parts include:
+ * TMA4XX
+ * TMA1036
+ *
+ * Copyright (C) 2009, 2010, 2011 Cypress Semiconductor, Inc.
+ * Copyright (C) 2012 Javier Martinez Canillas <javier@dowhile0.org>
+ * Copyright (C) 2013 Cypress Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
+ *
+ */
+
+#include "cyttsp4_core.h"
+
+#include <linux/i2c.h>
+#include <linux/input.h>
+
+#define CYTTSP4_I2C_DATA_SIZE	(3 * 256)
+
+static const struct cyttsp4_bus_ops cyttsp4_i2c_bus_ops = {
+	.bustype	= BUS_I2C,
+	.write		= cyttsp_i2c_write_block_data,
+	.read           = cyttsp_i2c_read_block_data,
+};
+
+static int cyttsp4_i2c_probe(struct i2c_client *client,
+				      const struct i2c_device_id *id)
+{
+	struct cyttsp4 *ts;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "I2C functionality not Supported\n");
+		return -EIO;
+	}
+
+	ts = cyttsp4_probe(&cyttsp4_i2c_bus_ops, &client->dev, client->irq,
+			  CYTTSP4_I2C_DATA_SIZE);
+
+	if (IS_ERR(ts))
+		return PTR_ERR(ts);
+
+	return 0;
+}
+
+static int cyttsp4_i2c_remove(struct i2c_client *client)
+{
+	struct cyttsp4 *ts = i2c_get_clientdata(client);
+
+	cyttsp4_remove(ts);
+
+	return 0;
+}
+
+static const struct i2c_device_id cyttsp4_i2c_id[] = {
+	{ CYTTSP4_I2C_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, cyttsp4_i2c_id);
+
+static struct i2c_driver cyttsp4_i2c_driver = {
+	.driver = {
+		.name	= CYTTSP4_I2C_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &cyttsp4_pm_ops,
+	},
+	.probe		= cyttsp4_i2c_probe,
+	.remove		= cyttsp4_i2c_remove,
+	.id_table	= cyttsp4_i2c_id,
+};
+
+module_i2c_driver(cyttsp4_i2c_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) I2C driver");
+MODULE_AUTHOR("Cypress");
+MODULE_ALIAS("i2c:cyttsp4");
-- 
1.7.9.5

