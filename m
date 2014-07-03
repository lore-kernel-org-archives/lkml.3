Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbaGCNPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:15:47 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35127 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbaGCNPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:15:44 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [RFC PATCH v2 1/5] mfd: qpnp: add support for Qualcomm QPNP PMICs
Date: Thu,  3 Jul 2014 16:13:59 +0300
Message-Id: <1404393243-7324-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com>
References: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <joshc@codeaurora.org>

The Qualcomm QPNP PMIC chips are components used with the
Snapdragon 800 series SoC family.  This driver exists
largely as a glue mfd component, it exists to be an owner
of an SPMI regmap for children devices described in
device tree.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/mfd/Kconfig     |   15 ++++++
 drivers/mfd/Makefile    |    1 +
 drivers/mfd/qpnp-spmi.c |  129 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/qpnp-spmi.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ee8204c..258b733 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -524,6 +524,21 @@ config MFD_PM8921_CORE
 	  Say M here if you want to include support for PM8921 chip as a module.
 	  This will build a module called "pm8921-core".
 
+config MFD_QPNP_SPMI
+	tristate "Qualcomm QPNP SPMI PMIC"
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on OF
+	select MFD_CORE
+	select REGMAP_SPMI
+	help
+	  This enables support for the Qualcomm QPNP SPMI PMICs.
+	  These PMICs are currently used with the Snapdragon 800 series of
+	  SoCs.  Note, that this will only be useful paired with descriptions
+	  of the independent functions as children nodes in the device tree.
+
+	  Say M here if you want to include support for the QPNP SPMI PMIC
+	  series as a module.  The module will be called "qpnp-spmi".
+
 config MFD_RDC321X
 	tristate "RDC R-321x southbridge"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8afedba..31833d7 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -153,6 +153,7 @@ obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
+obj-$(CONFIG_MFD_QPNP_SPMI)	+= qpnp-spmi.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
diff --git a/drivers/mfd/qpnp-spmi.c b/drivers/mfd/qpnp-spmi.c
new file mode 100644
index 0000000..efd7d3e
--- /dev/null
+++ b/drivers/mfd/qpnp-spmi.c
@@ -0,0 +1,129 @@
+/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spmi.h>
+#include <linux/regmap.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+#include <linux/mfd/core.h>
+
+#define QPNP_RESOURCE_SIZE	256
+
+static const struct regmap_config qpnp_regmap_config = {
+	.reg_bits	= 16,
+	.val_bits	= 8,
+	.max_register	= 0xffff,
+};
+
+static int qpnp_index_to_resource(struct device_node *np, int index,
+				  struct resource *res)
+{
+	const char *name = NULL;
+	const __be32 *addrp;
+	u64 addr;
+
+	addrp = of_get_address(np, index, NULL, NULL);
+	if (!addrp)
+		return -EINVAL;
+
+	addr = of_read_number(addrp, 1);
+	if (addr == OF_BAD_ADDR)
+		return -EINVAL;
+
+	of_property_read_string_index(np, "reg-names", index, &name);
+
+	res->start = addr;
+	res->end = addr + QPNP_RESOURCE_SIZE - 1;
+	res->flags = IORESOURCE_REG;
+	res->name = name ? name : np->name;
+
+	return 0;
+}
+
+static int qpnp_add_device(struct spmi_device *root, struct device_node *child)
+{
+	struct mfd_cell cell = {};
+	struct resource *res, *r;
+	int num_resources = 0;
+	const char *compat;
+	int ret, i;
+
+	compat = of_get_property(child, "compatible", NULL);
+	if (!compat)
+		return -ENODEV;
+
+	while (of_get_address(child, num_resources, NULL, NULL))
+		num_resources++;
+
+	if (!num_resources)
+		return -ENODEV;
+
+	res = kcalloc(num_resources, sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	r = res;
+	for (i = 0; i < num_resources; i++, r++)
+		qpnp_index_to_resource(child, i, r);
+
+	cell.name = kasprintf(GFP_KERNEL, "%x.%04x.%s", root->usid,
+			      (u16)res[0].start, child->name);
+	cell.of_compatible = compat;
+	cell.num_resources = num_resources;
+	cell.resources = res;
+
+	ret = mfd_add_devices(&root->dev, PLATFORM_DEVID_NONE, &cell, 1,
+			      NULL, 0, NULL);
+
+	kfree(res);
+	kfree(cell.name);
+
+	return ret;
+}
+
+static int qpnp_probe(struct spmi_device *sdev)
+{
+	struct device_node *root = sdev->dev.of_node;
+	struct device_node *child;
+	struct regmap *regmap;
+
+	regmap = devm_regmap_init_spmi_ext(sdev, &qpnp_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	for_each_available_child_of_node(root, child)
+		qpnp_add_device(sdev, child);
+
+	return 0;
+}
+
+static void qpnp_remove(struct spmi_device *sdev)
+{
+	mfd_remove_devices(&sdev->dev);
+}
+
+static const struct of_device_id qpnp_id_table[] = {
+	{ .compatible = "qcom,qpnp-spmi", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, qpnp_id_table);
+
+static struct spmi_driver qpnp_driver = {
+	.probe = qpnp_probe,
+	.remove = qpnp_remove,
+	.driver = {
+		.name = "qpnp-spmi",
+		.of_match_table = qpnp_id_table,
+	},
+};
+module_spmi_driver(qpnp_driver);
-- 
1.7.0.4

