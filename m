Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbbAPDLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:11:34 -0500
Received: from smtp1s1.overthewire.com.au ([203.18.94.100]:40739 "EHLO
	smtp1s1.overthewire.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbbAPDLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:11:33 -0500
From: Ken Wilson <ken.wilson@opengear.com>
To: broonie@kernel.org
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ken Wilson <ken.wilson@opengear.com>
Subject: [PATCHv3] spi: orion: Add multiple chip select support to spi-orion
Date: Fri, 16 Jan 2015 13:10:47 +1000
Message-Id: <1421377847-3198-1-git-send-email-ken.wilson@opengear.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for multiple hardware chip selects to spi-orion.
Different SoCs support different number of chip selects (up to
8 on some platforms). The driver allows up to this number, and it is up
to the implementer to only use the chip selects that are available.

Signed-off-by: Ken Wilson <ken.wilson@opengear.com>
---
 drivers/spi/spi-orion.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index e6ac9d5..db50f0e 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -28,7 +28,12 @@
 /* Runtime PM autosuspend timeout: PM is fairly light on this driver */
 #define SPI_AUTOSUSPEND_TIMEOUT		200
 
-#define ORION_NUM_CHIPSELECTS		1 /* only one slave is supported*/
+/* Some SoCs using this driver support up to 8 chip selects.
+ * It is up to the implementer to only use the chip selects
+ * that are available.
+ */
+#define ORION_NUM_CHIPSELECTS		8
+
 #define ORION_SPI_WAIT_RDY_MAX_LOOP	2000 /* in usec */
 
 #define ORION_SPI_IF_CTRL_REG		0x00
@@ -44,6 +49,10 @@
 #define ARMADA_SPI_CLK_PRESCALE_MASK	0xDF
 #define ORION_SPI_MODE_MASK		(ORION_SPI_MODE_CPOL | \
 					 ORION_SPI_MODE_CPHA)
+#define ORION_SPI_CS_MASK	0x1C
+#define ORION_SPI_CS_SHIFT	2
+#define ORION_SPI_CS(cs)	((cs << ORION_SPI_CS_SHIFT) & \
+					ORION_SPI_CS_MASK)
 
 enum orion_spi_type {
 	ORION_SPI,
@@ -221,6 +230,10 @@ static void orion_spi_set_cs(struct spi_device *spi, bool enable)
 
 	orion_spi = spi_master_get_devdata(spi->master);
 
+	orion_spi_clrbits(orion_spi, ORION_SPI_IF_CTRL_REG, ORION_SPI_CS_MASK);
+	orion_spi_setbits(orion_spi, ORION_SPI_IF_CTRL_REG,
+				ORION_SPI_CS(spi->chip_select));
+
 	/* Chip select logic is inverted from spi_set_cs */
 	if (!enable)
 		orion_spi_setbits(orion_spi, ORION_SPI_IF_CTRL_REG, 0x1);
-- 
2.0.0

