Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3GXELM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:11:12 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8540 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3GXEKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:10:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Jul 2013 21:09:10 -0700
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
Subject: [PATCH 7/9] ASoC: tegra: move to generic DMA DT binding
Date: Wed, 24 Jul 2013 12:10:00 +0800
Message-ID: <1374639002-16753-8-git-send-email-rizhao@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
References: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add tegra_dma_filter_data to specify dma info
  DMA DT binding needs the device that raise dma request and dma name
  to request a dma channel. tegra30_i2s is a special case. It should be ahub
  device and it also has dma name that cannot handled by ASoC dmaengine code.
  So we pass the info using filter data in snd_dmaengine_dai_dma_data.
- change i2s/ac97 drivers to use generic DT binding
- tegra30_i2s: alloc ahub tx/rx fifo at driver probe time

Signed-off-by: Richard Zhao <rizhao@nvidia.com>
---
 .../bindings/sound/nvidia,tegra20-ac97.txt         |  8 ++--
 .../bindings/sound/nvidia,tegra20-i2s.txt          |  8 ++--
 .../bindings/sound/nvidia,tegra30-ahub.txt         | 12 +++---
 sound/soc/tegra/tegra20_ac97.c                     | 17 +++------
 sound/soc/tegra/tegra20_ac97.h                     |  2 +
 sound/soc/tegra/tegra20_i2s.c                      | 26 ++++---------
 sound/soc/tegra/tegra20_i2s.h                      |  2 +
 sound/soc/tegra/tegra30_ahub.c                     | 25 +++++-------
 sound/soc/tegra/tegra30_ahub.h                     | 11 +++---
 sound/soc/tegra/tegra30_i2s.c                      | 44 +++++++++++++++-------
 sound/soc/tegra/tegra30_i2s.h                      |  2 +
 sound/soc/tegra/tegra_pcm.c                        | 14 +++++++
 sound/soc/tegra/tegra_pcm.h                        | 13 +++++++
 13 files changed, 107 insertions(+), 77 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra20-ac97.txt b/Documentation/devicetree/bindings/sound/nvidia,tegra20-ac97.txt
index c145497..972f444 100644
--- a/Documentation/devicetree/bindings/sound/nvidia,tegra20-ac97.txt
+++ b/Documentation/devicetree/bindings/sound/nvidia,tegra20-ac97.txt
@@ -4,8 +4,9 @@ Required properties:
 - compatible : "nvidia,tegra20-ac97"
 - reg : Should contain AC97 controller registers location and length
 - interrupts : Should contain AC97 interrupt
-- nvidia,dma-request-selector : The Tegra DMA controller's phandle and
-  request selector for the AC97 controller
+- dmas : The Tegra DMA controller's phandle and request selector for
+  the AC97 controller
+- dma-names : Should be "rx-tx"
 - nvidia,codec-reset-gpio : The Tegra GPIO controller's phandle and the number
   of the GPIO used to reset the external AC97 codec
 - nvidia,codec-sync-gpio : The Tegra GPIO controller's phandle and the number
@@ -16,7 +17,8 @@ ac97@70002000 {
 	compatible = "nvidia,tegra20-ac97";
 	reg = <0x70002000 0x200>;
 	interrupts = <0 81 0x04>;
-	nvidia,dma-request-selector = <&apbdma 12>;
+	dmas = <&apbdma 12>;
+	dma-names = "rx-tx";
 	nvidia,codec-reset-gpio = <&gpio 170 0>;
 	nvidia,codec-sync-gpio = <&gpio 120 0>;
 };
diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra20-i2s.txt b/Documentation/devicetree/bindings/sound/nvidia,tegra20-i2s.txt
index 0df2b5c..61a6c8d 100644
--- a/Documentation/devicetree/bindings/sound/nvidia,tegra20-i2s.txt
+++ b/Documentation/devicetree/bindings/sound/nvidia,tegra20-i2s.txt
@@ -4,8 +4,9 @@ Required properties:
 - compatible : "nvidia,tegra20-i2s"
 - reg : Should contain I2S registers location and length
 - interrupts : Should contain I2S interrupt
