Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3GVSMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:12:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:41865 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3GVSML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:12:11 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 10/16] usb: musb: remove a few is_dma_capable() in init/exit code
Date: Mon, 22 Jul 2013 20:10:01 +0200
Message-Id: <1374516607-2705-11-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes is_dma_capable() and an ifdef in the init/exit path
around init/de-init of the dma_controller. Since we have the empty stubs
in the PIO code we can call it without gcc trouble. Earlier we had an
ifdef and the is_dma_capable() macro where gcc ignored the if (0) path
even that the function was not around :)

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index a4434d2..b33bed5 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1764,7 +1764,7 @@ static void musb_free(struct musb *musb)
 			disable_irq_wake(musb->nIrq);
 		free_irq(musb->nIrq, musb);
 	}
-	if (is_dma_capable() && musb->dma_controller)
+	if (musb->dma_controller)
 		dma_controller_destroy(musb->dma_controller);
 
 	musb_host_free(musb);
@@ -1840,12 +1840,11 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 
 	pm_runtime_get_sync(musb->controller);
 
-#ifndef CONFIG_MUSB_PIO_ONLY
 	if (use_dma && dev->dma_mask)
 		musb->dma_controller = dma_controller_create(musb, musb->mregs);
-#endif
+
 	/* ideally this would be abstracted in platform setup */
-	if (!is_dma_capable() || !musb->dma_controller)
+	if (!musb->dma_controller)
 		dev->dma_mask = NULL;
 
 	/* be sure interrupts are disabled before connecting ISR */
-- 
1.8.3.2

