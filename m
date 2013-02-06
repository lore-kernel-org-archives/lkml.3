Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab3BFTui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:38 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:56023 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab3BFTud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:33 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 42/77] IB/ehca: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:14 -0800
Message-Id: <1360179649-22465-43-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ehca/ehca_cq.c | 27 +++++++--------------------
 drivers/infiniband/hw/ehca/ehca_qp.c | 34 +++++++++++++++-------------------
 2 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 8f52901..212150c 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -128,7 +128,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	void *vpage;
 	u32 counter;
 	u64 rpage, cqx_fec, h_ret;
-	int ipz_rc, ret, i;
+	int ipz_rc, i;
 	unsigned long flags;
 
 	if (cqe >= 0xFFFFFFFF - 64 - additional_cqe)
@@ -163,32 +163,19 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	adapter_handle = shca->ipz_hca_handle;
 	param.eq_handle = shca->eq.ipz_eq_handle;
 
-	do {
-		if (!idr_pre_get(&ehca_cq_idr, GFP_KERNEL)) {
-			cq = ERR_PTR(-ENOMEM);
-			ehca_err(device, "Can't reserve idr nr. device=%p",
-				 device);
-			goto create_cq_exit1;
-		}
-
-		write_lock_irqsave(&ehca_cq_idr_lock, flags);
-		ret = idr_get_new(&ehca_cq_idr, my_cq, &my_cq->token);
-		write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-	} while (ret == -EAGAIN);
+	idr_preload(GFP_KERNEL);
+	write_lock_irqsave(&ehca_cq_idr_lock, flags);
+	my_cq->token = idr_alloc(&ehca_cq_idr, my_cq, 0, 0x2000000, GFP_NOWAIT);
+	write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+	idr_preload_end();
 
-	if (ret) {
+	if (my_cq->token < 0) {
 		cq = ERR_PTR(-ENOMEM);
 		ehca_err(device, "Can't allocate new idr entry. device=%p",
 			 device);
 		goto create_cq_exit1;
 	}
 
-	if (my_cq->token > 0x1FFFFFF) {
-		cq = ERR_PTR(-ENOMEM);
-		ehca_err(device, "Invalid number of cq. device=%p", device);
-		goto create_cq_exit2;
-	}
-
 	/*
 	 * CQs maximum depth is 4GB-64, but we need additional 20 as buffer
 	 * for receiving errors CQEs.
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 1493939..00d6861 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -636,30 +636,26 @@ static struct ehca_qp *internal_create_qp(
 		my_qp->send_cq =
 			container_of(init_attr->send_cq, struct ehca_cq, ib_cq);
 
-	do {
-		if (!idr_pre_get(&ehca_qp_idr, GFP_KERNEL)) {
-			ret = -ENOMEM;
-			ehca_err(pd->device, "Can't reserve idr resources.");
-			goto create_qp_exit0;
-		}
+	idr_preload(GFP_KERNEL);
+	write_lock_irqsave(&ehca_qp_idr_lock, flags);
 
-		write_lock_irqsave(&ehca_qp_idr_lock, flags);
-		ret = idr_get_new(&ehca_qp_idr, my_qp, &my_qp->token);
-		write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
-	} while (ret == -EAGAIN);
+	ret = idr_alloc(&ehca_qp_idr, my_qp, 0, 0x2000000, GFP_NOWAIT);
+	if (ret >= 0)
+		my_qp->token = ret;
 
-	if (ret) {
-		ret = -ENOMEM;
-		ehca_err(pd->device, "Can't allocate new idr entry.");
+	write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+	idr_preload_end();
+	if (ret < 0) {
+		if (ret == -ENOSPC) {
+			ret = -EINVAL;
+			ehca_err(pd->device, "Invalid number of qp");
+		} else {
+			ret = -ENOMEM;
+			ehca_err(pd->device, "Can't allocate new idr entry.");
+		}
 		goto create_qp_exit0;
 	}
 
-	if (my_qp->token > 0x1FFFFFF) {
-		ret = -EINVAL;
-		ehca_err(pd->device, "Invalid number of qp");
-		goto create_qp_exit1;
-	}
-
 	if (has_srq)
 		parms.srq_token = my_qp->token;
 
-- 
1.8.1

