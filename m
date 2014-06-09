Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbaFIIz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:55:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58585 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932237AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 125/146] dmaengine: dw: went back to plain {request,free}_irq() calls
Date: Mon,  9 Jun 2014 10:51:00 +0200
Message-Id: <bc8cb59c032758fa1d2bd8d84c16bdfbeee96acb.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/dma/dw/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 89eb89f22284..da87adf85f03 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -1569,11 +1569,6 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
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
@@ -1584,6 +1579,11 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
+	err = request_irq(chip->irq, dw_dma_interrupt, IRQF_SHARED,
+			  "dw_dmac", dw);
+	if (err)
+		return err;
+
 	INIT_LIST_HEAD(&dw->dma.channels);
 	for (i = 0; i < nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
@@ -1686,6 +1686,7 @@ int dw_dma_remove(struct dw_dma_chip *chip)
 	dw_dma_off(dw);
 	dma_async_device_unregister(&dw->dma);
 
+	free_irq(chip->irq, dw);
 	tasklet_kill(&dw->tasklet);
 
 	list_for_each_entry_safe(dwc, _dwc, &dw->dma.channels,
-- 
1.9.3

