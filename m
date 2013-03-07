Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab3CGDaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:30:52 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:53155 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3CGDav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:30:51 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <richard.genoud@gmail.com>,
        <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 03/16] spi/spi-atmel: add support transfer on CS1,2,3, not only on CS0
Date: Thu, 7 Mar 2013 11:28:00 +0800
Message-ID: <1362626880-6703-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 drivers/spi/spi-atmel.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 8724157..e05aa8c 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -255,11 +255,6 @@ static bool atmel_spi_is_v2(struct atmel_spi *as)
  * Master on Chip Select 0.")  No workaround exists for that ... so for
  * nCS0 on that chip, we (a) don't use the GPIO, (b) can't support CS_HIGH,
  * and (c) will trigger that first erratum in some cases.
- *
- * TODO: Test if the atmel_spi_is_v2() branch below works on
- * AT91RM9200 if we use some other register than CSR0. However, don't
- * do this unconditionally since AP7000 has an errata where the BITS
- * field in CSR0 overrides all other CSRs.
  */
 
 static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
@@ -269,18 +264,22 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 	u32 mr;
 
 	if (atmel_spi_is_v2(as)) {
-		/*
-		 * Always use CSR0. This ensures that the clock
-		 * switches to the correct idle polarity before we
-		 * toggle the CS.
+		spi_writel(as, CSR0 + 4 * spi->chip_select, asd->csr);
+		/* For the low SPI version, there is a issue that PDC transfer
+		 * on CS1,2,3 needs SPI_CSR0.BITS config as SPI_CSR1,2,3.BITS
 		 */
 		spi_writel(as, CSR0, asd->csr);
 		if (as->caps.has_wdrbt) {
-			spi_writel(as, MR, SPI_BF(PCS, 0x0e) | SPI_BIT(WDRBT)
-				| SPI_BIT(MODFDIS) | SPI_BIT(MSTR));
+			spi_writel(as, MR,
+					SPI_BF(PCS, ~(0x01 << spi->chip_select))
+					| SPI_BIT(WDRBT)
+					| SPI_BIT(MODFDIS)
+					| SPI_BIT(MSTR));
 		} else {
-			spi_writel(as, MR, SPI_BF(PCS, 0x0e) | SPI_BIT(MODFDIS)
-				| SPI_BIT(MSTR));
+			spi_writel(as, MR,
+					SPI_BF(PCS, ~(0x01 << spi->chip_select))
+					| SPI_BIT(MODFDIS)
+					| SPI_BIT(MSTR));
 		}
 		mr = spi_readl(as, MR);
 		gpio_set_value(asd->npcs_pin, active);
-- 
1.7.9.5

