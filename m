Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaCNIzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:55:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51518 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbaCNIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:55:40 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH] spi: dw-mmio: add oftree support
Date: Fri, 14 Mar 2014 09:55:26 +0100
Message-Id: <1394787326-14520-1-git-send-email-s.trumtrar@pengutronix.de>
X-Mailer: git-send-email 1.9.0
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
This was tested on Socfpga and v3.14-rc6

 .../devicetree/bindings/spi/spi-dw-mmio.txt        | 25 ++++++++++++++++++++++
 drivers/spi/spi-dw-mmio.c                          | 19 +++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-dw-mmio.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-dw-mmio.txt b/Documentation/devicetree/bindings/spi/spi-dw-mmio.txt
new file mode 100644
index 0000000..2b9bb90
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-dw-mmio.txt
@@ -0,0 +1,25 @@
+Synopsys DesignWare SPI master controller.
+
+Required properties:
+- compatible : "snps,dw-spi-mmio"
+- reg : The register base for the controller.
+- interrupts : One interrupt, used by the controller.
+- #address-cells : <1>, as required by generic SPI binding.
+- #size-cells : <0>, also as required by generic SPI binding.
+
+Optional properties:
+- num-chipselects : The number of chipselects.
+
+Child nodes as per the generic SPI binding.
+
+Example:
+
+	spi@fff00000 {
+		compatible = "snps,dw-spi-mmio";
+		reg = <0xfff00000 0x1000>;
+		interrupts = <0 154 4>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		num-chipselects = <4>;
+	};
+
diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 9af56cd..71345e4 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -16,6 +16,8 @@
 #include <linux/spi/spi.h>
 #include <linux/scatterlist.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 #include "spi-dw.h"
 
@@ -32,6 +34,7 @@ static int dw_spi_mmio_probe(struct platform_device *pdev)
 	struct dw_spi *dws;
 	struct resource *mem;
 	int ret;
+	int val;
 
 	dwsmmio = devm_kzalloc(&pdev->dev, sizeof(struct dw_spi_mmio),
 			GFP_KERNEL);
@@ -66,8 +69,15 @@ static int dw_spi_mmio_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	dws->bus_num = 0;
+	dws->bus_num = pdev->id;
 	dws->num_cs = 4;
+
+	if (pdev->dev.of_node) {
+		if (of_property_read_u32(pdev->dev.of_node, "num-chipselects",
+					 &val))
+			dws->num_cs = val;
+	}
+
 	dws->max_freq = clk_get_rate(dwsmmio->clk);
 
 	ret = dw_spi_add_host(&pdev->dev, dws);
@@ -92,12 +102,19 @@ static int dw_spi_mmio_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id dw_spi_mmio_of_match[] = {
+	{ .compatible = "snps,dw-spi-mmio", },
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
1.9.0

