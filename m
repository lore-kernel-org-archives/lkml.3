Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaDWLio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:38:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61343 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaDWLiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:38:15 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Silvio F <silvio.fricke@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/6 v2] mfd: stmpe: prope properly from the device tree
Date: Wed, 23 Apr 2014 13:37:48 +0200
Message-Id: <1398253068-20984-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current STMPE I2C probing code does not really match the
compatible strings - it matches node names happening to give
the right device name. Instead, let's introduce some real
compatible matching, more complex, more accurate. Make the
driver depend on OF since all platforms using it are DT-only.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Make driver depend on OF and remove some ifdeffery that way.
- Squash OF match table to single lines.
- Merge of-specific probe function into probe().
- Print a small nag if DT is using the node name trick to make
  the driver probe.
---
 drivers/mfd/Kconfig     |  1 +
 drivers/mfd/stmpe-i2c.c | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 33834120d057..29be025d5835 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -675,6 +675,7 @@ config MFD_DB8500_PRCMU
 config MFD_STMPE
 	bool "STMicroelectronics STMPE"
 	depends on (I2C=y || SPI_MASTER=y)
+	depends on OF
 	select MFD_CORE
 	help
 	  Support for the STMPE family of I/O Expanders from
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 0da02e11d58e..da15dda04df9 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/of_device.h>
 #include "stmpe.h"
 
 static int i2c_reg_read(struct stmpe *stmpe, u8 reg)
@@ -52,15 +53,42 @@ static struct stmpe_client_info i2c_ci = {
 	.write_block = i2c_block_write,
 };
 
+static const struct of_device_id stmpe_of_match[] = {
+	{ .compatible = "st,stmpe610", .data = (void *)STMPE610, },
+	{ .compatible = "st,stmpe801", .data = (void *)STMPE801, },
+	{ .compatible = "st,stmpe811", .data = (void *)STMPE811, },
+	{ .compatible = "st,stmpe1601", .data = (void *)STMPE1601, },
+	{ .compatible = "st,stmpe1801", .data = (void *)STMPE1801, },
+	{ .compatible = "st,stmpe2401", .data = (void *)STMPE2401, },
+	{ .compatible = "st,stmpe2403", .data = (void *)STMPE2403, },
+	{},
+};
+MODULE_DEVICE_TABLE(of, stmpe_of_match);
+
 static int
 stmpe_i2c_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 {
+	int partnum;
+	const struct of_device_id *of_id;
+
 	i2c_ci.data = (void *)id;
 	i2c_ci.irq = i2c->irq;
 	i2c_ci.client = i2c;
 	i2c_ci.dev = &i2c->dev;
 
-	return stmpe_probe(&i2c_ci, id->driver_data);
+	of_id = of_match_device(stmpe_of_match, &i2c->dev);
+	if (!of_id) {
+		/*
+		 * This happens when the I2C ID matches the node name
+		 * but no real compatible string has been given.
+		 */
+		dev_info(&i2c->dev, "matching on node name, compatible is preferred\n");
+		partnum = id->driver_data;
+		return -ENODEV;
+	} else
+		partnum = (int)of_id->data;
+
+	return stmpe_probe(&i2c_ci, partnum);
 }
 
 static int stmpe_i2c_remove(struct i2c_client *i2c)
@@ -89,6 +117,7 @@ static struct i2c_driver stmpe_i2c_driver = {
 #ifdef CONFIG_PM
 		.pm = &stmpe_dev_pm_ops,
 #endif
+		.of_match_table = stmpe_of_match,
 	},
 	.probe		= stmpe_i2c_probe,
 	.remove		= stmpe_i2c_remove,
-- 
1.9.0

