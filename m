Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbaEDQnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:43:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaEDPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 085/158] IB/qib: Fix debugfs ordering issue with multiple HCAs
Date: Sun,  4 May 2014 11:39:54 -0400
Message-Id: <20140504154041.440874789@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_init.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1097,14 +1097,10 @@ struct qib_devdata *qib_alloc_devdata(st
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
@@ -1121,11 +1117,6 @@ struct qib_devdata *qib_alloc_devdata(st
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
 
@@ -1139,9 +1130,15 @@ struct qib_devdata *qib_alloc_devdata(st
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


