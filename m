Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3HAOAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:00:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56685 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab3HAOAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:00:34 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>
CC: <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [RFC/PATCH 2/2] driver: spi: Add quad spi read support
Date: Thu, 1 Aug 2013 19:30:02 +0530
Message-ID: <1375365602-31321-3-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1375365602-31321-1-git-send-email-sourav.poddar@ti.com>
References: <1375365602-31321-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since, qspi controller uses quad read.

Configuring the command register, if the transfer of data needs
dual or quad lines.

This patch has been done on top of the following patch[1], which is just the
basic idea of adding dual/quad support in spi framework.
$subject patch will undergo changes once the ongoing discussion in the
community is freezed.

This patch is posted to demonstrate how patch 1 of the series will support
quad read.

[1]: http://comments.gmane.org/gmane.linux.kernel.spi.devel/14047

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/spi/spi-ti-qspi.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index 73a1675..fac1722 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -265,18 +265,30 @@ static int qspi_write_msg(struct ti_qspi *qspi, struct spi_transfer *t)
 static int qspi_read_msg(struct ti_qspi *qspi, struct spi_transfer *t)
 {
 	int wlen, count, ret;
+	unsigned cmd = qspi->cmd;
 
 	count = t->len;
 	wlen = t->bits_per_word;
 
+	switch (t->bitwidth) {
+	case SPI_BITWIDTH_QUAD:
+		cmd |= QSPI_RD_QUAD;
+		break;
+	case SPI_BITWIDTH_DUAL:
+		cmd |= QSPI_RD_DUAL;
+		break;
+	case SPI_BITWIDTH_SINGLE:
+	default:
+		cmd |= QSPI_RD_SNGL;
+	}
+
 	if (wlen == 8) {
 		u8        *rxbuf;
 		rxbuf = t->rx_buf;
 		do {
 			dev_dbg(qspi->dev, "rx cmd %08x dc %08x\n",
 				qspi->cmd | QSPI_RD_SNGL, qspi->dc);
-			ti_qspi_write(qspi, qspi->cmd | QSPI_RD_SNGL,
-				QSPI_SPI_CMD_REG);
+			ti_qspi_write(qspi, cmd, QSPI_SPI_CMD_REG);
 			ret = wait_for_completion_timeout(&qspi->transfer_complete,
 				QSPI_COMPLETION_TIMEOUT);
 			if (ret == 0) {
@@ -294,8 +306,7 @@ static int qspi_read_msg(struct ti_qspi *qspi, struct spi_transfer *t)
 		do {
 			dev_dbg(qspi->dev, "rx cmd %08x dc %08x\n",
 				qspi->cmd | QSPI_RD_SNGL, qspi->dc);
-			ti_qspi_write(qspi, qspi->cmd | QSPI_RD_SNGL,
-				QSPI_SPI_CMD_REG);
+			ti_qspi_write(qspi, cmd, QSPI_SPI_CMD_REG);
 			ret = wait_for_completion_timeout(&qspi->transfer_complete,
 					QSPI_COMPLETION_TIMEOUT);
 			if (ret == 0) {
@@ -313,8 +324,7 @@ static int qspi_read_msg(struct ti_qspi *qspi, struct spi_transfer *t)
 		do {
 			dev_dbg(qspi->dev, "rx cmd %08x dc %08x\n",
 				qspi->cmd | QSPI_RD_SNGL, qspi->dc);
-			ti_qspi_write(qspi, qspi->cmd | QSPI_RD_SNGL,
-				QSPI_SPI_CMD_REG);
+			ti_qspi_write(qspi, cmd, QSPI_SPI_CMD_REG);
 			ret = wait_for_completion_timeout(&qspi->transfer_complete,
 					QSPI_COMPLETION_TIMEOUT);
 			if (ret == 0) {
-- 
1.7.1

