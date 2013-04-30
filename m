Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab3D3KHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 06:07:41 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:39839 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863Ab3D3KHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 06:07:39 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        zonque@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH 1/1] ASoC: McASP: Add device tree binding for defining separate clock and sync used by tx and rx.
Date: Tue, 30 Apr 2013 12:07:18 +0200
Message-Id: <1367316438-20267-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new property tx-rx-clk-separate which we can distinquish between common
and separate clock for tx and rx blocks.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
 .../bindings/sound/davinci-mcasp-audio.txt         |    2 ++
 include/linux/platform_data/davinci_asp.h          |    1 +
 sound/soc/davinci/davinci-mcasp.c                  |   11 ++++++++++-
 sound/soc/davinci/davinci-mcasp.h                  |    1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.txt b/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.txt
index 374e145..9afd2a0 100644
--- a/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.txt
+++ b/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.txt
@@ -23,6 +23,8 @@ Optional properties:
 - rx-num-evt : FIFO levels.
 - sram-size-playback : size of sram to be allocated during playback
 - sram-size-capture  : size of sram to be allocated during capture
+- tx-rx-clk-separate : separate clock and frame sync used by transmit and
+				receive sections
 
 Example:
 
diff --git a/include/linux/platform_data/davinci_asp.h b/include/linux/platform_data/davinci_asp.h
index 8db5ae0..da3099b 100644
--- a/include/linux/platform_data/davinci_asp.h
+++ b/include/linux/platform_data/davinci_asp.h
@@ -84,6 +84,7 @@ struct snd_platform_data {
 	u8 version;
 	u8 txnumevt;
 	u8 rxnumevt;
+	u8 tx_rx_clk_separate;
 };
 
 enum {
diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 2953c55..849a187 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -771,7 +771,12 @@ static void davinci_hw_param(struct davinci_audio_dev *dev, int stream)
 	for (i = 0; i < active_slots; i++)
 		mask |= (1 << i);
 
-	mcasp_clr_bits(dev->base + DAVINCI_MCASP_ACLKXCTL_REG, TX_ASYNC);
+	if (dev->tx_rx_clk_separate == 1)
+		mcasp_set_bits(dev->base + DAVINCI_MCASP_ACLKXCTL_REG,
+				TX_ASYNC);
+	else
+		mcasp_clr_bits(dev->base + DAVINCI_MCASP_ACLKXCTL_REG,
+				TX_ASYNC);
 
 	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		/* bit stream is MSB first  with no delay */
@@ -1121,6 +1126,9 @@ static struct snd_platform_data *davinci_mcasp_set_pdata_from_of(
 	if (ret >= 0)
 		pdata->sram_size_capture = val;
 
+	if (of_find_property(np, "tx-rx-clk-separate", NULL))
+		pdata->tx_rx_clk_separate = 1;
+
 	return  pdata;
 
 nodata:
@@ -1191,6 +1199,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	dev->version = pdata->version;
 	dev->txnumevt = pdata->txnumevt;
 	dev->rxnumevt = pdata->rxnumevt;
+	dev->tx_rx_clk_separate = pdata->tx_rx_clk_separate;
 	dev->dev = &pdev->dev;
 
 	dma_data = &dev->dma_params[SNDRV_PCM_STREAM_PLAYBACK];
diff --git a/sound/soc/davinci/davinci-mcasp.h b/sound/soc/davinci/davinci-mcasp.h
index a9ac0c1..4440666 100644
--- a/sound/soc/davinci/davinci-mcasp.h
+++ b/sound/soc/davinci/davinci-mcasp.h
@@ -39,6 +39,7 @@ struct davinci_audio_dev {
 	u8	*serial_dir;
 	u8	version;
 	u16	bclk_lrclk_ratio;
+	u8	tx_rx_clk_separate;
 
 	/* McASP FIFO related */
 	u8	txnumevt;
-- 
1.7.9.5

