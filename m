Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaHDROW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:14:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56478 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Christoph Hellwig" <hch@lst.de>,
        "Nathan Fontenot" <nfont@linux.vnet.ibm.com>,
        "Brian King" <brking@linux.vnet.ibm.com>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.994208773@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 13/94] ibmvscsi: Add memory barriers for send / receive
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 7114aae02742d6b5c5a0d39a41deb61d415d3717 upstream.

Add a memory barrier prior to sending a new command to the VIOS
to ensure the VIOS does not receive stale data in the command buffer.
Also add a memory barrier when processing the CRQ for completed commands.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[bwh: Backported to 3.2: as the iSeries code is still present, these
 functions have different names and live in rpa_vscsi.c.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
+++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -104,6 +104,11 @@ static struct viosrp_crq *crq_queue_next
 	if (crq->valid & 0x80) {
 		if (++queue->cur == queue->size)
 			queue->cur = 0;
+
+		/* Ensure the read of the valid bit occurs before reading any
+		 * other bits of the CRQ entry
+		 */
+		rmb();
 	} else
 		crq = NULL;
 	spin_unlock_irqrestore(&queue->lock, flags);
@@ -122,6 +127,11 @@ static int rpavscsi_send_crq(struct ibmv
 {
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
+	/*
+	 * Ensure the command buffer is flushed to memory before handing it
+	 * over to the VIOS to prevent it from fetching any stale data.
+	 */
+	mb();
 	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
 }
 

