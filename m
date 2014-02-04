Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaBDQEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:04:44 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:33212 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbaBDP71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:27 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 03/17] mmc: mmci: Mask IRQs for all variants during runtime suspend
Date: Tue,  4 Feb 2014 16:58:44 +0100
Message-Id: <1391529538-21685-4-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In runtime suspended state, we are not expecting IRQs and thus we can
safely mask them, not only for pwrreg_nopower variants but for all.

Obviously we then also need to make sure we restore the IRQ mask while
becoming runtime resumed.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/mmci.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index b931226..178868a 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1758,35 +1758,34 @@ static void mmci_save(struct mmci_host *host)
 {
 	unsigned long flags;
 
-	if (host->variant->pwrreg_nopower) {
-		spin_lock_irqsave(&host->lock, flags);
+	spin_lock_irqsave(&host->lock, flags);
 
-		writel(0, host->base + MMCIMASK0);
+	writel(0, host->base + MMCIMASK0);
+	if (host->variant->pwrreg_nopower) {
 		writel(0, host->base + MMCIDATACTRL);
 		writel(0, host->base + MMCIPOWER);
 		writel(0, host->base + MMCICLOCK);
-		mmci_reg_delay(host);
-
-		spin_unlock_irqrestore(&host->lock, flags);
 	}
+	mmci_reg_delay(host);
 
+	spin_unlock_irqrestore(&host->lock, flags);
 }
 
 static void mmci_restore(struct mmci_host *host)
 {
 	unsigned long flags;
 
-	if (host->variant->pwrreg_nopower) {
-		spin_lock_irqsave(&host->lock, flags);
+	spin_lock_irqsave(&host->lock, flags);
 
+	if (host->variant->pwrreg_nopower) {
 		writel(host->clk_reg, host->base + MMCICLOCK);
 		writel(host->datactrl_reg, host->base + MMCIDATACTRL);
 		writel(host->pwr_reg, host->base + MMCIPOWER);
-		writel(MCI_IRQENABLE, host->base + MMCIMASK0);
-		mmci_reg_delay(host);
-
-		spin_unlock_irqrestore(&host->lock, flags);
 	}
+	writel(MCI_IRQENABLE, host->base + MMCIMASK0);
+	mmci_reg_delay(host);
+
+	spin_unlock_irqrestore(&host->lock, flags);
 }
 
 static int mmci_runtime_suspend(struct device *dev)
-- 
1.7.9.5

