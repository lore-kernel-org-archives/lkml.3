Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaFMNgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:36:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33420 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaFMNge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:36:34 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v3] spi: dw-mmio: add devicetree support
Date: Fri, 13 Jun 2014 15:36:18 +0200
Message-Id: <1402666578-16540-1-git-send-email-s.trumtrar@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow probing the dw-mmio from devicetree.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
Changes since v2:
	- rebase to spi-v3.16
	- add cs-gpios to optional properties

Changes since v1:
	- num-chipselect -> num-cs
        - snps,dw-spi-mmio -> snps,dw-apb-ssi

 .../devicetree/bindings/spi/snps,dw-apb-ssi.txt    | 28 ++++++++++++++++++++++
 drivers/spi/spi-dw-mmio.c                          | 19 ++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.txt

diff --git a/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.txt b/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.txt
new file mode 100644
index 0000000..bd99193
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.txt
@@ -0,0 +1,28 @@
+Synopsys DesignWare AMBA 2.0 Synchronous Serial Interface.
+
+Required properties:
+- compatible : "snps,dw-apb-ssi"
+- reg : The register base for the controller.
+- interrupts : One interrupt, used by the controller.
+- #address-cells : <1>, as required by generic SPI binding.
+- #size-cells : <0>, also as required by generic SPI binding.
+
+Optional properties:
+- cs-gpios : Specifies the gpio pis to be used for chipselects.
+- num-cs : The number of chipselects. If omitted, this will default to 4.
+
+Child nodes as per the generic SPI binding.
+
+Example:
+
+	spi@fff00000 {
+		compatible = "snps,dw-apb-ssi";
+		reg = <0xfff00000 0x1000>;
+		interrupts = <0 154 4>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		num-cs = <2>;
+		cs-gpios = <&gpio0 13 0>,
+			   <&gpio0 14 0>;
+	};
+
diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index a5cba14..21ce0e3 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -16,7 +16,9 @@
 #include <linux/spi/spi.h>
 #include <linux/scatterlist.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/of_platform.h>
 
 #include "spi-dw.h"
 
@@ -33,6 +35,7 @@ static int dw_spi_mmio_probe(struct platform_device *pdev)
 	struct dw_spi *dws;
 	struct resource *mem;
 	int ret;
+	int num_cs;
 
 	dwsmmio = devm_kzalloc(&pdev->dev, sizeof(struct dw_spi_mmio),
 			GFP_KERNEL);
@@ -68,9 +71,16 @@ static int dw_spi_mmio_probe(struct platform_device *pdev)
 		return ret;
 
 	dws->bus_num = pdev->id;
-	dws->num_cs = 4;
+
 	dws->max_freq = clk_get_rate(dwsmmio->clk);
 
+	num_cs = 4;
+
+	if (pdev->dev.of_node)
+		of_property_read_u32(pdev->dev.of_node, "num-cs", &num_cs);
+
+	dws->num_cs = num_cs;
+
 	if (pdev->dev.of_node) {
 		int i;
 
@@ -114,12 +124,19 @@ static int dw_spi_mmio_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id dw_spi_mmio_of_match[] = {
+	{ .compatible = "snps,dw-apb-ssi", },
+	{ /* end of table */}
+};
+MODULE_DEVICE_TABLE(of, dw_spi_mmio_of_match);
+
 static struct platform_driver dw_spi_mmio_driver = {
 	.probe		= dw_spi_mmio_probe,
 	.remove		= dw_spi_mmio_remove,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = dw_spi_mmio_of_match,
 	},
 };
 module_platform_driver(dw_spi_mmio_driver);
-- 
2.0.0.rc2

