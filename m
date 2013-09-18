Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3IRSQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:16:51 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9511 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3IRSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:16:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 11:16:48 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>
CC: <spi-devel-general@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Simon Glass <sjg@chromium.org>,
        Olof Johansson <olof@lixom.net>, Rhyland Klein <rklein@nvidia.com>
Subject: [IP REVIEW] spi/tegra114: Correct support for cs_change
Date: Wed, 18 Sep 2013 14:13:39 -0400
Message-ID: <1379528019-6042-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tegra114 driver wasn't currently handling the cs_change functionality.
It is meant to invert normal behavior, and we were only using it to possibly
delay at the end of a transfer.

This patch modifies the logic so that the cs state will be toggled after
every individual transfer or NOT toggled at the end of the last transfer
if cs_change is set in that transfer struct.

Also, this builds in logic so that if a different device tries to start
a transfer while CS is active from a different device, it will abort the
previous transfer and start a new one for the new device.

This work was based on the spi-atmel driver.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/spi/spi-tegra114.c |   59 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 145dd43..a9973de 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -182,6 +182,7 @@ struct tegra_spi_data {
 	u32					cur_speed;
 
 	struct spi_device			*cur_spi;
+	struct spi_device			*cs_control;
 	unsigned				cur_pos;
 	unsigned				cur_len;
 	unsigned				words_per_32bit;
@@ -717,7 +718,12 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 		else if (req_mode == SPI_MODE_3)
 			command1 |= SPI_CONTROL_MODE_3;
 
-		tegra_spi_writel(tspi, command1, SPI_COMMAND1);
+		if (tspi->cs_control) {
+			if (tspi->cs_control != spi)
+				tegra_spi_writel(tspi, command1, SPI_COMMAND1);
+			tspi->cs_control = NULL;
+		} else
+			tegra_spi_writel(tspi, command1, SPI_COMMAND1);
 
 		command1 |= SPI_CS_SW_HW;
 		if (spi->mode & SPI_CS_HIGH)
@@ -732,6 +738,9 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 		command1 |= SPI_BIT_LENGTH(bits_per_word - 1);
 	}
 
+	if (t->len == 0 && !t->tx_buf && !t->rx_buf)
+		return 0;
+
 	if (tspi->is_packed)
 		command1 |= SPI_PACKED;
 
@@ -803,6 +812,17 @@ static int tegra_spi_setup(struct spi_device *spi)
 	return 0;
 }
 
+static void tegra_spi_transfer_delay(int delay)
+{
+	if (!delay)
+		return;
+
+	if (delay >= 1000)
+		mdelay(delay / 1000);
+
+	udelay(delay % 1000);
+}
+
 static int tegra_spi_transfer_one_message(struct spi_master *master,
 			struct spi_message *msg)
 {
@@ -812,6 +832,7 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 	struct spi_transfer *xfer;
 	struct spi_device *spi = msg->spi;
 	int ret;
+	bool skip = false;
 
 	msg->status = 0;
 	msg->actual_length = 0;
@@ -819,13 +840,20 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		INIT_COMPLETION(tspi->xfer_completion);
+
 		ret = tegra_spi_start_transfer_one(spi, xfer,
 					is_first_msg, single_xfer);
 		if (ret < 0) {
 			dev_err(tspi->dev,
 				"spi can not start transfer, err %d\n", ret);
-			goto exit;
+			goto complete_xfer;
+		}
+
+		if (xfer->len == 0 && !xfer->tx_buf && !xfer->rx_buf) {
+			skip = true;
+			goto complete_xfer;
 		}
+
 		is_first_msg = false;
 		ret = wait_for_completion_timeout(&tspi->xfer_completion,
 						SPI_DMA_TIMEOUT);
@@ -833,24 +861,41 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 			dev_err(tspi->dev,
 				"spi trasfer timeout, err %d\n", ret);
 			ret = -EIO;
-			goto exit;
+			goto complete_xfer;
 		}
 
 		if (tspi->tx_status ||  tspi->rx_status) {
 			dev_err(tspi->dev, "Error in Transfer\n");
 			ret = -EIO;
-			goto exit;
+			goto complete_xfer;
 		}
 		msg->actual_length += xfer->len;
-		if (xfer->cs_change && xfer->delay_usecs) {
+
+complete_xfer:
+		if (ret < 0 || skip) {
 			tegra_spi_writel(tspi, tspi->def_command1_reg,
 					SPI_COMMAND1);
-			udelay(xfer->delay_usecs);
+			tegra_spi_transfer_delay(xfer->delay_usecs);
+			goto exit;
+		} else if (msg->transfers.prev == &xfer->transfer_list) {
+			/* This is the last transfer in message */
+			if (xfer->cs_change)
+				tspi->cs_control = spi;
+			else {
+				tegra_spi_writel(tspi, tspi->def_command1_reg,
+						SPI_COMMAND1);
+				tegra_spi_transfer_delay(xfer->delay_usecs);
+			}
+		} else if (xfer->cs_change) {
+			tegra_spi_writel(tspi, tspi->def_command1_reg,
+					SPI_COMMAND1);
+			tegra_spi_transfer_delay(xfer->delay_usecs);
 		}
+
 	}
 	ret = 0;
 exit:
-	tegra_spi_writel(tspi, tspi->def_command1_reg, SPI_COMMAND1);
+
 	msg->status = ret;
 	spi_finalize_current_message(master);
 	return ret;
-- 
1.7.9.5

