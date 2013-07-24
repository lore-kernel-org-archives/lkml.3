Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3GXELB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:11:01 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16305 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3GXEKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:10:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Jul 2013 21:10:12 -0700
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
Subject: [PATCH 3/9] spi: tegra114: move to generic dma DT binding
Date: Wed, 24 Jul 2013 12:09:56 +0800
Message-ID: <1374639002-16753-4-git-send-email-rizhao@nvidia.com>
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
 .../devicetree/bindings/spi/nvidia,tegra114-spi.txt      | 10 +++++++---
 drivers/spi/spi-tegra114.c                               | 16 +++++-----------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/nvidia,tegra114-spi.txt b/Documentation/devicetree/bindings/spi/nvidia,tegra114-spi.txt
index 91ff771..92e1a9a 100644
--- a/Documentation/devicetree/bindings/spi/nvidia,tegra114-spi.txt
+++ b/Documentation/devicetree/bindings/spi/nvidia,tegra114-spi.txt
@@ -4,11 +4,14 @@ Required properties:
 - compatible : should be "nvidia,tegra114-spi".
 - reg: Should contain SPI registers location and length.
 - interrupts: Should contain SPI interrupts.
-- nvidia,dma-request-selector : The Tegra DMA controller's phandle and
-  request selector for this SPI controller.
 - This is also require clock named "spi" as per binding document
   Documentation/devicetree/bindings/clock/clock-bindings.txt
 
+Optional properties:
+- dmas : The Tegra DMA controller's phandle and request selector for
+  this SPI controller.
+- dma-names : Should be "rx-tx".
+
 Recommended properties:
 - spi-max-frequency: Definition as per
                      Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -18,7 +21,8 @@ spi@7000d600 {
 	compatible = "nvidia,tegra114-spi";
 	reg = <0x7000d600 0x200>;
 	interrupts = <0 82 0x04>;
-	nvidia,dma-request-selector = <&apbdma 16>;
+	dmas = <&apbdma 16>;
+	dma-names = "rx-tx";
 	spi-max-frequency = <25000000>;
 	#address-cells = <1>;
 	#size-cells = <0>;
diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index e8f542a..baff559 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -177,7 +177,7 @@ struct tegra_spi_data {
 	void __iomem				*base;
 	phys_addr_t				phys;
 	unsigned				irq;
-	int					dma_req_sel;
+	bool					use_dma;
 	u32					spi_max_frequency;
 	u32					cur_speed;
 
@@ -599,11 +599,8 @@ static int tegra_spi_init_dma_param(struct tegra_spi_data *tspi,
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
@@ -618,7 +615,6 @@ static int tegra_spi_init_dma_param(struct tegra_spi_data *tspi,
 		return -ENOMEM;
 	}
 
-	dma_sconfig.slave_id = tspi->dma_req_sel;
 	if (dma_to_memory) {
 		dma_sconfig.src_addr = tspi->phys + SPI_RX_FIFO;
 		dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
@@ -1012,11 +1008,9 @@ static void tegra_spi_parse_dt(struct platform_device *pdev,
 	struct tegra_spi_data *tspi)
 {
 	struct device_node *np = pdev->dev.of_node;
-	u32 of_dma[2];
 
-	if (of_property_read_u32_array(np, "nvidia,dma-request-selector",
-				of_dma, 2) >= 0)
-		tspi->dma_req_sel = of_dma[1];
+	if (of_find_property(np, "dmas", NULL))
+		tspi->use_dma = true;
 
 	if (of_property_read_u32(np, "spi-max-frequency",
 				&tspi->spi_max_frequency))
@@ -1093,7 +1087,7 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	tspi->max_buf_size = SPI_FIFO_DEPTH << 2;
 	tspi->dma_buf_size = DEFAULT_SPI_DMA_BUF_LEN;
 
-	if (tspi->dma_req_sel) {
+	if (tspi->use_dma) {
 		ret = tegra_spi_init_dma_param(tspi, true);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "RxDma Init failed, err %d\n", ret);
-- 
1.8.1.5

