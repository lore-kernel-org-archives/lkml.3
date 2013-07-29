Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3G2NbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:31:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34031 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab3G2Na5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:30:57 -0400
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
Subject: [PATCH 8/9] dma: edma: Link to dummy slot only for last SG list split
Date: Mon, 29 Jul 2013 08:29:54 -0500
Message-ID: <1375104595-16018-9-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375104595-16018-1-git-send-email-joelf@ti.com>
References: <1375104595-16018-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/dma/edma.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index c72e8c9..0d3ebde 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -164,6 +164,12 @@ static void edma_execute(struct edma_chan *echan)
 
 	edesc->total_processed += total_process;
 
+	/* If this is either the last set in a set of SG-list transactions
+	   then setup a link to the dummy slot, this results in all future
+	   events being absorbed and that's OK because we're done */
+	if (edesc->total_processed == edesc->pset_nr)
+		edma_link(echan->slot[total_process-1], echan->ecc->dummy_slot);
+
 	edma_resume(echan->ch_num);
 
 	if (edesc->total_processed <= MAX_NR_SG) {
-- 
1.7.9.5

