Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbaEMJ3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:29:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60878 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760101AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 070/182] IB/qib: Fix debugfs ordering issue with multiple HCAs
Date: Tue, 13 May 2014 11:27:02 +0200
Message-Id: <229eb3f3918472ff1871e7e7db36f300175ca9ed.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/hw/qib/qib_init.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 24e802f4ea2f..76c3e177164d 100644
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
1.9.3

