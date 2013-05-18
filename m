Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab3ERCrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:47:02 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:50461 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab3ERCrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:47:00 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.9-table] NTB: Link toggle memory leak
Date: Sat, 18 May 2013 11:44:51 +0900
Message-Id: <1368845091-4042-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@intel.com>

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jon Mason <jon.mason@intel.com>"

commit b77b2637b39ecc380bb08992380d7d48452b0872 upstream

Each link-up will allocate a new NTB receive buffer when the NTB
properties are negotiated with the remote system.  These allocations did
not check for existing buffers and thus did not free them.  Now, the
driver will check for an existing buffer and free it if not of the
correct size, before trying to alloc a new one.

Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/ntb/ntb_transport.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 2258649..f5a424d 100644
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
1.8.1.2

