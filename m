Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3HEQUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:20:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39214 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab3HEQPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:15:52 -0400
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
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v3 09/12] dma: edma: Implement multiple linked sets for continuity
Date: Mon, 5 Aug 2013 11:14:54 -0500
Message-ID: <1375719297-12871-10-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375719297-12871-1-git-send-email-joelf@ti.com>
References: <1375719297-12871-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we implement splitting up of the total MAX number of slots
available for a channel into 2 cyclically linked sets. Transfer
completion Interrupts are enabled on both linked sets and respective
handler recycles them on completion to process the next linked set.
Both linked sets are cyclically linked to each other to ensure
continuity of DMA operations. Interrupt handlers execute asynchronously
to the EDMA events and recycles the linked sets at the right time,
as a result EDMA is not blocked or dependent on interrupts and DMA
continues till the end of the SG-lists without any interruption.

Suggested-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |  157 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 118 insertions(+), 39 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index df50a04..70923a2 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -48,6 +48,7 @@
 
 /* Max of 16 segments per channel to conserve PaRAM slots */
 #define MAX_NR_SG		16
+#define MAX_NR_LS		(MAX_NR_SG >> 1)
 #define EDMA_MAX_SLOTS		(MAX_NR_SG+1)
 #define EDMA_DESCRIPTORS	16
 
@@ -57,6 +58,7 @@ struct edma_desc {
 	int				absync;
 	int				pset_nr;
 	int				total_processed;
+	int				next_setup_linkset;
 	struct edmacc_param		pset[0];
 };
 
@@ -140,7 +142,9 @@ static void edma_execute(struct edma_chan *echan)
 	struct edma_desc *edesc;
 	struct device *dev = echan->vchan.chan.device->dev;
 
