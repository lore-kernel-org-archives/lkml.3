Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3EVWK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:10:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab3EVWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: [ 15/21] NTB: Link toggle memory leak
Date: Wed, 22 May 2013 15:10:33 -0700
Message-Id: <20130522205234.378348774@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Mason <jon.mason@intel.com>

commit b77b2637b39ecc380bb08992380d7d48452b0872 upstream.

Each link-up will allocate a new NTB receive buffer when the NTB
properties are negotiated with the remote system.  These allocations did
not check for existing buffers and thus did not free them.  Now, the
driver will check for an existing buffer and free it if not of the
correct size, before trying to alloc a new one.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_transport.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -507,17 +507,37 @@ static void ntb_transport_setup_qp_mw(st
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
@@ -529,18 +549,6 @@ static int ntb_set_mw(struct ntb_transpo
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


