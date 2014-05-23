Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaEWAk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:40:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:40100 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaEWAky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:40:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,890,1392192000"; 
   d="scan'208";a="435816214"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH RESEND v2 2/4] mfd: intel_soc_pmic: I2C interface
Date: Fri, 23 May 2014 08:40:27 +0800
Message-Id: <1400805629-10322-3-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel SoC PMIC devices are connected to the CPU via the I2C
interface. This patch provides support of the related I2C operations.

v2:
- Use regmap instead of creating our own I2C read/write callbacks.

Signed-off-by: Yang, Bin <bin.yang@intel.com>
Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
---
 drivers/mfd/intel_soc_pmic_i2c.c | 148 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)
 create mode 100644 drivers/mfd/intel_soc_pmic_i2c.c

diff --git a/drivers/mfd/intel_soc_pmic_i2c.c b/drivers/mfd/intel_soc_pmic_i2c.c
new file mode 100644
index 0000000..b6b8ee1
--- /dev/null
+++ b/drivers/mfd/intel_soc_pmic_i2c.c
@@ -0,0 +1,148 @@
+/*
+ * intel_soc_pmic_i2c.c - Intel SoC PMIC MFD Driver
+ *
+ * Copyright (C) 2013, 2014 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Author: Yang, Bin <bin.yang@intel.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/acpi.h>
+#include <linux/version.h>
+#include <linux/gpio/consumer.h>
+#include <linux/regmap.h>
+#include <linux/mfd/intel_soc_pmic.h>
+#include "intel_soc_pmic_core.h"
+
+static struct i2c_client *pmic_i2c_client;
+static struct intel_soc_pmic *pmic_i2c;
+
+static void pmic_shutdown(struct i2c_client *client)
+{
+	disable_irq(pmic_i2c_client->irq);
+	return;
+}
+
+static int pmic_suspend(struct device *dev)
+{
+	disable_irq(pmic_i2c_client->irq);
+	return 0;
+}
+
+static int pmic_resume(struct device *dev)
+{
+	enable_irq(pmic_i2c_client->irq);
+	return 0;
+}
+
+static const struct dev_pm_ops pmic_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pmic_suspend, pmic_resume)
+};
+
+static int pmic_i2c_lookup_gpio(struct device *dev, int acpi_index)
+{
+	struct gpio_desc *desc;
+	int gpio;
+
+	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index);
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+
+	gpio = desc_to_gpio(desc);
+
+	gpiod_put(desc);
+
+	return gpio;
+}
+
+static int pmic_i2c_probe(struct i2c_client *i2c,
+			  const struct i2c_device_id *id)
+{
+	if (pmic_i2c_client != NULL || pmic_i2c != NULL)
+		return -EBUSY;
+
+	pmic_i2c	= (struct intel_soc_pmic *)id->driver_data;
+	pmic_i2c_client	= i2c;
+	pmic_i2c->dev	= &i2c->dev;
+	pmic_i2c->irq	= i2c->irq;
+	pmic_i2c->pmic_int_gpio = pmic_i2c_lookup_gpio(pmic_i2c->dev, 0);
+	pmic_i2c->regmap = devm_regmap_init_i2c(i2c, pmic_i2c->regmap_cfg);
+
+	return intel_pmic_add(pmic_i2c);
+}
+
+static int pmic_i2c_remove(struct i2c_client *i2c)
+{
+	int ret = intel_pmic_remove(pmic_i2c);
+
+	pmic_i2c_client = NULL;
+	pmic_i2c = NULL;
+
+	return ret;
+}
+
+static const struct i2c_device_id pmic_i2c_id[] = {
+	{ "crystal_cove", (kernel_ulong_t)&crystal_cove_pmic},
+	{ "INT33FD", (kernel_ulong_t)&crystal_cove_pmic},
+	{ "INT33FD:00", (kernel_ulong_t)&crystal_cove_pmic},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pmic_i2c_id);
+
+static struct acpi_device_id pmic_acpi_match[] = {
+	{ "INT33FD", (kernel_ulong_t)&crystal_cove_pmic},
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, pmic_acpi_match);
+
+static struct i2c_driver pmic_i2c_driver = {
+	.driver = {
+		.name = "intel_soc_pmic_i2c",
+		.owner = THIS_MODULE,
+		.pm = &pmic_pm_ops,
+		.acpi_match_table = ACPI_PTR(pmic_acpi_match),
+	},
+	.probe = pmic_i2c_probe,
+	.remove = pmic_i2c_remove,
+	.id_table = pmic_i2c_id,
+	.shutdown = pmic_shutdown,
+};
+
+static int __init pmic_i2c_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&pmic_i2c_driver);
+	if (ret != 0)
+		pr_err("Failed to register pmic I2C driver: %d\n", ret);
+
+	return ret;
+}
+subsys_initcall(pmic_i2c_init);
+
+static void __exit pmic_i2c_exit(void)
+{
+	i2c_del_driver(&pmic_i2c_driver);
+}
+module_exit(pmic_i2c_exit);
+
+MODULE_DESCRIPTION("I2C driver for Intel SoC PMIC");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
-- 
1.8.3.2

