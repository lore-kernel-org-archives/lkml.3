Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3KUAX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:23:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:10777 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab3KUAVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:21:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,740,1378882800"; 
   d="scan'208";a="431181570"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] NTB: Fix ntb_transport link down race
Date: Wed, 20 Nov 2013 17:21:25 -0700
Message-Id: <1384993290-10107-5-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A WARN_ON is being hit in ntb_qp_link_work due to the NTB transport link
being down while the ntb qp link is still active.  This is caused by the
transport link being brought down prior to the qp link worker thread
being terminated.  To correct this, shutdown the qp's prior to bringing
the transport link down.  Also, only call the qp worker thread if it is
in interrupt context, otherwise call the function directly.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 12a9e83..7010f23 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -584,11 +584,8 @@ static int ntb_set_mw(struct ntb_transport *nt, int num_mw, unsigned int size)
 	return 0;
 }
 
-static void ntb_qp_link_cleanup(struct work_struct *work)
+static void ntb_qp_link_cleanup(struct ntb_transport_qp *qp)
 {
-	struct ntb_transport_qp *qp = container_of(work,
-						   struct ntb_transport_qp,
-						   link_cleanup);
 	struct ntb_transport *nt = qp->transport;
 	struct pci_dev *pdev = ntb_query_pdev(nt->ndev);
 
@@ -602,6 +599,16 @@ static void ntb_qp_link_cleanup(struct work_struct *work)
 
 	dev_info(&pdev->dev, "qp %d: Link Down\n", qp->qp_num);
 	qp->qp_link = NTB_LINK_DOWN;
+}
+
+static void ntb_qp_link_cleanup_work(struct work_struct *work)
+{
+	struct ntb_transport_qp *qp = container_of(work,
+						   struct ntb_transport_qp,
+						   link_cleanup);
+	struct ntb_transport *nt = qp->transport;
+
+	ntb_qp_link_cleanup(qp);
 
 	if (nt->transport_link == NTB_LINK_UP)
 		schedule_delayed_work(&qp->link_work,
@@ -613,22 +620,20 @@ static void ntb_qp_link_down(struct ntb_transport_qp *qp)
 	schedule_work(&qp->link_cleanup);
 }
 
-static void ntb_transport_link_cleanup(struct work_struct *work)
+static void ntb_transport_link_cleanup(struct ntb_transport *nt)
 {
-	struct ntb_transport *nt = container_of(work, struct ntb_transport,
-						link_cleanup);
 	int i;
 
+	/* Pass along the info to any clients */
+	for (i = 0; i < nt->max_qps; i++)
+		if (!test_bit(i, &nt->qp_bitmap))
+			ntb_qp_link_cleanup(&nt->qps[i]);
+
 	if (nt->transport_link == NTB_LINK_DOWN)
 		cancel_delayed_work_sync(&nt->link_work);
 	else
 		nt->transport_link = NTB_LINK_DOWN;
 
-	/* Pass along the info to any clients */
-	for (i = 0; i < nt->max_qps; i++)
-		if (!test_bit(i, &nt->qp_bitmap))
-			ntb_qp_link_down(&nt->qps[i]);
-
 	/* The scratchpad registers keep the values if the remote side
 	 * goes down, blast them now to give them a sane value the next
 	 * time they are accessed
@@ -637,6 +642,14 @@ static void ntb_transport_link_cleanup(struct work_struct *work)
 		ntb_write_local_spad(nt->ndev, i, 0);
 }
 
+static void ntb_transport_link_cleanup_work(struct work_struct *work)
+{
+	struct ntb_transport *nt = container_of(work, struct ntb_transport,
+						link_cleanup);
+
+	ntb_transport_link_cleanup(nt);
+}
+
 static void ntb_transport_event_callback(void *data, enum ntb_hw_event event)
 {
 	struct ntb_transport *nt = data;
@@ -880,7 +893,7 @@ static int ntb_transport_init_queue(struct ntb_transport *nt,
 	}
 
 	INIT_DELAYED_WORK(&qp->link_work, ntb_qp_link_work);
-	INIT_WORK(&qp->link_cleanup, ntb_qp_link_cleanup);
+	INIT_WORK(&qp->link_cleanup, ntb_qp_link_cleanup_work);
 
 	spin_lock_init(&qp->ntb_rx_pend_q_lock);
 	spin_lock_init(&qp->ntb_rx_free_q_lock);
@@ -936,7 +949,7 @@ int ntb_transport_init(struct pci_dev *pdev)
 	}
 
 	INIT_DELAYED_WORK(&nt->link_work, ntb_transport_link_work);
-	INIT_WORK(&nt->link_cleanup, ntb_transport_link_cleanup);
+	INIT_WORK(&nt->link_cleanup, ntb_transport_link_cleanup_work);
 
 	rc = ntb_register_event_callback(nt->ndev,
 					 ntb_transport_event_callback);
@@ -972,7 +985,7 @@ void ntb_transport_free(void *transport)
 	struct ntb_device *ndev = nt->ndev;
 	int i;
 
-	nt->transport_link = NTB_LINK_DOWN;
+	ntb_transport_link_cleanup(nt);
 
 	/* verify that all the qp's are freed */
 	for (i = 0; i < nt->max_qps; i++) {
-- 
1.7.9.5

