Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab3KUAV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:21:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:60838 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab3KUAVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:21:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,740,1378882800"; 
   d="scan'208";a="436974423"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] NTB: Disable interrupts and poll under high load
Date: Wed, 20 Nov 2013 17:21:30 -0700
Message-Id: <1384993290-10107-10-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable interrupts and poll under high load

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c        |   42 +++++++++++++++++++++++++++++++++++++-----
 drivers/ntb/ntb_hw.h        |    7 ++++---
 drivers/ntb/ntb_transport.c |   25 +++++++------------------
 3 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 80505ae..170e8e6 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -141,6 +141,24 @@ void ntb_unregister_event_callback(struct ntb_device *ndev)
 	ndev->event_cb = NULL;
 }
 
+static void ntb_irq_work(unsigned long data)
+{
+	struct ntb_db_cb *db_cb = (struct ntb_db_cb *)data;
+	int rc;
+
+	rc = db_cb->callback(db_cb->data, db_cb->db_num);
+	if (rc)
+		tasklet_schedule(&db_cb->irq_work);
+	else {
+		struct ntb_device *ndev = db_cb->ndev;
+		unsigned long mask;
+
+		mask = readw(ndev->reg_ofs.ldb_mask);
+		clear_bit(db_cb->db_num * ndev->bits_per_vector, &mask);
+		writew(mask, ndev->reg_ofs.ldb_mask);
+	}
+}
+
 /**
  * ntb_register_db_callback() - register a callback for doorbell interrupt
  * @ndev: pointer to ntb_device instance
@@ -155,7 +173,7 @@ void ntb_unregister_event_callback(struct ntb_device *ndev)
  * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
  */
 int ntb_register_db_callback(struct ntb_device *ndev, unsigned int idx,
-			     void *data, void (*func)(void *data, int db_num))
+			     void *data, int (*func)(void *data, int db_num))
 {
 	unsigned long mask;
 
@@ -166,6 +184,10 @@ int ntb_register_db_callback(struct ntb_device *ndev, unsigned int idx,
 
 	ndev->db_cb[idx].callback = func;
 	ndev->db_cb[idx].data = data;
+	ndev->db_cb[idx].ndev = ndev;
+
+	tasklet_init(&ndev->db_cb[idx].irq_work, ntb_irq_work,
+		     (unsigned long) &ndev->db_cb[idx]);
 
 	/* unmask interrupt */
 	mask = readw(ndev->reg_ofs.ldb_mask);
@@ -194,6 +216,8 @@ void ntb_unregister_db_callback(struct ntb_device *ndev, unsigned int idx)
 	set_bit(idx * ndev->bits_per_vector, &mask);
 	writew(mask, ndev->reg_ofs.ldb_mask);
 
+	tasklet_disable(&ndev->db_cb[idx].irq_work);
+
 	ndev->db_cb[idx].callback = NULL;
 }
 
@@ -955,12 +979,16 @@ static irqreturn_t bwd_callback_msix_irq(int irq, void *data)
 {
 	struct ntb_db_cb *db_cb = data;
 	struct ntb_device *ndev = db_cb->ndev;
+	unsigned long mask;
 
 	dev_dbg(&ndev->pdev->dev, "MSI-X irq %d received for DB %d\n", irq,
 		db_cb->db_num);
 
-	if (db_cb->callback)
-		db_cb->callback(db_cb->data, db_cb->db_num);
+	mask = readw(ndev->reg_ofs.ldb_mask);
+	set_bit(db_cb->db_num * ndev->bits_per_vector, &mask);
+	writew(mask, ndev->reg_ofs.ldb_mask);
+
+	tasklet_schedule(&db_cb->irq_work);
 
 	/* No need to check for the specific HB irq, any interrupt means
 	 * we're connected.
@@ -976,12 +1004,16 @@ static irqreturn_t xeon_callback_msix_irq(int irq, void *data)
 {
 	struct ntb_db_cb *db_cb = data;
 	struct ntb_device *ndev = db_cb->ndev;
+	unsigned long mask;
 
 	dev_dbg(&ndev->pdev->dev, "MSI-X irq %d received for DB %d\n", irq,
 		db_cb->db_num);
 
-	if (db_cb->callback)
-		db_cb->callback(db_cb->data, db_cb->db_num);
+	mask = readw(ndev->reg_ofs.ldb_mask);
+	set_bit(db_cb->db_num * ndev->bits_per_vector, &mask);
+	writew(mask, ndev->reg_ofs.ldb_mask);
+
+	tasklet_schedule(&db_cb->irq_work);
 
 	/* On Sandybridge, there are 16 bits in the interrupt register
 	 * but only 4 vectors.  So, 5 bits are assigned to the first 3
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 0a31ced..bbdb7ed 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -106,10 +106,11 @@ struct ntb_mw {
 };
 
 struct ntb_db_cb {
-	void (*callback) (void *data, int db_num);
+	int (*callback)(void *data, int db_num);
 	unsigned int db_num;
 	void *data;
 	struct ntb_device *ndev;
+	struct tasklet_struct irq_work;
 };
 
 struct ntb_device {
@@ -228,8 +229,8 @@ struct ntb_device *ntb_register_transport(struct pci_dev *pdev,
 void ntb_unregister_transport(struct ntb_device *ndev);
 void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr);
 int ntb_register_db_callback(struct ntb_device *ndev, unsigned int idx,
-			     void *data, void (*db_cb_func) (void *data,
-							     int db_num));
+			     void *data, int (*db_cb_func)(void *data,
+							   int db_num));
 void ntb_unregister_db_callback(struct ntb_device *ndev, unsigned int idx);
 int ntb_register_event_callback(struct ntb_device *ndev,
 				void (*event_cb_func) (void *handle,
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 172501d..676937b 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -119,7 +119,6 @@ struct ntb_transport_qp {
 
 	void (*rx_handler) (struct ntb_transport_qp *qp, void *qp_data,
 			    void *data, int len);
-	struct tasklet_struct rx_work;
 	struct list_head rx_pend_q;
 	struct list_head rx_free_q;
 	spinlock_t ntb_rx_pend_q_lock;
@@ -1188,11 +1187,14 @@ err:
 	goto out;
 }
 
-static void ntb_transport_rx(unsigned long data)
+static int ntb_transport_rxc_db(void *data, int db_num)
 {
-	struct ntb_transport_qp *qp = (struct ntb_transport_qp *)data;
+	struct ntb_transport_qp *qp = data;
 	int rc, i;
 
+	dev_dbg(&ntb_query_pdev(qp->ndev)->dev, "%s: doorbell %d received\n",
+		__func__, db_num);
+
 	/* Limit the number of packets processed in a single interrupt to
 	 * provide fairness to others
 	 */
@@ -1204,16 +1206,8 @@ static void ntb_transport_rx(unsigned long data)
 
 	if (qp->dma_chan)
 		dma_async_issue_pending(qp->dma_chan);
-}
-
-static void ntb_transport_rxc_db(void *data, int db_num)
-{
-	struct ntb_transport_qp *qp = data;
 
-	dev_dbg(&ntb_query_pdev(qp->ndev)->dev, "%s: doorbell %d received\n",
-		__func__, db_num);
-
-	tasklet_schedule(&qp->rx_work);
+	return i;
 }
 
 static void ntb_tx_copy_callback(void *data)
@@ -1446,19 +1440,15 @@ ntb_transport_create_queue(void *data, struct pci_dev *pdev,
 			     &qp->tx_free_q);
 	}
 
-	tasklet_init(&qp->rx_work, ntb_transport_rx, (unsigned long) qp);
-
 	rc = ntb_register_db_callback(qp->ndev, free_queue, qp,
 				      ntb_transport_rxc_db);
 	if (rc)
-		goto err3;
+		goto err2;
 
 	dev_info(&pdev->dev, "NTB Transport QP %d created\n", qp->qp_num);
 
 	return qp;
 
-err3:
-	tasklet_disable(&qp->rx_work);
 err2:
 	while ((entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q)))
 		kfree(entry);
@@ -1505,7 +1495,6 @@ void ntb_transport_free_queue(struct ntb_transport_qp *qp)
 	}
 
 	ntb_unregister_db_callback(qp->ndev, qp->qp_num);
-	tasklet_disable(&qp->rx_work);
 
 	cancel_delayed_work_sync(&qp->link_work);
 
-- 
1.7.9.5

