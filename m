Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbbAFVvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:51:44 -0500
Received: from smtp1s1.overthewire.com.au ([203.18.94.100]:51220 "EHLO
	smtp1s1.overthewire.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313AbbAFVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:51:42 -0500
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 16:51:41 EST
From: Ken Wilson <ken.wilson@opengear.com>
To: robh+dt@kernel.org
Cc: pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, broonie@kernel.org,
        ezequiel.garcia@free-electrons.com, ken.wilson@opengear.com,
        gerg@uclinux.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org
Subject: [PATCH] spi: orion: Add multiple chip select support for Armada 370 and 375
Date: Wed,  7 Jan 2015 07:30:46 +1000
Message-Id: <1420579846-31962-1-git-send-email-ken.wilson@opengear.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new dt binding for the Armada 375 that supports up to
3 chip selects but uses the same prescaler values and algorithm
as the basic orion binding.

Update the Armada 370 so that it supports up to 4 chip selects.

This has been tested on the Armada 375 with multiple SPI-NOR chips.

Signed-off-by: Ken Wilson <ken.wilson@opengear.com>
---
 .../devicetree/bindings/spi/spi-orion.txt          |  3 ++-
 arch/arm/boot/dts/armada-375.dtsi                  |  4 +--
 drivers/spi/spi-orion.c                            | 29 +++++++++++++++++++---
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-orion.txt b/Documentation/devicetree/bindings/spi/spi-orion.txt
index 50c3a3d..2aeeb85 100644
--- a/Documentation/devicetree/bindings/spi/spi-orion.txt
+++ b/Documentation/devicetree/bindings/spi/spi-orion.txt
@@ -1,7 +1,8 @@
 Marvell Orion SPI device
 
 Required properties:
-- compatible : should be "marvell,orion-spi" or "marvell,armada-370-spi".
+- compatible : should be "marvell,orion-spi", "marvell,armada-370-spi",
+	or "marvell,armada-375-spi".
 - reg : offset and length of the register set for the device
 - cell-index : Which of multiple SPI controllers is this.
 Optional properties:
diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index de65714..f7a5ce2 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -192,7 +192,7 @@
 			};
 
 			spi0: spi@10600 {
-				compatible = "marvell,orion-spi";
+				compatible = "marvell,armada-375-spi", "marvell,orion-spi";
 				reg = <0x10600 0x50>;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -203,7 +203,7 @@
 			};
 
 			spi1: spi@10680 {
-				compatible = "marvell,orion-spi";
+				compatible = "marvell,armada-375-spi", "marvell,orion-spi";
 				reg = <0x10680 0x50>;
 				#address-cells = <1>;
 				#size-cells = <0>;
diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index c76b7d7..4129c37 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -28,7 +28,6 @@
 /* Runtime PM autosuspend timeout: PM is fairly light on this driver */
 #define SPI_AUTOSUSPEND_TIMEOUT		200
 
-#define ORION_NUM_CHIPSELECTS		1 /* only one slave is supported*/
 #define ORION_SPI_WAIT_RDY_MAX_LOOP	2000 /* in usec */
 
 #define ORION_SPI_IF_CTRL_REG		0x00
@@ -44,6 +43,7 @@
 #define ARMADA_SPI_CLK_PRESCALE_MASK	0xDF
 #define ORION_SPI_MODE_MASK		(ORION_SPI_MODE_CPOL | \
 					 ORION_SPI_MODE_CPHA)
+#define ORION_SPI_CS_MASK	0x1C
 
 enum orion_spi_type {
 	ORION_SPI,
@@ -55,6 +55,7 @@ struct orion_spi_dev {
 	unsigned int		min_divisor;
 	unsigned int		max_divisor;
 	u32			prescale_mask;
+	u8			num_cs;
 };
 
 struct orion_spi {
@@ -201,6 +202,13 @@ orion_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 
 	orion_spi_mode_set(spi);
 
+	if (orion_spi->master->num_chipselect > 1) {
+		orion_spi_clrbits(orion_spi, ORION_SPI_IF_CTRL_REG,
+				ORION_SPI_CS_MASK);
+		orion_spi_setbits(orion_spi, ORION_SPI_IF_CTRL_REG,
+				(spi->chip_select) << 2);
+	}
+
 	rc = orion_spi_baudrate_set(spi, speed);
 	if (rc)
 		return rc;
@@ -398,18 +406,31 @@ static const struct orion_spi_dev orion_spi_dev_data = {
 	.min_divisor = 4,
 	.max_divisor = 30,
 	.prescale_mask = ORION_SPI_CLK_PRESCALE_MASK,
+	.num_cs = 1,
 };
 
-static const struct orion_spi_dev armada_spi_dev_data = {
+static const struct orion_spi_dev armada_370_spi_dev_data = {
 	.typ = ARMADA_SPI,
 	.min_divisor = 1,
 	.max_divisor = 1920,
 	.prescale_mask = ARMADA_SPI_CLK_PRESCALE_MASK,
+	.num_cs = 4,
+};
+
+static const struct orion_spi_dev armada_375_spi_dev_data = {
+	.typ = ORION_SPI,
+	.min_divisor = 4,
+	.max_divisor = 30,
+	.prescale_mask = ORION_SPI_CLK_PRESCALE_MASK,
+	.num_cs = 3,
 };
 
 static const struct of_device_id orion_spi_of_match_table[] = {
 	{ .compatible = "marvell,orion-spi", .data = &orion_spi_dev_data, },
-	{ .compatible = "marvell,armada-370-spi", .data = &armada_spi_dev_data, },
+	{ .compatible = "marvell,armada-370-spi",
+		.data = &armada_370_spi_dev_data, },
+	{ .compatible = "marvell,armada-375-spi",
+		.data = &armada_375_spi_dev_data, },
 	{}
 };
 MODULE_DEVICE_TABLE(of, orion_spi_of_match_table);
@@ -444,7 +465,6 @@ static int orion_spi_probe(struct platform_device *pdev)
 	master->mode_bits = SPI_CPHA | SPI_CPOL;
 
 	master->transfer_one_message = orion_spi_transfer_one_message;
-	master->num_chipselect = ORION_NUM_CHIPSELECTS;
 	master->bits_per_word_mask = SPI_BPW_MASK(8) | SPI_BPW_MASK(16);
 	master->auto_runtime_pm = true;
 
@@ -470,6 +490,7 @@ static int orion_spi_probe(struct platform_device *pdev)
 	tclk_hz = clk_get_rate(spi->clk);
 	master->max_speed_hz = DIV_ROUND_UP(tclk_hz, devdata->min_divisor);
 	master->min_speed_hz = DIV_ROUND_UP(tclk_hz, devdata->max_divisor);
+	master->num_chipselect = devdata->num_cs;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	spi->base = devm_ioremap_resource(&pdev->dev, r);
-- 
2.0.0

