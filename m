Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaFYH0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:26:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38624 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaFYH0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:26:00 -0400
From: Tim Kryger <tim.kryger@gmail.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Sachin Kamat <spk.linux@gmail.com>
Cc: Tim Kryger <tim.kryger@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdhci: Improve external VDD regulator support
Date: Wed, 25 Jun 2014 00:25:34 -0700
Message-Id: <1403681134-12616-1-git-send-email-tim.kryger@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A standard compliant SDHCI can itself supply VDD at 1.8, 3.0, or 3.3v.
Several vendors ignore this and instead rely upon external regulators
to supply VDD.  While the external regulators typically can supply one
of the standard SDHCI voltage levels, there is no real reason for this
to be a hard requirement.

This patch alters the SDHCI driver such that external VDD regulators
that provide voltages other than the three mentioned above may be used
so long as they can supply a voltage that meets the needs of the card.

In the case that an external VDD regulator is provided, it is reasonable
to ignore the voltage capabilities of the host controller and allow the
external regulator to set the OCR mask.  Additionally, there is no need
to convert a VDD voltage request into one of the standard SDHCI voltage
levels or program it in the host controller's power control register.

Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
Tested-by: Sachin Kamat <spk.linux@gmail.com>
---

This change corrects a regression observed on Exynos platforms that was
triggered by "mmc: sdhci: Use mmc core regulator infrastucture"

https://www.mail-archive.com/linux-mmc@vger.kernel.org/msg27101.html

 drivers/mmc/host/sdhci.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index c23a872..07a2426 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1226,6 +1226,13 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
 	struct mmc_host *mmc = host->mmc;
 	u8 pwr = 0;
 
+	if (!IS_ERR(mmc->supply.vmmc)) {
+		spin_unlock_irq(&host->lock);
+		mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, vdd);
+		spin_lock_irq(&host->lock);
+		return;
+	}
+
 	if (mode != MMC_POWER_OFF) {
 		switch (1 << vdd) {
 		case MMC_VDD_165_195:
@@ -1284,12 +1291,6 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
 		if (host->quirks & SDHCI_QUIRK_DELAY_AFTER_POWER)
 			mdelay(10);
 	}
-
-	if (!IS_ERR(mmc->supply.vmmc)) {
-		spin_unlock_irq(&host->lock);
-		mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, vdd);
-		spin_lock_irq(&host->lock);
-	}
 }
 
 /*****************************************************************************\
@@ -3092,8 +3093,9 @@ int sdhci_add_host(struct sdhci_host *host)
 				   SDHCI_MAX_CURRENT_MULTIPLIER;
 	}
 
+	/* If OCR set by external regulators, use it instead */
 	if (mmc->ocr_avail)
-		ocr_avail &= mmc->ocr_avail;
+		ocr_avail = mmc->ocr_avail;
 
 	if (host->ocr_mask)
 		ocr_avail &= host->ocr_mask;
-- 
1.7.9.5

