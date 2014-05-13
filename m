Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaEMVft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:35:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55709 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbaEMVfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:35:03 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 4/4] spi: qup: Add support for v1.1.1
Date: Tue, 13 May 2014 16:34:44 -0500
Message-Id: <1400016884-9568-5-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for v1.1.1 of the SPI QUP controller.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/spi/spi-qup.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index b518b51..abad630 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -144,6 +144,7 @@ struct spi_qup {
 	int			w_size;	/* bytes per SPI word */
 	int			tx_bytes;
 	int			rx_bytes;
+	int			qup_v1;
 };
 
 
@@ -422,7 +423,9 @@ static int spi_qup_io_config(struct spi_device *spi, struct spi_transfer *xfer)
 	config |= QUP_CONFIG_SPI_MODE;
 	writel_relaxed(config, controller->base + QUP_CONFIG);
 
-	writel_relaxed(0, controller->base + QUP_OPERATIONAL_MASK);
+	/* only write to OPERATIONAL_MASK when register is present */
+	if (!controller->qup_v1)
+		writel_relaxed(0, controller->base + QUP_OPERATIONAL_MASK);
 	return 0;
 }
 
@@ -488,7 +491,7 @@ static int spi_qup_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct device *dev;
 	void __iomem *base;
-	u32 data, max_freq, iomode;
+	u32 data = 0, max_freq, iomode;
 	int ret, irq, size;
 
 	dev = &pdev->dev;
@@ -531,15 +534,6 @@ static int spi_qup_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	data = readl_relaxed(base + QUP_HW_VERSION);
-
-	if (data < QUP_HW_VERSION_2_1_1) {
-		clk_disable_unprepare(cclk);
-		clk_disable_unprepare(iclk);
-		dev_err(dev, "v.%08x is not supported\n", data);
-		return -ENXIO;
-	}
-
 	master = spi_alloc_master(dev, sizeof(struct spi_qup));
 	if (!master) {
 		clk_disable_unprepare(cclk);
@@ -567,6 +561,10 @@ static int spi_qup_probe(struct platform_device *pdev)
 	controller->cclk = cclk;
 	controller->irq = irq;
 
+	/* set v1 flag if device is version 1 */
+	if (of_device_is_compatible(dev->of_node, "qcom,spi-qup-v1.1.1"))
+		controller->qup_v1 = 1;
+
 	spin_lock_init(&controller->lock);
 	init_completion(&controller->done);
 
@@ -604,10 +602,19 @@ static int spi_qup_probe(struct platform_device *pdev)
 
 	writel_relaxed(0, base + QUP_OPERATIONAL);
 	writel_relaxed(0, base + QUP_IO_M_MODES);
-	writel_relaxed(0, base + QUP_OPERATIONAL_MASK);
+
+	if (!controller->qup_v1)
+		writel_relaxed(0, base + QUP_OPERATIONAL_MASK);
+
 	writel_relaxed(SPI_ERROR_CLK_UNDER_RUN | SPI_ERROR_CLK_OVER_RUN,
 		       base + SPI_ERROR_FLAGS_EN);
 
+	/* if earlier version of the QUP, disable INPUT_OVERRUN */
+	if (controller->qup_v1)
+		writel_relaxed(QUP_ERROR_OUTPUT_OVER_RUN |
+			QUP_ERROR_INPUT_UNDER_RUN | QUP_ERROR_OUTPUT_UNDER_RUN,
+			base + QUP_ERROR_FLAGS_EN);
+
 	writel_relaxed(0, base + SPI_CONFIG);
 	writel_relaxed(SPI_IO_C_NO_TRI_STATE, base + SPI_IO_CONTROL);
 
@@ -729,6 +736,7 @@ static int spi_qup_remove(struct platform_device *pdev)
 }
 
 static struct of_device_id spi_qup_dt_match[] = {
+	{ .compatible = "qcom,spi-qup-v1.1.1", },
 	{ .compatible = "qcom,spi-qup-v2.1.1", },
 	{ .compatible = "qcom,spi-qup-v2.2.1", },
 	{ }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

