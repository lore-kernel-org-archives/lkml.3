Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbaCaNrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:47:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35600 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaCaNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Xiaotian Feng <xtfeng@gmail.com>, Mike Galbraith <bitbucket@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 17/71] rapidio/tsi721: fix tasklet termination in dma channel release
Date: Mon, 31 Mar 2014 14:22:23 +0100
Message-Id: <1396272197-13394-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Bounine <alexandre.bounine@idt.com>

commit 04379dffdd4da820d51a1566ad2e86f3b1ad97ed upstream.

This patch is a modification of the patch originally proposed by
Xiaotian Feng <xtfeng@gmail.com>: https://lkml.org/lkml/2012/11/5/413
This new version disables DMA channel interrupts and ensures that the
tasklet wil not be scheduled again before calling tasklet_kill().

Unfortunately the updated patch was not released at that time due to
planned rework of Tsi721 mport driver to use threaded interrupts (which
has yet to happen).  Recently the issue was reported again:
https://lkml.org/lkml/2014/2/19/762.

Description from the original Xiaotian's patch:

 "Some drivers use tasklet_disable in device remove/release process,
  tasklet_disable will inc tasklet->count and return.  If the tasklet is
  not handled yet under some softirq pressure, the tasklet will be
  placed on the tasklet_vec, never have a chance to be excuted.  This
  might lead to a heavy loaded ksoftirqd, wakeup with pending_softirq,
  but tasklet is disabled.  tasklet_kill should be used in this case."

This patch is applicable to kernel versions starting from v3.5.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/rapidio/devices/tsi721.h     |  1 +
 drivers/rapidio/devices/tsi721_dma.c | 27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.h b/drivers/rapidio/devices/tsi721.h
index 59de9d7..36147ee 100644
--- a/drivers/rapidio/devices/tsi721.h
+++ b/drivers/rapidio/devices/tsi721.h
@@ -669,6 +669,7 @@ struct tsi721_bdma_chan {
 	struct list_head	free_list;
 	dma_cookie_t		completed_cookie;
 	struct tasklet_struct	tasklet;
+	bool			active;
 };
 
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index 92e06a5..96f77a6 100644
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
@@ -790,6 +799,7 @@ int __devinit tsi721_register_dma(struct tsi721_device *priv)
 		bdma_chan->dchan.cookie = 1;
 		bdma_chan->dchan.chan_id = i;
 		bdma_chan->id = i;
+		bdma_chan->active = false;
 
 		spin_lock_init(&bdma_chan->lock);
 
@@ -799,7 +809,6 @@ int __devinit tsi721_register_dma(struct tsi721_device *priv)
 
 		tasklet_init(&bdma_chan->tasklet, tsi721_dma_tasklet,
 			     (unsigned long)bdma_chan);
-		tasklet_disable(&bdma_chan->tasklet);
 		list_add_tail(&bdma_chan->dchan.device_node,
 			      &mport->dma.channels);
 	}
-- 
1.9.1

