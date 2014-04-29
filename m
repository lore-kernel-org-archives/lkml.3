Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbaD2IU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:20:28 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42098 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038AbaD2IUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:20:23 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 06/11] mmc: mmci: Qcomm: Add 3 clock cycle delay after register write
Date: Tue, 29 Apr 2014 09:20:14 +0100
Message-Id: <1398759614-13217-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Most of the Qcomm SD card controller registers must be updated to the MCLK
domain so subsequent writes to registers will be ignored until 3 clock cycles
have passed.

This patch adds a 3 clock cycle delay required after writing to controller
registers on Qualcomm SOCs. Without this delay all the register writes are not
successfull, resulting in not detecting cards.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 4f8d0ba..f73dc48 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -179,6 +179,14 @@ static inline u32 mmci_readl(struct mmci_host *host, u32 off)
 static inline void mmci_writel(struct mmci_host *host, u32 data, u32 off)
 {
 	writel(data, host->base + off);
+
+	/*
+	 * On QCom SD card controller, registers must be updated to the
+	 * MCLK domain so subsequent writes to this register will be ignored
+	 * for 3 clk cycles.
+	 */
+	if (host->hw_designer == AMBA_VENDOR_QCOM)
+		udelay(1 + ((3 * USEC_PER_SEC)/host->mclk));
 }
 
 static int mmci_card_busy(struct mmc_host *mmc)
-- 
1.7.9.5

