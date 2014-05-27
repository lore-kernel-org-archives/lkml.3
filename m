Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaE0EHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:07:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:31198 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbaE0EG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,916,1392192000"; 
   d="scan'208";a="545297430"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH v3 2/4] mfd: intel_soc_pmic: I2C interface
Date: Tue, 27 May 2014 12:06:14 +0800
Message-Id: <1401163576-14872-3-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel SoC PMIC devices are connected to the CPU via the I2C interface. This patch provides support of the related I2C operations.

v2:
- Use regmap instead of creating our own I2C read/write callbacks.
v3:
- Use gpiod interface instead of gpio numbers.
- Remove redundant I2C IDs.
- Use managed allocations.

Signed-off-by: Yang, Bin <bin.yang@intel.com>
Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
---
 drivers/mfd/intel_soc_pmic_i2c.c | 150 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)
 create mode 100644 drivers/mfd/intel_soc_pmic_i2c.c

diff --git a/drivers/mfd/intel_soc_pmic_i2c.c b/drivers/mfd/intel_soc_pmic_i2c.c
new file mode 100644
index 0000000..3b107d7
--- /dev/null
+++ b/drivers/mfd/intel_soc_pmic_i2c.c
@@ -0,0 +1,150 @@
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
+static struct intel_soc_pmic *pmic_i2c;
+
+static void pmic_shutdown(struct i2c_client *client)
+{
+	disable_irq(pmic_i2c->irq);
+	return;
+}
+
+static int pmic_suspend(struct device *dev)
+{
+	disable_irq(pmic_i2c->irq);
+	return 0;
+}
+
+static int pmic_resume(struct device *dev)
+{
+	enable_irq(pmic_i2c->irq);
+	return 0;
+}
+
+static const struct dev_pm_ops pmic_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pmic_suspend, pmic_resume)
+};
+
+static int pmic_i2c_probe(struct i2c_client *i2c,
+			  const struct i2c_device_id *id)
+{
+	struct gpio_desc *desc;
+	struct device *dev = &i2c->dev;
+	int irq = i2c->irq;
+
+	if (pmic_i2c != NULL) {
+		dev_err(dev, "PMIC already exists.\n");
+		return -EBUSY;
+	}
+
+	desc = devm_gpiod_get_index(dev, KBUILD_MODNAME, 0);
+	if (IS_ERR(desc)) {
+		dev_dbg(dev, "Not using GPIO as interrupt.\n");
+	} else {
+		irq = gpiod_to_irq(desc);
+		if (irq < 0) {
+			dev_warn(dev, "Can't get irq: %d\n", irq);
+			irq = i2c->irq;
+		}
+	}
+
+	pmic_i2c = devm_kzalloc(dev, sizeof(*pmic_i2c), GFP_KERNEL);
+	pmic_i2c->config = (struct intel_soc_pmic_config *)id->driver_data;
+	pmic_i2c->dev = dev;
+	pmic_i2c->regmap = devm_regmap_init_i2c(i2c,
+						pmic_i2c->config->regmap_cfg);
+	pmic_i2c->irq = irq;
+
+	return intel_pmic_add(pmic_i2c);
+}
+
+static int pmic_i2c_remove(struct i2c_client *i2c)
+{
+	int ret;
+	
+	if (pmic_i2c == NULL)
+		return -ENODEV;
+
+	ret = intel_pmic_remove(pmic_i2c);
+
+	pmic_i2c = NULL;
+
+	return ret;
+}
+
+static const struct i2c_device_id pmic_i2c_id[] = {
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
+module_init(pmic_i2c_init);
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

