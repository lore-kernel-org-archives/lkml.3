Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbaHHVd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:33:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbaHHUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian King <brking@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 034/259] ibmvscsi: Add memory barriers for send / receive
Date: Fri,  8 Aug 2014 13:37:37 -0700
Message-Id: <1407530482-4483-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 7114aae02742d6b5c5a0d39a41deb61d415d3717 upstream.

Add a memory barrier prior to sending a new command to the VIOS
to ensure the VIOS does not receive stale data in the command buffer.
Also add a memory barrier when processing the CRQ for completed commands.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index c3d4991..c5bb0e0 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -185,6 +185,11 @@ static struct viosrp_crq *crq_queue_next_crq(struct crq_queue *queue)
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
@@ -203,6 +208,11 @@ static int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
 {
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
+	/*
+	 * Ensure the command buffer is flushed to memory before handing it
+	 * over to the VIOS to prevent it from fetching any stale data.
+	 */
+	mb();
 	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
 }
 
-- 
1.9.1

