Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3GXELI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:11:08 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8510 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3GXEKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:10:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Jul 2013 21:10:10 -0700
From: Richard Zhao <rizhao@nvidia.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <alsa-devel@alsa-project.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <swarren@wwwdotorg.org>, <vinod.koul@intel.com>, <djbw@fb.com>,
        <broonie@kernel.org>, <gregkh@linuxfoundation.org>,
        <lgirdwood@gmail.com>, <rizhao@nvidia.com>, <linuxzsc@gmail.com>,
        <ldewangan@nvidia.com>, <dev@lynxeye.de>
Subject: [PATCH 2/9] dma: tegra20-apbdma: move to generic device tree bindings
Date: Wed, 24 Jul 2013 12:09:55 +0800
Message-ID: <1374639002-16753-3-git-send-email-rizhao@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
References: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update tegra20-apbdma driver to adopt generic DMA device tree bindings.
It calls of_dma_controller_register() with of_dma_simple_xlate to get
the generic DMA device tree helper support. The #dma-cells for apbdma
must be 1, which is slave ID.

The existing nvidia,dma-request-selector still works there, and the
support will be removed after all clients get converted to generic DMA
device tree helper.

Signed-off-by: Richard Zhao <rizhao@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c | 46 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index f137914..0e12f78 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_dma.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
@@ -199,6 +200,7 @@ struct tegra_dma_channel {
 	void			*callback_param;
 
 	/* Channel-slave specific configuration */
+	int slave_id;
 	struct dma_slave_config dma_sconfig;
 	struct tegra_dma_channel_regs	channel_reg;
 };
@@ -219,6 +221,8 @@ struct tegra_dma {
 	struct tegra_dma_channel channels[0];
 };
 
+static struct platform_driver tegra_dmac_driver;
+
 static inline void tdma_write(struct tegra_dma *tdma, u32 reg, u32 val)
 {
 	writel(val, tdma->base_addr + reg);
@@ -339,6 +343,14 @@ static int tegra_dma_slave_config(struct dma_chan *dc,
 	}
 
 	memcpy(&tdc->dma_sconfig, sconfig, sizeof(*sconfig));
+
+	/* If we didn't get slave_id from DT when request channel, use the one
+	 * passed here.
+	 * It makes compatible with legacy nvidia,dma-request-selector.
+	 */
+	if (tdc->slave_id == -EINVAL)
+		tdc->slave_id = sconfig->slave_id;
+
 	tdc->config_init = true;
 	return 0;
 }
@@ -943,7 +955,7 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
 	ahb_seq |= TEGRA_APBDMA_AHBSEQ_BUS_WIDTH_32;
 
 	csr |= TEGRA_APBDMA_CSR_ONCE | TEGRA_APBDMA_CSR_FLOW;
-	csr |= tdc->dma_sconfig.slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
+	csr |= tdc->slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
 	if (flags & DMA_PREP_INTERRUPT)
 		csr |= TEGRA_APBDMA_CSR_IE_EOC;
 
@@ -1087,7 +1099,7 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 	csr |= TEGRA_APBDMA_CSR_FLOW;
 	if (flags & DMA_PREP_INTERRUPT)
 		csr |= TEGRA_APBDMA_CSR_IE_EOC;
-	csr |= tdc->dma_sconfig.slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
+	csr |= tdc->slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
 
 	apb_seq |= TEGRA_APBDMA_APBSEQ_WRAP_WORD_1;
 
@@ -1209,6 +1221,23 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 	clk_disable_unprepare(tdma->dma_clk);
 }
 
+static bool tegra_dma_filter_fn(struct dma_chan *dc, void *param)
+{
+	if (dc->device->dev->driver == &tegra_dmac_driver.driver) {
+		struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+		unsigned req = *(unsigned *)param;
+
+		tdc->slave_id = req;
+
+		return true;
+	}
+	return false;
+}
+
+static struct of_dma_filter_info tegra_dma_info = {
+	.filter_fn = tegra_dma_filter_fn,
+};
+
 /* Tegra20 specific DMA controller information */
 static const struct tegra_dma_chip_data tegra20_dma_chip_data = {
 	.nr_channels		= 16,
@@ -1345,6 +1374,7 @@ static int tegra_dma_probe(struct platform_device *pdev)
 				&tdma->dma_dev.channels);
 		tdc->tdma = tdma;
 		tdc->id = i;
+		tdc->slave_id = -EINVAL;
 
 		tasklet_init(&tdc->tasklet, tegra_dma_tasklet,
 				(unsigned long)tdc);
@@ -1378,10 +1408,21 @@ static int tegra_dma_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+	ret = of_dma_controller_register(pdev->dev.of_node,
+					of_dma_simple_xlate, &tegra_dma_info);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Tegra20 APB DMA controller registration failed %d\n",
+			ret);
+		goto err_of_dma;
+	}
+
 	dev_info(&pdev->dev, "Tegra20 APB DMA driver register %d channels\n",
 			cdata->nr_channels);
 	return 0;
 
+err_of_dma:
+	dma_async_device_unregister(&tdma->dma_dev);
 err_irq:
 	while (--i >= 0) {
 		struct tegra_dma_channel *tdc = &tdma->channels[i];
@@ -1401,6 +1442,7 @@ static int tegra_dma_remove(struct platform_device *pdev)
 	int i;
 	struct tegra_dma_channel *tdc;
 
+	of_dma_controller_free(pdev->dev.of_node);
 	dma_async_device_unregister(&tdma->dma_dev);
 
 	for (i = 0; i < tdma->chip_data->nr_channels; ++i) {
-- 
1.8.1.5

