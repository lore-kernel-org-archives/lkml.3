Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937755Ab3DKAJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:09:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937495Ab3DKAHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:07:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 20/30] ASoC: samsung: convert to dmaengine API
Date: Thu, 11 Apr 2013 02:05:02 +0200
Message-Id: <1365638712-1028578-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3cB5kbMKPtSnUsARoEQhMt1H3HbIWTJSHg9ZKpcj051
 oAN3qxbIldPviiAl0cD6izAPqRoU+lQZLbRoCByvdhioYUE6QH
 IQNNVhfChNCEChLgf5IRLmU7Jq2lENz90VHVUIFKdbJRMkPWOV
 Y89tX2fIbGzp1pbXxdUVpWmFEfLQylQrQgQvYpe5y7W7YOyfvS
 ZJ0zMF0eNAjsz4htbU7xflJVVX1pwTfx9IgEvLxoLnNlwzmdo3
 eBcAhPJxMaWxN4LpzRhR638QSN6OpzvOc0RI14UM4kWG6S6ELs
 GiPvYpjPDZg7Im/t/2Q974TRGd1gnjizyofhOHgToQ9oimUtsX
 mp6D2ADY44SfEEB61twlj29pMQKbrtvBsHMisqE9zU9eQGo9Pc
 A4cmnkhGrri5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to build the exynos kernel with CONFIG_ARCH_MULTIPLATFORM,
we must convert all users of the Samsung private DMA interface to
the generic dmaengine API. This version of the patch adds the
generic dmaengine API as an alternative to the existing samsung
specific one. Once all the older platforms provide support for
the common dmaengine interfaces, we can remove the old code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 sound/soc/samsung/dma.c   | 219 ++++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/samsung/dma.h   |  15 +++-
 sound/soc/samsung/i2s.c   |   2 -
 sound/soc/samsung/pcm.c   |   1 -
 sound/soc/samsung/spdif.c |   1 -
 5 files changed, 232 insertions(+), 6 deletions(-)

diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index 21b7926..9fd53df 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -22,8 +22,14 @@
 #include <sound/pcm_params.h>
 
 #include <asm/dma.h>
+
+#ifdef CONFIG_SAMSUNG_DMADEV
 #include <mach/hardware.h>
 #include <mach/dma.h>
+#else
+#include <linux/dmaengine.h>
+#include <linux/amba/pl330.h>
+#endif
 
 #include "dma.h"
 
