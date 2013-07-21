Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3GUG7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 02:59:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50296 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab3GUG6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 02:58:51 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Balaji TK <balajitk@ti.com>, Gururaja Hebbar <gururaja.hebbar@ti.com>,
        Chris Ball <cjb@laptop.org>, Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [RFC 2/5] dma: edma: Write out and handle MAX_SG_NR at a given time
Date: Sun, 21 Jul 2013 01:58:08 -0500
Message-ID: <1374389888-32538-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Process SG-elements in batches of MAX_SG_NR if they are greater
than MAX_SG_NR. Due to this, at any given time only those many
slots will be used in the given channel no matter how long the
scatter list is. We keep track of how much has been written
inorder to process the next batch of elements in the scatter-list
and detect completion.

For such intermediate transfer completions (one batch of MAX_SG_NR),
make use of pause and resume functions instead of start and stop
when such intermediate transfer is in progress or completed as we
donot want to clear any pending events.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |   79 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 25 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 9b9954e..0e7ed79 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -56,6 +56,7 @@ struct edma_desc {
 	struct list_head		node;
 	int				absync;
 	int				pset_nr;
+	int				total_processed;
 	struct edmacc_param		pset[0];
 };
 
@@ -105,22 +106,36 @@ static void edma_desc_free(struct virt_dma_desc *vdesc)
 /* Dispatch a queued descriptor to the controller (caller holds lock) */
 static void edma_execute(struct edma_chan *echan)
 {
-	struct virt_dma_desc *vdesc = vchan_next_desc(&echan->vchan);
+	struct virt_dma_desc *vdesc;
 	struct edma_desc *edesc;
-	int i;
+	struct device *dev = echan->vchan.chan.device->dev;
 
-	if (!vdesc) {
-		echan->edesc = NULL;
-		return;
+	int i, j, total_left, total_process;
+
+	/* If either we processed all psets or we're still not started */
+	if (!echan->edesc ||
+	    echan->edesc->pset_nr == echan->edesc->total_processed) {
+		/* Get next vdesc */
+		vdesc = vchan_next_desc(&echan->vchan);
+		if (!vdesc) {
+			echan->edesc = NULL;
+			return;
+		}
+		list_del(&vdesc->node);
+		echan->edesc = to_edma_desc(&vdesc->tx);
 	}
 
-	list_del(&vdesc->node);
+	edesc = echan->edesc;
+
+	/* Find out how many left */
+	total_left = edesc->pset_nr - edesc->total_processed;
+	total_process = total_left > MAX_NR_SG ? MAX_NR_SG : total_left;
 
-	echan->edesc = edesc = to_edma_desc(&vdesc->tx);
 
 	/* Write descriptor PaRAM set(s) */
-	for (i = 0; i < edesc->pset_nr; i++) {
-		edma_write_slot(echan->slot[i], &edesc->pset[i]);
+	for (i = 0; i < total_process; i++) {
+		j = i + edesc->total_processed;
+		edma_write_slot(echan->slot[i], &edesc->pset[j]);
 		dev_dbg(echan->vchan.chan.device->dev,
 			"\n pset[%d]:\n"
 			"  chnum\t%d\n"
@@ -133,24 +148,31 @@ static void edma_execute(struct edma_chan *echan)
 			"  bidx\t%08x\n"
 			"  cidx\t%08x\n"
 			"  lkrld\t%08x\n",
-			i, echan->ch_num, echan->slot[i],
-			edesc->pset[i].opt,
-			edesc->pset[i].src,
-			edesc->pset[i].dst,
-			edesc->pset[i].a_b_cnt,
-			edesc->pset[i].ccnt,
-			edesc->pset[i].src_dst_bidx,
-			edesc->pset[i].src_dst_cidx,
-			edesc->pset[i].link_bcntrld);
+			j, echan->ch_num, echan->slot[i],
+			edesc->pset[j].opt,
+			edesc->pset[j].src,
+			edesc->pset[j].dst,
+			edesc->pset[j].a_b_cnt,
+			edesc->pset[j].ccnt,
+			edesc->pset[j].src_dst_bidx,
+			edesc->pset[j].src_dst_cidx,
+			edesc->pset[j].link_bcntrld);
 		/* Link to the previous slot if not the last set */
-		if (i != (edesc->pset_nr - 1))
+		if (i != (total_process - 1))
 			edma_link(echan->slot[i], echan->slot[i+1]);
 		/* Final pset links to the dummy pset */
 		else
 			edma_link(echan->slot[i], echan->ecc->dummy_slot);
 	}
 
-	edma_start(echan->ch_num);
+	edesc->total_processed += total_process;
+
+	edma_resume(echan->ch_num);
+
+	if (edesc->total_processed <= MAX_NR_SG) {
+		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
+		edma_start(echan->ch_num);
+	}
 }
 
 static int edma_terminate_all(struct edma_chan *echan)
@@ -366,19 +388,26 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 	struct edma_desc *edesc;
 	unsigned long flags;
 
-	/* Stop the channel */
-	edma_stop(echan->ch_num);
+	/* Pause the channel */
+	edma_pause(echan->ch_num);
 
 	switch (ch_status) {
 	case DMA_COMPLETE:
-		dev_dbg(dev, "transfer complete on channel %d\n", ch_num);
-
 		spin_lock_irqsave(&echan->vchan.lock, flags);
 
 		edesc = echan->edesc;
 		if (edesc) {
+			if (edesc->total_processed == edesc->pset_nr) {
+				dev_dbg(dev, "transfer complete." \
+					" stopping channel %d\n", ch_num);
+				edma_stop(echan->ch_num);
+				vchan_cookie_complete(&edesc->vdesc);
+			} else {
+				dev_dbg(dev, "Intermediate transfer complete" \
+					" on channel %d\n", ch_num);
+			}
+
 			edma_execute(echan);
-			vchan_cookie_complete(&edesc->vdesc);
 		}
 
 		spin_unlock_irqrestore(&echan->vchan.lock, flags);
-- 
1.7.9.5

