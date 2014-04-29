Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbaD2ITp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:19:45 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44336 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbaD2ITk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:19:40 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 03/11] mmc: mmci: Add Qcom datactrl register variant
Date: Tue, 29 Apr 2014 09:19:31 +0100
Message-Id: <1398759571-13095-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Instance of this IP on Qualcomm's SOCs has bit different layout for datactrl
register. Bit postion datactrl[16:4] hold the true block size instead of power
of 2.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 391e8d4..19d6b6f 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -58,6 +58,8 @@ static unsigned int fmax = 515633;
  * @sdio: variant supports SDIO
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
  * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
+ * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
+ *		     register
  * @pwrreg_powerup: power up value for MMCIPOWER register
  * @signal_direction: input/out direction of bus signals can be indicated
  * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
@@ -73,6 +75,7 @@ struct variant_data {
 	bool			sdio;
 	bool			st_clkdiv;
 	bool			blksz_datactrl16;
+	bool			blksz_datactrl4;
 	u32			pwrreg_powerup;
 	bool			signal_direction;
 	bool			pwrreg_clkgate;
@@ -162,6 +165,7 @@ static struct variant_data variant_qcom = {
 	.fifosize		= 16 * 4,
 	.fifohalfsize		= 8 * 4,
 	.clkreg			= MCI_CLK_ENABLE,
+	.blksz_datactrl4	= true,
 	.datalength_bits	= 24,
 	.blksz_datactrl4	= true,
 	.pwrreg_powerup		= MCI_PWR_UP,
@@ -760,6 +764,8 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 
 	if (variant->blksz_datactrl16)
 		datactrl = MCI_DPSM_ENABLE | (data->blksz << 16);
+	else if (variant->blksz_datactrl4)
+		datactrl = MCI_DPSM_ENABLE | (data->blksz << 4);
 	else
 		datactrl = MCI_DPSM_ENABLE | blksz_bits << 4;
 
-- 
1.7.9.5

