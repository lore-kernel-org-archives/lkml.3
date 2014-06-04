Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaFEACt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:02:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaFDXW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 3.14 192/228] dmaengine: dw: went back to plain {request,free}_irq() calls
Date: Wed,  4 Jun 2014 16:23:41 -0700
Message-Id: <20140604232354.193045242@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dw/core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -1545,11 +1545,6 @@ int dw_dma_probe(struct dw_dma_chip *chi
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
@@ -1560,6 +1555,11 @@ int dw_dma_probe(struct dw_dma_chip *chi
 
 	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
 
+	err = request_irq(chip->irq, dw_dma_interrupt, IRQF_SHARED,
+			  "dw_dmac", dw);
+	if (err)
+		return err;
+
 	INIT_LIST_HEAD(&dw->dma.channels);
 	for (i = 0; i < nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
@@ -1664,6 +1664,7 @@ int dw_dma_remove(struct dw_dma_chip *ch
 	dw_dma_off(dw);
 	dma_async_device_unregister(&dw->dma);
 
+	free_irq(chip->irq, dw);
 	tasklet_kill(&dw->tasklet);
 
 	list_for_each_entry_safe(dwc, _dwc, &dw->dma.channels,


