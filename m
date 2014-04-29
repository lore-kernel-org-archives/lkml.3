Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaD2IUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:20:40 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40619 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbaD2IUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:20:34 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 07/11] mmc: mmci: move ST specific register extensions access under condition.
Date: Tue, 29 Apr 2014 09:20:27 +0100
Message-Id: <1398759627-13256-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch moves some of the ST specific register extensions access under
condition, so that other SOCs like Qualcomm or ARM would not a side effect of
writing to those reserved/different purpose bits.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index f73dc48..306e0c8 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -269,7 +269,8 @@ static void mmci_write_pwrreg(struct mmci_host *host, u32 pwr)
 static void mmci_write_datactrlreg(struct mmci_host *host, u32 datactrl)
 {
 	/* Keep ST Micro busy mode if enabled */
-	datactrl |= host->datactrl_reg & MCI_ST_DPSM_BUSYMODE;
+	if (host->hw_designer == AMBA_VENDOR_ST)
+		datactrl |= host->datactrl_reg & MCI_ST_DPSM_BUSYMODE;
 
 	if (host->datactrl_reg != datactrl) {
 		host->datactrl_reg = datactrl;
@@ -815,7 +816,8 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 			mmci_write_clkreg(host, clk);
 		}
 
-	if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
+	if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50 &&
+	    host->hw_designer == AMBA_VENDOR_ST)
 		datactrl |= MCI_ST_DPSM_DDRMODE;
 
 	/*
-- 
1.7.9.5

