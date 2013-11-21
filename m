Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3KUAXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:23:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:60838 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab3KUAVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:21:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,740,1378882800"; 
   d="scan'208";a="436974398"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] NTB: correct dmaengine_get/put usage
Date: Wed, 20 Nov 2013 17:21:26 -0700
Message-Id: <1384993290-10107-6-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine_get() causes the initialization of the per-cpu channel tables.
It needs to be called prior to dma_find_channel().

Initial version by Dan Williams <dan.j.williams@intel.com>

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 7010f23..172501d 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1419,11 +1419,12 @@ ntb_transport_create_queue(void *data, struct pci_dev *pdev,
 	qp->tx_handler = handlers->tx_handler;
 	qp->event_handler = handlers->event_handler;
 
+	dmaengine_get();
 	qp->dma_chan = dma_find_channel(DMA_MEMCPY);
-	if (!qp->dma_chan)
+	if (!qp->dma_chan) {
+		dmaengine_put();
 		dev_info(&pdev->dev, "Unable to allocate DMA channel, using CPU instead\n");
-	else
-		dmaengine_get();
+	}
 
 	for (i = 0; i < NTB_QP_DEF_NUM_ENTRIES; i++) {
 		entry = kzalloc(sizeof(struct ntb_queue_entry), GFP_ATOMIC);
@@ -1464,6 +1465,8 @@ err2:
 err1:
 	while ((entry = ntb_list_rm(&qp->ntb_rx_free_q_lock, &qp->rx_free_q)))
 		kfree(entry);
+	if (qp->dma_chan)
+		dmaengine_put();
 	set_bit(free_queue, &nt->qp_bitmap);
 err:
 	return NULL;
-- 
1.7.9.5

