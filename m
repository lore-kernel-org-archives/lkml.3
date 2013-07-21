Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3GUG7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 02:59:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39520 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab3GUG6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 02:58:39 -0400
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
Subject: [RFC 1/5] dma: edma: Setup parameters to DMA MAX_SG_NR at a time
Date: Sun, 21 Jul 2013 01:57:56 -0500
Message-ID: <1374389876-32500-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes are made here for configuring existing parameters to support
DMA'ing them out in batches as needed.

Also allocate as many as slots as needed by the SG list, but not more
than MAX_SG_NR. Then these slots will be reused accordingly.
For ex, if MAX_SG_NR=10, and number of SG entries is 40, still only
10 slots will be allocated to DMA the entire SG list of size 40.

Also enable TC interrupts for slots that are a last in a current
iteration, or that fall on a MAX_SG_NR boundary.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 083ecff..9b9954e 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -223,9 +223,11 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 	enum dma_slave_buswidth dev_width;
 	u32 burst;
 	struct scatterlist *sg;
-	int i;
+
 	int acnt, bcnt, ccnt, src, dst, cidx;
 	int src_bidx, dst_bidx, src_cidx, dst_cidx;
+	int i, ret;
+	int num_slots_needed;
 
 	if (unlikely(!echan || !sgl || !sg_len))
 		return NULL;
@@ -257,8 +259,11 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 
 	edesc->pset_nr = sg_len;
 
-	for_each_sg(sgl, sg, sg_len, i) {
-		/* Allocate a PaRAM slot, if needed */
+	/* Allocate a PaRAM slot, if needed */
+
+	num_slots_needed = sg_len > MAX_NR_SG ? MAX_NR_SG : sg_len;
+
+	for (i = 0; i < num_slots_needed; i++) {
 		if (echan->slot[i] < 0) {
 			echan->slot[i] =
 				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
@@ -268,6 +273,10 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 				return NULL;
 			}
 		}
+	}
+
+	/* Configure PaRAM sets for each SG */
+	for_each_sg(sgl, sg, sg_len, i) {
 
 		acnt = dev_width;
 
@@ -325,6 +334,12 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 		/* Configure A or AB synchronized transfers */
 		if (edesc->absync)
 			edesc->pset[i].opt |= SYNCDIM;
+
+		/* If this is the last in a current SG set of transactions,
+		   enable interrupts so that next set is processed */
+		if (!((i+1) % MAX_NR_SG))
+			edesc->pset[i].opt |= TCINTEN;
+
 		/* If this is the last set, enable completion interrupt flag */
 		if (i == sg_len - 1)
 			edesc->pset[i].opt |= TCINTEN;
-- 
1.7.9.5

