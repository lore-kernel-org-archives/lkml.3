Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaFLTet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:34:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45731 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaFLTeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:34:46 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v2 3/3] spi: qup: Add support for v1.1.1
Date: Thu, 12 Jun 2014 14:34:12 -0500
Message-Id: <1402601652-24641-4-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
References: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for v1.1.1 of the SPI QUP controller.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/spi/qcom,spi-qup.txt       |    6 +++-
 drivers/spi/spi-qup.c                              |   36 ++++++++++++--------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt b/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
index bee6ff2..e2c88df 100644
--- a/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
+++ b/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
@@ -7,7 +7,11 @@ SPI in master mode supports up to 50MHz, up to four chip selects, programmable
 data path from 4 bits to 32 bits and numerous protocol variants.
 
 Required properties:
-- compatible:     Should contain "qcom,spi-qup-v2.1.1" or "qcom,spi-qup-v2.2.1"
+- compatible:     Should contain:
+		  "qcom,spi-qup-v1.1.1" for 8660, 8960 and 8064.
+		  "qcom,spi-qup-v2.1.1" for 8974 and later
+		  "qcom,spi-qup-v2.2.1" for 8974 v2 and later.
+
 - reg:            Should contain base register location and length
 - interrupts:     Interrupt number used by this controller
 
diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index c08da38..9f83d29 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -142,6 +142,7 @@ struct spi_qup {
 	int			w_size;	/* bytes per SPI word */
 	int			tx_bytes;
 	int			rx_bytes;
+	int			qup_v1;
 };
 
 
@@ -420,7 +421,9 @@ static int spi_qup_io_config(struct spi_device *spi, struct spi_transfer *xfer)
 	config |= QUP_CONFIG_SPI_MODE;
 	writel_relaxed(config, controller->base + QUP_CONFIG);
 
-	writel_relaxed(0, controller->base + QUP_OPERATIONAL_MASK);
+	/* only write to OPERATIONAL_MASK when register is present */
+	if (!controller->qup_v1)
+		writel_relaxed(0, controller->base + QUP_OPERATIONAL_MASK);
 	return 0;
 }
 
@@ -486,7 +489,7 @@ static int spi_qup_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct device *dev;
 	void __iomem *base;
-	u32 data, max_freq, iomode;
+	u32 max_freq, iomode;
 	int ret, irq, size;
 
 	dev = &pdev->dev;
@@ -529,15 +532,6 @@ static int spi_qup_probe(struct platform_device *pdev)
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
@@ -570,6 +564,10 @@ static int spi_qup_probe(struct platform_device *pdev)
 	controller->cclk = cclk;
 	controller->irq = irq;
 
+	/* set v1 flag if device is version 1 */
+	if (of_device_is_compatible(dev->of_node, "qcom,spi-qup-v1.1.1"))
+		controller->qup_v1 = 1;
+
 	spin_lock_init(&controller->lock);
 	init_completion(&controller->done);
 
@@ -593,8 +591,8 @@ static int spi_qup_probe(struct platform_device *pdev)
 	size = QUP_IO_M_INPUT_FIFO_SIZE(iomode);
 	controller->in_fifo_sz = controller->in_blk_sz * (2 << size);
 
-	dev_info(dev, "v.%08x IN:block:%d, fifo:%d, OUT:block:%d, fifo:%d\n",
-		 data, controller->in_blk_sz, controller->in_fifo_sz,
+	dev_info(dev, "IN:block:%d, fifo:%d, OUT:block:%d, fifo:%d\n",
+		 controller->in_blk_sz, controller->in_fifo_sz,
 		 controller->out_blk_sz, controller->out_fifo_sz);
 
 	writel_relaxed(1, base + QUP_SW_RESET);
@@ -607,10 +605,19 @@ static int spi_qup_probe(struct platform_device *pdev)
 
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
 
@@ -732,6 +739,7 @@ static int spi_qup_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id spi_qup_dt_match[] = {
+	{ .compatible = "qcom,spi-qup-v1.1.1", },
 	{ .compatible = "qcom,spi-qup-v2.1.1", },
 	{ .compatible = "qcom,spi-qup-v2.2.1", },
 	{ }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

