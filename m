Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaDRArZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:47:25 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49510 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDRArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:47:22 -0400
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="25071026"
From: Tim Kryger <tim.kryger@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] mmc: sdhci: Use supplies in common mmc_host struct
Date: Thu, 17 Apr 2014 17:47:00 -0700
Message-ID: <1397782021-31396-2-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397782021-31396-1-git-send-email-tim.kryger@linaro.org>
References: <1397782021-31396-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the common SDHCI code over to use mmc_host's regulator pointers
and remove the ones in the sdhci_host structure.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/mmc/host/sdhci.c  |   71 ++++++++++++++++++++++++---------------------
 include/linux/mmc/sdhci.h |    3 --
 2 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9a79fc4..16fba66 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1429,6 +1429,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 {
+	struct mmc_host *mmc = host->mmc;
 	unsigned long flags;
 	int vdd_bit = -1;
 	u8 ctrl;
@@ -1437,8 +1438,8 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 
 	if (host->flags & SDHCI_DEVICE_DEAD) {
 		spin_unlock_irqrestore(&host->lock, flags);
-		if (host->vmmc && ios->power_mode == MMC_POWER_OFF)
-			mmc_regulator_set_ocr(host->mmc, host->vmmc, 0);
+		if (mmc->supply.vmmc && ios->power_mode == MMC_POWER_OFF)
+			mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, 0);
 		return;
 	}
 
@@ -1463,9 +1464,9 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 	else
 		vdd_bit = sdhci_set_power(host, ios->vdd);
 
-	if (host->vmmc && vdd_bit != -1) {
+	if (mmc->supply.vmmc && vdd_bit != -1) {
 		spin_unlock_irqrestore(&host->lock, flags);
-		mmc_regulator_set_ocr(host->mmc, host->vmmc, vdd_bit);
+		mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, vdd_bit);
 		spin_lock_irqsave(&host->lock, flags);
 	}
 
@@ -1742,6 +1743,7 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 						struct mmc_ios *ios)
 {
+	struct mmc_host *mmc = host->mmc;
 	u16 ctrl;
 	int ret;
 
@@ -1760,8 +1762,9 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 		ctrl &= ~SDHCI_CTRL_VDD_180;
 		sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);
 
