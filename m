Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab3CHGXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:23:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1649 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3CHGXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:23:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Mar 2013 22:23:03 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>
CC: <swarren@wwwdotorg.org>, <spi-devel-general@lists.sourceforge.net>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] spi: slink-tegra20: move runtime pm calls to transfer_one_message
Date: Fri, 8 Mar 2013 11:51:19 +0530
Message-ID: <1362723679-1155-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prepare_transfer_hardware() is called in atomic context and
calling synchronous runtime pm calls can create scheduling deadlock.

Therefore, in place of calling runtime PM calls from prepare/unprepare
message transfer, calling this in transfer_one_message().

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/spi/spi-tegra20-slink.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index b8698b3..a829563 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -858,21 +858,6 @@ static int tegra_slink_setup(struct spi_device *spi)
 	return 0;
 }
 
-static int tegra_slink_prepare_transfer(struct spi_master *master)
-{
-	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
-
-	return pm_runtime_get_sync(tspi->dev);
-}
-
-static int tegra_slink_unprepare_transfer(struct spi_master *master)
-{
-	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
-
-	pm_runtime_put(tspi->dev);
-	return 0;
-}
-
 static int tegra_slink_transfer_one_message(struct spi_master *master,
 			struct spi_message *msg)
 {
@@ -885,6 +870,12 @@ static int tegra_slink_transfer_one_message(struct spi_master *master,
 
 	msg->status = 0;
 	msg->actual_length = 0;
+	ret = pm_runtime_get_sync(tspi->dev);
+	if (ret < 0) {
+		dev_err(tspi->dev, "runtime get failed: %d\n", ret);
+		goto done;
+	}
+
 	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		INIT_COMPLETION(tspi->xfer_completion);
@@ -921,6 +912,8 @@ static int tegra_slink_transfer_one_message(struct spi_master *master,
 exit:
 	tegra_slink_writel(tspi, tspi->def_command_reg, SLINK_COMMAND);
 	tegra_slink_writel(tspi, tspi->def_command2_reg, SLINK_COMMAND2);
+	pm_runtime_put(tspi->dev);
+done:
 	msg->status = ret;
 	spi_finalize_current_message(master);
 	return ret;
@@ -1148,9 +1141,7 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 	master->setup = tegra_slink_setup;
-	master->prepare_transfer_hardware = tegra_slink_prepare_transfer;
 	master->transfer_one_message = tegra_slink_transfer_one_message;
-	master->unprepare_transfer_hardware = tegra_slink_unprepare_transfer;
 	master->num_chipselect = MAX_CHIP_SELECT;
 	master->bus_num = -1;
 
-- 
1.7.1.1

