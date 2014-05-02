Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaEBQLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:11:24 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53823 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaEBQLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:11:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Mark Brown <broonie@kernel.org>, Xia Kaixu <kaixu.xia@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 13/15] ASoC: SND_S3C_DMA_LEGACY needs S3C24XX_DMA
Date: Fri, 02 May 2014 18:10:41 +0200
Message-ID: <23328024.fZtE3FFkWh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <11471248.qyIXLf6t3H@diego>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org> <7071653.m3UbztQEJc@wuerfel> <11471248.qyIXLf6t3H@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:AAIBSTzVuI+KbhJhlAmPBW7U9VhcOC8HXx/YUgo/a97
 25c96vrjI9tRqgHjGRdNzaGvE9FBP0YEAinviwLKRe0h+iFiRv
 SZAQ3uCR1/Ektq6nOS7FBHSE1lYf+9t625ewQ1RgfCe6UxIidW
 oV34iPQCi/SkNR5wr7ORYFhsRNdLMHxGesUKajqWQW2w8G5TKy
 Qj0+97OVcih7LGhnYGfpcFZDijwbuUYxovUTT21Uz5iSkKQi2s
 ZUEurCSXjTMBsG07v/p6uHZZuW9C5SiIoupgBqvmoVGAiLTxw/
 WKAewCLphgozxxwcv2fTb4zCh9mpyN9sB1e3qu80iwIf+drJUs
 qXzz2ib0HVb30gr68bWI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2014 12:25:58 Heiko Stübner wrote:
> 
> Just to mention, we have a dmaengine driver for s3c24xx  . Correct 
> platform-data is present for all s3c24xx socs (in mach-s3c24xx/common.c) .
> 
> Mark already removed support for the legacy API from the s3c64xx spi driver 
> (used by s3c2416 and s3c2443), so I guess to way forward would be to "simply" 
> convert asoc and s3cmci to dmaengine and get rid of it altogether.

For asoc, this is probably very simple: the dma.c gets replaced with the
dmaengine.c, and the three drivers calling s3c2410_dma_ctrl(dma_data->channel, S3C2410_DMAOP_STARTED) get changed to do something equivalent.

> I just never had hardware using the old mci driver or with any previously 
> working sound and didn't trust my experience to be enough to be able to do 
> such a conversion "on the fly" like you below in the opposite direction 

What I did was much easier: the dma.c file was already using a wrapper
around both interfaces, I just unwrapped it. For mci, you'd have to
replace one API with another incompatible one. I've tried a conversion
in the patch below, but I also don't enough confidence in this to
submit it.

What is interesting however is that none of the three defconfigs we have
for S3C24xx actually uses DMA wiht MMC_S3C: tct_hammer doesn't have
any MMC support, and mini2440_defonfig as well as s3c2410_defconfig
enable the MMC driver in PIO-only mode.

When Ben Dooks did all the changes to the DMA code in that driver, but
he also marked DMA support as 'EXPERIMENTAL'. Maybe we can just get
away with deprecating that?

	Arnd

8<------
Subject: convert s3cmci to use dmaengine

This is an attempt to migrate s3cmci from the samsung-proprietary DMA
interface to the generic dmaengine API. I don't really understand
what I'm doing here, and this is not tested at all. Somebody who
has the hardware and understands this code can probably get it to
work, but I would expect a couple of small bugs to get introduced.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index f237826..02847d3 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
+#include <linux/dmaengine.h>
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
 #include <linux/cpufreq.h>
@@ -28,6 +29,7 @@
 #include <mach/gpio-samsung.h>
 
 #include <linux/platform_data/mmc-s3cmci.h>
+#include <linux/platform_data/dma-s3c24xx.h>
 
 #include "s3cmci.h"
 
@@ -140,10 +142,6 @@ static const int dbgmap_debug = dbg_err | dbg_debug;
 		dev_dbg(&host->pdev->dev, args);  \
 	} while (0)
 
-static struct s3c2410_dma_client s3cmci_dma_client = {
-	.name		= "s3c-mci",
-};
-
 static void finalize_request(struct s3cmci_host *host);
 static void s3cmci_send_request(struct mmc_host *mmc);
 static void s3cmci_reset(struct s3cmci_host *host);
