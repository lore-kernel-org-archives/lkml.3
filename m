Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422639AbaDPOoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:44:46 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43162 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161145AbaDPOoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:44:44 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Silvio F <silvio.fricke@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/6] mfd: stmpe: prope properly from the device tree
Date: Wed, 16 Apr 2014 16:44:12 +0200
Message-Id: <1397659455-13638-4-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current STMPE I2C probing code does not really match the
compatible strings - it matches node names happening to give
the right device name. Instead, let's introduce some real
compatible matching, more complex, more accurate.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stmpe-i2c.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 0da02e11d58e..8902a600d978 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/of_device.h>
 #include "stmpe.h"
 
 static int i2c_reg_read(struct stmpe *stmpe, u8 reg)
@@ -52,15 +53,71 @@ static struct stmpe_client_info i2c_ci = {
 	.write_block = i2c_block_write,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id stmpe_of_match[] = {
+	{
+		.compatible = "st,stmpe610",
+		.data = (void *)STMPE610,
+	},
+	{
+		.compatible = "st,stmpe801",
+		.data = (void *)STMPE801,
+	},
+	{
+		.compatible = "st,stmpe811",
+		.data = (void *)STMPE811,
+	},
+	{
+		.compatible = "st,stmpe1601",
+		.data = (void *)STMPE1601,
+	},
+	{
+		.compatible = "st,stmpe1801",
+		.data = (void *)STMPE1801,
+	},
+	{
+		.compatible = "st,stmpe2401",
+		.data = (void *)STMPE2401,
+	},
+	{
+		.compatible = "st,stmpe2403",
+		.data = (void *)STMPE2403,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, stmpe_of_match);
+
+int stmpe_i2c_of_probe(struct i2c_client *i2c)
+{
+	const struct of_device_id *of_id;
+
+	of_id = of_match_device(stmpe_of_match, &i2c->dev);
+	if (!of_id)
+		return -EINVAL;
+	return (int)of_id->data;
+}
+#else
+int stmpe_i2c_of_probe(struct i2c_client *i2c)
+{
+	return -EINVAL;
+}
+#endif
+
 static int
 stmpe_i2c_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 {
+	int partnum;
+
 	i2c_ci.data = (void *)id;
 	i2c_ci.irq = i2c->irq;
 	i2c_ci.client = i2c;
 	i2c_ci.dev = &i2c->dev;
 
-	return stmpe_probe(&i2c_ci, id->driver_data);
+	partnum = stmpe_i2c_of_probe(i2c);
+	if (partnum < 0)
+		partnum = id->driver_data;
+
+	return stmpe_probe(&i2c_ci, partnum);
 }
 
 static int stmpe_i2c_remove(struct i2c_client *i2c)
@@ -89,6 +146,7 @@ static struct i2c_driver stmpe_i2c_driver = {
 #ifdef CONFIG_PM
 		.pm = &stmpe_dev_pm_ops,
 #endif
+		.of_match_table = of_match_ptr(stmpe_of_match),
 	},
 	.probe		= stmpe_i2c_probe,
 	.remove		= stmpe_i2c_remove,
-- 
1.9.0

