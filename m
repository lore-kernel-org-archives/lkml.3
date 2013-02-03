Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3BCBas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:30:48 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61683 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3BCBWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:14 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Mike Marciniszyn <infinipath@intel.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 30/62] infiniband/qib: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:31 -0800
Message-Id: <1359854463-2538-31-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: linux-rdma@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/infiniband/hw/qib/qib_init.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index ddf066d..50e33aa 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1060,22 +1060,23 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	struct qib_devdata *dd;
 	int ret;
 
-	if (!idr_pre_get(&qib_unit_table, GFP_KERNEL)) {
-		dd = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
 	dd = (struct qib_devdata *) ib_alloc_device(sizeof(*dd) + extra);
 	if (!dd) {
 		dd = ERR_PTR(-ENOMEM);
 		goto bail;
 	}
 
+	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&qib_devs_lock, flags);
-	ret = idr_get_new(&qib_unit_table, dd, &dd->unit);
-	if (ret >= 0)
+
+	ret = idr_alloc(&qib_unit_table, dd, 0, 0, GFP_NOWAIT);
+	if (ret >= 0) {
+		dd->unit = ret;
 		list_add(&dd->list, &qib_dev_list);
+	}
+
 	spin_unlock_irqrestore(&qib_devs_lock, flags);
+	idr_preload_end();
 
 	if (ret < 0) {
 		qib_early_err(&pdev->dev,
@@ -1180,11 +1181,6 @@ static int __init qlogic_ib_init(void)
 	 * the PCI subsystem.
 	 */
 	idr_init(&qib_unit_table);
-	if (!idr_pre_get(&qib_unit_table, GFP_KERNEL)) {
-		pr_err("idr_pre_get() failed\n");
-		ret = -ENOMEM;
-		goto bail_cq_wq;
-	}
 
 	ret = pci_register_driver(&qib_driver);
 	if (ret < 0) {
@@ -1199,7 +1195,6 @@ static int __init qlogic_ib_init(void)
 
 bail_unit:
 	idr_destroy(&qib_unit_table);
-bail_cq_wq:
 	destroy_workqueue(qib_cq_wq);
 bail_dev:
 	qib_dev_cleanup();
-- 
1.8.1