@@ -841,9 +839,7 @@ static irqreturn_t s3cmci_irq_cd(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch,
-				     void *buf_id, int size,
-				     enum s3c2410_dma_buffresult result)
+static void s3cmci_dma_done_callback(void *buf_id)
 {
 	struct s3cmci_host *host = buf_id;
 	unsigned long iflags;
@@ -856,45 +852,18 @@ static void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch,
 
 	BUG_ON(!host->mrq);
 	BUG_ON(!host->mrq->data);
-	BUG_ON(!host->dmatogo);
 
 	spin_lock_irqsave(&host->complete_lock, iflags);
 
-	if (result != S3C2410_RES_OK) {
-		dbg(host, dbg_fail, "DMA FAILED: csta=0x%08x dsta=0x%08x "
-			"fsta=0x%08x dcnt:0x%08x result:0x%08x toGo:%u\n",
-			mci_csta, mci_dsta, mci_fsta,
-			mci_dcnt, result, host->dmatogo);
-
-		goto fail_request;
-	}
-
-	host->dmatogo--;
-	if (host->dmatogo) {
-		dbg(host, dbg_dma, "DMA DONE  Size:%i DSTA:[%08x] "
-			"DCNT:[%08x] toGo:%u\n",
-			size, mci_dsta, mci_dcnt, host->dmatogo);
-
-		goto out;
-	}
-
-	dbg(host, dbg_dma, "DMA FINISHED Size:%i DSTA:%08x DCNT:%08x\n",
-		size, mci_dsta, mci_dcnt);
+	dbg(host, dbg_dma, "DMA FINISHED DSTA:%08x DCNT:%08x\n",
+		mci_dsta, mci_dcnt);
 
 	host->dma_complete = 1;
 	host->complete_what = COMPLETION_FINALIZE;
 
-out:
 	tasklet_schedule(&host->pio_tasklet);
 	spin_unlock_irqrestore(&host->complete_lock, iflags);
 	return;
-
-fail_request:
-	host->mrq->data->error = -EINVAL;
-	host->complete_what = COMPLETION_FINALIZE;
-	clear_imask(host);
-
-	goto out;
 }
 
 static void finalize_request(struct s3cmci_host *host)
