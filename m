Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbaD2IVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:21:05 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33375 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaD2IU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:20:59 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 09/11] mmc: mmci: Add clock support for Qualcomm.
Date: Tue, 29 Apr 2014 09:20:51 +0100
Message-Id: <1398759651-13341-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

MCICLK going to card bus is directly driven by the clock controller, so the
driver has to set the required rates depending on the state of the card. This
bit of support is very much similar to bypass mode but there is no such thing
called bypass mode in MCICLK register of Qcom SD card controller. By default
the clock is directly driven by the clk controller.

This patch adds clock support for Qualcomm SDCC in the driver. This bit of
code is conditioned on hw designer.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 35aed38..da135c0 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -290,7 +290,10 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 	host->cclk = 0;
 
 	if (desired) {
-		if (desired >= host->mclk) {
+
+		if (host->hw_designer == AMBA_VENDOR_QCOM) {
+			host->cclk = host->mclk;
+		} else if (desired >= host->mclk) {
 			clk = MCI_CLK_BYPASS;
 			if (variant->st_clkdiv)
 				clk |= MCI_ST_UX500_NEG_EDGE;
@@ -1371,6 +1374,19 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	if (!ios->clock && variant->pwrreg_clkgate)
 		pwr &= ~MCI_PWR_ON;
 
+	if (ios->clock != host->mclk &&
+		host->hw_designer == AMBA_VENDOR_QCOM) {
+		/* Qcom MCLKCLK register does not define bypass bits */
+		int rc = clk_set_rate(host->clk, ios->clock);
+		if (rc < 0) {
+			dev_err(mmc_dev(host->mmc),
+				"Error setting clock rate (%d)\n", rc);
+		} else {
+			host->mclk = clk_get_rate(host->clk);
+			host->cclk = host->mclk;
+		}
+	}
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	mmci_set_clkreg(host, ios->clock);
@@ -1611,7 +1627,8 @@ static int mmci_probe(struct amba_device *dev,
 	 * of course.
 	 */
 	if (plat->f_max)
-		mmc->f_max = min(host->mclk, plat->f_max);
+		mmc->f_max = (host->hw_designer == AMBA_VENDOR_QCOM) ?
+				plat->f_max : min(host->mclk, plat->f_max);
 	else
 		mmc->f_max = min(host->mclk, fmax);
 	dev_dbg(mmc_dev(mmc), "clocking block at %u Hz\n", mmc->f_max);
-- 
1.7.9.5

