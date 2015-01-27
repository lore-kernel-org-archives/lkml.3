Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbbA0WLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:11:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38493 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760097AbbA0WKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:10:49 -0500
From: Andy Gross <agross@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-soc@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH 1/6] soc: qcom: gsbi: Add support for ADM CRCI muxing
Date: Tue, 27 Jan 2015 16:10:39 -0600
Message-Id: <1422396644-21714-2-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds automatic configuration for the ADM CRCI muxing required to
support DMA operations for GSBI clients.  The GSBI mode and instance determine
the correct TCSR ADM CRCI MUX value that must be programmed so that the DMA
works properly.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/soc/qcom/qcom,gsbi.txt     |   17 ++-
 drivers/soc/qcom/Kconfig                           |    1 +
 drivers/soc/qcom/qcom_gsbi.c                       |  148 +++++++++++++++++++-
 3 files changed, 158 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt
index 4ce24d4..39eea8a 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt
@@ -6,12 +6,18 @@ configuration settings.  The mode setting will govern the input/output mode of
 the 4 GSBI IOs.
 
 Required properties:
-- compatible: must contain "qcom,gsbi-v1.0.0" for APQ8064/IPQ8064
+- compatible:	Should contain:
+		"qcom,gsbi-ipq8064" for IPQ8064
+		"qcom,gsbi-apq8064" for APQ8064
+		"qcom,gsbi-msm8960" for MSM8960
+		"qcom,gsbi-msm8660" for MSM8660
 - reg: Address range for GSBI registers
 - clocks: required clock
 - clock-names: must contain "iface" entry
 - qcom,mode : indicates MUX value for configuration of the serial interface.
   Please reference dt-bindings/soc/qcom,gsbi.h for valid mux values.
+- qcom,gsbi-num: indicates GSBI instance number
+- syscon-tcsr: indicates phandle of TCSR syscon node
 
 Optional properties:
 - qcom,crci : indicates CRCI MUX value for QUP CRCI ports.  Please reference
@@ -48,6 +54,9 @@ Example for APQ8064:
 		qcom,mode = <GSBI_PROT_I2C_UART>;
 		qcom,crci = <GSBI_CRCI_QUP>;
 
+		qcom,gsbi-num = <4>;
+		syscon-tcsr = <&tcsr>;
+
 		/* child nodes go under here */
 
 		i2c_qup4: i2c@16380000 {
@@ -76,3 +85,9 @@ Example for APQ8064:
 		};
 	};
 
+	tcsr: syscon@1a400000 {
+		compatible = "qcom,apq8064-tcsr", "syscon";
+		reg = <0x1a400000 0x100>;
+	};
+
+
diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 7bd2c94..32f20be 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -4,6 +4,7 @@
 config QCOM_GSBI
         tristate "QCOM General Serial Bus Interface"
         depends on ARCH_QCOM
+	select MFD_SYSCON
         help
           Say y here to enable GSBI support.  The GSBI provides control
           functions for connecting the underlying serial UART, SPI, and I2C
diff --git a/drivers/soc/qcom/qcom_gsbi.c b/drivers/soc/qcom/qcom_gsbi.c
index 729425d..c7a22b5 100644
--- a/drivers/soc/qcom/qcom_gsbi.c
+++ b/drivers/soc/qcom/qcom_gsbi.c
@@ -18,22 +18,129 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#include <dt-bindings/soc/qcom,gsbi.h>
 
 #define GSBI_CTRL_REG		0x0000
 #define GSBI_PROTOCOL_SHIFT	4
