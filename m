Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab3H2XHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:07:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58602 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab3H2XGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:06:39 -0400
From: Joel Fernandes <joelf@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sricharan R <r.sricharan@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Franklin Cooper <fcooper@ti.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH v4 1/6] dma: edma: Setup parameters to DMA MAX_NR_SG at a time
Date: Thu, 29 Aug 2013 18:05:40 -0500
Message-ID: <1377817545-18015-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377817545-18015-1-git-send-email-joelf@ti.com>
References: <1377817545-18015-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes are made here for configuring existing parameters to support
DMA'ing them out in batches as needed.

Also allocate as many as slots as needed by the SG list, but not more
than MAX_NR_SG. Then these slots will be reused accordingly.
For ex, if MAX_NR_SG=10, and number of SG entries is 40, still only
10 slots will be allocated to DMA the entire SG list of size 40.

Also enable TC interrupts for slots that are a last in a current
iteration, or that fall on a MAX_NR_SG boundary.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 5f3e532..e522ad5 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -222,9 +222,9 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 	enum dma_slave_buswidth dev_width;
 	u32 burst;
 	struct scatterlist *sg;
-	int i;
 	int acnt, bcnt, ccnt, src, dst, cidx;
 	int src_bidx, dst_bidx, src_cidx, dst_cidx;
+	int i, nslots;
 
 	if (unlikely(!echan || !sgl || !sg_len))
 		return NULL;
@@ -262,8 +262,10 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 
 	edesc->pset_nr = sg_len;
 
-	for_each_sg(sgl, sg, sg_len, i) {
-		/* Allocate a PaRAM slot, if needed */
+	/* Allocate a PaRAM slot, if needed */
+	nslots = min_t(unsigned, MAX_NR_SG, sg_len);
+
+	for (i = 0; i < nslots; i++) {
 		if (echan->slot[i] < 0) {
 			echan->slot[i] =
 				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
@@ -273,6 +275,10 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 				return NULL;
 			}
 		}
+	}
+
+	/* Configure PaRAM sets for each SG */
+	for_each_sg(sgl, sg, sg_len, i) {
 
 		acnt = dev_width;
 
@@ -330,6 +336,12 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
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
1.8.1.2

