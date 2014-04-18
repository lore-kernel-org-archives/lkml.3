Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaDRAr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:47:28 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:1699 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaDRArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:47:22 -0400
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="24879142"
From: Tim Kryger <tim.kryger@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] mmc: sdhci: Use common mmc_regulator_get_supply
Date: Thu, 17 Apr 2014 17:47:01 -0700
Message-ID: <1397782021-31396-3-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397782021-31396-1-git-send-email-tim.kryger@linaro.org>
References: <1397782021-31396-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace some buggy code with a call to mmc_regulator_get_supply.

When external regulator provides VDD, ocr_avail is set directly based on
the supported voltage range.  This allows for the use of regulators that
can't provide exactly 1.8v, 3.0v, or 3.3v.  Commit cec2e21 had attempted
to address this by relaxing the range checks in the SDHCI driver but it
set the capabilities as an intermediate step which meant ocr_avail could
get bits set for unsupported voltages.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/mmc/host/sdhci.c |   67 +++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 49 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 16fba66..2d081d8 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1438,7 +1438,8 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 
 	if (host->flags & SDHCI_DEVICE_DEAD) {
 		spin_unlock_irqrestore(&host->lock, flags);
-		if (mmc->supply.vmmc && ios->power_mode == MMC_POWER_OFF)
+		if (!IS_ERR(mmc->supply.vmmc) &&
+		    ios->power_mode == MMC_POWER_OFF)
 			mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, 0);
 		return;
 	}
@@ -1464,7 +1465,7 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 	else
 		vdd_bit = sdhci_set_power(host, ios->vdd);
 
-	if (mmc->supply.vmmc && vdd_bit != -1) {
+	if (!IS_ERR(mmc->supply.vmmc) && vdd_bit != -1) {
 		spin_unlock_irqrestore(&host->lock, flags);
 		mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, vdd_bit);
 		spin_lock_irqsave(&host->lock, flags);
@@ -1762,7 +1763,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 		ctrl &= ~SDHCI_CTRL_VDD_180;
 		sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);
 
-		if (mmc->supply.vqmmc) {
+		if (!IS_ERR(mmc->supply.vqmmc)) {
 			ret = regulator_set_voltage(mmc->supply.vqmmc, 2700000,
 						    3600000);
 			if (ret) {
@@ -1784,7 +1785,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_180:
-		if (mmc->supply.vqmmc) {
+		if (!IS_ERR(mmc->supply.vqmmc)) {
 			ret = regulator_set_voltage(mmc->supply.vqmmc,
 					1700000, 1950000);
 			if (ret) {
@@ -1814,7 +1815,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_120:
-		if (mmc->supply.vqmmc) {
+		if (!IS_ERR(mmc->supply.vqmmc)) {
 			ret = regulator_set_voltage(mmc->supply.vqmmc, 1100000,
 						    1300000);
 			if (ret) {
@@ -2979,15 +2980,12 @@ int sdhci_add_host(struct sdhci_host *host)
 	    !(host->mmc->caps & MMC_CAP_NONREMOVABLE))
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
+	/* If there are external regulators, get them */
+	if (mmc_regulator_get_supply(mmc) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
 	/* If vqmmc regulator and no 1.8V signalling, then there's no UHS */
-	mmc->supply.vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
-	if (IS_ERR_OR_NULL(mmc->supply.vqmmc)) {
-		if (PTR_ERR(mmc->supply.vqmmc) < 0) {
-			pr_info("%s: no vqmmc regulator found\n",
-				mmc_hostname(mmc));
-			mmc->supply.vqmmc = NULL;
-		}
-	} else {
+	if (!IS_ERR(mmc->supply.vqmmc)) {
 		ret = regulator_enable(mmc->supply.vqmmc);
 		if (!regulator_is_supported_voltage(mmc->supply.vqmmc, 1700000,
 						    1950000))
@@ -3058,34 +3056,6 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	ocr_avail = 0;
 
-	mmc->supply.vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
-	if (IS_ERR_OR_NULL(mmc->supply.vmmc)) {
-		if (PTR_ERR(mmc->supply.vmmc) < 0) {
-			pr_info("%s: no vmmc regulator found\n",
-				mmc_hostname(mmc));
-			mmc->supply.vmmc = NULL;
-		}
-	}
-
-#ifdef CONFIG_REGULATOR
-	/*
-	 * Voltage range check makes sense only if regulator reports
-	 * any voltage value.
-	 */
-	if (mmc->supply.vmmc && regulator_get_voltage(mmc->supply.vmmc) > 0) {
-		ret = regulator_is_supported_voltage(mmc->supply.vmmc, 2700000,
-			3600000);
-		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
-			caps[0] &= ~SDHCI_CAN_VDD_330;
-		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_300)))
-			caps[0] &= ~SDHCI_CAN_VDD_300;
-		ret = regulator_is_supported_voltage(mmc->supply.vmmc, 1700000,
-			1950000);
-		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_180)))
-			caps[0] &= ~SDHCI_CAN_VDD_180;
-	}
-#endif /* CONFIG_REGULATOR */
-
 	/*
 	 * According to SD Host Controller spec v3.00, if the Host System
 	 * can afford more than 150mA, Host Driver should set XPC to 1. Also
@@ -3094,7 +3064,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * value.
 	 */
 	max_current_caps = sdhci_readl(host, SDHCI_MAX_CURRENT);
-	if (!max_current_caps && mmc->supply.vmmc) {
+	if (!max_current_caps && !IS_ERR(mmc->supply.vmmc)) {
 		u32 curr = regulator_get_current_limit(mmc->supply.vmmc);
 		if (curr > 0) {
 
@@ -3135,8 +3105,11 @@ int sdhci_add_host(struct sdhci_host *host)
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
@@ -3330,15 +3303,11 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 	tasklet_kill(&host->card_tasklet);
 	tasklet_kill(&host->finish_tasklet);
 
-	if (mmc->supply.vmmc) {
+	if (!IS_ERR(mmc->supply.vmmc))
 		regulator_disable(mmc->supply.vmmc);
-		regulator_put(mmc->supply.vmmc);
-	}
 
-	if (mmc->supply.vqmmc) {
+	if (!IS_ERR(mmc->supply.vqmmc))
 		regulator_disable(mmc->supply.vqmmc);
-		regulator_put(mmc->supply.vqmmc);
-	}
 
 	kfree(host->adma_desc);
 	kfree(host->align_buffer);
-- 
1.7.9.5

