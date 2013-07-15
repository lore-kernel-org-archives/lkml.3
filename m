Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3GOMEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:04:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:9086 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab3GOMEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:04:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="370443002"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4/6] dma: dw: allow shared interrupts
Date: Mon, 15 Jul 2013 15:04:39 +0300
Message-Id: <1373889881-21075-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the PC world is quite possible that devices are sharing the same interrupt
line. The patch prepares dw_dmac driver to such cases.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index a0aa6f9..f70c6b4 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -650,10 +650,13 @@ static void dw_dma_tasklet(unsigned long data)
 static irqreturn_t dw_dma_interrupt(int irq, void *dev_id)
 {
 	struct dw_dma *dw = dev_id;
-	u32 status;
+	u32 status = dma_readl(dw, STATUS_INT);
 
-	dev_vdbg(dw->dma.dev, "%s: status=0x%x\n", __func__,
-			dma_readl(dw, STATUS_INT));
+	dev_vdbg(dw->dma.dev, "%s: status=0x%x\n", __func__, status);
+
+	/* Check if we have any interrupt from the DMAC */
+	if (!status)
+		return IRQ_NONE;
 
 	/*
 	 * Just disable the interrupts. We'll turn them back on in the
@@ -1567,8 +1570,8 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 	/* Disable BLOCK interrupts as well */
 	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 
-	err = devm_request_irq(chip->dev, chip->irq, dw_dma_interrupt, 0,
-			       "dw_dmac", dw);
+	err = devm_request_irq(chip->dev, chip->irq, dw_dma_interrupt,
+			       IRQF_SHARED, "dw_dmac", dw);
 	if (err)
 		return err;
 
-- 
1.8.3.2

