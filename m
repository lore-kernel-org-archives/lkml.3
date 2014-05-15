Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaEOJhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:37:10 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55879 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaEOJhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:37:06 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 06/14] mmc: mmci: Qcomm: Add 3 clock cycle delay after register write
Date: Thu, 15 May 2014 10:37:01 +0100
Message-Id: <1400146621-30056-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Most of the Qcomm SD card controller registers must be updated to the MCLK
domain so subsequent writes to registers will be ignored until 3 clock cycles
have passed.

This patch adds a 3 clock cycle delay required after writing to controller
registers on Qualcomm SOCs. Without this delay all the register writes are not
successful, resulting in not detecting cards. The write clock delay is
activated by setting up mclk_delayed_writes variable in variant data.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 881bb24..1385554 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -67,6 +67,8 @@ static unsigned int fmax = 515633;
  * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
  * @busy_detect: true if busy detection on dat0 is supported
  * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
+ * @mclk_delayed_writes: enable delayed writes to ensure, subsequent updates
+ *			 are not ignored.
  */
 struct variant_data {
 	unsigned int		clkreg;
@@ -83,6 +85,7 @@ struct variant_data {
 	bool			pwrreg_clkgate;
 	bool			busy_detect;
 	bool			pwrreg_nopower;
+	bool			mclk_delayed_writes;
 };
 
 static struct variant_data variant_arm = {
@@ -171,6 +174,12 @@ static struct variant_data variant_qcom = {
 	.datalength_bits	= 24,
 	.blksz_datactrl4	= true,
 	.pwrreg_powerup		= MCI_PWR_UP,
+	/*
+	 * On QCom SD card controller, registers must be updated to the
+	 * MCLK domain so subsequent writes to this register will be ignored
+	 * for 3 clk cycles.
+	 */
+	.mclk_delayed_writes	= true,
 };
 
 static inline u32 mmci_readl(struct mmci_host *host, u32 off)
@@ -181,6 +190,9 @@ static inline u32 mmci_readl(struct mmci_host *host, u32 off)
 static inline void mmci_writel(struct mmci_host *host, u32 data, u32 off)
 {
 	writel(data, host->base + off);
+
+	if (host->variant->mclk_delayed_writes)
+		udelay(DIV_ROUND_UP((3 * USEC_PER_SEC), host->mclk));
 }
 
 static int mmci_card_busy(struct mmc_host *mmc)
-- 
1.9.1

