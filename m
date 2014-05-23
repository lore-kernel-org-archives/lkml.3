Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaEWMvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:51:33 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:59625 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaEWMva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:51:30 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 04/13] mmc: mmci: Add Qcom datactrl register variant
Date: Fri, 23 May 2014 13:51:25 +0100
Message-Id: <1400849485-7220-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Instance of this IP on Qualcomm's SOCs has bit different layout for datactrl
register. Bit position datactrl[16:4] hold the true block size instead of power
of 2.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 7bdf4d3..324a886 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -60,6 +60,8 @@ static unsigned int fmax = 515633;
  * @sdio: variant supports SDIO
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
  * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
+ * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
+ *		     register
  * @pwrreg_powerup: power up value for MMCIPOWER register
  * @signal_direction: input/out direction of bus signals can be indicated
  * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
@@ -75,6 +77,7 @@ struct variant_data {
 	bool			sdio;
 	bool			st_clkdiv;
 	bool			blksz_datactrl16;
+	bool			blksz_datactrl4;
 	u32			pwrreg_powerup;
 	bool			signal_direction;
 	bool			pwrreg_clkgate;
@@ -164,6 +167,7 @@ static struct variant_data variant_qcom = {
 	.fifosize		= 16 * 4,
 	.fifohalfsize		= 8 * 4,
 	.clkreg			= MCI_CLK_ENABLE,
+	.blksz_datactrl4	= true,
 	.datalength_bits	= 24,
 	.blksz_datactrl4	= true,
 	.pwrreg_powerup		= MCI_PWR_UP,
@@ -740,6 +744,8 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 
 	if (variant->blksz_datactrl16)
 		datactrl = MCI_DPSM_ENABLE | (data->blksz << 16);
+	else if (variant->blksz_datactrl4)
+		datactrl = MCI_DPSM_ENABLE | (data->blksz << 4);
 	else
 		datactrl = MCI_DPSM_ENABLE | blksz_bits << 4;
 
-- 
1.9.1