@@ -62,11 +68,13 @@ struct runtime_data {
 
 static void audio_buffdone(void *data);
 
+#ifdef CONFIG_SAMSUNG_DMADEV
 /* dma_enqueue
  *
  * place a dma buffer onto the queue for the dma system
  * to handle.
  */
+
 static void dma_enqueue(struct snd_pcm_substream *substream)
 {
 	struct runtime_data *prtd = substream->runtime->private_data;
@@ -265,6 +273,217 @@ static int dma_trigger(struct snd_pcm_substream *substream, int cmd)
 
 	return ret;
 }
+#else
+/* dma_enqueue
+ *
+ * place a dma buffer onto the queue for the dma system
+ * to handle.
+ */
+
+static void dma_enqueue(struct snd_pcm_substream *substream)
+{
+	struct runtime_data *prtd = substream->runtime->private_data;
+	dma_addr_t pos = prtd->dma_pos;
+	unsigned long period = prtd->dma_period;
+	unsigned int limit;
+	enum dma_transfer_direction direction;
+	struct dma_chan *chan = prtd->params->ch;
+	struct dma_async_tx_descriptor *desc;
+
+	pr_debug("Entered %s\n", __func__);
+
+	limit = (prtd->dma_end - prtd->dma_start) / prtd->dma_period;
+
+	pr_debug("%s: loaded %d, limit %d\n",
+				__func__, prtd->dma_loaded, limit);
+
+	direction = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK
+		     ? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
+
+	while (prtd->dma_loaded < limit) {
+		pr_debug("dma_loaded: %d\n", prtd->dma_loaded);
+
+		if ((pos + period) > prtd->dma_end) {
+			period  = prtd->dma_end - pos;
+			pr_debug("%s: corrected dma len %ld\n",
+					__func__, period);
+		}
+
+		desc = dmaengine_prep_dma_cyclic(chan, pos,
+			 prtd->dma_period*limit, period, direction,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+
+		if (desc) {
+			desc->callback = audio_buffdone;
+			desc->callback_param = substream;
+			dmaengine_submit(desc);
+		}
+
+		prtd->dma_loaded++;
+		pos += period;
+		if (pos >= prtd->dma_end)
+			pos = prtd->dma_start;
+	}
+
+	prtd->dma_pos = pos;
+}
+
+static void audio_buffdone(void *data)
+{
+	struct snd_pcm_substream *substream = data;
+	struct runtime_data *prtd = substream->runtime->private_data;
+
+	pr_debug("Entered %s\n", __func__);
+
+	if (prtd->state & ST_RUNNING) {
+		prtd->dma_pos += prtd->dma_period;
+		if (prtd->dma_pos >= prtd->dma_end)
+			prtd->dma_pos = prtd->dma_start;
+
+		if (substream)
+			snd_pcm_period_elapsed(substream);
+	}
+}
+
+static int dma_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct runtime_data *prtd = runtime->private_data;
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	unsigned long totbytes = params_buffer_bytes(params);
+	struct s3c_dma_params *dma =
+		snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
+
+	pr_debug("Entered %s\n", __func__);
+
+	/* return if this is a bufferless transfer e.g.
+	 * codec <--> BT codec or GSM modem -- lg FIXME */
+	if (!dma)
+		return 0;
+
+	/* this may get called several times by oss emulation
+	 * with different params -HW */
+	if (prtd->params == NULL) {
+		struct dma_slave_config config;
+		dma_cap_mask_t mask;
+
+		/* prepare DMA */
+		prtd->params = dma;
+
+		pr_debug("params %p, channel %d\n", prtd->params,
+			 prtd->params->channel);
+
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_CYCLIC, mask);
+
+		prtd->params->ch = dma_request_slave_channel_compat(mask,
+			pl330_filter, (void *)prtd->params->channel,
+			rtd->cpu_dai->dev, prtd->params->ch_name);
+
+		memset(&config, 0, sizeof(struct dma_slave_config));
+
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+			config.direction = DMA_MEM_TO_DEV;
+			config.dst_addr = prtd->params->dma_addr;
+			config.dst_addr_width = prtd->params->dma_size;
+			config.dst_maxburst = 1;
+			dmaengine_slave_config(prtd->params->ch, &config);
+		} else {
+			config.direction = DMA_DEV_TO_MEM;
+			config.src_addr = prtd->params->dma_addr;
+			config.src_addr_width = prtd->params->dma_size;
+			config.src_maxburst = 1;
+			dmaengine_slave_config(prtd->params->ch, &config);
+		}
+	}
+
+	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
+
+	runtime->dma_bytes = totbytes;
+
+	spin_lock_irq(&prtd->lock);
+	prtd->dma_loaded = 0;
+	prtd->dma_period = params_period_bytes(params);
+	prtd->dma_start = runtime->dma_addr;
+	prtd->dma_pos = prtd->dma_start;
+	prtd->dma_end = prtd->dma_start + totbytes;
+	spin_unlock_irq(&prtd->lock);
+
+	return 0;
+}
+
+static int dma_hw_free(struct snd_pcm_substream *substream)
+{
+	struct runtime_data *prtd = substream->runtime->private_data;
+
+	pr_debug("Entered %s\n", __func__);
+
+	snd_pcm_set_runtime_buffer(substream, NULL);
+
+	if (prtd->params) {
+		dmaengine_terminate_all(prtd->params->ch);
+		dma_release_channel(prtd->params->ch);
+		prtd->params = NULL;
+	}
+
+	return 0;
+}
+
+static int dma_prepare(struct snd_pcm_substream *substream)
+{
+	struct runtime_data *prtd = substream->runtime->private_data;
+	int ret = 0;
+
+	pr_debug("Entered %s\n", __func__);
+
+	/* return if this is a bufferless transfer e.g.
+	 * codec <--> BT codec or GSM modem -- lg FIXME */
+	if (!prtd->params)
+		return 0;
+
+	/* flush the DMA channel */
+	dmaengine_terminate_all(prtd->params->ch);
+
+	prtd->dma_loaded = 0;
+	prtd->dma_pos = prtd->dma_start;
+
+	/* enqueue dma buffers */
+	dma_enqueue(substream);
+
+	return ret;
+}
+
+static int dma_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct runtime_data *prtd = substream->runtime->private_data;
+	int ret = 0;
+
+	pr_debug("Entered %s\n", __func__);
+
+	spin_lock(&prtd->lock);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		prtd->state |= ST_RUNNING;
+		dma_async_issue_pending(prtd->params->ch);
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+		prtd->state &= ~ST_RUNNING;
+		dmaengine_terminate_all(prtd->params->ch);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	spin_unlock(&prtd->lock);
+
+	return ret;
+}
+#endif
 
 static snd_pcm_uframes_t
 dma_pointer(struct snd_pcm_substream *substream)
