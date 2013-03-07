Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3CGAb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:31:28 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5316 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab3CGA3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:29:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27740512"
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/6] SSBI: Convert SSBI to device tree
Date: Wed,  6 Mar 2013 16:29:43 -0800
Message-Id: <1362616187-21089-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SSBI bus is exclusive to the Qualcomm MSM targets, and all SoCs
using it will be using device tree.  Convert this driver to indentify
with device tree.

This makes the bus probing a good bit simpler, since the attaching of
child nodes can be represented directly in the devicetree, rather than
having to be inferred by name.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/msm/ssbi.txt | 18 +++++
 arch/arm/boot/dts/msm8660-surf.dts                 |  6 ++
 arch/arm/boot/dts/msm8960-cdp.dts                  |  6 ++
 drivers/ssbi/ssbi.c                                | 81 +++++++++-------------
 4 files changed, 62 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/ssbi.txt

diff --git a/Documentation/devicetree/bindings/arm/msm/ssbi.txt b/Documentation/devicetree/bindings/arm/msm/ssbi.txt
new file mode 100644
index 0000000..54fd5ce
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/msm/ssbi.txt
@@ -0,0 +1,18 @@
+* Qualcomm SSBI
+
+Some Qualcomm MSM devices contain a point-to-point serial bus used to
+communicate with a limited range of devices (mostly power management
+chips).
+
+These require the following properties:
+
+- compatible: "qcom,ssbi"
+
+- qcom,controller-type
+  indicates the SSBI bus variant the controller should use to talk
+  with the slave device.  This should be one of "ssbi", "ssbi2", or
+  "pmic-arbiter".  The type chosen is determined by the attached
+  slave.
+
+The slave device should be the single child node of the ssbi device
+with a compatible field.
diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index 31f2157..67f8670 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -38,4 +38,10 @@
 		      <0x19c00000 0x1000>;
 		interrupts = <0 195 0x0>;
 	};
+
+	qcom,ssbi@500000 {
+		compatible = "qcom,ssbi";
+		reg = <0x500000 0x1000>;
+		qcom,controller-type = "pmic-arbiter";
+	};
 };
diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index 9e621b5..c9b09a8 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -38,4 +38,10 @@
 		      <0x16400000 0x1000>;
 		interrupts = <0 154 0x0>;
 	};
+
+	qcom,ssbi@500000 {
+		compatible = "qcom,ssbi";
+		reg = <0x500000 0x1000>;
+		qcom,controller-type = "pmic-arbiter";
+	};
 };
diff --git a/drivers/ssbi/ssbi.c b/drivers/ssbi/ssbi.c
index 8b0b10d..86d8416 100644
--- a/drivers/ssbi/ssbi.c
+++ b/drivers/ssbi/ssbi.c
@@ -26,6 +26,8 @@
 #include <linux/slab.h>
 #include <linux/msm_ssbi.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 /* SSBI 2.0 controller registers */
 #define SSBI2_CMD			0x0008
@@ -261,56 +263,13 @@ int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
 }
 EXPORT_SYMBOL(msm_ssbi_write);
 
-static int msm_ssbi_add_slave(struct msm_ssbi *ssbi,
-				const struct msm_ssbi_slave_info *slave)
-{
-	struct platform_device *slave_pdev;
-	int ret;
-
-	if (ssbi->slave) {
-		pr_err("slave already attached??\n");
-		return -EBUSY;
-	}
-
-	slave_pdev = platform_device_alloc(slave->name, -1);
-	if (!slave_pdev) {
-		pr_err("cannot allocate pdev for slave '%s'", slave->name);
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	slave_pdev->dev.parent = ssbi->dev;
-	slave_pdev->dev.platform_data = slave->platform_data;
-
-	ret = platform_device_add(slave_pdev);
-	if (ret) {
-		pr_err("cannot add slave platform device for '%s'\n",
-				slave->name);
-		goto err;
-	}
-
-	ssbi->slave = &slave_pdev->dev;
-	return 0;
-
-err:
-	if (slave_pdev)
-		platform_device_put(slave_pdev);
-	return ret;
-}
-
 static int msm_ssbi_probe(struct platform_device *pdev)
 {
-	const struct msm_ssbi_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	struct resource *mem_res;
 	struct msm_ssbi *ssbi;
 	int ret = 0;
-
-	if (!pdata) {
-		pr_err("missing platform data\n");
-		return -EINVAL;
-	}
-
-	pr_debug("%s\n", pdata->slave.name);
+	const char *type;
 
 	ssbi = kzalloc(sizeof(struct msm_ssbi), GFP_KERNEL);
 	if (!ssbi) {
@@ -334,7 +293,25 @@ static int msm_ssbi_probe(struct platform_device *pdev)
 	ssbi->dev = &pdev->dev;
 	platform_set_drvdata(pdev, ssbi);
 
-	ssbi->controller_type = pdata->controller_type;
+	type = of_get_property(np, "qcom,controller-type", NULL);
+	if (type == NULL) {
+		pr_err("Missing qcom,controller-type property\n");
+		ret = -EINVAL;
+		goto err_ssbi_controller;
+	}
+	dev_info(&pdev->dev, "SSBI controller type: '%s'\n", type);
+	if (strcmp(type, "ssbi") == 0)
+		ssbi->controller_type = MSM_SBI_CTRL_SSBI;
+	else if (strcmp(type, "ssbi2") == 0)
+		ssbi->controller_type = MSM_SBI_CTRL_SSBI2;
+	else if (strcmp(type, "pmic-arbiter") == 0)
+		ssbi->controller_type = MSM_SBI_CTRL_PMIC_ARBITER;
+	else {
+		pr_err("Unknown qcom,controller-type\n");
+		ret = -EINVAL;
+		goto err_ssbi_controller;
+	}
+
 	if (ssbi->controller_type == MSM_SBI_CTRL_PMIC_ARBITER) {
 		ssbi->read = msm_ssbi_pa_read_bytes;
 		ssbi->write = msm_ssbi_pa_write_bytes;
@@ -345,13 +322,13 @@ static int msm_ssbi_probe(struct platform_device *pdev)
 
 	spin_lock_init(&ssbi->lock);
 
-	ret = msm_ssbi_add_slave(ssbi, &pdata->slave);
+	ret = of_platform_populate(np, NULL, NULL, &pdev->dev);
 	if (ret)
-		goto err_ssbi_add_slave;
+		goto err_ssbi_controller;
 
 	return 0;
 
-err_ssbi_add_slave:
+err_ssbi_controller:
 	platform_set_drvdata(pdev, NULL);
 	iounmap(ssbi->base);
 err_ioremap:
@@ -370,12 +347,18 @@ static int msm_ssbi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct of_device_id ssbi_match_table[] = {
+	{ .compatible = "qcom,ssbi" },
+	{}
+};
+
 static struct platform_driver msm_ssbi_driver = {
 	.probe		= msm_ssbi_probe,
 	.remove		= __exit_p(msm_ssbi_remove),
 	.driver		= {
 		.name	= "msm_ssbi",
 		.owner	= THIS_MODULE,
+		.of_match_table = ssbi_match_table,
 	},
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

