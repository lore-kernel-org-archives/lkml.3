Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3DXJ7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:59:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1734 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3DXJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:59:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 24 Apr 2013 02:59:03 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>
CC: <djbw@fb.com>, <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] dma: tegra: implement suspend/resume callbacks
Date: Wed, 24 Apr 2013 15:24:27 +0530
Message-ID: <1366797267-29567-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement suspend/resume callbacks to store APB DMA channel's
register on suspend and restore APB DMA channel's register on
resume.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |   65 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 5a0b66c..ce19340 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -30,6 +30,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/clk/tegra.h>
@@ -199,6 +200,7 @@ struct tegra_dma_channel {
 
 	/* Channel-slave specific configuration */
 	struct dma_slave_config dma_sconfig;
+	struct tegra_dma_channel_regs	channel_reg;
 };
 
 /* tegra_dma: Tegra DMA specific information */
@@ -1440,11 +1442,74 @@ static int tegra_dma_runtime_resume(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int tegra_dma_pm_suspend(struct device *dev)
+{
+	struct tegra_dma *tdma = dev_get_drvdata(dev);
+	int i;
+	int ret;
+
+	/* Enable clock before accessing register */
+	ret = tegra_dma_runtime_resume(dev);
+	if (ret < 0)
+		return ret;
+
+	tdma->reg_gen = tdma_read(tdma, TEGRA_APBDMA_GENERAL);
+	for (i = 0; i < tdma->chip_data->nr_channels; i++) {
+		struct tegra_dma_channel *tdc = &tdma->channels[i];
+		struct tegra_dma_channel_regs *ch_reg = &tdc->channel_reg;
+
+		ch_reg->csr = tdc_read(tdc, TEGRA_APBDMA_CHAN_CSR);
+		ch_reg->ahb_ptr = tdc_read(tdc, TEGRA_APBDMA_CHAN_AHBPTR);
+		ch_reg->apb_ptr = tdc_read(tdc, TEGRA_APBDMA_CHAN_APBPTR);
+		ch_reg->ahb_seq = tdc_read(tdc, TEGRA_APBDMA_CHAN_AHBSEQ);
+		ch_reg->apb_seq = tdc_read(tdc, TEGRA_APBDMA_CHAN_APBSEQ);
+	}
+
+	/* Disable clock */
+	tegra_dma_runtime_suspend(dev);
+	return 0;
+}
+
+static int tegra_dma_pm_resume(struct device *dev)
+{
+	struct tegra_dma *tdma = dev_get_drvdata(dev);
+	int i;
+	int ret;
+
+	/* Enable clock before accessing register */
+	ret = tegra_dma_runtime_resume(dev);
+	if (ret < 0)
+		return ret;
+
+	tdma_write(tdma, TEGRA_APBDMA_GENERAL, tdma->reg_gen);
+	tdma_write(tdma, TEGRA_APBDMA_CONTROL, 0);
+	tdma_write(tdma, TEGRA_APBDMA_IRQ_MASK_SET, 0xFFFFFFFFul);
+
+	for (i = 0; i < tdma->chip_data->nr_channels; i++) {
+		struct tegra_dma_channel *tdc = &tdma->channels[i];
+		struct tegra_dma_channel_regs *ch_reg = &tdc->channel_reg;
+
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_APBSEQ, ch_reg->apb_seq);
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_APBPTR, ch_reg->apb_ptr);
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_AHBSEQ, ch_reg->ahb_seq);
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_AHBPTR, ch_reg->ahb_ptr);
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_CSR,
+			(ch_reg->csr & ~TEGRA_APBDMA_CSR_ENB));
+	}
+
+	/* Disable clock */
+	tegra_dma_runtime_suspend(dev);
+	return 0;
+}
+#endif
+
 static const struct dev_pm_ops tegra_dma_dev_pm_ops = {
 #ifdef CONFIG_PM_RUNTIME
 	.runtime_suspend = tegra_dma_runtime_suspend,
 	.runtime_resume = tegra_dma_runtime_resume,
 #endif
+	SET_SYSTEM_SLEEP_PM_OPS(tegra_dma_pm_suspend, tegra_dma_pm_resume)
 };
 
 static struct platform_driver tegra_dmac_driver = {
-- 
1.7.1.1

