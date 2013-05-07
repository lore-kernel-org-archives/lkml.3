Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab3EGB4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:56:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:20011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932974Ab3EGB4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="237793516"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 05/10] NTB: Link toggle memory leak
Date: Mon,  6 May 2013 18:55:24 -0700
Message-Id: <1367891729-11738-6-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each link-up will allocate a new NTB receive buffer when the NTB
properties are negotiated with the remote system.  These allocations did
not check for existing buffers and thus did not free them.  Now, the
driver will check for an existing buffer and free it if not of the
correct size, before trying to alloc a new one.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 79a3203..be416d6 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -507,17 +507,37 @@ static void ntb_transport_setup_qp_mw(struct ntb_transport *nt,
 	qp->tx_pkts = 0;
 }
 
+static void ntb_free_mw(struct ntb_transport *nt, int num_mw)
+{
+	struct ntb_transport_mw *mw = &nt->mw[num_mw];
+	struct pci_dev *pdev = ntb_query_pdev(nt->ndev);
+
+	if (!mw->virt_addr)
+		return;
+
+	dma_free_coherent(&pdev->dev, mw->size, mw->virt_addr, mw->dma_addr);
+	mw->virt_addr = NULL;
+}
+
 static int ntb_set_mw(struct ntb_transport *nt, int num_mw, unsigned int size)
 {
 	struct ntb_transport_mw *mw = &nt->mw[num_mw];
 	struct pci_dev *pdev = ntb_query_pdev(nt->ndev);
 
+	/* No need to re-setup */
+	if (mw->size == ALIGN(size, 4096))
+		return 0;
+
+	if (mw->size != 0)
+		ntb_free_mw(nt, num_mw);
+
 	/* Alloc memory for receiving data.  Must be 4k aligned */
 	mw->size = ALIGN(size, 4096);
 
 	mw->virt_addr = dma_alloc_coherent(&pdev->dev, mw->size, &mw->dma_addr,
 					   GFP_KERNEL);
 	if (!mw->virt_addr) {
+		mw->size = 0;
 		dev_err(&pdev->dev, "Unable to allocate MW buffer of size %d\n",
 		       (int) mw->size);
 		return -ENOMEM;
@@ -529,18 +549,6 @@ static int ntb_set_mw(struct ntb_transport *nt, int num_mw, unsigned int size)
 	return 0;
 }
 
-static void ntb_free_mw(struct ntb_transport *nt, int num_mw)
-{
-	struct ntb_transport_mw *mw = &nt->mw[num_mw];
-	struct pci_dev *pdev = ntb_query_pdev(nt->ndev);
-
-	if (!mw->virt_addr)
-		return;
-
-	dma_free_coherent(&pdev->dev, mw->size, mw->virt_addr, mw->dma_addr);
-	mw->virt_addr = NULL;
-}
-
 static void ntb_qp_link_cleanup(struct work_struct *work)
 {
 	struct ntb_transport_qp *qp = container_of(work,
-- 
1.7.9.5

