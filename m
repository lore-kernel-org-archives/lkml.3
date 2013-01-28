Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3A1LEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:04:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:17366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab3A1LEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:04:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,550,1355126400"; 
   d="scan'208";a="253522226"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] dw_dmac: adjust slave_id accordingly to request line base
Date: Mon, 28 Jan 2013 13:04:20 +0200
Message-Id: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some hardware configurations we have got the request line with the offset.
The patch introduces convert_slave_id() helper for that cases. The request line
base is got from the platform device resources provided by the IORESOURCE_DMA
type.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   13 +++++++++++++
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 3155c11..8484ca1 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -995,6 +995,13 @@ static inline void convert_burst(u32 *maxburst)
 		*maxburst = 0;
 }
 
+static inline void convert_slave_id(struct dw_dma_chan *dwc)
+{
+	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
+
+	dwc->dma_sconfig.slave_id -= dw->request_line_base;
+}
+
 static int
 set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 {
@@ -1009,6 +1016,7 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 
 	convert_burst(&dwc->dma_sconfig.src_maxburst);
 	convert_burst(&dwc->dma_sconfig.dst_maxburst);
+	convert_slave_id(dwc);
 
 	return 0;
 }
@@ -1717,6 +1725,11 @@ static int dw_probe(struct platform_device *pdev)
 		memcpy(dw->data_width, pdata->data_width, 4);
 	}
 
+	/* Get the base request line if set */
+	io = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (io)
+		dw->request_line_base = (unsigned int)io->start;
+
 	/* Calculate all channel mask before DMA setup */
 	dw->all_chan_mask = (1 << nr_channels) - 1;
 
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 88dd8eb..3eeb766 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -248,6 +248,7 @@ struct dw_dma {
 	/* hardware configuration */
 	unsigned char		nr_masters;
 	unsigned char		data_width[4];
+	unsigned int		request_line_base;
 
 	struct dw_dma_chan	chan[0];
 };
-- 
1.7.10.4

