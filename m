Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaHSLO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:14:58 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33021 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaHSLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:14:55 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 2/4] mmc: mmci: move block size validation under relevant code
Date: Tue, 19 Aug 2014 12:14:26 +0100
Message-Id: <1408446866-1649-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code moves a BUG_ON condition to relevant if block, this check is
not necessary for IPs which can set any arbitrary block size in a given
range.
This patch is necessary for SDIO which sets block sizes that are exactly
not power of 2.

Original issue detected while testing WLAN ath6kl on Qualcomm APQ8064 SOC.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 3089fba..1c99195 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -800,15 +800,16 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	writel(timeout, base + MMCIDATATIMER);
 	writel(host->size, base + MMCIDATALENGTH);
 
-	blksz_bits = ffs(data->blksz) - 1;
-	BUG_ON(1 << blksz_bits != data->blksz);
 
-	if (variant->blksz_datactrl16)
+	if (variant->blksz_datactrl16) {
 		datactrl = MCI_DPSM_ENABLE | (data->blksz << 16);
-	else if (variant->blksz_datactrl4)
+	} else if (variant->blksz_datactrl4) {
 		datactrl = MCI_DPSM_ENABLE | (data->blksz << 4);
-	else
+	} else {
+		blksz_bits = ffs(data->blksz) - 1;
+		BUG_ON(1 << blksz_bits != data->blksz);
 		datactrl = MCI_DPSM_ENABLE | blksz_bits << 4;
+	}
 
 	if (data->flags & MMC_DATA_READ)
 		datactrl |= MCI_DPSM_DIRECTION;
-- 
1.9.1

