Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3HEQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:16:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39373 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab3HEQQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:16:23 -0400
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
Subject: [PATCH v3 11/12] dma: edma: Keep tracking of Pending interrupts (pending_acks)
Date: Mon, 5 Aug 2013 11:14:56 -0500
Message-ID: <1375719297-12871-12-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375719297-12871-1-git-send-email-joelf@ti.com>
References: <1375719297-12871-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The total_processed variable was being used to keep track of when
DMA is completed for a particular descriptor.

This doesn't work anymore, as the interrupt for completion can come
in much later than when the total_processed variable is updated to
reflect that all SG entries have been issues. Introduce another
variable that reflects the actual value. This will serve a purpose
different from what total_processed was required to help with.

Also add code that give special treatment for the first linked set
interrupt as pending_acks is handled a bit differently for that case.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 061f0cf..eca1b47 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -59,6 +59,10 @@ struct edma_desc {
 	int				pset_nr;
 	int				total_processed;
 	int				next_setup_linkset;
+
+	int				no_first_ls_ack;
+	int				pending_acks;
+
 	struct edmacc_param		pset[0];
 };
 
@@ -147,8 +151,7 @@ static void edma_execute(struct edma_chan *echan)
 	struct edmacc_param tmp_param;
 
 	/* If either we processed all psets or we're still not started */
-	if (!echan->edesc ||
-	    echan->edesc->pset_nr == echan->edesc->total_processed) {
+	if (!echan->edesc || !echan->edesc->pending_acks) {
 		/* Get next vdesc */
 		vdesc = vchan_next_desc(&echan->vchan);
 		if (!vdesc) {
@@ -180,6 +183,8 @@ static void edma_execute(struct edma_chan *echan)
 
 		edesc->total_processed += total_link_set;
 
+		edesc->pending_acks += total_link_set;
+
 		total_left = edesc->pset_nr - edesc->total_processed;
 
 		total_link_set = total_left > MAX_NR_LS ?
@@ -190,6 +195,8 @@ static void edma_execute(struct edma_chan *echan)
 			   where total pset_nr is strictly within MAX_NR size */
 			if (total_left > total_link_set)
 				edma_enable_interrupt(echan->slot[i]);
+			else
+				edesc->no_first_ls_ack = 1;
 
 			/* Setup link between linked set 0 to set 1 */
 			edma_link(echan->slot[i], echan->slot[i+1]);
@@ -210,6 +217,9 @@ static void edma_execute(struct edma_chan *echan)
 			}
 
 			edesc->total_processed += total_link_set;
+
+			edesc->pending_acks += total_link_set;
+
 			total_left = edesc->pset_nr - edesc->total_processed;
 
 			if (total_left)
@@ -267,6 +277,8 @@ static void edma_execute(struct edma_chan *echan)
 
 	edesc->total_processed += total_link_set;
 
+	edesc->pending_acks += total_link_set;
+
 	slot_off = total_link_set + ls_cur_off - 1;
 
 	if (edesc->total_processed == edesc->pset_nr)
@@ -498,8 +510,22 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 
 		edesc = echan->edesc;
 
+		if (edesc->pending_acks < MAX_NR_LS)
+			edesc->pending_acks = 0;
+		else
+			edesc->pending_acks -= MAX_NR_LS;
+
+		if (edesc->no_first_ls_ack) {
+			if (edesc->pending_acks < MAX_NR_LS)
+				edesc->pending_acks = 0;
+			else
+				edesc->pending_acks -= MAX_NR_LS;
+
+			edesc->no_first_ls_ack = 0;
+		}
+
 		if (edesc) {
-			if (edesc->total_processed == edesc->pset_nr) {
+			if (!edesc->pending_acks) {
 				dev_dbg(dev, "Transfer complete,"
 					" stopping channel %d\n", ch_num);
 				edma_stop(echan->ch_num);
-- 
1.7.9.5

