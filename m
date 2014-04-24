Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaDXLLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:11:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46521 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaDXIxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 060/182] IB/qib: Fix debugfs ordering issue with multiple HCAs
Date: Thu, 24 Apr 2014 09:49:45 +0100
Message-Id: <1398329507-5911-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit f8b6c47a44c063062317646683a73371c24c69ee upstream.

The debugfs init code was incorrectly called before the idr mechanism
is used to get the unit number, so the dd->unit hasn't been
initialized.  This caused the unit relative directory creation to fail
after the first.

This patch moves the init for the debugfs stuff until after all of the
failures and after the unit number has been determined.

A bug in unwind code in qib_alloc_devdata() is also fixed.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/hw/qib/qib_init.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 36e048e..a17c19b 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1097,14 +1097,10 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	int ret;
 
 	dd = (struct qib_devdata *) ib_alloc_device(sizeof(*dd) + extra);
-	if (!dd) {
-		dd = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
+	if (!dd)
+		return ERR_PTR(-ENOMEM);
 
-#ifdef CONFIG_DEBUG_FS
-	qib_dbg_ibdev_init(&dd->verbs_dev);
-#endif
+	INIT_LIST_HEAD(&dd->list);
 
 	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&qib_devs_lock, flags);
@@ -1121,11 +1117,6 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	if (ret < 0) {
 		qib_early_err(&pdev->dev,
 			      "Could not allocate unit ID: error %d\n", -ret);
-#ifdef CONFIG_DEBUG_FS
-		qib_dbg_ibdev_exit(&dd->verbs_dev);
-#endif
-		ib_dealloc_device(&dd->verbs_dev.ibdev);
-		dd = ERR_PTR(ret);
 		goto bail;
 	}
 
@@ -1139,9 +1130,15 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 			qib_early_err(&pdev->dev,
 				"Could not alloc cpulist info, cpu affinity might be wrong\n");
 	}
-
-bail:
+#ifdef CONFIG_DEBUG_FS
+	qib_dbg_ibdev_init(&dd->verbs_dev);
+#endif
 	return dd;
+bail:
+	if (!list_empty(&dd->list))
+		list_del_init(&dd->list);
+	ib_dealloc_device(&dd->verbs_dev.ibdev);
+	return ERR_PTR(ret);;
 }
 
 /*
-- 
1.9.1

