Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaHLME6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:04:58 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35141 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaHLME4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:04:56 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
X-Google-Original-From: Srinivas Kandagatla <srinivas.kandadgatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 3/5] mmc: mmci: relax blksz check for SDIO
Date: Tue, 12 Aug 2014 13:04:40 +0100
Message-Id: <1407845080-8353-1-git-send-email-srinivas.kandadgatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds condition in mmci_validate_data to skip checking
blocksize for SDIO card types. SDIO card type can issue blocksizes
which are not exactly power of 2 so this check always fails, resulting
in SDIO failures.

Relaxing this check for SDIO in mmci_validate_data solves the issue
encountered during WLAN ath6kl testing with Qualcomm APQ8064 SOC on
IFC6410 board.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 99fe80a..747aba0 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -240,6 +240,10 @@ static int mmci_validate_data(struct mmci_host *host,
 	if (!data)
 		return 0;
 
+	/* sdio could have sizes which are not power of 2 */
+	if (host->mmc->card && mmc_card_sdio(host->mmc->card))
+		return 0;
+
 	if (!is_power_of_2(data->blksz)) {
 		dev_err(mmc_dev(host->mmc),
 			"unsupported block size (%d bytes)\n", data->blksz);
-- 
1.9.1