-		if (host->vqmmc) {
-			ret = regulator_set_voltage(host->vqmmc, 2700000, 3600000);
+		if (mmc->supply.vqmmc) {
+			ret = regulator_set_voltage(mmc->supply.vqmmc, 2700000,
+						    3600000);
 			if (ret) {
 				pr_warning("%s: Switching to 3.3V signalling voltage "
 						" failed\n", mmc_hostname(host->mmc));
@@ -1781,8 +1784,8 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_180:
-		if (host->vqmmc) {
-			ret = regulator_set_voltage(host->vqmmc,
+		if (mmc->supply.vqmmc) {
+			ret = regulator_set_voltage(mmc->supply.vqmmc,
 					1700000, 1950000);
 			if (ret) {
 				pr_warning("%s: Switching to 1.8V signalling voltage "
@@ -1811,8 +1814,9 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_120:
-		if (host->vqmmc) {
-			ret = regulator_set_voltage(host->vqmmc, 1100000, 1300000);
+		if (mmc->supply.vqmmc) {
+			ret = regulator_set_voltage(mmc->supply.vqmmc, 1100000,
+						    1300000);
 			if (ret) {
 				pr_warning("%s: Switching to 1.2V signalling voltage "
 						" failed\n", mmc_hostname(host->mmc));
@@ -2976,24 +2980,24 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
 	/* If vqmmc regulator and no 1.8V signalling, then there's no UHS */
-	host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
-	if (IS_ERR_OR_NULL(host->vqmmc)) {
-		if (PTR_ERR(host->vqmmc) < 0) {
+	mmc->supply.vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
+	if (IS_ERR_OR_NULL(mmc->supply.vqmmc)) {
+		if (PTR_ERR(mmc->supply.vqmmc) < 0) {
 			pr_info("%s: no vqmmc regulator found\n",
 				mmc_hostname(mmc));
-			host->vqmmc = NULL;
+			mmc->supply.vqmmc = NULL;
 		}
 	} else {
-		ret = regulator_enable(host->vqmmc);
-		if (!regulator_is_supported_voltage(host->vqmmc, 1700000,
-			1950000))
+		ret = regulator_enable(mmc->supply.vqmmc);
+		if (!regulator_is_supported_voltage(mmc->supply.vqmmc, 1700000,
+						    1950000))
 			caps[1] &= ~(SDHCI_SUPPORT_SDR104 |
 					SDHCI_SUPPORT_SDR50 |
 					SDHCI_SUPPORT_DDR50);
 		if (ret) {
 			pr_warn("%s: Failed to enable vqmmc regulator: %d\n",
 				mmc_hostname(mmc), ret);
-			host->vqmmc = NULL;
+			mmc->supply.vqmmc = NULL;
 		}
 	}
 
@@ -3054,12 +3058,12 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	ocr_avail = 0;
 
-	host->vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
-	if (IS_ERR_OR_NULL(host->vmmc)) {
-		if (PTR_ERR(host->vmmc) < 0) {
+	mmc->supply.vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
+	if (IS_ERR_OR_NULL(mmc->supply.vmmc)) {
+		if (PTR_ERR(mmc->supply.vmmc) < 0) {
 			pr_info("%s: no vmmc regulator found\n",
 				mmc_hostname(mmc));
-			host->vmmc = NULL;
+			mmc->supply.vmmc = NULL;
 		}
 	}
 
@@ -3068,14 +3072,14 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * Voltage range check makes sense only if regulator reports
 	 * any voltage value.
 	 */
-	if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
-		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
+	if (mmc->supply.vmmc && regulator_get_voltage(mmc->supply.vmmc) > 0) {
+		ret = regulator_is_supported_voltage(mmc->supply.vmmc, 2700000,
 			3600000);
 		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
 			caps[0] &= ~SDHCI_CAN_VDD_330;
 		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_300)))
 			caps[0] &= ~SDHCI_CAN_VDD_300;
-		ret = regulator_is_supported_voltage(host->vmmc, 1700000,
+		ret = regulator_is_supported_voltage(mmc->supply.vmmc, 1700000,
 			1950000);
 		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_180)))
 			caps[0] &= ~SDHCI_CAN_VDD_180;
@@ -3090,8 +3094,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * value.
 	 */
 	max_current_caps = sdhci_readl(host, SDHCI_MAX_CURRENT);
-	if (!max_current_caps && host->vmmc) {
-		u32 curr = regulator_get_current_limit(host->vmmc);
+	if (!max_current_caps && mmc->supply.vmmc) {
+		u32 curr = regulator_get_current_limit(mmc->supply.vmmc);
 		if (curr > 0) {
 
 			/* convert to SDHCI_MAX_CURRENT format */
@@ -3288,6 +3292,7 @@ EXPORT_SYMBOL_GPL(sdhci_add_host);
 
 void sdhci_remove_host(struct sdhci_host *host, int dead)
 {
+	struct mmc_host *mmc = host->mmc;
 	unsigned long flags;
 
 	if (dead) {
@@ -3325,14 +3330,14 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 	tasklet_kill(&host->card_tasklet);
 	tasklet_kill(&host->finish_tasklet);
 
-	if (host->vmmc) {
-		regulator_disable(host->vmmc);
-		regulator_put(host->vmmc);
+	if (mmc->supply.vmmc) {
+		regulator_disable(mmc->supply.vmmc);
+		regulator_put(mmc->supply.vmmc);
 	}
 
-	if (host->vqmmc) {
-		regulator_disable(host->vqmmc);
-		regulator_put(host->vqmmc);
+	if (mmc->supply.vqmmc) {
+		regulator_disable(mmc->supply.vqmmc);
+		regulator_put(mmc->supply.vqmmc);
 	}
 
 	kfree(host->adma_desc);
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 7be12b8..0e3c3f8 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -108,9 +108,6 @@ struct sdhci_host {
 
 	const struct sdhci_ops *ops;	/* Low level hw interface */
 
-	struct regulator *vmmc;		/* Power regulator (vmmc) */
-	struct regulator *vqmmc;	/* Signaling regulator (vccq) */
-
 	/* Internal data */
 	struct mmc_host *mmc;	/* MMC structure */
 	u64 dma_mask;		/* custom DMA mask */
-- 
1.7.9.5

