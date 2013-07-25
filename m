Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3GYJjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:39:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38526 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3GYJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:39:23 -0400
Date: Thu, 25 Jul 2013 10:38:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/4] ASoc: kirkwood: change the pcm/dma stream data
	pointer
Message-ID: <20130725093855.GB24642@n2100.arm.linux.org.uk>
References: <20130725111314.66b811bc@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725111314.66b811bc@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:13:14AM +0200, Jean-Francois Moine wrote:
> In the kirkwood pcm/dma driver, the private stream related data pointer
> was hold in the platform drvdata.
> As this pointer may be used by other parts of the audio subsystem,
> this patch uses the substream runtime private data pointer instead.

There's a much better solution to this, which is to get rid of
kirkwood_dma_priv entirely:

diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index d3d4bdc..112c262 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -33,11 +33,11 @@
 	 SNDRV_PCM_FMTBIT_IEC958_SUBFRAME_LE | \
 	 SNDRV_PCM_FMTBIT_IEC958_SUBFRAME_BE)
 
-struct kirkwood_dma_priv {
-	struct snd_pcm_substream *play_stream;
-	struct snd_pcm_substream *rec_stream;
-	struct kirkwood_dma_data *data;
-};
+static struct kirkwood_dma_data *kirkwood_priv(struct snd_pcm_substream *subs)
+{
+	struct snd_soc_pcm_runtime *soc_runtime = subs->private_data;
+	return snd_soc_dai_get_drvdata(soc_runtime->cpu_dai);
+}
 
 static struct snd_pcm_hardware kirkwood_dma_snd_hw = {
 	.info = (SNDRV_PCM_INFO_INTERLEAVED |
@@ -63,8 +63,7 @@ static u64 kirkwood_dma_dmamask = DMA_BIT_MASK(32);
 
 static irqreturn_t kirkwood_dma_irq(int irq, void *dev_id)
 {
-	struct kirkwood_dma_priv *prdata = dev_id;
-	struct kirkwood_dma_data *priv = prdata->data;
+	struct kirkwood_dma_data *priv = dev_id;
 	unsigned long mask, status, cause;
 
 	mask = readl(priv->io + KIRKWOOD_INT_MASK);
@@ -89,10 +88,10 @@ static irqreturn_t kirkwood_dma_irq(int irq, void *dev_id)
 	writel(status, priv->io + KIRKWOOD_INT_CAUSE);
 
 	if (status & KIRKWOOD_INT_CAUSE_PLAY_BYTES)
-		snd_pcm_period_elapsed(prdata->play_stream);
+		snd_pcm_period_elapsed(priv->substream_play);
 
 	if (status & KIRKWOOD_INT_CAUSE_REC_BYTES)
-		snd_pcm_period_elapsed(prdata->rec_stream);
+		snd_pcm_period_elapsed(priv->substream_rec);
 
 	return IRQ_HANDLED;
 }
@@ -126,15 +125,10 @@ static int kirkwood_dma_open(struct snd_pcm_substream *substream)
 {
 	int err;
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *soc_runtime = substream->private_data;
-	struct snd_soc_platform *platform = soc_runtime->platform;
-	struct snd_soc_dai *cpu_dai = soc_runtime->cpu_dai;
-	struct kirkwood_dma_data *priv;
-	struct kirkwood_dma_priv *prdata = snd_soc_platform_get_drvdata(platform);
+	struct kirkwood_dma_data *priv = kirkwood_priv(substream);
 	const struct mbus_dram_target_info *dram;
 	unsigned long addr;
 
-	priv = snd_soc_dai_get_dma_data(cpu_dai, substream);
 	snd_soc_set_runtime_hwparams(substream, &kirkwood_dma_snd_hw);
 
 	/* Ensure that all constraints linked to dma burst are fulfilled */
@@ -157,21 +151,11 @@ static int kirkwood_dma_open(struct snd_pcm_substream *substream)
 	if (err < 0)
 		return err;
 
-	if (prdata == NULL) {
-		prdata = kzalloc(sizeof(struct kirkwood_dma_priv), GFP_KERNEL);
-		if (prdata == NULL)
-			return -ENOMEM;
-
-		prdata->data = priv;
-
+	if (!priv->substream_play && !priv->substream_rec) {
 		err = request_irq(priv->irq, kirkwood_dma_irq, IRQF_SHARED,
-				  "kirkwood-i2s", prdata);
-		if (err) {
-			kfree(prdata);
+				  "kirkwood-i2s", priv);
+		if (err)
 			return -EBUSY;
-		}
-
-		snd_soc_platform_set_drvdata(platform, prdata);
 
 		/*
 		 * Enable Error interrupts. We're only ack'ing them but
@@ -183,11 +167,11 @@ static int kirkwood_dma_open(struct snd_pcm_substream *substream)
 	dram = mv_mbus_dram_info();
 	addr = substream->dma_buffer.addr;
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		prdata->play_stream = substream;
+		priv->substream_play = substream;
 		kirkwood_dma_conf_mbus_windows(priv->io,
 			KIRKWOOD_PLAYBACK_WIN, addr, dram);
 	} else {
-		prdata->rec_stream = substream;
+		priv->substream_rec = substream;
 		kirkwood_dma_conf_mbus_windows(priv->io,
 			KIRKWOOD_RECORD_WIN, addr, dram);
 	}
@@ -197,27 +181,19 @@ static int kirkwood_dma_open(struct snd_pcm_substream *substream)
 
 static int kirkwood_dma_close(struct snd_pcm_substream *substream)
 {
-	struct snd_soc_pcm_runtime *soc_runtime = substream->private_data;
-	struct snd_soc_dai *cpu_dai = soc_runtime->cpu_dai;
-	struct snd_soc_platform *platform = soc_runtime->platform;
-	struct kirkwood_dma_priv *prdata = snd_soc_platform_get_drvdata(platform);
-	struct kirkwood_dma_data *priv;
-
-	priv = snd_soc_dai_get_dma_data(cpu_dai, substream);
+	struct kirkwood_dma_data *priv = kirkwood_priv(substream);
 
-	if (!prdata || !priv)
+	if (!priv)
 		return 0;
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		prdata->play_stream = NULL;
+		priv->substream_play = NULL;
 	else
-		prdata->rec_stream = NULL;
+		priv->substream_rec = NULL;
 
-	if (!prdata->play_stream && !prdata->rec_stream) {
+	if (!priv->substream_play && !priv->substream_rec) {
 		writel(0, priv->io + KIRKWOOD_ERR_MASK);
-		free_irq(priv->irq, prdata);
-		kfree(prdata);
-		snd_soc_platform_set_drvdata(platform, NULL);
+		free_irq(priv->irq, priv);
 	}
 
 	return 0;
@@ -243,13 +219,9 @@ static int kirkwood_dma_hw_free(struct snd_pcm_substream *substream)
 static int kirkwood_dma_prepare(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *soc_runtime = substream->private_data;
-	struct snd_soc_dai *cpu_dai = soc_runtime->cpu_dai;
-	struct kirkwood_dma_data *priv;
+	struct kirkwood_dma_data *priv = kirkwood_priv(substream);
 	unsigned long size, count;
 
-	priv = snd_soc_dai_get_dma_data(cpu_dai, substream);
-
 	/* compute buffer size in term of "words" as requested in specs */
 	size = frames_to_bytes(runtime, runtime->buffer_size);
 	size = (size>>2)-1;
@@ -272,13 +244,9 @@ static int kirkwood_dma_prepare(struct snd_pcm_substream *substream)
 static snd_pcm_uframes_t kirkwood_dma_pointer(struct snd_pcm_substream
 						*substream)
 {
-	struct snd_soc_pcm_runtime *soc_runtime = substream->private_data;
-	struct snd_soc_dai *cpu_dai = soc_runtime->cpu_dai;
-	struct kirkwood_dma_data *priv;
+	struct kirkwood_dma_data *priv = kirkwood_priv(substream);
 	snd_pcm_uframes_t count;
 
-	priv = snd_soc_dai_get_dma_data(cpu_dai, substream);
-
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		count = bytes_to_frames(substream->runtime,
 			readl(priv->io + KIRKWOOD_PLAY_BYTE_COUNT));
diff --git a/sound/soc/kirkwood/kirkwood.h b/sound/soc/kirkwood/kirkwood.h
index 4d92637..10a3aaa 100644
--- a/sound/soc/kirkwood/kirkwood.h
+++ b/sound/soc/kirkwood/kirkwood.h
@@ -129,6 +129,8 @@ struct kirkwood_dma_data {
 	struct clk *extclk;
 	uint32_t ctl_play;
 	uint32_t ctl_rec;
+	struct snd_pcm_substream *substream_play;
+	struct snd_pcm_substream *substream_rec;
 	int irq;
 	int burst;
 };
