Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaHLMEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:04:31 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60682 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaHLMEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:04:30 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
X-Google-Original-From: Srinivas Kandagatla <srinivas.kandadgatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 2/5] mmc: mmci: move block size validation under relevant code
Date: Tue, 12 Aug 2014 13:03:49 +0100
Message-Id: <1407845029-8271-1-git-send-email-srinivas.kandadgatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

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
index 8641572..99fe80a 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -793,15 +793,16 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
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

