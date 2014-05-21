Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaEUISo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:18:44 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:42388
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751691AbaEUISj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:18:39 -0400
From: <hongbo.zhang@freescale.com>
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <leo.li@freescale.com>, <scottwood@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v5 2/3] DMA: Freescale: add suspend resume functions for DMA driver
Date: Wed, 21 May 2014 16:03:02 +0800
Message-ID: <1400659383-6555-3-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400659383-6555-1-git-send-email-hongbo.zhang@freescale.com>
References: <1400659383-6555-1-git-send-email-hongbo.zhang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(81342001)(46102001)(77982001)(50226001)(62966002)(36756003)(87936001)(87286001)(76482001)(77156001)(4396001)(50466002)(6806004)(83322001)(48376002)(44976005)(76176999)(92726001)(77096999)(19580395003)(2201001)(92566001)(86152002)(85852003)(74662001)(31966008)(83072002)(99396002)(74502001)(19580405001)(89996001)(50986999)(64706001)(33646001)(21056001)(20776003)(575784001)(86362001)(88136002)(47776003)(93916002)(102836001)(551934003)(80022001)(81542001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB399;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=fail (sender IP is 192.88.158.246)
 smtp.mailfrom=hongbo.zhang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

This patch adds suspend and resume functions for Freescale DMA driver.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/fsldma.h |   15 ++++++++++
 2 files changed, 92 insertions(+)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index b291e6c..465f16d 100644
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
@@ -1221,6 +1229,9 @@ static int fsl_dma_chan_probe(struct fsldma_device *fdev,
 	INIT_LIST_HEAD(&chan->ld_pending);
 	INIT_LIST_HEAD(&chan->ld_running);
 	chan->idle = true;
+#ifdef CONFIG_PM
+	chan->pm_state = RUNNING;
+#endif
 
 	chan->common.device = &fdev->common;
 	dma_cookie_init(&chan->common);
@@ -1360,6 +1371,69 @@ static int fsldma_of_remove(struct platform_device *op)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int fsldma_suspend_late(struct device *dev)
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
+		if (unlikely(!chan->idle))
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
+static int fsldma_resume_early(struct device *dev)
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
+	.suspend_late	= fsldma_suspend_late,
+	.resume_early	= fsldma_resume_early,
+};
+#endif
+
 static const struct of_device_id fsldma_of_ids[] = {
 	{ .compatible = "fsl,elo3-dma", },
 	{ .compatible = "fsl,eloplus-dma", },
@@ -1372,6 +1446,9 @@ static struct platform_driver fsldma_of_driver = {
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
index d56e835..f2e0c4d 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -134,6 +134,17 @@ struct fsldma_device {
 #define FSL_DMA_CHAN_PAUSE_EXT	0x00001000
 #define FSL_DMA_CHAN_START_EXT	0x00002000
 
+#ifdef CONFIG_PM
+struct fsldma_chan_regs_save {
+	u32 mr;
+};
+
+enum fsldma_pm_state {
+	RUNNING = 0,
+	SUSPENDED,
+};
+#endif
+
 struct fsldma_chan {
 	char name[8];			/* Channel name */
 	struct fsldma_chan_regs __iomem *regs;
@@ -148,6 +159,10 @@ struct fsldma_chan {
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


