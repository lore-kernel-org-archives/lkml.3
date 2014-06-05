Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaFEWBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:01:07 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:44951 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaFEWBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:01:02 -0400
X-IronPort-AV: E=Sophos;i="4.98,983,1392192000"; 
   d="scan'208";a="32783866"
From: Markus Mayer <markus.mayer@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@gmail.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] mmc: sdhci: Use mmc core regulator infrastucture
Date: Thu, 5 Jun 2014 15:00:03 -0700
Message-ID: <1402005605-24197-2-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402005605-24197-1-git-send-email-markus.mayer@linaro.org>
References: <1402005605-24197-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Kryger <tim.kryger@gmail.com>

Switch the common SDHCI code over to use mmc_host's regulator pointers
and remove the ones in the sdhci_host structure.  Additionally, use the
common mmc_regulator_get_supply function to get the regulators and set
the ocr_avail mask.

This change sets the ocr_avail directly based upon the voltage ranges
supported which ensures ocr_avail is set correctly while allowing the
use of regulators that can't provide exactly 1.8v, 3.0v, or 3.3v.

Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 drivers/mmc/host/sdhci.c  | 97 ++++++++++++++++++-----------------------------
 include/linux/mmc/sdhci.h |  3 --
 2 files changed, 36 insertions(+), 64 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 47055f3..ee524b0 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1223,6 +1223,7 @@ EXPORT_SYMBOL_GPL(sdhci_set_clock);
 static void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
 			    unsigned short vdd)
 {
+	struct mmc_host *mmc = host->mmc;
 	u8 pwr = 0;
 
 	if (mode != MMC_POWER_OFF) {
@@ -1284,9 +1285,9 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
 			mdelay(10);
 	}
 
-	if (host->vmmc) {
+	if (!IS_ERR(mmc->supply.vmmc)) {
 		spin_unlock_irq(&host->lock);
-		mmc_regulator_set_ocr(host->mmc, host->vmmc, vdd);
+		mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, vdd);
 		spin_lock_irq(&host->lock);
 	}
 }
@@ -1440,13 +1441,15 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 {
 	unsigned long flags;
 	u8 ctrl;
+	struct mmc_host *mmc = host->mmc;
 
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (host->flags & SDHCI_DEVICE_DEAD) {
 		spin_unlock_irqrestore(&host->lock, flags);
-		if (host->vmmc && ios->power_mode == MMC_POWER_OFF)
-			mmc_regulator_set_ocr(host->mmc, host->vmmc, 0);
+		if (!IS_ERR(mmc->supply.vmmc) &&
+		    ios->power_mode == MMC_POWER_OFF)
+			mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, 0);
 		return;
 	}
 
@@ -1707,6 +1710,7 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 						struct mmc_ios *ios)
 {
+	struct mmc_host *mmc = host->mmc;
 	u16 ctrl;
 	int ret;
 
@@ -1725,8 +1729,9 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 		ctrl &= ~SDHCI_CTRL_VDD_180;
 		sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);
 
