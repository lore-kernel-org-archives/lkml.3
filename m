Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab3GVSLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:11:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:41844 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab3GVSLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:11:01 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 13/16] usb: musb: do not change dev's dma_mask
Date: Mon, 22 Jul 2013 20:10:04 +0200
Message-Id: <1374516607-2705-14-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8d2421e ("usb: musb: kill global and static for multi instance")
removed the global dma_mask copy and replaced by parent's DMA mask. The
problem here is that if the parent does not have a dma_mask then
musb_remove() goes kaboom.
Instead trying to fix this I was thinking we do we need to erase
dma_mask in the first place?

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 9b774e7..80ffd7e 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1843,10 +1843,6 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	if (use_dma && dev->dma_mask)
 		musb->dma_controller = dma_controller_create(musb, musb->mregs);
 
-	/* ideally this would be abstracted in platform setup */
-	if (!musb->dma_controller)
-		dev->dma_mask = NULL;
-
 	/* be sure interrupts are disabled before connecting ISR */
 	musb_platform_disable(musb);
 	musb_generic_disable(musb);
@@ -1993,9 +1989,6 @@ static int musb_remove(struct platform_device *pdev)
 
 	musb_free(musb);
 	device_init_wakeup(dev, 0);
-#ifndef CONFIG_MUSB_PIO_ONLY
-	dma_set_mask(dev, *dev->parent->dma_mask);
-#endif
 	return 0;
 }
 
-- 
1.8.3.2

