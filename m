Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbbALDQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 22:16:31 -0500
Received: from smtp1s1.overthewire.com.au ([203.18.94.100]:48316 "EHLO
	smtp1s1.overthewire.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbbALDQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 22:16:12 -0500
From: Ken Wilson <ken.wilson@opengear.com>
To: thomas.petazzoni@free-electrons.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        broonie@kernel.org, ezequiel.garcia@free-electrons.com,
        gerg@uclinux.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Ken Wilson <ken.wilson@opengear.com>
Subject: [PATCHv2 2/2] spi: orion: Add multiple chip select support to spi-orion
Date: Mon, 12 Jan 2015 13:14:00 +1000
Message-Id: <1421032440-15335-3-git-send-email-ken.wilson@opengear.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1421032440-15335-1-git-send-email-ken.wilson@opengear.com>
References: <1421032440-15335-1-git-send-email-ken.wilson@opengear.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for multiple hardware chip selects to spi-orion.
The number of supported chip selects varies based on the SoC and pin
configuration, so it is set using the num-cs device tree binding.

Signed-off-by: Ken Wilson <ken.wilson@opengear.com>
---
 Documentation/devicetree/bindings/spi/spi-orion.txt |  3 +++
 drivers/spi/spi-orion.c                             | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-orion.txt b/Documentation/devicetree/bindings/spi/spi-orion.txt
index 50c3a3d..0f8fd7e 100644
--- a/Documentation/devicetree/bindings/spi/spi-orion.txt
+++ b/Documentation/devicetree/bindings/spi/spi-orion.txt
@@ -6,6 +6,8 @@ Required properties:
 - cell-index : Which of multiple SPI controllers is this.
 Optional properties:
 - interrupts : Is currently not used.
+- num-cs     : The total number of chip selects used by this platform.
+		If unset, this defaults to 1.
 
 Example:
        spi@10600 {
@@ -15,5 +17,6 @@ Example:
 	       cell-index = <0>;
 	       reg = <0x10600 0x28>;
 	       interrupts = <23>;
+	       num-cs = <1>;
 	       status = "disabled";
        };
diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index e6ac9d5..1c28152 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -28,7 +28,6 @@
 /* Runtime PM autosuspend timeout: PM is fairly light on this driver */
 #define SPI_AUTOSUSPEND_TIMEOUT		200
 
-#define ORION_NUM_CHIPSELECTS		1 /* only one slave is supported*/
 #define ORION_SPI_WAIT_RDY_MAX_LOOP	2000 /* in usec */
 
 #define ORION_SPI_IF_CTRL_REG		0x00
@@ -44,6 +43,10 @@
 #define ARMADA_SPI_CLK_PRESCALE_MASK	0xDF
 #define ORION_SPI_MODE_MASK		(ORION_SPI_MODE_CPOL | \
 					 ORION_SPI_MODE_CPHA)
+#define ORION_SPI_CS_MASK	0x1C
+#define ORION_SPI_CS_SHIFT	2
+#define ORION_SPI_CS(cs)	((cs << ORION_SPI_CS_SHIFT) & \
+					ORION_SPI_CS_MASK)
 
 enum orion_spi_type {
 	ORION_SPI,
@@ -221,6 +224,10 @@ static void orion_spi_set_cs(struct spi_device *spi, bool enable)
 
 	orion_spi = spi_master_get_devdata(spi->master);
 
+	orion_spi_clrbits(orion_spi, ORION_SPI_IF_CTRL_REG, ORION_SPI_CS_MASK);
+	orion_spi_setbits(orion_spi, ORION_SPI_IF_CTRL_REG,
+				ORION_SPI_CS(spi->chip_select));
+
 	/* Chip select logic is inverted from spi_set_cs */
 	if (!enable)
 		orion_spi_setbits(orion_spi, ORION_SPI_IF_CTRL_REG, 0x1);
@@ -406,17 +413,23 @@ static int orion_spi_probe(struct platform_device *pdev)
 		master->bus_num = pdev->id;
 	if (pdev->dev.of_node) {
 		u32 cell_index;
+		u32 num_cs;
 
 		if (!of_property_read_u32(pdev->dev.of_node, "cell-index",
 					  &cell_index))
 			master->bus_num = cell_index;
+
+		if (!of_property_read_u32(pdev->dev.of_node, "num_cs",
+					  &num_cs))
+			master->num_chipselect = num_cs;
+		else
+			master->num_chipselect = 1;
 	}
 
 	/* we support only mode 0, and no options */
 	master->mode_bits = SPI_CPHA | SPI_CPOL;
 	master->set_cs = orion_spi_set_cs;
 	master->transfer_one = orion_spi_transfer_one;
-	master->num_chipselect = ORION_NUM_CHIPSELECTS;
 	master->setup = orion_spi_setup;
 	master->bits_per_word_mask = SPI_BPW_MASK(8) | SPI_BPW_MASK(16);
 	master->auto_runtime_pm = true;
-- 
2.0.0

