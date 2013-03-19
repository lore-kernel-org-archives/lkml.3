Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab3CSHq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:46:29 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:27451 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933066Ab3CSHq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:46:28 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>,
        <richard.genoud@gmail.com>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 02/14] spi/spi-atmel: add support transfer on CS1,2,3, not only on CS0
Date: Tue, 19 Mar 2013 15:43:01 +0800
Message-ID: <1363678981-3724-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
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
index 0928dee..64e2795 100644
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

