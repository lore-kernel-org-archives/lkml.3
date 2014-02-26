Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaBZPPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:15:37 -0500
Received: from mxout1.idt.com ([157.165.5.25]:36314 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaBZPPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:15:33 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Xiaotian Feng <xtfeng@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org,
        <stable@vger.kernel.org>
Subject: [PATCH v2] rapidio/tsi721: fix tasklet termination in dma channel release
Date: Wed, 26 Feb 2014 10:13:47 -0500
Message-Id: <1393427627-18525-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a modification of the patch originally proposed
by Xiaotian Feng <xtfeng@gmail.com>: https://lkml.org/lkml/2012/11/5/413
This new version disables DMA channel interrupts and ensures that the tasklet
wil not be scheduled again before calling tasklet_kill().

Unfortunately the updated patch was not released at that time due to planned
rework of Tsi721 mport driver to use threaded interrupts (which has yet to
happen).
Recently the issue was reported again: https://lkml.org/lkml/2014/2/19/762.

Description from the original Xiaotian's patch:

"Some drivers use tasklet_disable in device remove/release process, 
tasklet_disable will inc tasklet->count and return. If the tasklet is 
not handled yet under some softirq pressure, the tasklet will be 
placed on the tasklet_vec, never have a chance to be excuted. This 
might lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, 
but tasklet is disabled. tasklet_kill should be used in this case."

This patch is applicable to kernel versions starting from v3.5.

v2 - fixes compile error if MSI support (CONFIG_PCI_MSI) is disabled.  

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org>
---
 drivers/rapidio/devices/tsi721.h     |    1 +
 drivers/rapidio/devices/tsi721_dma.c |   27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.h b/drivers/rapidio/devices/tsi721.h
index b4b0d83..7061ac0 100644
--- a/drivers/rapidio/devices/tsi721.h
+++ b/drivers/rapidio/devices/tsi721.h
@@ -678,6 +678,7 @@ struct tsi721_bdma_chan {
 	struct list_head	free_list;
 	dma_cookie_t		completed_cookie;
 	struct tasklet_struct	tasklet;
+	bool			active;
 };
 
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index 502663f..91245f5 100644
--- a/drivers/rapidio/devices/tsi721_dma.c
+++ b/drivers/rapidio/devices/tsi721_dma.c
@@ -206,8 +206,8 @@ void tsi721_bdma_handler(struct tsi721_bdma_chan *bdma_chan)
 {
 	/* Disable BDMA channel interrupts */
 	iowrite32(0, bdma_chan->regs + TSI721_DMAC_INTE);
-
-	tasklet_schedule(&bdma_chan->tasklet);
+	if (bdma_chan->active)
+		tasklet_schedule(&bdma_chan->tasklet);
 }
 
 #ifdef CONFIG_PCI_MSI
@@ -562,7 +562,7 @@ static int tsi721_alloc_chan_resources(struct dma_chan *dchan)
 	}
 #endif /* CONFIG_PCI_MSI */
 
-	tasklet_enable(&bdma_chan->tasklet);
+	bdma_chan->active = true;
 	tsi721_bdma_interrupt_enable(bdma_chan, 1);
 
 	return bdma_chan->bd_num - 1;
@@ -576,9 +576,7 @@ err_out:
 static void tsi721_free_chan_resources(struct dma_chan *dchan)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-#ifdef CONFIG_PCI_MSI
 	struct tsi721_device *priv = to_tsi721(dchan->device);
-#endif
 	LIST_HEAD(list);
 
 	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
@@ -589,14 +587,25 @@ static void tsi721_free_chan_resources(struct dma_chan *dchan)
 	BUG_ON(!list_empty(&bdma_chan->active_list));
 	BUG_ON(!list_empty(&bdma_chan->queue));
 
-	tasklet_disable(&bdma_chan->tasklet);
+	tsi721_bdma_interrupt_enable(bdma_chan, 0);
+	bdma_chan->active = false;
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX) {
+		synchronize_irq(priv->msix[TSI721_VECT_DMA0_DONE +
+					   bdma_chan->id].vector);
+		synchronize_irq(priv->msix[TSI721_VECT_DMA0_INT +
+					   bdma_chan->id].vector);
+	} else
+#endif
+	synchronize_irq(priv->pdev->irq);
+
+	tasklet_kill(&bdma_chan->tasklet);
 
 	spin_lock_bh(&bdma_chan->lock);
 	list_splice_init(&bdma_chan->free_list, &list);
 	spin_unlock_bh(&bdma_chan->lock);
 
-	tsi721_bdma_interrupt_enable(bdma_chan, 0);
-
 #ifdef CONFIG_PCI_MSI
 	if (priv->flags & TSI721_USING_MSIX) {
 		free_irq(priv->msix[TSI721_VECT_DMA0_DONE +
@@ -790,6 +799,7 @@ int tsi721_register_dma(struct tsi721_device *priv)
 		bdma_chan->dchan.cookie = 1;
 		bdma_chan->dchan.chan_id = i;
 		bdma_chan->id = i;
+		bdma_chan->active = false;
 
 		spin_lock_init(&bdma_chan->lock);
 
@@ -799,7 +809,6 @@ int tsi721_register_dma(struct tsi721_device *priv)
 
 		tasklet_init(&bdma_chan->tasklet, tsi721_dma_tasklet,
 			     (unsigned long)bdma_chan);
-		tasklet_disable(&bdma_chan->tasklet);
 		list_add_tail(&bdma_chan->dchan.device_node,
 			      &mport->dma.channels);
 	}
-- 
1.7.8.4

