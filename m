Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaHSLOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:14:30 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:65276 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaHSLO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:14:26 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 1/4] mmc: mmci: Support any block sizes for ux500v2 and qcom variant
Date: Tue, 19 Aug 2014 12:14:07 +0100
Message-Id: <1408446847-1604-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

For the ux500v2 variant of the PL18x block, any block sizes are
supported. This will make it possible to decrease data overhead
for SDIO transfers.

This patch is based on Ulf Hansson patch
http://www.spinics.net/lists/linux-mmc/msg12160.html

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
	enabled this support on qcom variant.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index c11cb05..3089fba 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -77,6 +77,7 @@ static unsigned int fmax = 515633;
  * @qcom_fifo: enables qcom specific fifo pio read logic.
  * @reversed_irq_handling: handle data irq before cmd irq.
  * @qcom_dml: enables qcom specific dma glue for dma transfers.
+ * @any_blksize: true if block any sizes are supported
  */
 struct variant_data {
 	unsigned int		clkreg;
@@ -102,6 +103,7 @@ struct variant_data {
 	bool			qcom_fifo;
 	bool			reversed_irq_handling;
 	bool			qcom_dml;
+	bool			any_blksize;
 };
 
 static struct variant_data variant_arm = {
@@ -194,6 +196,7 @@ static struct variant_data variant_ux500v2 = {
 	.pwrreg_clkgate		= true,
 	.busy_detect		= true,
 	.pwrreg_nopower		= true,
+	.any_blksize		= true,
 };
 
 static struct variant_data variant_qcom = {
@@ -212,6 +215,7 @@ static struct variant_data variant_qcom = {
 	.explicit_mclk_control	= true,
 	.qcom_fifo		= true,
 	.qcom_dml		= true,
+	.any_blksize		= true,
 };
 
 static int mmci_card_busy(struct mmc_host *mmc)
@@ -239,10 +243,11 @@ static int mmci_card_busy(struct mmc_host *mmc)
 static int mmci_validate_data(struct mmci_host *host,
 			      struct mmc_data *data)
 {
+	struct variant_data *variant = host->variant;
+
 	if (!data)
 		return 0;
-
-	if (!is_power_of_2(data->blksz)) {
+	if (!is_power_of_2(data->blksz) && !variant->any_blksize) {
 		dev_err(mmc_dev(host->mmc),
 			"unsupported block size (%d bytes)\n", data->blksz);
 		return -EINVAL;
-- 
1.9.1

