Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3C2OM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:12:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50641 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab3C2OMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:12:25 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
CC: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [RFC] dmaengine: omap-dma: Start DMA without delay
Date: Fri, 29 Mar 2013 15:12:03 +0100
Message-ID: <1364566323-24144-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of a tasklet to start the DMA channel when issue_pending is
called.
The use of tasklet delays the DMA start which can cause issues at drivers,
for example the audio drivers expect that the DMA is started right away.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi Russell,

I know you are against removing the tasklet since you have planed to move the
omap-dma to use runtime/dynamic DMA channel use.
I have looked at the amba-pl08x.c driver which is doing that exactly (as you
pointed out that to me). AMBA did not use tasklet either and I'm sure we can
change the omap-dma driver to do the same in a same way as we could have done it
with the tasklet use.

I have tested the patch on OMAP3/4 devices and have not seen any ill effects of
this patch.

Currently OMAP audio is affected by the taskelt: we have random channel switch/shift
when starting audio. This is because the DMA is started after (because of the tasklet)
the audio IPs.

We probably need to backport this patch to 3.7 and 3.8 as well after the review
rounds.

Regards,
Peter

 drivers/dma/omap-dma.c | 51 ++------------------------------------------------
 1 file changed, 2 insertions(+), 49 deletions(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index c4b4fd2..d6a1dc0 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -22,13 +22,10 @@
 struct omap_dmadev {
 	struct dma_device ddev;
 	spinlock_t lock;
-	struct tasklet_struct task;
-	struct list_head pending;
 };
 
 struct omap_chan {
 	struct virt_dma_chan vc;
-	struct list_head node;
 
 	struct dma_slave_config	cfg;
 	unsigned dma_sig;
@@ -153,33 +150,6 @@ static void omap_dma_callback(int ch, u16 status, void *data)
 	spin_unlock_irqrestore(&c->vc.lock, flags);
 }
 
-/*
- * This callback schedules all pending channels.  We could be more
- * clever here by postponing allocation of the real DMA channels to
- * this point, and freeing them when our virtual channel becomes idle.
- *
- * We would then need to deal with 'all channels in-use'
- */
-static void omap_dma_sched(unsigned long data)
-{
-	struct omap_dmadev *d = (struct omap_dmadev *)data;
-	LIST_HEAD(head);
-
-	spin_lock_irq(&d->lock);
-	list_splice_tail_init(&d->pending, &head);
-	spin_unlock_irq(&d->lock);
-
-	while (!list_empty(&head)) {
-		struct omap_chan *c = list_first_entry(&head,
-			struct omap_chan, node);
-
-		spin_lock_irq(&c->vc.lock);
-		list_del_init(&c->node);
-		omap_dma_start_desc(c);
-		spin_unlock_irq(&c->vc.lock);
-	}
-}
-
 static int omap_dma_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct omap_chan *c = to_omap_dma_chan(chan);
@@ -275,14 +245,8 @@ static void omap_dma_issue_pending(struct dma_chan *chan)
 	unsigned long flags;
 
 	spin_lock_irqsave(&c->vc.lock, flags);
-	if (vchan_issue_pending(&c->vc) && !c->desc) {
-		struct omap_dmadev *d = to_omap_dma_dev(chan->device);
-		spin_lock(&d->lock);
-		if (list_empty(&c->node))
-			list_add_tail(&c->node, &d->pending);
-		spin_unlock(&d->lock);
-		tasklet_schedule(&d->task);
-	}
+	if (vchan_issue_pending(&c->vc) && !c->desc)
+		omap_dma_start_desc(c);
 	spin_unlock_irqrestore(&c->vc.lock, flags);
 }
 
@@ -456,17 +420,11 @@ static int omap_dma_slave_config(struct omap_chan *c, struct dma_slave_config *c
 
 static int omap_dma_terminate_all(struct omap_chan *c)
 {
-	struct omap_dmadev *d = to_omap_dma_dev(c->vc.chan.device);
 	unsigned long flags;
 	LIST_HEAD(head);
 
 	spin_lock_irqsave(&c->vc.lock, flags);
 
-	/* Prevent this channel being scheduled */
-	spin_lock(&d->lock);
-	list_del_init(&c->node);
-	spin_unlock(&d->lock);
-
 	/*
 	 * Stop DMA activity: we assume the callback will not be called
 	 * after omap_stop_dma() returns (even if it does, it will see
@@ -562,7 +520,6 @@ static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
 	c->dma_sig = dma_sig;
 	c->vc.desc_free = omap_dma_desc_free;
 	vchan_init(&c->vc, &od->ddev);
-	INIT_LIST_HEAD(&c->node);
 
 	od->ddev.chancnt++;
 
@@ -571,7 +528,6 @@ static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
 
 static void omap_dma_free(struct omap_dmadev *od)
 {
-	tasklet_kill(&od->task);
 	while (!list_empty(&od->ddev.channels)) {
 		struct omap_chan *c = list_first_entry(&od->ddev.channels,
 			struct omap_chan, vc.chan.device_node);
@@ -603,11 +559,8 @@ static int omap_dma_probe(struct platform_device *pdev)
 	od->ddev.device_control = omap_dma_control;
 	od->ddev.dev = &pdev->dev;
 	INIT_LIST_HEAD(&od->ddev.channels);
-	INIT_LIST_HEAD(&od->pending);
 	spin_lock_init(&od->lock);
 
-	tasklet_init(&od->task, omap_dma_sched, (unsigned long)od);
-
 	for (i = 0; i < 127; i++) {
 		rc = omap_dma_chan_init(od, i);
 		if (rc) {
-- 
1.8.1.5

