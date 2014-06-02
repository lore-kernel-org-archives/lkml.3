Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaFBJKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:10:06 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44931 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaFBJKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:10:02 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v6 10/12] mmc: mmci: add explicit clk control
Date: Mon,  2 Jun 2014 10:09:55 +0100
Message-Id: <1401700195-11834-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

On Controllers like Qcom SD card controller where cclk is mclk and mclk should
be directly controlled by the driver.

This patch adds support to control mclk directly in the driver, and also
adds explicit_mclk_control flag in variant structure giving more flexibility
to the driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 30 +++++++++++++++++++++++++++---
 drivers/mmc/host/mmci.h |  2 ++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 55d39d2..08715ab 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -72,6 +72,7 @@ static unsigned int fmax = 515633;
  * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
  * @busy_detect: true if busy detection on dat0 is supported
  * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
+ * @explicit_mclk_control: enable explicit mclk control in driver.
  */
 struct variant_data {
 	unsigned int		clkreg;
@@ -93,6 +94,7 @@ struct variant_data {
 	bool			pwrreg_clkgate;
 	bool			busy_detect;
 	bool			pwrreg_nopower;
+	bool			explicit_mclk_control;
 };
 
 static struct variant_data variant_arm = {
@@ -286,7 +288,9 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 	host->cclk = 0;
 
 	if (desired) {
-		if (desired >= host->mclk) {
+		if (variant->explicit_mclk_control) {
+			host->cclk = host->mclk;
+		} else if (desired >= host->mclk) {
 			clk = MCI_CLK_BYPASS;
 			if (variant->st_clkdiv)
 				clk |= MCI_ST_UX500_NEG_EDGE;
@@ -1325,6 +1329,18 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	if (!ios->clock && variant->pwrreg_clkgate)
 		pwr &= ~MCI_PWR_ON;
 
+	if (host->variant->explicit_mclk_control &&
+	    ios->clock != host->clock_cache) {
+		int rc = clk_set_rate(host->clk, ios->clock);
+		if (rc < 0) {
+			dev_err(mmc_dev(host->mmc),
+				"Error setting clock rate (%d)\n", rc);
+		} else {
+			host->mclk = clk_get_rate(host->clk);
+			host->clock_cache = ios->clock;
+		}
+	}
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	mmci_set_clkreg(host, ios->clock);
@@ -1500,9 +1516,12 @@ static int mmci_probe(struct amba_device *dev,
 	 * The ARM and ST versions of the block have slightly different
 	 * clock divider equations which means that the minimum divider
 	 * differs too.
+	 * on Qualcomm like controllers get the nearest minimum clock to 100Khz
 	 */
 	if (variant->st_clkdiv)
 		mmc->f_min = DIV_ROUND_UP(host->mclk, 257);
+	else if (variant->explicit_mclk_control)
+		mmc->f_min = clk_round_rate(host->clk, 100000);
 	else
 		mmc->f_min = DIV_ROUND_UP(host->mclk, 512);
 	/*
@@ -1512,9 +1531,14 @@ static int mmci_probe(struct amba_device *dev,
 	 * the block, of course.
 	 */
 	if (mmc->f_max)
-		mmc->f_max = min(host->mclk, mmc->f_max);
+		mmc->f_max = variant->explicit_mclk_control ?
+				min(variant->f_max, mmc->f_max) :
+				min(host->mclk, mmc->f_max);
 	else
-		mmc->f_max = min(host->mclk, fmax);
+		mmc->f_max = variant->explicit_mclk_control ?
+				fmax : min(host->mclk, fmax);
+
+
 	dev_dbg(mmc_dev(mmc), "clocking block at %u Hz\n", mmc->f_max);
 
 	/* Get regulators and the supported OCR mask */
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index d38a99d..ef34617 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -208,6 +208,8 @@ struct mmci_host {
 	spinlock_t		lock;
 
 	unsigned int		mclk;
+	/* cached value of requested clk in set_ios */
+	unsigned int		clock_cache;
 	unsigned int		cclk;
 	u32			pwr_reg;
 	u32			pwr_reg_add;
-- 
1.9.1

