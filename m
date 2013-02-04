Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3BDTqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:46:34 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:52265 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab3BDTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:46:29 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [PATCH v3 3/3] mmc: davinci: get SG segment limits with dma_get_slave_sg_caps()
Date: Mon,  4 Feb 2013 14:47:04 -0500
Message-Id: <1360007224-21735-4-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360007224-21735-1-git-send-email-mporter@ti.com>
References: <1360007224-21735-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the hardcoded values used to set max_segs/max_seg_size with
a dma_get_slave_sg_caps() query to the dmaengine driver.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/mmc/host/davinci_mmc.c            |   37 ++++++++---------------------
 include/linux/platform_data/mmc-davinci.h |    3 ---
 2 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 2063677..583cbd0 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -144,18 +144,6 @@
 /* MMCSD Init clock in Hz in opendrain mode */
 #define MMCSD_INIT_CLOCK		200000
 
-/*
- * One scatterlist dma "segment" is at most MAX_CCNT rw_threshold units,
- * and we handle up to MAX_NR_SG segments.  MMC_BLOCK_BOUNCE kicks in only
- * for drivers with max_segs == 1, making the segments bigger (64KB)
- * than the page or two that's otherwise typical. nr_sg (passed from
- * platform data) == 16 gives at least the same throughput boost, using
- * EDMA transfer linkage instead of spending CPU time copying pages.
- */
-#define MAX_CCNT	((1 << 16) - 1)
-
-#define MAX_NR_SG	16
-
 static unsigned rw_threshold = 32;
 module_param(rw_threshold, uint, S_IRUGO);
 MODULE_PARM_DESC(rw_threshold,
@@ -216,8 +204,6 @@ struct mmc_davinci_host {
 	u8 version;
 	/* for ns in one cycle calculation */
 	unsigned ns_in_one_cycle;
-	/* Number of sg segments */
-	u8 nr_sg;
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 #endif
@@ -1165,6 +1151,7 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 	struct resource *r, *mem = NULL;
 	int ret = 0, irq = 0;
 	size_t mem_size;
+	struct dma_slave_sg_caps *dma_sg_caps;
 
 	/* REVISIT:  when we're fully converted, fail if pdata is NULL */
 
@@ -1214,12 +1201,6 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 
 	init_mmcsd_host(host);
 
-	if (pdata->nr_sg)
-		host->nr_sg = pdata->nr_sg - 1;
-
-	if (host->nr_sg > MAX_NR_SG || !host->nr_sg)
-		host->nr_sg = MAX_NR_SG;
-
 	host->use_dma = use_dma;
 	host->mmc_irq = irq;
 	host->sdio_irq = platform_get_irq(pdev, 1);
@@ -1248,14 +1229,16 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 		mmc->caps |= pdata->caps;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-	/* With no iommu coalescing pages, each phys_seg is a hw_seg.
-	 * Each hw_seg uses one EDMA parameter RAM slot, always one
-	 * channel and then usually some linked slots.
-	 */
-	mmc->max_segs		= MAX_NR_SG;
+	/* Just check one channel for the DMA SG limits */
+	dma_sg_caps = dma_get_slave_sg_caps(
+				host->dma_tx,
+				DMA_SLAVE_BUSWIDTH_4_BYTES,
+				rw_threshold / DMA_SLAVE_BUSWIDTH_4_BYTES);
 
-	/* EDMA limit per hw segment (one or two MBytes) */
-	mmc->max_seg_size	= MAX_CCNT * rw_threshold;
+	if (dma_sg_caps) {
+		mmc->max_segs = dma_sg_caps->max_seg_nr;
+		mmc->max_seg_size = dma_sg_caps->max_seg_len;
+	}
 
 	/* MMC/SD controller limits for multiblock requests */
 	mmc->max_blk_size	= 4095;  /* BLEN is 12 bits */
diff --git a/include/linux/platform_data/mmc-davinci.h b/include/linux/platform_data/mmc-davinci.h
index 5ba6b22..6910209 100644
--- a/include/linux/platform_data/mmc-davinci.h
+++ b/include/linux/platform_data/mmc-davinci.h
@@ -25,9 +25,6 @@ struct davinci_mmc_config {
 
 	/* Version of the MMC/SD controller */
 	u8	version;
-
-	/* Number of sg segments */
-	u8	nr_sg;
 };
 void davinci_setup_mmc(int module, struct davinci_mmc_config *config);
 
-- 
1.7.9.5

