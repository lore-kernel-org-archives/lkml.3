Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3EVWKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:10:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab3EVWKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jon Mason <jon.mason@intel.com>
Subject: [ 11/21] NTB: variable dereferenced before check
Date: Wed, 22 May 2013 15:10:29 -0700
Message-Id: <20130522205233.929794688@linuxfoundation.org>
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

commit 186f27ff9f9ec5c110739ced88ce9f8fca053882 upstream.

Correct instances of variable dereferencing before checking its value on
the functions exported to the client drivers.  Also, add sanity checks
for all exported functions.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_transport.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1210,12 +1210,14 @@ EXPORT_SYMBOL_GPL(ntb_transport_create_q
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
@@ -1371,12 +1373,13 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_up)
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
@@ -1408,6 +1411,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_dow
  */
 bool ntb_transport_link_query(struct ntb_transport_qp *qp)
 {
+	if (!qp)
+		return false;
+
 	return qp->qp_link == NTB_LINK_UP;
 }
 EXPORT_SYMBOL_GPL(ntb_transport_link_query);
@@ -1422,6 +1428,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_que
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


