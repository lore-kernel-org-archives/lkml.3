Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3HBRjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:39:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:10958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab3HBRgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="375273092"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/15] NTB: Correct debugfs to work with more than 1 NTB Device
Date: Fri,  2 Aug 2013 10:35:33 -0700
Message-Id: <1375464944-27914-5-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugfs was setup in NTB to only have a single debugfs directory.  This
resulted in the leaking of debugfs directories and files when multiple
NTB devices were present, due to each device stomping on the variables
containing the previous device's values (thus preventing them from being
freed on cleanup).  Correct this by creating a secondary directory of
the PCI BDF for each device present, and nesting the previously existing
information in those directories.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c        |   27 +++++++++++++++++++++++++++
 drivers/ntb/ntb_hw.h        |   16 ++++++++++++++++
 drivers/ntb/ntb_transport.c |   17 +++++------------
 3 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 26b808b..97d6704 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -78,6 +78,8 @@ enum {
 	BWD_HW,
 };
 
+struct dentry *debugfs_dir;
+
 /* Translate memory window 0,1 to BAR 2,4 */
 #define MW_TO_BAR(mw)	(mw * 2 + 2)
 
@@ -998,6 +1000,28 @@ static void ntb_free_callbacks(struct ntb_device *ndev)
 	kfree(ndev->db_cb);
 }
 
+static void ntb_setup_debugfs(struct ntb_device *ndev)
+{
+	if (!debugfs_initialized())
+		return;
+
+	if (!debugfs_dir)
+		debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+
+	ndev->debugfs_dir = debugfs_create_dir(pci_name(ndev->pdev),
+					       debugfs_dir);
+}
+
+static void ntb_free_debugfs(struct ntb_device *ndev)
+{
+	debugfs_remove_recursive(ndev->debugfs_dir);
+
+	if (debugfs_dir && simple_empty(debugfs_dir)) {
+		debugfs_remove_recursive(debugfs_dir);
+		debugfs_dir = NULL;
+	}
+}
+
 static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ntb_device *ndev;
@@ -1010,6 +1034,7 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ndev->pdev = pdev;
 	ndev->link_status = NTB_LINK_DOWN;
 	pci_set_drvdata(pdev, ndev);
+	ntb_setup_debugfs(ndev);
 
 	rc = pci_enable_device(pdev);
 	if (rc)
@@ -1106,6 +1131,7 @@ err2:
 err1:
 	pci_disable_device(pdev);
 err:
+	ntb_free_debugfs(ndev);
 	kfree(ndev);
 
 	dev_err(&pdev->dev, "Error loading %s module\n", KBUILD_MODNAME);
@@ -1135,6 +1161,7 @@ static void ntb_pci_remove(struct pci_dev *pdev)
 	iounmap(ndev->reg_base);
 	pci_release_selected_regions(pdev, NTB_BAR_MASK);
 	pci_disable_device(pdev);
+	ntb_free_debugfs(ndev);
 	kfree(ndev);
 }
 
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 3a3038c..6a4f56f 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -127,6 +127,8 @@ struct ntb_device {
 	unsigned char link_status;
 	struct delayed_work hb_timer;
 	unsigned long last_ts;
+
+	struct dentry *debugfs_dir;
 };
 
 /**
@@ -155,6 +157,20 @@ static inline struct pci_dev *ntb_query_pdev(struct ntb_device *ndev)
 	return ndev->pdev;
 }
 
+/**
+ * ntb_query_debugfs() - return the debugfs pointer
+ * @ndev: pointer to ntb_device instance
+ *
+ * Given the ntb pointer, return the debugfs directory pointer for the NTB
+ * hardware device
+ *
+ * RETURNS: a pointer to the debugfs directory
+ */
+static inline struct dentry *ntb_query_debugfs(struct ntb_device *ndev)
+{
+	return ndev->debugfs_dir;
+}
+
 struct ntb_device *ntb_register_transport(struct pci_dev *pdev,
 					  void *transport);
 void ntb_unregister_transport(struct ntb_device *ndev);
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index f8d7081..c308915 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -157,7 +157,6 @@ struct ntb_transport {
 	bool transport_link;
 	struct delayed_work link_work;
 	struct work_struct link_cleanup;
-	struct dentry *debugfs_dir;
 };
 
 enum {
@@ -824,12 +823,12 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
 	qp->tx_max_frame = min(transport_mtu, tx_size / 2);
 	qp->tx_max_entry = tx_size / qp->tx_max_frame;
 
-	if (nt->debugfs_dir) {
+	if (ntb_query_debugfs(nt->ndev)) {
 		char debugfs_name[4];
 
 		snprintf(debugfs_name, 4, "qp%d", qp_num);
 		qp->debugfs_dir = debugfs_create_dir(debugfs_name,
-						     nt->debugfs_dir);
+						 ntb_query_debugfs(nt->ndev));
 
 		qp->debugfs_stats = debugfs_create_file("stats", S_IRUSR,
 							qp->debugfs_dir, qp,
@@ -857,11 +856,6 @@ int ntb_transport_init(struct pci_dev *pdev)
 	if (!nt)
 		return -ENOMEM;
 
-	if (debugfs_initialized())
-		nt->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	else
-		nt->debugfs_dir = NULL;
-
 	nt->ndev = ntb_register_transport(pdev, nt);
 	if (!nt->ndev) {
 		rc = -EIO;
@@ -907,7 +901,6 @@ err2:
 err1:
 	ntb_unregister_transport(nt->ndev);
 err:
-	debugfs_remove_recursive(nt->debugfs_dir);
 	kfree(nt);
 	return rc;
 }
@@ -921,16 +914,16 @@ void ntb_transport_free(void *transport)
 	nt->transport_link = NTB_LINK_DOWN;
 
 	/* verify that all the qp's are freed */
-	for (i = 0; i < nt->max_qps; i++)
+	for (i = 0; i < nt->max_qps; i++) {
 		if (!test_bit(i, &nt->qp_bitmap))
 			ntb_transport_free_queue(&nt->qps[i]);
+		debugfs_remove_recursive(nt->qps[i].debugfs_dir);
+	}
 
 	ntb_bus_remove(nt);
 
 	cancel_delayed_work_sync(&nt->link_work);
 
-	debugfs_remove_recursive(nt->debugfs_dir);
-
 	ntb_unregister_event_callback(nt->ndev);
 
 	pdev = ntb_query_pdev(nt->ndev);
-- 
1.7.9.5