-	int i, j, total_left, total_process;
+	int i, total_left, total_link_set;
+	int ls_cur_off, ls_next_off, slot_off;
+	struct edmacc_param tmp_param;
 
 	/* If either we processed all psets or we're still not started */
 	if (!echan->edesc ||
@@ -159,48 +163,121 @@ static void edma_execute(struct edma_chan *echan)
 
 	/* Find out how many left */
 	total_left = edesc->pset_nr - edesc->total_processed;
-	total_process = total_left > MAX_NR_SG ? MAX_NR_SG : total_left;
-
-
-	/* Write descriptor PaRAM set(s) */
-	for (i = 0; i < total_process; i++) {
-		j = i + edesc->total_processed;
-		edma_write_slot(echan->slot[i], &edesc->pset[j]);
-		dev_dbg(echan->vchan.chan.device->dev,
-			"\n pset[%d]:\n"
-			"  chnum\t%d\n"
-			"  slot\t%d\n"
-			"  opt\t%08x\n"
-			"  src\t%08x\n"
-			"  dst\t%08x\n"
-			"  abcnt\t%08x\n"
-			"  ccnt\t%08x\n"
-			"  bidx\t%08x\n"
-			"  cidx\t%08x\n"
-			"  lkrld\t%08x\n",
-			j, echan->ch_num, echan->slot[i],
-			edesc->pset[j].opt,
-			edesc->pset[j].src,
-			edesc->pset[j].dst,
-			edesc->pset[j].a_b_cnt,
-			edesc->pset[j].ccnt,
-			edesc->pset[j].src_dst_bidx,
-			edesc->pset[j].src_dst_cidx,
-			edesc->pset[j].link_bcntrld);
-		/* Link to the previous slot if not the last set */
-		if (i != (total_process - 1))
+	total_link_set = total_left > MAX_NR_LS ? MAX_NR_LS : total_left;
+
+	/* First time, setup 2 cyclically linked sets, each containing half
+	   the slots allocated for this channel */
+	if (edesc->total_processed == 0) {
+		for (i = 0; i < total_link_set; i++) {
+			edma_write_slot(echan->slot[i+1], &edesc->pset[i]);
+
+			if (i != total_link_set - 1) {
+				edma_link(echan->slot[i+1], echan->slot[i+2]);
+				dump_pset(echan, echan->slot[i+1],
+					  edesc->pset, i);
+			}
+		}
+
+		edesc->total_processed += total_link_set;
+
+		total_left = edesc->pset_nr - edesc->total_processed;
+
+		total_link_set = total_left > MAX_NR_LS ?
+				 MAX_NR_LS : total_left;
+
+		if (total_link_set) {
+			/* Don't setup interrupt for first linked set for cases
+			   where total pset_nr is strictly within MAX_NR size */
+			if (total_left > total_link_set)
+				edma_enable_interrupt(echan->slot[i]);
+
+			/* Setup link between linked set 0 to set 1 */
 			edma_link(echan->slot[i], echan->slot[i+1]);
-		/* Final pset links to the dummy pset */
-		else
+
+			dump_pset(echan, echan->slot[i], edesc->pset, i-1);
+
+			/* Write out linked set 1 */
+			for (; i < total_link_set + MAX_NR_LS; i++) {
+				edma_write_slot(echan->slot[i+1],
+						&edesc->pset[i]);
+
+				if (i != total_link_set + MAX_NR_LS - 1) {
+					edma_link(echan->slot[i+1],
+						  echan->slot[i+2]);
+					dump_pset(echan, echan->slot[i+1],
+						  edesc->pset, i);
+				}
+			}
+
+			edesc->total_processed += total_link_set;
+			total_left = edesc->pset_nr - edesc->total_processed;
+
+			if (total_left)
+				/* Setup a link from linked set 1 to set 0 */
+				edma_link(echan->slot[i], echan->slot[1]);
+			else
+				/* Setup a link between linked set 1 to dummy */
+				edma_link(echan->slot[i], echan->ecc->dummy_slot);
+		} else {
+			/* First linked set was enough, simply link to dummy */
 			edma_link(echan->slot[i], echan->ecc->dummy_slot);
-	}
+		}
+
+		edma_enable_interrupt(echan->slot[i]);
+		dump_pset(echan, echan->slot[i], edesc->pset, i-1);
 
-	edesc->total_processed += total_process;
+		edesc->next_setup_linkset = 0;
 
-	if (edesc->total_processed <= MAX_NR_SG) {
+		/* Start the ball rolling... */
 		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
+
+		edma_read_slot(echan->slot[1], &tmp_param);
+		edma_write_slot(echan->slot[0], &tmp_param);
 		edma_start(echan->ch_num);
+
+		return;
+	}
+
+	/* We got called in the middle of an SG-list transaction as one of the
+	   linked sets completed  */
+
+	/* Setup offsets into echan_slot, +1 is as slot 0 is for chan */
+	if (edesc->next_setup_linkset == 1) {
+		edesc->next_setup_linkset = 0;
+		ls_cur_off = MAX_NR_LS + 1;
+		ls_next_off = 1;
+	} else {
+		edesc->next_setup_linkset = 1;
+		ls_cur_off = 1;
+		ls_next_off = MAX_NR_LS + 1;
+	}
+
+	for (i = 0; i < total_link_set; i++) {
+		edma_write_slot(echan->slot[i + ls_cur_off],
+				&edesc->pset[i + edesc->total_processed]);
+
+		if (i != total_link_set - 1) {
+			edma_link(echan->slot[i + ls_cur_off],
+				  echan->slot[i + ls_cur_off + 1]);
+
+			dump_pset(echan, echan->slot[i + ls_cur_off],
+				  edesc->pset, i + edesc->total_processed);
+		}
 	}
+
+	edesc->total_processed += total_link_set;
+
+	slot_off = total_link_set + ls_cur_off - 1;
+
+	if (edesc->total_processed == edesc->pset_nr)
+		edma_link(echan->slot[slot_off], echan->ecc->dummy_slot);
+	else
+		edma_link(echan->slot[slot_off], echan->slot[ls_next_off]);
+
+	edma_enable_interrupt(echan->slot[slot_off]);
+
+	dump_pset(echan, echan->slot[slot_off],
+		  edesc->pset, edesc->total_processed-1);
 }
 
 static int edma_terminate_all(struct edma_chan *echan)
@@ -417,15 +494,17 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 		spin_lock_irqsave(&echan->vchan.lock, flags);
 
 		edesc = echan->edesc;
+
 		if (edesc) {
 			if (edesc->total_processed == edesc->pset_nr) {
-				dev_dbg(dev, "transfer complete." \
+				dev_dbg(dev, "Transfer complete,"
 					" stopping channel %d\n", ch_num);
 				edma_stop(echan->ch_num);
 				vchan_cookie_complete(&edesc->vdesc);
 			} else {
-				dev_dbg(dev, "Intermediate transfer complete" \
-					" on channel %d\n", ch_num);
+				dev_dbg(dev, "Intermediate transfer "
+					"complete, setup next linked set on "
+					"%d\n ", ch_num);
 			}
 
 			edma_execute(echan);
-- 
1.7.9.5