-- nvidia,dma-request-selector : The Tegra DMA controller's phandle and
-  request selector for this I2S controller
+- dmas : The Tegra DMA controller's phandle and request selector
+  for this I2S controller
+- dma-names : Should be "rx-tx"
 
 Example:
 
@@ -13,5 +14,6 @@ i2s@70002800 {
 	compatible = "nvidia,tegra20-i2s";
 	reg = <0x70002800 0x200>;
 	interrupts = < 45 >;
-	nvidia,dma-request-selector = < &apbdma 2 >;
+	dmas = < &apbdma 2 >;
+	dma-names = "rx-tx";
 };
diff --git a/Documentation/devicetree/bindings/sound/nvidia,tegra30-ahub.txt b/Documentation/devicetree/bindings/sound/nvidia,tegra30-ahub.txt
index 0e5c12c..0ac563b 100644
--- a/Documentation/devicetree/bindings/sound/nvidia,tegra30-ahub.txt
+++ b/Documentation/devicetree/bindings/sound/nvidia,tegra30-ahub.txt
@@ -7,11 +7,10 @@ Required properties:
   - Tegra30 requires 2 entries, for the APBIF and AHUB/AUDIO register blocks.
   - Tegra114 requires an additional entry, for the APBIF2 register block.
 - interrupts : Should contain AHUB interrupt
-- nvidia,dma-request-selector : A list of the DMA channel specifiers. Each
-  entry contains the Tegra DMA controller's phandle and request selector.
-  If a single entry is present, the request selectors for the channels are
-  assumed to be contiguous, and increment from this value.
-  If multiple values are given, one value must be given per channel.
+- dmas : A list of the DMA channel specifiers. Each entry contains the Tegra
+  DMA controller's phandle and request selector.
+- dma-names : Should be a list of "channelx", in which x is 0, 1, 2, ...
+  One entry is required for each RX/TX FIFO pair that exists in hardware.
 - clocks : Must contain an entry for each required entry in clock-names.
 - clock-names : Must include the following entries:
   - Tegra30: Requires d_audio, apbif, i2s0, i2s1, i2s2, i2s3, i2s4, dam0,
