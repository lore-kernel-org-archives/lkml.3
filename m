Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab3EGBz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:55:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:20011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab3EGBz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:55:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="237793479"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 01/10] NTB: variable dereferenced before check
Date: Mon,  6 May 2013 18:55:20 -0700
Message-Id: <1367891729-11738-2-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct instances of variable dereferencing before checking its value on
the functions exported to the client drivers.  Also, add sanity checks
for all exported functions.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index e0bdfd7..74c5812 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1210,12 +1210,14 @@ EXPORT_SYMBOL_GPL(ntb_transport_create_queue);
  */
 void ntb_transport_free_queue(struct ntb_transport_qp *qp)
 {
-	struct pci_dev *pdev = ntb_query_pdev(qp->ndev);
+	struct pci_dev *pdev;
 	struct ntb_queue_entry *entry;
 
 	if (!qp)
 		return;
 
+	pdev = ntb_query_pdev(qp->ndev);
+
 	cancel_delayed_work_sync(&qp->link_work);
 
 	ntb_unregister_db_callback(qp->ndev, qp->qp_num);
@@ -1371,12 +1373,13 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_up);
  */
 void ntb_transport_link_down(struct ntb_transport_qp *qp)
 {
-	struct pci_dev *pdev = ntb_query_pdev(qp->ndev);
+	struct pci_dev *pdev;
 	int rc, val;
 
 	if (!qp)
 		return;
 
+	pdev = ntb_query_pdev(qp->ndev);
 	qp->client_ready = NTB_LINK_DOWN;
 
 	rc = ntb_read_local_spad(qp->ndev, QP_LINKS, &val);
@@ -1408,6 +1411,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_down);
  */
 bool ntb_transport_link_query(struct ntb_transport_qp *qp)
 {
+	if (!qp)
+		return false;
+
 	return qp->qp_link == NTB_LINK_UP;
 }
 EXPORT_SYMBOL_GPL(ntb_transport_link_query);
@@ -1422,6 +1428,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_query);
  */
 unsigned char ntb_transport_qp_num(struct ntb_transport_qp *qp)
 {
+	if (!qp)
+		return 0;
+
 	return qp->qp_num;
 }
 EXPORT_SYMBOL_GPL(ntb_transport_qp_num);
@@ -1436,6 +1445,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_qp_num);
  */
 unsigned int ntb_transport_max_size(struct ntb_transport_qp *qp)
 {
+	if (!qp)
+		return 0;
+
 	return qp->tx_max_frame - sizeof(struct ntb_payload_header);
 }
 EXPORT_SYMBOL_GPL(ntb_transport_max_size);
-- 
1.7.9.5

