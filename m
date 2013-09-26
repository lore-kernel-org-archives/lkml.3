Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3IZRBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:01:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12352 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3IZRBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:01:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Sep 2013 09:57:54 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-spi@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Simon Glass <sjg@chromium.org>,
        Olof Johansson <olof@lixom.net>, Rhyland Klein <rklein@nvidia.com>
Subject: [Patch V2] spi/tegra114: Correct support for cs_change
Date: Thu, 26 Sep 2013 13:01:43 -0400
Message-ID: <1380214904-12899-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tegra114 driver wasn't currently handling the cs_change
functionality. cs_change is meant to invert the decisions of whether
or not to deactivate CS after each transfer. Without cs_change, after
every transfer (other than the last in the message) the normal behavior
is to leave CS active. For the last transfer, normally CS is
deactivated when the transfer is complete.

With cs_change set on a transfer (other than last one) CS would be
deactivated and the next transfer would need to activate it again. If
cs_change was set on the last tranfer in a message, then CS would be
left active when the message compeleted.

Also, this builds in logic so that if a different device tries to start
a transfer while CS is active from a different device, it will abort the
previous transfer and start a new one for the new device.

This splits tegra_spi_start_transfer_one into 2 functions, the new one
being tegra_spi_setup_transfer_one. The setup function is safe to call
on all transfers, sets up for the transfer, and handles the special case
of the first transfer in a message. In this special case, it needs to
know whether or not it needs to activate CS.

This work was based on the spi-atmel driver.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v2:
 - Split start_transfer_one into setup & start, now setup it always safe
   to call, and we can simplify the checks for a transfer with no length.
 - removed unnecessary whitespace changes
 - I also cleaned up the parameters to tegra_spi_start_transfer_one,
   removing is_first_of_msg (moved to setup) and is_single_xfer, since it
   was not used.

 drivers/spi/spi-tegra114.c |   85 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 68 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 946ff73..95c7caa 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -182,6 +182,7 @@ struct tegra_spi_data {
 	u32					cur_speed;
 
 	struct spi_device			*cur_spi;
+	struct spi_device			*cs_control;
 	unsigned				cur_pos;
 	unsigned				cur_len;
 	unsigned				words_per_32bit;
@@ -676,15 +677,12 @@ static void tegra_spi_deinit_dma_param(struct tegra_spi_data *tspi,
 	dma_release_channel(dma_chan);
 }
 
-static int tegra_spi_start_transfer_one(struct spi_device *spi,
-		struct spi_transfer *t, bool is_first_of_msg,
-		bool is_single_xfer)
+static unsigned long tegra_spi_setup_transfer_one(struct spi_device *spi,
+		struct spi_transfer *t, bool is_first_of_msg)
 {
 	struct tegra_spi_data *tspi = spi_master_get_devdata(spi->master);
 	u32 speed = t->speed_hz;
 	u8 bits_per_word = t->bits_per_word;
-	unsigned total_fifo_words;
-	int ret;
 	unsigned long command1;
 	int req_mode;
 
@@ -698,7 +696,6 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 	tspi->cur_rx_pos = 0;
 	tspi->cur_tx_pos = 0;
 	tspi->curr_xfer = t;
-	total_fifo_words = tegra_spi_calculate_curr_xfer_param(spi, tspi, t);
 
 	if (is_first_of_msg) {
 		tegra_spi_clear_status(tspi);
@@ -717,7 +714,12 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
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
@@ -732,6 +734,18 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 		command1 |= SPI_BIT_LENGTH(bits_per_word - 1);
 	}
 
+	return command1;
+}
+
+static int tegra_spi_start_transfer_one(struct spi_device *spi,
+		struct spi_transfer *t, unsigned long command1)
+{
+	struct tegra_spi_data *tspi = spi_master_get_devdata(spi->master);
+	unsigned total_fifo_words;
+	int ret;
+
+	total_fifo_words = tegra_spi_calculate_curr_xfer_param(spi, tspi, t);
+
 	if (tspi->is_packed)
 		command1 |= SPI_PACKED;
 
@@ -803,29 +817,50 @@ static int tegra_spi_setup(struct spi_device *spi)
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
 	bool is_first_msg = true;
-	int single_xfer;
 	struct tegra_spi_data *tspi = spi_master_get_devdata(master);
 	struct spi_transfer *xfer;
 	struct spi_device *spi = msg->spi;
 	int ret;
+	bool skip = false;
 
 	msg->status = 0;
 	msg->actual_length = 0;
 
-	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
+		unsigned long cmd1;
+
 		INIT_COMPLETION(tspi->xfer_completion);
-		ret = tegra_spi_start_transfer_one(spi, xfer,
-					is_first_msg, single_xfer);
+
+		cmd1 = tegra_spi_setup_transfer_one(spi, xfer, is_first_msg);
+
+		if (!xfer->len) {
+			ret = 0;
+			skip = true;
+			goto complete_xfer;
+		}
+
+		ret = tegra_spi_start_transfer_one(spi, xfer, cmd1);
 		if (ret < 0) {
 			dev_err(tspi->dev,
 				"spi can not start transfer, err %d\n", ret);
-			goto exit;
+			goto complete_xfer;
 		}
+
 		is_first_msg = false;
 		ret = wait_for_completion_timeout(&tspi->xfer_completion,
 						SPI_DMA_TIMEOUT);
@@ -833,24 +868,40 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
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
 	msg->status = ret;
 	spi_finalize_current_message(master);
 	return ret;
-- 
1.7.9.5

