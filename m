Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3H2XGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:06:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50971 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902Ab3H2XGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:06:38 -0400
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
Subject: [PATCH v4 5/6] dma: edma: Leave linked to Null slot instead of DUMMY slot
Date: Thu, 29 Aug 2013 18:05:44 -0500
Message-ID: <1377817545-18015-6-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377817545-18015-1-git-send-email-joelf@ti.com>
References: <1377817545-18015-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dummy slot has been used as a way for missed-events not to be
reported as missing. This has been particularly troublesome for cases
where we might want to temporarily pause all incoming events.

For EDMA DMAC, there is no way to do any such pausing of events as
the occurence of the "next" event is not software controlled.
Using "edma_pause" in IRQ handlers doesn't help as by then the event
in concern from the slave is already missed.

Linking a dummy slot, is seen to absorb these events which we didn't
want to miss. So we don't link to dummy, but instead leave it linked
to NULL set, allow an error condition and detect the channel that
missed it.

Signed-off-by: Joel Fernandes <joelf@ti.com>

dma: edma: Link to dummy slot only for last SG list split

Consider the case where we have a scatter-list like:
SG1->SG2->SG3->SG4->SG5->SG6->Null

For ex, for a MAX_NR_SG of 2, earlier we were splitting this as:
SG1->SG2->Null
SG3->SG4->Null
SG5->SG6->Null

Now we split it as
SG1->SG2->Null
SG3->SG4->Null
SG5->SG6->Dummy

This approach results in lesser unwanted interrupts that occur
for the last list split. The Dummy slot has the property of not
raising an error condition if events are missed unlike the Null
slot. We are OK with this as we're done with processing the
whole list once we reach Dummy.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 0e77b57..25e47d4 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -158,13 +158,18 @@ static void edma_execute(struct edma_chan *echan)
 		/* Link to the previous slot if not the last set */
 		if (i != (nslots - 1))
 			edma_link(echan->slot[i], echan->slot[i+1]);
-		/* Final pset links to the dummy pset */
-		else
-			edma_link(echan->slot[i], echan->ecc->dummy_slot);
 	}
 
 	edesc->processed += nslots;
 
+	/*
+	 * If this is either the last set in a set of SG-list transactions
+	 * then setup a link to the dummy slot, this results in all future
+	 * events being absorbed and that's OK because we're done
+	 */
+	if (edesc->processed == edesc->pset_nr)
+		edma_link(echan->slot[nslots-1], echan->ecc->dummy_slot);
+
 	edma_resume(echan->ch_num);
 
 	if (edesc->processed <= MAX_NR_SG) {
-- 
1.8.1.2

