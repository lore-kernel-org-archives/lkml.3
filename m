Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaEWMxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:53:08 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36894 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaEWMxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:53:03 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 12/13] mmc: mmci: add explicit clk control
Date: Fri, 23 May 2014 13:52:58 +0100
Message-Id: <1400849578-7585-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

On Controllers like Qcom SD card controller where cclk is mclk and mclk should
be directly controlled by the driver.

This patch adds support to control mclk directly in the driver, and also
adds explicit_mclk_control and cclk_is_mclk flags in variant structure giving
more flexibility to the driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 5cbf644..f6dfd24 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -73,6 +73,8 @@ static unsigned int fmax = 515633;
  * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
  * @mclk_delayed_writes: enable delayed writes to ensure, subsequent updates
  *			 are not ignored.
+ * @explicit_mclk_control: enable explicit mclk control in driver.
+ * @cclk_is_mclk: enable iff card clock is multimedia card adapter clock.
  */
 struct variant_data {
 	unsigned int		clkreg;
@@ -94,6 +96,8 @@ struct variant_data {
 	bool			busy_detect;
 	bool			pwrreg_nopower;
 	bool			mclk_delayed_writes;
+	bool			explicit_mclk_control;
+	bool			cclk_is_mclk;
 };
 
 static struct variant_data variant_arm = {
@@ -202,6 +206,8 @@ static struct variant_data variant_qcom = {
 	 * for 3 clk cycles.
 	 */
 	.mclk_delayed_writes	= true,
+	.explicit_mclk_control	= true,
+	.cclk_is_mclk	= true,
 };
 
 static inline u32 mmci_readl(struct mmci_host *host, u32 off)
@@ -317,7 +323,9 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 	host->cclk = 0;
 
 	if (desired) {
-		if (desired >= host->mclk) {
+		if (variant->cclk_is_mclk) {
+			host->cclk = host->mclk;
+		} else if (desired >= host->mclk) {
 			clk = MCI_CLK_BYPASS;
 			if (variant->st_clkdiv)
 				clk |= MCI_ST_UX500_NEG_EDGE;
@@ -1354,6 +1362,16 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	if (!ios->clock && variant->pwrreg_clkgate)
 		pwr &= ~MCI_PWR_ON;
 
+	if (ios->clock != host->mclk && host->variant->explicit_mclk_control) {
+		int rc = clk_set_rate(host->clk, ios->clock);
+		if (rc < 0) {
+			dev_err(mmc_dev(host->mmc),
+				"Error setting clock rate (%d)\n", rc);
+		} else {
+			host->mclk = clk_get_rate(host->clk);
+		}
+	}
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	mmci_set_clkreg(host, ios->clock);
@@ -1540,10 +1558,12 @@ static int mmci_probe(struct amba_device *dev,
 	 * is not specified. Either value must not exceed the clock rate into
 	 * the block, of course.
 	 */
-	if (mmc->f_max)
-		mmc->f_max = min(host->mclk, mmc->f_max);
-	else
-		mmc->f_max = min(host->mclk, fmax);
+	if (!host->variant->explicit_mclk_control) {
+		if (mmc->f_max)
+			mmc->f_max = min(host->mclk, mmc->f_max);
+		else
+			mmc->f_max = min(host->mclk, fmax);
+	}
 	dev_dbg(mmc_dev(mmc), "clocking block at %u Hz\n", mmc->f_max);
 
 	/* Get regulators and the supported OCR mask */
-- 
1.9.1