diff --git a/sound/soc/samsung/dma.h b/sound/soc/samsung/dma.h
index 189a7a6..6bd1857 100644
--- a/sound/soc/samsung/dma.h
+++ b/sound/soc/samsung/dma.h
@@ -12,13 +12,24 @@
 #ifndef _S3C_AUDIO_H
 #define _S3C_AUDIO_H
 
+#ifdef CONFIG_SAMSUNG_DMADEV
+#include <mach/dma.h>
+#endif
+
 struct s3c_dma_params {
+#ifdef CONFIG_SAMSUNG_DMADEV
 	struct s3c2410_dma_client *client;	/* stream identifier */
+	unsigned ch;
+	struct samsung_dma_ops *ops;
+#else
+	struct s3c2410_dma_client {
+		char *name;			/* unused */
+	} *client;
+	struct dma_chan *ch;
+#endif
 	int channel;				/* Channel ID */
 	dma_addr_t dma_addr;
 	int dma_size;			/* Size of the DMA transfer */
-	unsigned ch;
-	struct samsung_dma_ops *ops;
 	char *ch_name;
 };
 
diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index d7231e3..61f2622 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -22,8 +22,6 @@
 #include <sound/soc.h>
 #include <sound/pcm_params.h>
 
-#include <mach/dma.h>
-
 #include <linux/platform_data/asoc-s3c.h>
 
 #include "dma.h"
diff --git a/sound/soc/samsung/pcm.c b/sound/soc/samsung/pcm.c
index 13bab79..b5f267c 100644
--- a/sound/soc/samsung/pcm.c
+++ b/sound/soc/samsung/pcm.c
@@ -20,7 +20,6 @@
 #include <sound/pcm_params.h>
 
 #include <linux/platform_data/asoc-s3c.h>
-#include <mach/dma.h>
 
 #include "dma.h"
 #include "pcm.h"
diff --git a/sound/soc/samsung/spdif.c b/sound/soc/samsung/spdif.c
index 5008e5b..ee792aa 100644
--- a/sound/soc/samsung/spdif.c
+++ b/sound/soc/samsung/spdif.c
@@ -18,7 +18,6 @@
 #include <sound/pcm_params.h>
 
 #include <linux/platform_data/asoc-s3c.h>
-#include <mach/dma.h>
 
 #include "dma.h"
 #include "spdif.h"
-- 
1.8.1.2

