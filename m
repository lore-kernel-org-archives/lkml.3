Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaDOBm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:42:57 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53019 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaDOBmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:42:52 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 1/4] mmc: tegra: disable UHS modes
Date: Mon, 14 Apr 2014 18:42:40 -0700
Message-Id: <1397526163-20126-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Program TEGRA_SDHCI_VENDOR_MISC_CTRL so that UHS modes aren't advertised
in SDHCI_CAPABILITIES_1.  While the Tegra SDHCI controller does support
these modes, they require Tegra-specific tuning and calibration routines
which the driver does not support yet.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/mmc/host/sdhci-tegra.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index a835898..3cadd9c 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -32,11 +32,17 @@
 
 /* Tegra SDHOST controller vendor register definitions */
 #define SDHCI_TEGRA_VENDOR_MISC_CTRL		0x120
+#define SDHCI_MISC_CTRL_ENABLE_SDR104		0x8
+#define SDHCI_MISC_CTRL_ENABLE_SDR50		0x10
 #define SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300	0x20
+#define SDHCI_MISC_CTRL_ENABLE_DDR50		0x200
 
 #define NVQUIRK_FORCE_SDHCI_SPEC_200	BIT(0)
 #define NVQUIRK_ENABLE_BLOCK_GAP_DET	BIT(1)
 #define NVQUIRK_ENABLE_SDHCI_SPEC_300	BIT(2)
+#define NVQUIRK_DISABLE_SDR50		BIT(3)
+#define NVQUIRK_DISABLE_SDR104		BIT(4)
+#define NVQUIRK_DISABLE_DDR50		BIT(5)
 
 struct sdhci_tegra_soc_data {
 	const struct sdhci_pltfm_data *pdata;
@@ -113,18 +119,23 @@ static void tegra_sdhci_reset_exit(struct sdhci_host *host, u8 mask)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_tegra *tegra_host = pltfm_host->priv;
 	const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
+	u32 misc_ctrl;
 
 	if (!(mask & SDHCI_RESET_ALL))
 		return;
 
+	misc_ctrl = sdhci_readw(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
 	/* Erratum: Enable SDHCI spec v3.00 support */
-	if (soc_data->nvquirks & NVQUIRK_ENABLE_SDHCI_SPEC_300) {
-		u32 misc_ctrl;
-
-		misc_ctrl = sdhci_readb(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
+	if (soc_data->nvquirks & NVQUIRK_ENABLE_SDHCI_SPEC_300)
 		misc_ctrl |= SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300;
-		sdhci_writeb(host, misc_ctrl, SDHCI_TEGRA_VENDOR_MISC_CTRL);
-	}
+	/* Don't advertise UHS modes which aren't supported yet */
+	if (soc_data->nvquirks & NVQUIRK_DISABLE_SDR50)
+		misc_ctrl &= ~SDHCI_MISC_CTRL_ENABLE_SDR50;
+	if (soc_data->nvquirks & NVQUIRK_DISABLE_DDR50)
+		misc_ctrl &= ~SDHCI_MISC_CTRL_ENABLE_DDR50;
+	if (soc_data->nvquirks & NVQUIRK_DISABLE_SDR104)
+		misc_ctrl &= ~SDHCI_MISC_CTRL_ENABLE_SDR104;
+	sdhci_writew(host, misc_ctrl, SDHCI_TEGRA_VENDOR_MISC_CTRL);
 }
 
 static int tegra_sdhci_buswidth(struct sdhci_host *host, int bus_width)
@@ -181,7 +192,9 @@ static const struct sdhci_pltfm_data sdhci_tegra30_pdata = {
 
 static struct sdhci_tegra_soc_data soc_data_tegra30 = {
 	.pdata = &sdhci_tegra30_pdata,
-	.nvquirks = NVQUIRK_ENABLE_SDHCI_SPEC_300,
+	.nvquirks = NVQUIRK_ENABLE_SDHCI_SPEC_300 |
+		    NVQUIRK_DISABLE_SDR50 |
+		    NVQUIRK_DISABLE_SDR104,
 };
 
 static const struct sdhci_pltfm_data sdhci_tegra114_pdata = {
@@ -195,6 +208,9 @@ static const struct sdhci_pltfm_data sdhci_tegra114_pdata = {
 
 static struct sdhci_tegra_soc_data soc_data_tegra114 = {
 	.pdata = &sdhci_tegra114_pdata,
+	.nvquirks = NVQUIRK_DISABLE_SDR50 |
+		    NVQUIRK_DISABLE_DDR50 |
+		    NVQUIRK_DISABLE_SDR104,
 };
 
 static const struct of_device_id sdhci_tegra_dt_match[] = {
-- 
1.9.1.423.g4596e3a

