Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaI3AfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:35:25 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11008 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755266AbaI3AfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:35:18 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC 7/7] regulator: qcom-smd-rpm: Regulator driver for the Qualcomm RPM
Date: Mon, 29 Sep 2014 17:34:51 -0700
Message-ID: <1412037291-16880-8-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for regulators exposed by the Resource Power Manager (RPM) found
in Qualcomm 8974 based devices.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

According to the datasheet for the PMIC the regulators are indeed programmed in
steps, but the steps seems to vary between different regulators and the details
are hidden by the RPM that exposes contiguous voltage ranges.

Either we run with this, add a few more compatibles to encode the steps or have
the step coming from devicetree. I prefer the current implementation as that is
the cleanest of these.

 drivers/regulator/Kconfig              |   12 ++
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/qcom_smd-regulator.c |  229 ++++++++++++++++++++++++++++++++
 3 files changed, 242 insertions(+)
 create mode 100644 drivers/regulator/qcom_smd-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 0e59754..ad01acf 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -461,6 +461,18 @@ config REGULATOR_QCOM_RPM
 	  Qualcomm RPM as a module. The module will be named
 	  "qcom_rpm-regulator".
 
+config REGULATOR_QCOM_SMD_RPM
+	tristate "Qualcomm SMD based RPM regulator driver"
+	depends on MFD_QCOM_SMD_RPM
+	help
+	  If you say yes to this option, support will be included for the
+	  regulators exposed by the Resource Power Manager found in Qualcomm
+	  8974 based devices.
+
+	  Say M here if you want to include support for the regulators on the
+	  Qualcomm RPM as a module. The module will be named
+	  "qcom_smd-regulator".
+
 config REGULATOR_RC5T583
 	tristate "RICOH RC5T583 Power regulators"
 	depends on MFD_RC5T583
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 9c50dc6..b022270 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
 obj-$(CONFIG_REGULATOR_QCOM_RPM) += qcom_rpm-regulator.o
+obj-$(CONFIG_REGULATOR_QCOM_SMD_RPM) += qcom_smd-regulator.o
 obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
 obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
 obj-$(CONFIG_REGULATOR_TPS51632) += tps51632-regulator.o
