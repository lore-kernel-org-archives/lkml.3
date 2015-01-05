Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbbAEWjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:39:46 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:53068 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbbAEWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:39:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        dmaengine@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-mmc@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH, RFC] MIPS: jz4740: use dma filter function
Date: Mon, 05 Jan 2015 23:39:35 +0100
Message-ID: <22569458.nE7JkNNnz3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:OzkKx3cYm5t0cZsLKUSR+/Rt4LNTNZez6eMYES6w4c1dHi+gLb7
 Jt0J7qfHd6ZmE4vobvf7GfJS8QR8OblodAVByW6hHtujkd7YGh+8zDIFT3ZiBgpVVDqaOV2
 onrFV28Df6ulxrlce/vTeewU5R0OzayjhYEM8SOq7tIg5Hry4GEZLwD1xIB+Vh2SO5XTJiA
 GVlKER/5B4vkG65FW8BQA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed on the topic of shmobile DMA today, jz4740 is the only
user of the slave_id field in dma_slave_config besides shmobile. This
use is really incompatible with the way that other drivers use the
dmaengine API, so we should get rid of it.

This adds a trivial filter function that uses the filter param to
pass the dma type, and uses that in both drivers.

With this patch and the respective shmobile change, we can remove the
slave_id field from dma_slave_config.

To make the drivers more generic, another patch would be required
that passes the filter function and the argument through platform_data,
but that can be done later.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/mips/include/asm/mach-jz4740/dma.h |  7 +++++++
 drivers/dma/dma-jz4740.c                | 11 +++++++++--
 drivers/mmc/host/jz4740_mmc.c           |  8 ++++----
 sound/soc/jz4740/jz4740-i2s.c           | 18 ++++++++++++------
 4 files changed, 32 insertions(+), 12 deletions(-)

completely untested

diff --git a/arch/mips/include/asm/mach-jz4740/dma.h b/arch/mips/include/asm/mach-jz4740/dma.h
index 14ecc5313d2d..ece7e39cdacb 100644
--- a/arch/mips/include/asm/mach-jz4740/dma.h
+++ b/arch/mips/include/asm/mach-jz4740/dma.h
@@ -16,6 +16,13 @@
 #ifndef __ASM_MACH_JZ4740_DMA_H__
 #define __ASM_MACH_JZ4740_DMA_H__
 
