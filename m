Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbbANGYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:24:48 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53567 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbANGYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:24:47 -0500
From: Tim Kryger <tim.kryger@gmail.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Tim Kryger <tim.kryger@gmail.com>, Alexandre Courbot <gnurou@gmail.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        Linux MMC List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: sdhci: Set SDHCI_POWER_ON with external vmmc
Date: Tue, 13 Jan 2015 22:24:12 -0800
Message-Id: <1421216652-348-1-git-send-email-tim.kryger@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Host controllers lacking the required internal vmmc regulator may still
follow the spec with regard to the LSB of SDHCI_POWER_CONTROL.  Set the
SDHCI_POWER_ON bit when vmmc is enabled to encourage the controller to
to drive CMD, DAT, SDCLK.

This fixes a regression observed on some Qualcomm and Nvidia boards
caused by 5222161 mmc: sdhci: Improve external VDD regulator support.

Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
Tested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/mmc/host/sdhci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index ada1a3e..59a328a 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1239,6 +1239,12 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned char mode,
 		spin_unlock_irq(&host->lock);
 		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
 		spin_lock_irq(&host->lock);
+
+		if (mode != MMC_POWER_OFF)
+			sdhci_writeb(host, SDHCI_POWER_ON, SDHCI_POWER_CONTROL);
+		else
+			sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
+
 		return;
 	}
 
-- 
1.9.1