@@ -34,7 +33,8 @@ ahub@70080000 {
 	compatible = "nvidia,tegra30-ahub";
 	reg = <0x70080000 0x200 0x70080200 0x100>;
 	interrupts = < 0 103 0x04 >;
-	nvidia,dma-request-selector = <&apbdma 1>;
+	dmas = <&apbdma 1>, <&apbdma 2>, <&apbdma 3>, <&apbdma 4>;
+	dma-names = "channel0", "channel1", "channel2", "channel3";
 	clocks = <&tegra_car 106>, <&tegra_car 107>, <&tegra_car 30>,
 		<&tegra_car 11>, <&tegra_car 18>, <&tegra_car 101>,
 		<&tegra_car 102>, <&tegra_car 108>, <&tegra_car 109>,
diff --git a/sound/soc/tegra/tegra20_ac97.c b/sound/soc/tegra/tegra20_ac97.c
index 6c48662..935900a 100644
--- a/sound/soc/tegra/tegra20_ac97.c
+++ b/sound/soc/tegra/tegra20_ac97.c
@@ -313,7 +313,6 @@ static int tegra20_ac97_platform_probe(struct platform_device *pdev)
 {
 	struct tegra20_ac97 *ac97;
 	struct resource *mem;
-	u32 of_dma[2];
 	void __iomem *regs;
 	int ret = 0;
 
@@ -354,14 +353,6 @@ static int tegra20_ac97_platform_probe(struct platform_device *pdev)
 		goto err_clk_put;
 	}
 
-	if (of_property_read_u32_array(pdev->dev.of_node,
-				       "nvidia,dma-request-selector",
-				       of_dma, 2) < 0) {
-		dev_err(&pdev->dev, "No DMA resource\n");
-		ret = -ENODEV;
-		goto err_clk_put;
-	}
-
 	ac97->reset_gpio = of_get_named_gpio(pdev->dev.of_node,
 					     "nvidia,codec-reset-gpio", 0);
 	if (gpio_is_valid(ac97->reset_gpio)) {
@@ -386,12 +377,16 @@ static int tegra20_ac97_platform_probe(struct platform_device *pdev)
 	ac97->capture_dma_data.addr = mem->start + TEGRA20_AC97_FIFO_RX1;
 	ac97->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	ac97->capture_dma_data.maxburst = 4;
-	ac97->capture_dma_data.slave_id = of_dma[1];
+	ac97->filter_data_rx.dma_dev = &pdev->dev;
+	sprintf(ac97->filter_data_rx.dma_name, "rx-tx");
+	ac97->capture_dma_data.filter_data = &ac97->filter_data_rx;
 
 	ac97->playback_dma_data.addr = mem->start + TEGRA20_AC97_FIFO_TX1;
 	ac97->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	ac97->playback_dma_data.maxburst = 4;
-	ac97->playback_dma_data.slave_id = of_dma[1];
+	ac97->filter_data_tx.dma_dev = &pdev->dev;
+	sprintf(ac97->filter_data_tx.dma_name, "rx-tx");
+	ac97->playback_dma_data.filter_data = &ac97->filter_data_tx;
 
 	ret = tegra_asoc_utils_init(&ac97->util_data, &pdev->dev);
 	if (ret)
diff --git a/sound/soc/tegra/tegra20_ac97.h b/sound/soc/tegra/tegra20_ac97.h
index 4acb3aa..ac09d34 100644
--- a/sound/soc/tegra/tegra20_ac97.h
+++ b/sound/soc/tegra/tegra20_ac97.h
@@ -86,7 +86,9 @@
 struct tegra20_ac97 {
 	struct clk *clk_ac97;
 	struct snd_dmaengine_dai_dma_data capture_dma_data;
+	struct tegra_dma_filter_data filter_data_rx;
 	struct snd_dmaengine_dai_dma_data playback_dma_data;
+	struct tegra_dma_filter_data filter_data_tx;
 	struct regmap *regmap;
 	int reset_gpio;
 	int sync_gpio;
diff --git a/sound/soc/tegra/tegra20_i2s.c b/sound/soc/tegra/tegra20_i2s.c
index 52af7f6..af98338 100644
--- a/sound/soc/tegra/tegra20_i2s.c
+++ b/sound/soc/tegra/tegra20_i2s.c
@@ -339,9 +339,7 @@ static const struct regmap_config tegra20_i2s_regmap_config = {
 static int tegra20_i2s_platform_probe(struct platform_device *pdev)
 {
 	struct tegra20_i2s *i2s;
-	struct resource *mem, *memregion, *dmareq;
-	u32 of_dma[2];
-	u32 dma_ch;
+	struct resource *mem, *memregion;
 	void __iomem *regs;
 	int ret;
 
@@ -370,20 +368,6 @@ static int tegra20_i2s_platform_probe(struct platform_device *pdev)
 		goto err_clk_put;
 	}
 
-	dmareq = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!dmareq) {
-		if (of_property_read_u32_array(pdev->dev.of_node,
-					"nvidia,dma-request-selector",
-					of_dma, 2) < 0) {
-			dev_err(&pdev->dev, "No DMA resource\n");
-			ret = -ENODEV;
-			goto err_clk_put;
-		}
-		dma_ch = of_dma[1];
-	} else {
-		dma_ch = dmareq->start;
-	}
-
 	memregion = devm_request_mem_region(&pdev->dev, mem->start,
 					    resource_size(mem), DRV_NAME);
 	if (!memregion) {
@@ -410,12 +394,16 @@ static int tegra20_i2s_platform_probe(struct platform_device *pdev)
 	i2s->capture_dma_data.addr = mem->start + TEGRA20_I2S_FIFO2;
 	i2s->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	i2s->capture_dma_data.maxburst = 4;
-	i2s->capture_dma_data.slave_id = dma_ch;
+	i2s->filter_data_rx.dma_dev = &pdev->dev;
+	sprintf(i2s->filter_data_rx.dma_name, "rx-tx");
+	i2s->capture_dma_data.filter_data = &i2s->filter_data_rx;
 
 	i2s->playback_dma_data.addr = mem->start + TEGRA20_I2S_FIFO1;
 	i2s->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	i2s->playback_dma_data.maxburst = 4;
-	i2s->playback_dma_data.slave_id = dma_ch;
+	i2s->filter_data_tx.dma_dev = &pdev->dev;
+	sprintf(i2s->filter_data_tx.dma_name, "rx-tx");
+	i2s->playback_dma_data.filter_data = &i2s->filter_data_tx;
 
 	pm_runtime_enable(&pdev->dev);
 	if (!pm_runtime_enabled(&pdev->dev)) {
diff --git a/sound/soc/tegra/tegra20_i2s.h b/sound/soc/tegra/tegra20_i2s.h
index fa6c29c..794d487 100644
--- a/sound/soc/tegra/tegra20_i2s.h
+++ b/sound/soc/tegra/tegra20_i2s.h
@@ -156,7 +156,9 @@ struct tegra20_i2s {
 	struct snd_soc_dai_driver dai;
 	struct clk *clk_i2s;
 	struct snd_dmaengine_dai_dma_data capture_dma_data;
+	struct tegra_dma_filter_data filter_data_rx;
 	struct snd_dmaengine_dai_dma_data playback_dma_data;
+	struct tegra_dma_filter_data filter_data_tx;
 	struct regmap *regmap;
 };
 
diff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c
index d554d46..afa8a0b 100644
--- a/sound/soc/tegra/tegra30_ahub.c
+++ b/sound/soc/tegra/tegra30_ahub.c
@@ -96,7 +96,7 @@ static int tegra30_ahub_runtime_resume(struct device *dev)
 
 int tegra30_ahub_allocate_rx_fifo(enum tegra30_ahub_rxcif *rxcif,
 				  dma_addr_t *fiforeg,
-				  unsigned int *reqsel)
+				 struct tegra_dma_filter_data *filter_data)
 {
 	int channel;
 	u32 reg, val;
@@ -111,7 +111,9 @@ int tegra30_ahub_allocate_rx_fifo(enum tegra30_ahub_rxcif *rxcif,
 	*rxcif = TEGRA30_AHUB_RXCIF_APBIF_RX0 + channel;
 	*fiforeg = ahub->apbif_addr + TEGRA30_AHUB_CHANNEL_RXFIFO +
 		   (channel * TEGRA30_AHUB_CHANNEL_RXFIFO_STRIDE);
-	*reqsel = ahub->dma_sel + channel;
+
+	filter_data->dma_dev = ahub->dev;
+	sprintf(filter_data->dma_name, "channel%d", channel);
 
 	reg = TEGRA30_AHUB_CHANNEL_CTRL +
 	      (channel * TEGRA30_AHUB_CHANNEL_CTRL_STRIDE);
@@ -178,8 +180,8 @@ int tegra30_ahub_free_rx_fifo(enum tegra30_ahub_rxcif rxcif)
 EXPORT_SYMBOL_GPL(tegra30_ahub_free_rx_fifo);
 
 int tegra30_ahub_allocate_tx_fifo(enum tegra30_ahub_txcif *txcif,
-				  dma_addr_t *fiforeg,
-				  unsigned int *reqsel)
+				dma_addr_t *fiforeg,
+				struct tegra_dma_filter_data *filter_data)
 {
 	int channel;
 	u32 reg, val;
@@ -194,7 +196,9 @@ int tegra30_ahub_allocate_tx_fifo(enum tegra30_ahub_txcif *txcif,
 	*txcif = TEGRA30_AHUB_TXCIF_APBIF_TX0 + channel;
 	*fiforeg = ahub->apbif_addr + TEGRA30_AHUB_CHANNEL_TXFIFO +
 		   (channel * TEGRA30_AHUB_CHANNEL_TXFIFO_STRIDE);
-	*reqsel = ahub->dma_sel + channel;
+
+	filter_data->dma_dev = ahub->dev;
+	sprintf(filter_data->dma_name, "channel%d", channel);
 
 	reg = TEGRA30_AHUB_CHANNEL_CTRL +
 	      (channel * TEGRA30_AHUB_CHANNEL_CTRL_STRIDE);
@@ -456,7 +460,6 @@ static int tegra30_ahub_probe(struct platform_device *pdev)
 	struct clk *clk;
 	int i;
 	struct resource *res0, *res1, *region;
-	u32 of_dma[2];
 	void __iomem *regs_apbif, *regs_ahub;
 	int ret = 0;
 
@@ -513,16 +516,6 @@ static int tegra30_ahub_probe(struct platform_device *pdev)
 		goto err_clk_put_d_audio;
 	}
 
-	if (of_property_read_u32_array(pdev->dev.of_node,
-				"nvidia,dma-request-selector",
-				of_dma, 2) < 0) {
-		dev_err(&pdev->dev,
-			"Missing property nvidia,dma-request-selector\n");
-		ret = -ENODEV;
-		goto err_clk_put_d_audio;
-	}
-	ahub->dma_sel = of_dma[1];
-
 	res0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res0) {
 		dev_err(&pdev->dev, "No apbif memory resource\n");
diff --git a/sound/soc/tegra/tegra30_ahub.h b/sound/soc/tegra/tegra30_ahub.h
index 09766cd..3eae224 100644
--- a/sound/soc/tegra/tegra30_ahub.h
+++ b/sound/soc/tegra/tegra30_ahub.h
@@ -19,6 +19,8 @@
 #ifndef __TEGRA30_AHUB_H__
 #define __TEGRA30_AHUB_H__
 
+#include "tegra_pcm.h"
+
 /* Fields in *_CIF_RX/TX_CTRL; used by AHUB FIFOs, and all other audio modules */
 
 #define TEGRA30_AUDIOCIF_CTRL_FIFO_THRESHOLD_SHIFT	28
@@ -451,15 +453,15 @@ enum tegra30_ahub_rxcif {
 };
 
 extern int tegra30_ahub_allocate_rx_fifo(enum tegra30_ahub_rxcif *rxcif,
-					 dma_addr_t *fiforeg,
-					 unsigned int *reqsel);
+				 dma_addr_t *fiforeg,
+				 struct tegra_dma_filter_data *filter_data);
 extern int tegra30_ahub_enable_rx_fifo(enum tegra30_ahub_rxcif rxcif);
 extern int tegra30_ahub_disable_rx_fifo(enum tegra30_ahub_rxcif rxcif);
 extern int tegra30_ahub_free_rx_fifo(enum tegra30_ahub_rxcif rxcif);
 
 extern int tegra30_ahub_allocate_tx_fifo(enum tegra30_ahub_txcif *txcif,
-					 dma_addr_t *fiforeg,
-					 unsigned int *reqsel);
+				 dma_addr_t *fiforeg,
+				 struct tegra_dma_filter_data *filter_data);
 extern int tegra30_ahub_enable_tx_fifo(enum tegra30_ahub_txcif txcif);
 extern int tegra30_ahub_disable_tx_fifo(enum tegra30_ahub_txcif txcif);
 extern int tegra30_ahub_free_tx_fifo(enum tegra30_ahub_txcif txcif);
@@ -488,7 +490,6 @@ struct tegra30_ahub {
 	struct device *dev;
 	struct clk *clk_d_audio;
 	struct clk *clk_apbif;
-	int dma_sel;
 	resource_size_t apbif_addr;
 	struct regmap *regmap_apbif;
 	struct regmap *regmap_ahub;
diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index d04146c..e1672c0 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -76,27 +76,16 @@ static int tegra30_i2s_startup(struct snd_pcm_substream *substream,
 			struct snd_soc_dai *dai)
 {
 	struct tegra30_i2s *i2s = snd_soc_dai_get_drvdata(dai);
-	int ret;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		ret = tegra30_ahub_allocate_tx_fifo(&i2s->playback_fifo_cif,
-					&i2s->playback_dma_data.addr,
-					&i2s->playback_dma_data.slave_id);
-		i2s->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-		i2s->playback_dma_data.maxburst = 4;
 		tegra30_ahub_set_rx_cif_source(i2s->playback_i2s_cif,
 					       i2s->playback_fifo_cif);
 	} else {
-		ret = tegra30_ahub_allocate_rx_fifo(&i2s->capture_fifo_cif,
-					&i2s->capture_dma_data.addr,
-					&i2s->capture_dma_data.slave_id);
-		i2s->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-		i2s->capture_dma_data.maxburst = 4;
 		tegra30_ahub_set_rx_cif_source(i2s->capture_fifo_cif,
 					       i2s->capture_i2s_cif);
 	}
 
-	return ret;
+	return 0;
 }
 
 static void tegra30_i2s_shutdown(struct snd_pcm_substream *substream,
@@ -106,10 +95,8 @@ static void tegra30_i2s_shutdown(struct snd_pcm_substream *substream,
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		tegra30_ahub_unset_rx_cif_source(i2s->playback_i2s_cif);
-		tegra30_ahub_free_tx_fifo(i2s->playback_fifo_cif);
 	} else {
 		tegra30_ahub_unset_rx_cif_source(i2s->capture_fifo_cif);
-		tegra30_ahub_free_rx_fifo(i2s->capture_fifo_cif);
 	}
 }
 
@@ -412,6 +399,9 @@ static int tegra30_i2s_platform_probe(struct platform_device *pdev)
 	}
 	dev_set_drvdata(&pdev->dev, i2s);
 
+	i2s->capture_dma_data.filter_data = &i2s->filter_data_rx;
+	i2s->playback_dma_data.filter_data = &i2s->filter_data_tx;
+
 	i2s->dai = tegra30_i2s_dai_template;
 	i2s->dai.name = dev_name(&pdev->dev);
 
@@ -462,6 +452,26 @@ static int tegra30_i2s_platform_probe(struct platform_device *pdev)
 	}
 	regcache_cache_only(i2s->regmap, true);
 
+	ret = tegra30_ahub_allocate_tx_fifo(&i2s->playback_fifo_cif,
+					&i2s->playback_dma_data.addr,
+					&i2s->filter_data_tx);
+	if (ret) {
+		dev_err(&pdev->dev, "ahub allocate tx fifo failed\n");
+		goto err_clk_put;
+	}
+	ret = tegra30_ahub_allocate_rx_fifo(&i2s->capture_fifo_cif,
+					&i2s->capture_dma_data.addr,
+					&i2s->filter_data_rx);
+	if (ret) {
+		dev_err(&pdev->dev, "ahub allocate rx fifo failed\n");
+		goto err_ahub_free_tx;
+	}
+
+	i2s->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	i2s->playback_dma_data.maxburst = 4;
+	i2s->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	i2s->capture_dma_data.maxburst = 4;
+
 	pm_runtime_enable(&pdev->dev);
 	if (!pm_runtime_enabled(&pdev->dev)) {
 		ret = tegra30_i2s_runtime_resume(&pdev->dev);
@@ -492,6 +502,9 @@ err_suspend:
 		tegra30_i2s_runtime_suspend(&pdev->dev);
 err_pm_disable:
 	pm_runtime_disable(&pdev->dev);
+	tegra30_ahub_free_rx_fifo(i2s->capture_fifo_cif);
+err_ahub_free_tx:
+	tegra30_ahub_free_tx_fifo(i2s->playback_fifo_cif);
 err_clk_put:
 	clk_put(i2s->clk_i2s);
 err:
@@ -506,6 +519,9 @@ static int tegra30_i2s_platform_remove(struct platform_device *pdev)
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra30_i2s_runtime_suspend(&pdev->dev);
 
+	tegra30_ahub_free_rx_fifo(i2s->capture_fifo_cif);
+	tegra30_ahub_free_tx_fifo(i2s->playback_fifo_cif);
+
 	tegra_pcm_platform_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 
diff --git a/sound/soc/tegra/tegra30_i2s.h b/sound/soc/tegra/tegra30_i2s.h
index bea23af..73f5650 100644
--- a/sound/soc/tegra/tegra30_i2s.h
+++ b/sound/soc/tegra/tegra30_i2s.h
@@ -232,9 +232,11 @@ struct tegra30_i2s {
 	enum tegra30_ahub_txcif capture_i2s_cif;
 	enum tegra30_ahub_rxcif capture_fifo_cif;
 	struct snd_dmaengine_dai_dma_data capture_dma_data;
+	struct tegra_dma_filter_data filter_data_rx;
 	enum tegra30_ahub_rxcif playback_i2s_cif;
 	enum tegra30_ahub_txcif playback_fifo_cif;
 	struct snd_dmaengine_dai_dma_data playback_dma_data;
+	struct tegra_dma_filter_data filter_data_tx;
 	struct regmap *regmap;
 };
 
diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
index f056f63..3baea16 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -53,8 +53,22 @@ static const struct snd_pcm_hardware tegra_pcm_hardware = {
 	.fifo_size		= 4,
 };
 
+static struct dma_chan *tegra_pcm_request_chan(struct snd_soc_pcm_runtime *rtd,
+	struct snd_pcm_substream *substream)
+{
+	struct snd_dmaengine_dai_dma_data *dma_data;
+	struct tegra_dma_filter_data *filter_data;
+
+	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+	filter_data = dma_data->filter_data;
+
+	return dma_request_slave_channel(filter_data->dma_dev,
+					filter_data->dma_name);
+}
+
 static const struct snd_dmaengine_pcm_config tegra_dmaengine_pcm_config = {
 	.pcm_hardware = &tegra_pcm_hardware,
+	.compat_request_channel = tegra_pcm_request_chan,
 	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
 	.compat_filter_fn = NULL,
 	.prealloc_buffer_size = PAGE_SIZE * 8,
diff --git a/sound/soc/tegra/tegra_pcm.h b/sound/soc/tegra/tegra_pcm.h
index 68ad901..8c0b1eb 100644
--- a/sound/soc/tegra/tegra_pcm.h
+++ b/sound/soc/tegra/tegra_pcm.h
@@ -31,6 +31,19 @@
 #ifndef __TEGRA_PCM_H__
 #define __TEGRA_PCM_H__
 
+#define TEGRA_DMA_NAME_MAX_LEN	10
+
+/*
+ * Generic DMA DT binding needs the device that raise dma request and dma name
+ * to request a dma channel. tegra30_i2s is a special case. It should be ahub
+ * device and it also has dma name that cannot handled by ASoC dmaengine code.
+ * So we pass the info using filter data in snd_dmaengine_dai_dma_data.
+ */
+struct tegra_dma_filter_data {
+	struct device *dma_dev;
+	char dma_name[TEGRA_DMA_NAME_MAX_LEN];
+};
+
 int tegra_pcm_platform_register(struct device *dev);
 void tegra_pcm_platform_unregister(struct device *dev);
 
-- 
1.8.1.5