diff --git a/drivers/regulator/qcom_smd-regulator.c b/drivers/regulator/qcom_smd-regulator.c
new file mode 100644
index 0000000..510cb44
--- /dev/null
+++ b/drivers/regulator/qcom_smd-regulator.c
@@ -0,0 +1,229 @@
+/*
+ * Copyright (c) 2014, Sony Mobile Communications AB.
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
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
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/mfd/qcom-smd-rpm.h>
+#include <dt-bindings/mfd/qcom-rpm.h>
+
+struct qcom_rpm_reg {
+	struct qcom_smd_rpm *rpm;
+	unsigned resource;
+
+	struct regulator_desc desc;
+
+	int is_enabled;
+	int uV;
+};
+
+struct rpm_regulator_req {
+	u32 key;
+	u32 nbytes;
+	u32 value;
+};
+
+#define RPM_KEY_SWEN	0x6e657773 /* "swen" */
+#define RPM_KEY_UV	0x00007675 /* "uv" */
+#define RPM_KEY_MV	0x0000616d /* "ma" */
+
+static int rpm_reg_enable(struct regulator_dev *rdev)
+{
+	struct qcom_rpm_reg *vreg = rdev_get_drvdata(rdev);
+	struct rpm_regulator_req req;
+	int ret;
+
+	req.key = RPM_KEY_SWEN;
+	req.nbytes = sizeof(u32);
+	req.value = 1;
+
+	ret = qcom_rpm_smd_write(vreg->rpm, vreg->resource, &req, sizeof(req));
+	if (!ret)
+		vreg->is_enabled = 1;
+
+	return ret;
+}
+
+static int rpm_reg_is_enabled(struct regulator_dev *rdev)
+{
+	struct qcom_rpm_reg *vreg = rdev_get_drvdata(rdev);
+
+	return vreg->is_enabled;
+}
+
+static int rpm_reg_disable(struct regulator_dev *rdev)
+{
+	struct qcom_rpm_reg *vreg = rdev_get_drvdata(rdev);
+	struct rpm_regulator_req req;
+	int ret;
+
+	req.key = RPM_KEY_SWEN;
+	req.nbytes = sizeof(u32);
+	req.value = 0;
+
+	ret = qcom_rpm_smd_write(vreg->rpm, vreg->resource, &req, sizeof(req));
+	if (!ret)
+		vreg->is_enabled = 0;
+
+	return ret;
+}
+
+static int rpm_reg_get_voltage(struct regulator_dev *rdev)
+{
+	struct qcom_rpm_reg *vreg = rdev_get_drvdata(rdev);
+
+	return vreg->uV;
+}
+
+static int rpm_reg_set_voltage(struct regulator_dev *rdev,
+			       int min_uV,
+			       int max_uV,
+			       unsigned *selector)
+{
+	struct qcom_rpm_reg *vreg = rdev_get_drvdata(rdev);
+	struct rpm_regulator_req req;
+	int ret = 0;
+
+	req.key = RPM_KEY_UV;
+	req.nbytes = sizeof(u32);
+	req.value = min_uV;
+
+	ret = qcom_rpm_smd_write(vreg->rpm, vreg->resource, &req, sizeof(req));
+	if (!ret)
+		vreg->uV = min_uV;
+
+	return ret;
+}
+
+static struct regulator_ops rpm_smps_ops = {
+	.enable = rpm_reg_enable,
+	.disable = rpm_reg_disable,
+	.is_enabled = rpm_reg_is_enabled,
+
+	.get_voltage = rpm_reg_get_voltage,
+	.set_voltage = rpm_reg_set_voltage,
+};
+
+static struct regulator_ops rpm_ldo_ops = {
+	.enable = rpm_reg_enable,
+	.disable = rpm_reg_disable,
+	.is_enabled = rpm_reg_is_enabled,
+
+	.get_voltage = rpm_reg_get_voltage,
+	.set_voltage = rpm_reg_set_voltage,
+};
+
+static struct regulator_ops rpm_switch_ops = {
+	.enable = rpm_reg_enable,
+	.disable = rpm_reg_disable,
+	.is_enabled = rpm_reg_is_enabled,
+};
+
+static const struct of_device_id rpm_of_match[] = {
+	{ .compatible = "qcom,rpm-pm8841-smps", .data = &rpm_smps_ops },
+	{ .compatible = "qcom,rpm-pm8941-smps", .data = &rpm_smps_ops },
+	{ .compatible = "qcom,rpm-pm8941-ldo", .data = &rpm_ldo_ops},
+	{ .compatible = "qcom,rpm-pm8941-switch", .data = &rpm_switch_ops },
+	{}
+};
+MODULE_DEVICE_TABLE(of, rpm_of_match);
+
+static int rpm_reg_probe(struct platform_device *pdev)
+{
+	struct regulator_init_data *initdata;
+	const struct of_device_id *match;
+	struct regulator_config config = { };
+	struct regulator_dev *rdev;
+	struct qcom_rpm_reg *vreg;
+	const char *key;
+	u32 val;
+	int ret;
+
+	match = of_match_device(rpm_of_match, &pdev->dev);
+
+	initdata = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
+	if (!initdata)
+		return -EINVAL;
+
+	vreg = devm_kzalloc(&pdev->dev, sizeof(*vreg), GFP_KERNEL);
+	if (!vreg)
+		return -ENOMEM;
+
+	vreg->desc.continuous_voltage_range = true;
+	vreg->desc.id = -1;
+	vreg->desc.name = pdev->dev.of_node->name;
+	vreg->desc.ops = (struct regulator_ops *)match->data;
+	vreg->desc.owner = THIS_MODULE;
+	vreg->desc.type = REGULATOR_VOLTAGE;
+
+	vreg->rpm = dev_get_drvdata(pdev->dev.parent);
+	if (!vreg->rpm) {
+		dev_err(&pdev->dev, "unable to get rpm handle\n");
+		return -ENXIO;
+	}
+
+	key = "reg";
+	ret = of_property_read_u32(pdev->dev.of_node, key, &val);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to read %s\n", key);
+		return ret;
+	}
+	vreg->resource = val;
+
+	if (vreg->desc.ops->set_voltage &&
+	    (!initdata->constraints.min_uV || !initdata->constraints.max_uV)) {
+		dev_err(&pdev->dev, "no voltage specified for regulator\n");
+		return -EINVAL;
+	}
+
+	config.dev = &pdev->dev;
+	config.init_data = initdata;
+	config.driver_data = vreg;
+	config.of_node = pdev->dev.of_node;
+	rdev = devm_regulator_register(&pdev->dev, &vreg->desc, &config);
+	if (IS_ERR(rdev)) {
+		dev_err(&pdev->dev, "can't register regulator\n");
+		return PTR_ERR(rdev);
+	}
+
+	return 0;
+}
+
+static struct platform_driver rpm_reg_driver = {
+	.probe = rpm_reg_probe,
+	.driver = {
+		.name  = "qcom_rpm_smd_regulator",
+		.owner = THIS_MODULE,
+		.of_match_table = rpm_of_match,
+	},
+};
+
+static int __init rpm_reg_init(void)
+{
+	return platform_driver_register(&rpm_reg_driver);
+}
+subsys_initcall(rpm_reg_init);
+
+static void __exit rpm_reg_exit(void)
+{
+	platform_driver_unregister(&rpm_reg_driver);
+}
+module_exit(rpm_reg_exit)
+
+MODULE_DESCRIPTION("Qualcomm RPM regulator driver");
+MODULE_LICENSE("GPLv2");
-- 
1.7.9.5

