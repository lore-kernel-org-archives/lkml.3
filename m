Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966514AbaFQVuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344AbaFQVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 164/212] dmaengine: dw: went back to plain {request,free}_irq() calls
Date: Tue, 17 Jun 2014 14:44:18 -0700
Message-Id: <1403041506-13646-165-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 97977f7576a89cb9436c000ae703c0d515e748ac upstream.

The commit dbde5c29 "dw_dmac: use devm_* functions to simplify code" turns
probe function to use devm_* helpers and simultaneously brings a regression. We
need to ensure irq is disabled, followed by ensuring that don't schedule any
more tasklets and then its safe to use tasklet_kill().

The free_irq() will ensure that the irq is disabled and also wait till all
scheduled interrupts are executed by invoking synchronize_irq(). So we need to
only do tasklet_kill() after invoking free_irq().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/dma/dw/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 7516be4..42c208d 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -1546,11 +1546,6 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 	/* Disable BLOCK interrupts as well */
 	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 
-	err = devm_request_irq(chip->dev, chip->irq, dw_dma_interrupt,
-			       IRQF_SHARED, "dw_dmac", dw);
-	if (err)
-		return err;
-
 	/* Create a pool of consistent memory blocks for hardware descriptors */
 	dw->desc_pool = dmam_pool_create("dw_dmac_desc_pool", chip->dev,
 					 sizeof(struct dw_desc), 4, 0);
@@ -1561,6 +1556,11 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
+	err = request_irq(chip->irq, dw_dma_interrupt, IRQF_SHARED,
+			  "dw_dmac", dw);
+	if (err)
+		return err;
+
 	INIT_LIST_HEAD(&dw->dma.channels);
 	for (i = 0; i < nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
@@ -1663,6 +1663,7 @@ int dw_dma_remove(struct dw_dma_chip *chip)
 	dw_dma_off(dw);
 	dma_async_device_unregister(&dw->dma);
 
+	free_irq(chip->irq, dw);
 	tasklet_kill(&dw->tasklet);
 
 	list_for_each_entry_safe(dwc, _dwc, &dw->dma.channels,
-- 
1.9.1