+#define MAX_GSBI		12
+
+#define TCSR_ADM_CRCI_BASE	0x70
+
+struct crci_config {
+	u32 num_rows;
+	const u32 *array;
+};
+
+static const u32 crci_ipq8064[][MAX_GSBI] = {
+	{
+		0x000003, 0x00000c, 0x000030, 0x0000c0,
+		0x000300, 0x000c00, 0x003000, 0x00c000,
+		0x030000, 0x0c0000, 0x300000, 0xc00000
+	},
+	{
+		0x000003, 0x00000c, 0x000030, 0x0000c0,
+		0x000300, 0x000c00, 0x003000, 0x00c000,
+		0x030000, 0x0c0000, 0x300000, 0xc00000
+	},
+};
+
+static const struct crci_config config_ipq8064 = {
+	.num_rows = ARRAY_SIZE(crci_ipq8064),
+	.array = crci_ipq8064[0],
+};
+
+static const unsigned int crci_apq8064[][MAX_GSBI] = {
+	{
+		0x001800, 0x006000, 0x000030, 0x0000c0,
+		0x000300, 0x000400, 0x000000, 0x000000,
+		0x000000, 0x000000, 0x000000, 0x000000
+	},
+	{
+		0x000000, 0x000000, 0x000000, 0x000000,
+		0x000000, 0x000020, 0x0000c0, 0x000000,
+		0x000000, 0x000000, 0x000000, 0x000000
+	},
+};
+
+static const struct crci_config config_apq8064 = {
+	.num_rows = ARRAY_SIZE(crci_apq8064),
+	.array = crci_apq8064[0],
+};
+
+static const unsigned int crci_msm8960[][MAX_GSBI] = {
+	{
+		0x000003, 0x00000c, 0x000030, 0x0000c0,
+		0x000300, 0x000400, 0x000000, 0x000000,
+		0x000000, 0x000000, 0x000000, 0x000000
+	},
+	{
+		0x000000, 0x000000, 0x000000, 0x000000,
+		0x000000, 0x000020, 0x0000c0, 0x000300,
+		0x001800, 0x006000, 0x000000, 0x000000
+	},
+};
+
+static const struct crci_config config_msm8960 = {
+	.num_rows = ARRAY_SIZE(crci_msm8960),
+	.array = crci_msm8960[0],
+};
+
+static const unsigned int crci_msm8660[][MAX_GSBI] = {
+	{	/* ADM 0 - B */
+		0x000003, 0x00000c, 0x000030, 0x0000c0,
+		0x000300, 0x000c00, 0x003000, 0x00c000,
+		0x030000, 0x0c0000, 0x300000, 0xc00000
+	},
+	{	/* ADM 0 - B */
+		0x000003, 0x00000c, 0x000030, 0x0000c0,
+		0x000300, 0x000c00, 0x003000, 0x00c000,
+		0x030000, 0x0c0000, 0x300000, 0xc00000
+	},
+	{	/* ADM 1 - A */
+		0x000003, 0x00000c, 0x000030, 0x0000c0,
+		0x000300, 0x000c00, 0x003000, 0x00c000,
+		0x030000, 0x0c0000, 0x300000, 0xc00000
+	},
+	{	/* ADM 1 - B */
+		0x000003, 0x00000c, 0x000030, 0x0000c0,
+		0x000300, 0x000c00, 0x003000, 0x00c000,
+		0x030000, 0x0c0000, 0x300000, 0xc00000
+	},
+};
+
+static const struct crci_config config_msm8660 = {
+	.num_rows = ARRAY_SIZE(crci_msm8660),
+	.array = crci_msm8660[0],
+};
 
 struct gsbi_info {
 	struct clk *hclk;
 	u32 mode;
 	u32 crci;
+	struct regmap *tcsr;
+};
+
+static const struct of_device_id gsbi_dt_match[] = {
+	{ .compatible = "qcom,gsbi-v1.0.0", .data = NULL},
+	{ .compatible = "qcom,gsbi-ipq8064", .data = &config_ipq8064},
+	{ .compatible = "qcom,gsbi-apq8064", .data = &config_apq8064},
+	{ .compatible = "qcom,gsbi-msm8960", .data = &config_msm8960},
+	{ .compatible = "qcom,gsbi-msm8660", .data = &config_msm8660},
+	{ },
 };
+MODULE_DEVICE_TABLE(of, gsbi_dt_match);
 
 static int gsbi_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
+	const struct of_device_id *match;
 	struct resource *res;
 	void __iomem *base;
 	struct gsbi_info *gsbi;
+	u32 gsbi_num, i, val;
+	struct crci_config *config;
 
 	gsbi = devm_kzalloc(&pdev->dev, sizeof(*gsbi), GFP_KERNEL);
 
@@ -45,6 +152,20 @@ static int gsbi_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
+	gsbi->tcsr = syscon_regmap_lookup_by_phandle(node, "syscon-tcsr");
+	if (IS_ERR(gsbi->tcsr))
+		return -EINVAL;
+
+	if (of_property_read_u32(node, "qcom,gsbi-num", &gsbi_num)) {
+		dev_err(&pdev->dev, "missing gsbi instance number\n");
+		return -EINVAL;
+	}
+
+	if (!gsbi_num || gsbi_num > MAX_GSBI) {
+		dev_err(&pdev->dev, "invalid gsbi number\n");
+		return -EINVAL;
+	}
+
 	if (of_property_read_u32(node, "qcom,mode", &gsbi->mode)) {
 		dev_err(&pdev->dev, "missing mode configuration\n");
 		return -EINVAL;
@@ -64,6 +185,26 @@ static int gsbi_probe(struct platform_device *pdev)
 	writel_relaxed((gsbi->mode << GSBI_PROTOCOL_SHIFT) | gsbi->crci,
 				base + GSBI_CTRL_REG);
 
+	/*
+	 * modify tcsr to reflect mode and ADM CRCI mux
+	 * Each gsbi contains a pair of bits, one for RX and one for TX
+	 * SPI mode requires both bits cleared, otherwise they are set
+	 */
+	match = of_match_node(gsbi_dt_match, node);
+	config = (struct crci_config *)match->data;
+
+	if (config)
+		for (i = 0; i < config->num_rows; i++) {
+			if (gsbi->mode == GSBI_PROT_SPI)
+				val = config->array[i*MAX_GSBI + gsbi_num - 1];
+			else
+				val = 0;
+
+			regmap_update_bits(gsbi->tcsr,
+				TCSR_ADM_CRCI_BASE + 0x4*i,
+				config->array[i*MAX_GSBI + gsbi_num - 1], val);
+		}
+
 	/* make sure the gsbi control write is not reordered */
 	wmb();
 
@@ -81,13 +222,6 @@ static int gsbi_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id gsbi_dt_match[] = {
-	{ .compatible = "qcom,gsbi-v1.0.0", },
-	{ },
-};
-
-MODULE_DEVICE_TABLE(of, gsbi_dt_match);
-
 static struct platform_driver gsbi_driver = {
 	.driver = {
 		.name		= "gsbi",
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