@@ -966,7 +935,7 @@ static void finalize_request(struct s3cmci_host *host)
 	 * DMA channel and the fifo to clear out any garbage. */
 	if (mrq->data->error != 0) {
 		if (s3cmci_host_usedma(host))
-			s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
+			dmaengine_terminate_all(host->dma);
 
 		if (host->is2440) {
 			/* Clear failure register and reset fifo. */
@@ -993,26 +962,27 @@ request_done:
 }
 
 static void s3cmci_dma_setup(struct s3cmci_host *host,
-			     enum dma_data_direction source)
+			     enum dma_transfer_direction source)
 {
-	static enum dma_data_direction last_source = -1;
-	static int setup_ok;
+	static enum dma_transfer_direction last_source = -1;
+	struct dma_slave_config slave_config;
 
 	if (last_source == source)
 		return;
 
-	last_source = source;
-
-	s3c2410_dma_devconfig(host->dma, source,
-			      host->mem->start + host->sdidata);
-
-	if (!setup_ok) {
-		s3c2410_dma_config(host->dma, 4);
-		s3c2410_dma_set_buffdone_fn(host->dma,
-					    s3cmci_dma_done_callback);
-		s3c2410_dma_setflags(host->dma, S3C2410_DMAF_AUTOSTART);
-		setup_ok = 1;
+	memset(&slave_config, 0, sizeof(struct dma_slave_config));
+	slave_config.direction = source;
+	if (source == DMA_DEV_TO_MEM) {
+		slave_config.src_addr = host->mem->start + host->sdidata;
+		slave_config.src_addr_width = 4;
+		slave_config.src_maxburst = 1;
+	} else {
+		slave_config.dst_addr = host->mem->start + host->sdidata;
+		slave_config.dst_addr_width = 4;
+		slave_config.dst_maxburst = 1;
 	}
+	last_source = source;
+	dmaengine_slave_config(host->dma, &slave_config);
 }
 
 static void s3cmci_send_command(struct s3cmci_host *host,
@@ -1162,41 +1132,33 @@ static int s3cmci_prepare_pio(struct s3cmci_host *host, struct mmc_data *data)
 
 static int s3cmci_prepare_dma(struct s3cmci_host *host, struct mmc_data *data)
 {
-	int dma_len, i;
-	int rw = data->flags & MMC_DATA_WRITE;
+	int dma_len;
+	int dir = data->flags & MMC_DATA_WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	struct dma_async_tx_descriptor *desc;
 
 	BUG_ON((data->flags & BOTH_DIR) == BOTH_DIR);
 
-	s3cmci_dma_setup(host, rw ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
-	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
-
-	dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
-			     rw ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	s3cmci_dma_setup(host, dir);
 
+	dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len, dir);
 	if (dma_len == 0)
 		return -ENOMEM;
 
-	host->dma_complete = 0;
-	host->dmatogo = dma_len;
-
-	for (i = 0; i < dma_len; i++) {
-		int res;
+	desc = dmaengine_prep_slave_sg(host->dma, data->sg, dma_len,
+				       dir, DMA_CTRL_ACK);
 
-		dbg(host, dbg_dma, "enqueue %i: %08x@%u\n", i,
-		    sg_dma_address(&data->sg[i]),
-		    sg_dma_len(&data->sg[i]));
+	if (!desc) {
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, dma_len, dir);
+		return -EIO;
+	}
 
-		res = s3c2410_dma_enqueue(host->dma, host,
-					  sg_dma_address(&data->sg[i]),
-					  sg_dma_len(&data->sg[i]));
+	host->dma_complete = 0;
 
-		if (res) {
-			s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
-			return -EBUSY;
-		}
-	}
+	desc->callback = s3cmci_dma_done_callback;
+	desc->callback_param = host;
 
-	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_START);
+	dmaengine_submit(desc);
+	dma_async_issue_pending(host->dma);
 
 	return 0;
 }
@@ -1765,9 +1727,14 @@ static int s3cmci_probe(struct platform_device *pdev)
 	/* depending on the dma state, get a dma channel to use. */
 
 	if (s3cmci_host_usedma(host)) {
-		host->dma = s3c2410_dma_request(DMACH_SDI, &s3cmci_dma_client,
-						host);
-		if (host->dma < 0) {
+		dma_cap_mask_t mask;
+        
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_SLAVE, mask);
+
+		host->dma = dma_request_channel(mask, s3c24xx_dma_filter, (void *)DMACH_SDI);
+
+		if (!host->dma) {
 			dev_err(&pdev->dev, "cannot get DMA channel.\n");
 			if (!s3cmci_host_canpio()) {
 				ret = -EBUSY;
@@ -1816,9 +1783,9 @@ static int s3cmci_probe(struct platform_device *pdev)
 	mmc->max_segs		= 128;
 
 	dbg(host, dbg_debug,
-	    "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
+	    "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u.\n",
 	    (host->is2440?"2440":""),
-	    host->base, host->irq, host->irq_cd, host->dma);
+	    host->base, host->irq, host->irq_cd);
 
 	ret = s3cmci_cpufreq_register(host);
 	if (ret) {
@@ -1852,7 +1819,7 @@ static int s3cmci_probe(struct platform_device *pdev)
 
  probe_free_dma:
 	if (s3cmci_host_usedma(host))
-		s3c2410_dma_free(host->dma, &s3cmci_dma_client);
+		dma_release_channel(host->dma);
 
  probe_free_gpio_wp:
 	if (!host->pdata->no_wprotect)
@@ -1914,7 +1881,7 @@ static int s3cmci_remove(struct platform_device *pdev)
 	tasklet_disable(&host->pio_tasklet);
 
 	if (s3cmci_host_usedma(host))
-		s3c2410_dma_free(host->dma, &s3cmci_dma_client);
+		dma_release_channel(host->dma);
 
 	free_irq(host->irq, host);
 

