Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3GXELH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:11:07 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8520 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3GXEKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:10:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Jul 2013 21:09:05 -0700
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
Subject: [PATCH 4/9] spi: tegra20-slink: move to generic dma DT binding
Date: Wed, 24 Jul 2013 12:09:57 +0800
Message-ID: <1374639002-16753-5-git-send-email-rizhao@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
References: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- driver: remove use of nvidia,dma-request-selector
	  use dma_request_slave_channel to request channel
- if dmas/dma-names are missing, it still supports cpu based transfer
- update binding doc and specify dmas/dma-names properties as optional

Signed-off-by: Richard Zhao <rizhao@nvidia.com>
---
 .../devicetree/bindings/spi/nvidia,tegra20-slink.txt     | 10 +++++++---
 drivers/spi/spi-tegra20-slink.c                          | 16 +++++-----------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt b/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
index eefe15e..ae43bd1 100644
--- a/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
+++ b/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
@@ -4,8 +4,11 @@ Required properties:
 - compatible : should be "nvidia,tegra20-slink", "nvidia,tegra30-slink".
 - reg: Should contain SLINK registers location and length.
 - interrupts: Should contain SLINK interrupts.
-- nvidia,dma-request-selector : The Tegra DMA controller's phandle and
-  request selector for this SLINK controller.
+
+Optional properties:
+- dmas : The Tegra DMA controller's phandle and request selector for
+  this SLINK controller.
+- dma-names : Should be "rx-tx".
 
 Recommended properties:
 - spi-max-frequency: Definition as per
@@ -17,7 +20,8 @@ spi@7000d600 {
 	compatible = "nvidia,tegra20-slink";
 	reg = <0x7000d600 0x200>;
 	interrupts = <0 82 0x04>;
-	nvidia,dma-request-selector = <&apbdma 16>;
+	dmas = <&apbdma 16>;
+	dma-names = "rx-tx";
 	spi-max-frequency = <25000000>;
 	#address-cells = <1>;
 	#size-cells = <0>;
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 80490cc..278fb04 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -170,7 +170,7 @@ struct tegra_slink_data {
 	void __iomem				*base;
 	phys_addr_t				phys;
 	unsigned				irq;
-	int					dma_req_sel;
+	bool					use_dma;
 	u32					spi_max_frequency;
 	u32					cur_speed;
 
@@ -629,11 +629,8 @@ static int tegra_slink_init_dma_param(struct tegra_slink_data *tspi,
 	dma_addr_t dma_phys;
 	int ret;
 	struct dma_slave_config dma_sconfig;
-	dma_cap_mask_t mask;
 
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	dma_chan = dma_request_channel(mask, NULL, NULL);
+	dma_chan = dma_request_slave_channel(tspi->dev, "rx-tx");
 	if (!dma_chan) {
 		dev_err(tspi->dev,
 			"Dma channel is not available, will try later\n");
@@ -648,7 +645,6 @@ static int tegra_slink_init_dma_param(struct tegra_slink_data *tspi,
 		return -ENOMEM;
 	}
 
-	dma_sconfig.slave_id = tspi->dma_req_sel;
 	if (dma_to_memory) {
 		dma_sconfig.src_addr = tspi->phys + SLINK_RX_FIFO;
 		dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
@@ -1034,11 +1030,9 @@ static irqreturn_t tegra_slink_isr(int irq, void *context_data)
 static void tegra_slink_parse_dt(struct tegra_slink_data *tspi)
 {
 	struct device_node *np = tspi->dev->of_node;
-	u32 of_dma[2];
 
-	if (of_property_read_u32_array(np, "nvidia,dma-request-selector",
-				of_dma, 2) >= 0)
-		tspi->dma_req_sel = of_dma[1];
+	if (of_find_property(np, "dmas", NULL))
+		tspi->use_dma = true;
 
 	if (of_property_read_u32(np, "spi-max-frequency",
 					&tspi->spi_max_frequency))
@@ -1132,7 +1126,7 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	tspi->max_buf_size = SLINK_FIFO_DEPTH << 2;
 	tspi->dma_buf_size = DEFAULT_SPI_DMA_BUF_LEN;
 
-	if (tspi->dma_req_sel) {
+	if (tspi->use_dma) {
 		ret = tegra_slink_init_dma_param(tspi, true);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "RxDma Init failed, err %d\n", ret);
-- 
1.8.1.5

