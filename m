Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaE1Nqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:46:36 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60400 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaE1Nqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:46:33 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4 04/13] mmc: mmci: Add enough delay between writes to CMD register.
Date: Wed, 28 May 2014 14:46:26 +0100
Message-Id: <1401284786-16604-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

On Qcom SD Card controller POWER, CLKCTRL, DATACTRL and COMMAND registers
should be updated in MCLK domain, and writes to these registers must be
separated by three MCLK cycles. This resitriction is not applicable for
other registers. Any subsequent writes to these register will be ignored
until 3 MCLK have passed.

One usec delay between two CMD register writes is not sufficient in the
card identification phase where the CCLK is very low. This patch replaces
a static 1 usec delay to use mmci_reg_delay function which can provide
correct delay depending on the cclk frequency.

Without this patch the card is not detected.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 86f25a9..aa2d381 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -818,7 +818,7 @@ mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
 
 	if (readl(base + MMCICOMMAND) & MCI_CPSM_ENABLE) {
 		writel(0, base + MMCICOMMAND);
-		udelay(1);
+		mmci_reg_delay(host);
 	}
 
 	c |= cmd->opcode | MCI_CPSM_ENABLE;
-- 
1.9.1

