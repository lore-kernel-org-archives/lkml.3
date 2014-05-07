Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbaEGPtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:49:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:48595 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbaEGPoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:00 -0400
Message-Id: <20140507154337.873477334@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 19/32] tile: hvc: Use irq_alloc/free_hwirq
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=tile-hvc-use-alloc-free-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Just convert to the new interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/tty/hvc/hvc_tile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: tip/drivers/tty/hvc/hvc_tile.c
===================================================================
--- tip.orig/drivers/tty/hvc/hvc_tile.c
+++ tip/drivers/tty/hvc/hvc_tile.c
@@ -133,14 +133,14 @@ static int hvc_tile_probe(struct platfor
 	int tile_hvc_irq;
 
 	/* Create our IRQ and register it. */
-	tile_hvc_irq = create_irq();
-	if (tile_hvc_irq < 0)
+	tile_hvc_irq = irq_alloc_hwirq(-1);
+	if (!tile_hvc_irq)
 		return -ENXIO;
 
 	tile_irq_activate(tile_hvc_irq, TILE_IRQ_PERCPU);
 	hp = hvc_alloc(0, tile_hvc_irq, &hvc_tile_get_put_ops, 128);
 	if (IS_ERR(hp)) {
-		destroy_irq(tile_hvc_irq);
+		irq_free_hwirq(tile_hvc_irq);
 		return PTR_ERR(hp);
 	}
 	dev_set_drvdata(&pdev->dev, hp);
@@ -155,7 +155,7 @@ static int hvc_tile_remove(struct platfo
 
 	rc = hvc_remove(hp);
 	if (rc == 0)
-		destroy_irq(hp->data);
+		irq_free_hwirq(hp->data);
 
 	return rc;
 }


