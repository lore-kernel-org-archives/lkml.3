Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3GHNn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:43:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43393 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3GHNny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:43:54 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>
CC: <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [RFC/PATCH 3/3] driver: spi: Add quad spi read support
Date: Mon, 8 Jul 2013 19:13:00 +0530
Message-ID: <1373290980-17883-4-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since, qspi controller uses quad read.

Configuring the command register, if the transfer of data needs
quad lines.

This patch has been done on top of the following patch[1], which is still
under review/comments.
This patch will also go changes, as the parent patch[1] does.

[1]: http://comments.gmane.org/gmane.linux.kernel.spi.devel/14047

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/spi/spi-ti-qspi.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index 430de9c..307cbed 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -258,8 +258,12 @@ static int qspi_read_msg(struct dra7xxx_qspi *qspi, struct spi_transfer *t)
 			qspi->cmd | QSPI_RD_SNGL, qspi->dc);
 		dra7xxx_writel(qspi, QSPI_WC_INT_EN, QSPI_INTR_ENABLE_SET_REG);
 		dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
-		dra7xxx_writel(qspi, qspi->cmd | QSPI_RD_SNGL,
-			QSPI_SPI_CMD_REG);
+		if (t->bitwidth == SPI_BITWIDTH_QUAD)
+			dra7xxx_writel(qspi, qspi->cmd | QSPI_RD_QUAD,
+				QSPI_SPI_CMD_REG);
+		else
+			dra7xxx_writel(qspi, qspi->cmd | QSPI_RD_SNGL,
+				QSPI_SPI_CMD_REG);
 		wait_for_completion(&qspi->word_complete);
 		*rxbuf++ = dra7xxx_readl_data(qspi, QSPI_SPI_DATA_REG, wlen);
 		dev_dbg(qspi->dev, "rx done, read %02x\n", *(rxbuf-1));
-- 
1.7.1