+#include <linux/dmaengine.h>
+
+static inline bool jz4740_dma_filter_fn(struct dma_chan *chan, void *filter_param)
+{
+	chan->private = filter_param;
+}
+
 enum jz4740_dma_request_type {
 	JZ4740_DMA_TYPE_AUTO_REQUEST	= 8,
 	JZ4740_DMA_TYPE_UART_TRANSMIT	= 20,
diff --git a/drivers/dma/dma-jz4740.c b/drivers/dma/dma-jz4740.c
index bdeafeefa5f6..f02e60e8e5cc 100644
--- a/drivers/dma/dma-jz4740.c
+++ b/drivers/dma/dma-jz4740.c
@@ -119,6 +119,7 @@ struct jz4740_dma_desc {
 struct jz4740_dmaengine_chan {
 	struct virt_dma_chan vchan;
 	unsigned int id;
+	unsigned int slave;
 
 	dma_addr_t fifo_addr;
 	unsigned int transfer_shift;
@@ -220,6 +221,11 @@ static int jz4740_dma_slave_config(struct dma_chan *c,
 	enum jz4740_dma_flags flags;
 	uint32_t cmd;
 
+	/* deprecated: all drivers should request the channel with
+	 * the correct slave argument */
+	if (!chan->slave)
+		chan->slave = config->slave_id;
+
 	switch (config->direction) {
 	case DMA_MEM_TO_DEV:
 		flags = JZ4740_DMA_SRC_AUTOINC;
@@ -265,8 +271,7 @@ static int jz4740_dma_slave_config(struct dma_chan *c,
 
 	jz4740_dma_write(dmadev, JZ_REG_DMA_CMD(chan->id), cmd);
 	jz4740_dma_write(dmadev, JZ_REG_DMA_STATUS_CTRL(chan->id), 0);
-	jz4740_dma_write(dmadev, JZ_REG_DMA_REQ_TYPE(chan->id),
-		config->slave_id);
+	jz4740_dma_write(dmadev, JZ_REG_DMA_REQ_TYPE(chan->id), chan->slave);
 
 	return 0;
 }
@@ -513,6 +518,8 @@ static enum dma_status jz4740_dma_tx_status(struct dma_chan *c,
 
 static int jz4740_dma_alloc_chan_resources(struct dma_chan *c)
 {
+	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
+	chan->slave = (unsigned long)c->private;
 	return 0;
 }
 
diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 76e8bce6f46e..a6680959ce83 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -178,13 +178,15 @@ static int jz4740_mmc_acquire_dma_channels(struct jz4740_mmc_host *host)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	host->dma_tx = dma_request_channel(mask, NULL, host);
+	host->dma_tx = dma_request_channel(mask, jz4740_dma_filter_fn,
+					   (void*)JZ4740_DMA_TYPE_MMC_TRANSMIT);
 	if (!host->dma_tx) {
 		dev_err(mmc_dev(host->mmc), "Failed to get dma_tx channel\n");
 		return -ENODEV;
 	}
 
-	host->dma_rx = dma_request_channel(mask, NULL, host);
+	host->dma_rx = dma_request_channel(mask, jz4740_dma_filter_fn,
+					   (void*)JZ4740_DMA_TYPE_MMC_RECEIVE);
 	if (!host->dma_rx) {
 		dev_err(mmc_dev(host->mmc), "Failed to get dma_rx channel\n");
 		goto free_master_write;
@@ -283,12 +285,10 @@ static int jz4740_mmc_start_dma_transfer(struct jz4740_mmc_host *host,
 	if (data->flags & MMC_DATA_WRITE) {
 		conf.direction = DMA_MEM_TO_DEV;
 		conf.dst_addr = host->mem_res->start + JZ_REG_MMC_TXFIFO;
-		conf.slave_id = JZ4740_DMA_TYPE_MMC_TRANSMIT;
 		chan = host->dma_tx;
 	} else {
 		conf.direction = DMA_DEV_TO_MEM;
 		conf.src_addr = host->mem_res->start + JZ_REG_MMC_RXFIFO;
-		conf.slave_id = JZ4740_DMA_TYPE_MMC_RECEIVE;
 		chan = host->dma_rx;
 	}
 
diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index d3d45c6f064f..7a60c075bd81 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -31,10 +31,12 @@
 #include <sound/initval.h>
 #include <sound/dmaengine_pcm.h>
 
+#include <asm/mach-jz4740/dma.h>
+
 #include "jz4740-i2s.h"
 
-#define JZ4740_DMA_TYPE_AIC_TRANSMIT 24
-#define JZ4740_DMA_TYPE_AIC_RECEIVE 25
+#define JZ4740_DMA_TYPE_AIC_TRANSMIT (void *)24ul
+#define JZ4740_DMA_TYPE_AIC_RECEIVE (void *)25ul
 
 #define JZ_REG_AIC_CONF		0x00
 #define JZ_REG_AIC_CTRL		0x04
@@ -337,13 +339,13 @@ static void jz4740_i2c_init_pcm_config(struct jz4740_i2s *i2s)
 	/* Playback */
 	dma_data = &i2s->playback_dma_data;
 	dma_data->maxburst = 16;
-	dma_data->slave_id = JZ4740_DMA_TYPE_AIC_TRANSMIT;
+	dma_data->filter_data = JZ4740_DMA_TYPE_AIC_TRANSMIT;
 	dma_data->addr = i2s->phys_base + JZ_REG_AIC_FIFO;
 
 	/* Capture */
 	dma_data = &i2s->capture_dma_data;
 	dma_data->maxburst = 16;
-	dma_data->slave_id = JZ4740_DMA_TYPE_AIC_RECEIVE;
+	dma_data->filter_data = JZ4740_DMA_TYPE_AIC_RECEIVE;
 	dma_data->addr = i2s->phys_base + JZ_REG_AIC_FIFO;
 }
 
@@ -415,6 +417,10 @@ static const struct snd_soc_component_driver jz4740_i2s_component = {
 	.name		= "jz4740-i2s",
 };
 
+static struct snd_dmaengine_pcm_config jz4740_i2s_pcm_config = {
+	.filter_fn = jz4740_dma_filter_fn,
+};
+
 static int jz4740_i2s_dev_probe(struct platform_device *pdev)
 {
 	struct jz4740_i2s *i2s;
@@ -447,8 +453,8 @@ static int jz4740_i2s_dev_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	return devm_snd_dmaengine_pcm_register(&pdev->dev, NULL,
-		SND_DMAENGINE_PCM_FLAG_COMPAT);
+	return devm_snd_dmaengine_pcm_register(&pdev->dev,
+		jz4740_i2s_pcm_config, SND_DMAENGINE_PCM_FLAG_COMPAT);
 }
 
 static struct platform_driver jz4740_i2s_driver = {

