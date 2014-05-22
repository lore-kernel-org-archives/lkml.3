Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaEVQBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:01:47 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:42102 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEVQBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:01:46 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v3 1/2] mmc: tegra: disable UHS modes
Date: Thu, 22 May 2014 08:55:35 -0700
Message-Id: <1400774136-12396-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Program TEGRA_SDHCI_VENDOR_MISC_CTRL so that UHS modes aren't advertised
in SDHCI_CAPABILITIES_1.  While the Tegra SDHCI controller does support
these modes, they require Tegra-specific tuning and calibration routines
which the driver does not support yet.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
Changes from v2:
 - rebased on mmc-next
No changes from v1
---
 drivers/mmc/host/sdhci-tegra.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 9852476..4375cd4 100644
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
@@ -100,20 +106,25 @@ static void tegra_sdhci_reset(struct sdhci_host *host, u8 mask)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_tegra *tegra_host = pltfm_host->priv;
 	const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
+	u32 misc_ctrl;
 
 	sdhci_reset(host, mask);
 
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
 
 static void tegra_sdhci_set_bus_width(struct sdhci_host *host, int bus_width)
@@ -170,7 +181,9 @@ static const struct sdhci_pltfm_data sdhci_tegra30_pdata = {
 
 static struct sdhci_tegra_soc_data soc_data_tegra30 = {
 	.pdata = &sdhci_tegra30_pdata,
-	.nvquirks = NVQUIRK_ENABLE_SDHCI_SPEC_300,
+	.nvquirks = NVQUIRK_ENABLE_SDHCI_SPEC_300 |
+		    NVQUIRK_DISABLE_SDR50 |
+		    NVQUIRK_DISABLE_SDR104,
 };
 
 static const struct sdhci_pltfm_data sdhci_tegra114_pdata = {
@@ -184,6 +197,9 @@ static const struct sdhci_pltfm_data sdhci_tegra114_pdata = {
 
 static struct sdhci_tegra_soc_data soc_data_tegra114 = {
 	.pdata = &sdhci_tegra114_pdata,
+	.nvquirks = NVQUIRK_DISABLE_SDR50 |
+		    NVQUIRK_DISABLE_DDR50 |
+		    NVQUIRK_DISABLE_SDR104,
 };
 
 static const struct of_device_id sdhci_tegra_dt_match[] = {
-- 
1.9.1.423.g4596e3a

