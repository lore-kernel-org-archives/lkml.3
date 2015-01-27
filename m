Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbbA0RXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:23:19 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17632 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbbA0RXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:23:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 27 Jan 2015 09:13:10 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: <ulf.hansson@linaro.org>, <chris@printf.net>
CC: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pkunapuli@nvidia.com>, <gnurou@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH] mmc: tegra: Write xfer_mode, CMD regs in together
Date: Tue, 27 Jan 2015 12:23:30 -0500
Message-ID: <1422379410-7127-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Kunapuli <pkunapuli@nvidia.com>

If there is a gap between xfer mode and command register writes,
tegra SDMMC controller can sometimes issue a spurious command before
the CMD register is written. To avoid this, these two registers need
to be written together in a single write operation.

Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 59797106af93..3d34de47e57e 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -41,6 +41,7 @@
 #define NVQUIRK_DISABLE_SDR50		BIT(3)
 #define NVQUIRK_DISABLE_SDR104		BIT(4)
 #define NVQUIRK_DISABLE_DDR50		BIT(5)
+#define NVQUIRK_SHADOW_XFER_MODE_REG	BIT(6)
 
 struct sdhci_tegra_soc_data {
 	const struct sdhci_pltfm_data *pdata;
@@ -67,6 +68,32 @@ static u16 tegra_sdhci_readw(struct sdhci_host *host, int reg)
 	return readw(host->ioaddr + reg);
 }
 
+static void tegra_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_tegra *tegra_host = pltfm_host->priv;
+	const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
+
+	if (soc_data->nvquirks * NVQUIRK_SHADOW_XFER_MODE_REG) {
+		switch (reg) {
+		case SDHCI_TRANSFER_MODE:
+			/*
+			 * Postpone this write, we must do it together with a
+			 * command write that is down below.
+			 */
+			pltfm_host->xfer_mode_shadow = val;
+			return;
+		case SDHCI_COMMAND:
+			writel((val << 16) | pltfm_host->xfer_mode_shadow,
+				host->ioaddr + SDHCI_TRANSFER_MODE);
+			pltfm_host->xfer_mode_shadow = 0;
+			return;
+		}
+	}
+
+	writew(val, host->ioaddr + reg);
+}
+
 static void tegra_sdhci_writel(struct sdhci_host *host, u32 val, int reg)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
@@ -147,6 +174,7 @@ static void tegra_sdhci_set_bus_width(struct sdhci_host *host, int bus_width)
 static const struct sdhci_ops tegra_sdhci_ops = {
 	.get_ro     = tegra_sdhci_get_ro,
 	.read_w     = tegra_sdhci_readw,
+	.write_w    = tegra_sdhci_writew,
 	.write_l    = tegra_sdhci_writel,
 	.set_clock  = sdhci_set_clock,
 	.set_bus_width = tegra_sdhci_set_bus_width,
@@ -201,7 +229,8 @@ static struct sdhci_tegra_soc_data soc_data_tegra114 = {
 	.pdata = &sdhci_tegra114_pdata,
 	.nvquirks = NVQUIRK_DISABLE_SDR50 |
 		    NVQUIRK_DISABLE_DDR50 |
-		    NVQUIRK_DISABLE_SDR104,
+		    NVQUIRK_DISABLE_SDR104 |
+		    NVQUIRK_SHADOW_XFER_MODE_REG,
 };
 
 static const struct of_device_id sdhci_tegra_dt_match[] = {
-- 
1.7.9.5