-		if (host->vqmmc) {
-			ret = regulator_set_voltage(host->vqmmc, 2700000, 3600000);
+		if (!IS_ERR(mmc->supply.vqmmc)) {
+			ret = regulator_set_voltage(mmc->supply.vqmmc, 2700000,
+						    3600000);
 			if (ret) {
 				pr_warning("%s: Switching to 3.3V signalling voltage "
 						" failed\n", mmc_hostname(host->mmc));
@@ -1746,8 +1751,8 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_180:
-		if (host->vqmmc) {
-			ret = regulator_set_voltage(host->vqmmc,
+		if (!IS_ERR(mmc->supply.vqmmc)) {
+			ret = regulator_set_voltage(mmc->supply.vqmmc,
 					1700000, 1950000);
 			if (ret) {
 				pr_warning("%s: Switching to 1.8V signalling voltage "
@@ -1776,8 +1781,9 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_120:
-		if (host->vqmmc) {
-			ret = regulator_set_voltage(host->vqmmc, 1100000, 1300000);
+		if (!IS_ERR(mmc->supply.vqmmc)) {
+			ret = regulator_set_voltage(mmc->supply.vqmmc, 1100000,
+						    1300000);
 			if (ret) {
 				pr_warning("%s: Switching to 1.2V signalling voltage "
 						" failed\n", mmc_hostname(host->mmc));
@@ -2962,25 +2968,22 @@ int sdhci_add_host(struct sdhci_host *host)
 	    !(host->mmc->caps & MMC_CAP_NONREMOVABLE))
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
+	/* If there are external regulators, get them */
+	if (mmc_regulator_get_supply(mmc) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
 	/* If vqmmc regulator and no 1.8V signalling, then there's no UHS */
-	host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
-	if (IS_ERR_OR_NULL(host->vqmmc)) {
-		if (PTR_ERR(host->vqmmc) < 0) {
-			pr_info("%s: no vqmmc regulator found\n",
-				mmc_hostname(mmc));
-			host->vqmmc = NULL;
-		}
-	} else {
-		ret = regulator_enable(host->vqmmc);
-		if (!regulator_is_supported_voltage(host->vqmmc, 1700000,
-			1950000))
+	if (!IS_ERR(mmc->supply.vqmmc)) {
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
 
@@ -3041,34 +3044,6 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	ocr_avail = 0;
 
-	host->vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
-	if (IS_ERR_OR_NULL(host->vmmc)) {
-		if (PTR_ERR(host->vmmc) < 0) {
-			pr_info("%s: no vmmc regulator found\n",
-				mmc_hostname(mmc));
-			host->vmmc = NULL;
-		}
-	}
-
-#ifdef CONFIG_REGULATOR
-	/*
-	 * Voltage range check makes sense only if regulator reports
-	 * any voltage value.
-	 */
-	if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
-		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
-			3600000);
-		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
-			caps[0] &= ~SDHCI_CAN_VDD_330;
-		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_300)))
-			caps[0] &= ~SDHCI_CAN_VDD_300;
-		ret = regulator_is_supported_voltage(host->vmmc, 1700000,
-			1950000);
-		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_180)))
-			caps[0] &= ~SDHCI_CAN_VDD_180;
-	}
-#endif /* CONFIG_REGULATOR */
-
 	/*
 	 * According to SD Host Controller spec v3.00, if the Host System
 	 * can afford more than 150mA, Host Driver should set XPC to 1. Also
@@ -3077,8 +3052,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * value.
 	 */
 	max_current_caps = sdhci_readl(host, SDHCI_MAX_CURRENT);
-	if (!max_current_caps && host->vmmc) {
-		u32 curr = regulator_get_current_limit(host->vmmc);
+	if (!max_current_caps && !IS_ERR(mmc->supply.vmmc)) {
+		u32 curr = regulator_get_current_limit(mmc->supply.vmmc);
 		if (curr > 0) {
 
 			/* convert to SDHCI_MAX_CURRENT format */
@@ -3118,8 +3093,11 @@ int sdhci_add_host(struct sdhci_host *host)
 				   SDHCI_MAX_CURRENT_MULTIPLIER;
 	}
 
+	if (mmc->ocr_avail)
+		ocr_avail &= mmc->ocr_avail;
+
 	if (host->ocr_mask)
-		ocr_avail = host->ocr_mask;
+		ocr_avail &= host->ocr_mask;
 
 	mmc->ocr_avail = ocr_avail;
 	mmc->ocr_avail_sdio = ocr_avail;
@@ -3273,6 +3251,7 @@ EXPORT_SYMBOL_GPL(sdhci_add_host);
 
 void sdhci_remove_host(struct sdhci_host *host, int dead)
 {
+	struct mmc_host *mmc = host->mmc;
 	unsigned long flags;
 
 	if (dead) {
@@ -3310,15 +3289,11 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 	tasklet_kill(&host->finish_tasklet);
 
-	if (host->vmmc) {
-		regulator_disable(host->vmmc);
-		regulator_put(host->vmmc);
-	}
+	if (!IS_ERR(mmc->supply.vmmc))
+		regulator_disable(mmc->supply.vmmc);
 
-	if (host->vqmmc) {
-		regulator_disable(host->vqmmc);
-		regulator_put(host->vqmmc);
-	}
+	if (!IS_ERR(mmc->supply.vqmmc))
+		regulator_disable(mmc->supply.vqmmc);
 
 	if (host->adma_desc)
 		dma_free_coherent(mmc_dev(host->mmc), ADMA_SIZE,
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 08abe99..09ebe57 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -104,9 +104,6 @@ struct sdhci_host {
 
 	const struct sdhci_ops *ops;	/* Low level hw interface */
 
-	struct regulator *vmmc;		/* Power regulator (vmmc) */
-	struct regulator *vqmmc;	/* Signaling regulator (vccq) */
-
 	/* Internal data */
 	struct mmc_host *mmc;	/* MMC structure */
 	u64 dma_mask;		/* custom DMA mask */
-- 
1.9.1

