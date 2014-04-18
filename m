Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaDRIVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:21:37 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30124
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbaDRIS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:18:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzd799hzz1f42h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6h208chzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: <hongbo.zhang@freescale.com>
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <leo.li@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v4 8/8] DMA: Freescale: add suspend resume functions for DMA driver
Date: Fri, 18 Apr 2014 16:17:51 +0800
Message-ID: <1397809071-5353-9-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

This patch adds suspend resume functions for Freescale DMA driver.
.prepare callback is used to stop further descriptors from being added into the
pending queue, and also issue pending queues into execution if there is any.
.suspend callback makes sure all the pending jobs are cleaned up and all the
channels are idle, and save the mode registers.
.resume callback re-initializes the channels by restore the mode registers.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 drivers/dma/fsldma.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/fsldma.h |   16 ++++++++
 2 files changed, 116 insertions(+)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 6e1c9b3..836fc27 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -400,6 +400,14 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 
 	spin_lock_bh(&chan->desc_lock);
 
+#ifdef CONFIG_PM
+	if (unlikely(chan->pm_state != RUNNING)) {
+		chan_dbg(chan, "cannot submit due to suspend\n");
+		spin_unlock_bh(&chan->desc_lock);
+		return -1;
+	}
+#endif
+
 	/*
 	 * assign cookies to all of the software descriptors
 	 * that make up this transaction
@@ -1312,6 +1320,9 @@ static int fsl_dma_chan_probe(struct fsldma_device *fdev,
 	INIT_LIST_HEAD(&chan->ld_running);
 	INIT_LIST_HEAD(&chan->ld_completed);
 	chan->idle = true;
+#ifdef CONFIG_PM
+	chan->pm_state = RUNNING;
+#endif
 
 	chan->common.device = &fdev->common;
 	dma_cookie_init(&chan->common);
@@ -1451,6 +1462,92 @@ static int fsldma_of_remove(struct platform_device *op)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int fsldma_prepare(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fsldma_device *fdev = platform_get_drvdata(pdev);
+	struct fsldma_chan *chan;
+	int i;
+
+	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
+		chan = fdev->chan[i];
+		if (!chan)
+			continue;
+
+		spin_lock_bh(&chan->desc_lock);
+		chan->pm_state = SUSPENDING;
+		if (!list_empty(&chan->ld_pending))
+			fsl_chan_xfer_ld_queue(chan);
+		spin_unlock_bh(&chan->desc_lock);
+	}
+
+	return 0;
+}
+
+static int fsldma_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fsldma_device *fdev = platform_get_drvdata(pdev);
+	struct fsldma_chan *chan;
+	int i;
+
+	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
+		chan = fdev->chan[i];
+		if (!chan)
+			continue;
+
+		spin_lock_bh(&chan->desc_lock);
+		if (!chan->idle)
+			goto out;
+		chan->regs_save.mr = get_mr(chan);
+		chan->pm_state = SUSPENDED;
+		spin_unlock_bh(&chan->desc_lock);
+	}
+	return 0;
+
+out:
+	for (; i >= 0; i--) {
+		chan = fdev->chan[i];
+		if (!chan)
+			continue;
+		chan->pm_state = RUNNING;
+		spin_unlock_bh(&chan->desc_lock);
+	}
+	return -EBUSY;
+}
+
+static int fsldma_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fsldma_device *fdev = platform_get_drvdata(pdev);
+	struct fsldma_chan *chan;
+	u32 mode;
+	int i;
+
+	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
+		chan = fdev->chan[i];
+		if (!chan)
+			continue;
+
+		spin_lock_bh(&chan->desc_lock);
+		mode = chan->regs_save.mr
+			& ~FSL_DMA_MR_CS & ~FSL_DMA_MR_CC & ~FSL_DMA_MR_CA;
+		set_mr(chan, mode);
+		chan->pm_state = RUNNING;
+		spin_unlock_bh(&chan->desc_lock);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops fsldma_pm_ops = {
+	.prepare	= fsldma_prepare,
+	.suspend	= fsldma_suspend,
+	.resume		= fsldma_resume,
+};
+#endif
+
 static const struct of_device_id fsldma_of_ids[] = {
 	{ .compatible = "fsl,elo3-dma", },
 	{ .compatible = "fsl,eloplus-dma", },
@@ -1463,6 +1560,9 @@ static struct platform_driver fsldma_of_driver = {
 		.name = "fsl-elo-dma",
 		.owner = THIS_MODULE,
 		.of_match_table = fsldma_of_ids,
+#ifdef CONFIG_PM
+		.pm = &fsldma_pm_ops,
+#endif
 	},
 	.probe = fsldma_of_probe,
 	.remove = fsldma_of_remove,
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index ec19517..eecaf9e 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -134,6 +134,18 @@ struct fsldma_device {
 #define FSL_DMA_CHAN_PAUSE_EXT	0x00001000
 #define FSL_DMA_CHAN_START_EXT	0x00002000
 
+#ifdef CONFIG_PM
+struct fsldma_chan_regs_save {
+	u32 mr;
+};
+
+enum fsldma_pm_state {
+	RUNNING = 0,
+	SUSPENDING,
+	SUSPENDED,
+};
+#endif
+
 struct fsldma_chan {
 	char name[8];			/* Channel name */
 	struct fsldma_chan_regs __iomem *regs;
@@ -161,6 +173,10 @@ struct fsldma_chan {
 	struct tasklet_struct tasklet;
 	u32 feature;
 	bool idle;			/* DMA controller is idle */
+#ifdef CONFIG_PM
+	struct fsldma_chan_regs_save regs_save;
+	enum fsldma_pm_state pm_state;
+#endif
 
 	void (*toggle_ext_pause)(struct fsldma_chan *fsl_chan, int enable);
 	void (*toggle_ext_start)(struct fsldma_chan *fsl_chan, int enable);
-- 
1.7.9.5



