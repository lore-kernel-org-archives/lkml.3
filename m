Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbaGXMq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:46:26 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54504 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbaGXMqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:46:23 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 1/4] mfd: pm8xxx-spmi: add support for Qualcomm SPMI PMICs
Date: Thu, 24 Jul 2014 15:45:18 +0300
Message-Id: <1406205921-7452-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com>
References: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <joshc@codeaurora.org>

The Qualcomm SPMI PMIC chips are components used with the
Snapdragon 800 series SoC family.  This driver exists
largely as a glue mfd component, it exists to be an owner
of an SPMI regmap for children devices described in
device tree.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig       |   16 +++++++++++
 drivers/mfd/Makefile      |    1 +
 drivers/mfd/pm8xxx-spmi.c |   65 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/pm8xxx-spmi.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6cc4b6a..122e2d9 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -524,6 +524,22 @@ config MFD_PM8921_CORE
 	  Say M here if you want to include support for PM8921 chip as a module.
 	  This will build a module called "pm8921-core".
 
+config MFD_PM8XXX_SPMI
+	tristate "Qualcomm PM8XXX SPMI PMICs"
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on OF
+	depends on SPMI
+	select MFD_PM8XXX
+	select REGMAP_SPMI
+	help
+	  This enables support for the Qualcomm PM8XXX SPMI PMICs.
+	  These PMICs are currently used with the Snapdragon 800 series of
+	  SoCs.  Note, that this will only be useful paired with descriptions
+	  of the independent functions as children nodes in the device tree.
+
+	  Say M here if you want to include support for the PM8XXX SPMI PMIC
+	  series as a module.  The module will be called "pm8xxx-spmi".
+
 config MFD_RDC321X
 	tristate "RDC R-321x southbridge"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8afedba..93d82cc 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -153,6 +153,7 @@ obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
+obj-$(CONFIG_MFD_PM8XXX_SPMI)	+= pm8xxx-spmi.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
diff --git a/drivers/mfd/pm8xxx-spmi.c b/drivers/mfd/pm8xxx-spmi.c
new file mode 100644
index 0000000..16335a1
--- /dev/null
+++ b/drivers/mfd/pm8xxx-spmi.c
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
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
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spmi.h>
+#include <linux/regmap.h>
+#include <linux/of_platform.h>
+
+static const struct regmap_config pm8xxx_regmap_config = {
+	.reg_bits	= 16,
+	.val_bits	= 8,
+	.max_register	= 0xffff,
+};
+
+static int pm8xxx_probe(struct spmi_device *sdev)
+{
+	struct device_node *root = sdev->dev.of_node;
+	struct regmap *regmap;
+
+	regmap = devm_regmap_init_spmi_ext(sdev, &pm8xxx_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	return of_platform_populate(root, NULL, NULL, &sdev->dev);
+}
+
+static void pm8xxx_remove(struct spmi_device *sdev)
+{
+	of_platform_depopulate(&sdev->dev);
+}
+
+static const struct of_device_id pm8xxx_id_table[] = {
+	{ .compatible = "qcom,pm8941" },
+	{ .compatible = "qcom,pm8841" },
+	{ .compatible = "qcom,pma8084" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pm8xxx_id_table);
+
+static struct spmi_driver pm8xxx_driver = {
+	.probe = pm8xxx_probe,
+	.remove = pm8xxx_remove,
+	.driver = {
+		.name = "pm8xxx-spmi",
+		.of_match_table = pm8xxx_id_table,
+	},
+};
+module_spmi_driver(pm8xxx_driver);
+
+MODULE_DESCRIPTION("PM8XXX SPMI PMIC driver");
+MODULE_ALIAS("spmi:pm8xxx-spmi");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Josh Cartwright <joshc@codeaurora.org>");
+MODULE_AUTHOR("Stanimir Varbanov <svarbanov@mm-sol.com>");
-- 
1.7.0.4

