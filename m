Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaFOUif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:35 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:49841 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752411AbaFOUib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:4050:4118:4321:4385:4605:5007:6261:8603:9592:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: apple79_67374d7b8304a
X-Filterd-Recvd-Size: 7938
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH -next 08/26] infiniband: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:37 -0700
Message-Id: <fc94266778d11e0faa0011efed23b1915a4eaa2a.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/cxgb3/cxio_hal.c      |  7 +++----
 drivers/infiniband/hw/mthca/mthca_memfree.c |  5 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 20 ++++++++------------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  6 ++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  8 +++-----
 5 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index de1c61b4..3173154 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -293,13 +293,12 @@ int cxio_create_qp(struct cxio_rdev *rdev_p, u32 kernel_domain,
 	if (!wq->sq)
 		goto err3;
 
-	wq->queue = dma_alloc_coherent(&(rdev_p->rnic_info.pdev->dev),
-					     depth * sizeof(union t3_wr),
-					     &(wq->dma_addr), GFP_KERNEL);
+	wq->queue = dma_zalloc_coherent(&(rdev_p->rnic_info.pdev->dev),
+					depth * sizeof(union t3_wr),
+					&wq->dma_addr, GFP_KERNEL);
 	if (!wq->queue)
 		goto err4;
 
-	memset(wq->queue, 0, depth * sizeof(union t3_wr));
 	dma_unmap_addr_set(wq, mapping, wq->dma_addr);
 	wq->doorbell = (void __iomem *)rdev_p->rnic_info.kdb_addr;
 	if (!kernel_domain)
diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 7d2e42d..1959dc5 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -624,13 +624,12 @@ int mthca_alloc_db(struct mthca_dev *dev, enum mthca_db_type type,
 	page = dev->db_tab->page + end;
 
 alloc:
-	page->db_rec = dma_alloc_coherent(&dev->pdev->dev, MTHCA_ICM_PAGE_SIZE,
-					  &page->mapping, GFP_KERNEL);
+	page->db_rec = dma_zalloc_coherent(&dev->pdev->dev, MTHCA_ICM_PAGE_SIZE,
+					   &page->mapping, GFP_KERNEL);
 	if (!page->db_rec) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	memset(page->db_rec, 0, MTHCA_ICM_PAGE_SIZE);
 
 	ret = mthca_MAP_ICM_page(dev, page->mapping,
 				 mthca_uarc_virt(dev, &dev->driver_uar, i));
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 3bbf201..f747d64 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -365,11 +365,11 @@ static int ocrdma_alloc_q(struct ocrdma_dev *dev,
 	q->len = len;
 	q->entry_size = entry_size;
 	q->size = len * entry_size;
-	q->va = dma_alloc_coherent(&dev->nic_info.pdev->dev, q->size,
-				   &q->dma, GFP_KERNEL);
+	q->va = dma_zalloc_coherent(&dev->nic_info.pdev->dev, q->size,
+				    &q->dma, GFP_KERNEL);
 	if (!q->va)
 		return -ENOMEM;
-	memset(q->va, 0, q->size);
+
 	return 0;
 }
 
@@ -1581,12 +1581,11 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 		return -ENOMEM;
 	ocrdma_init_mch(&cmd->cmd.req, OCRDMA_CMD_CREATE_CQ,
 			OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
-	cq->va = dma_alloc_coherent(&pdev->dev, cq->len, &cq->pa, GFP_KERNEL);
+	cq->va = dma_zalloc_coherent(&pdev->dev, cq->len, &cq->pa, GFP_KERNEL);
 	if (!cq->va) {
 		status = -ENOMEM;
 		goto mem_err;
 	}
-	memset(cq->va, 0, cq->len);
 	page_size = cq->len / hw_pages;
 	cmd->cmd.pgsz_pgcnt = (page_size / OCRDMA_MIN_Q_PAGE_SIZE) <<
 					OCRDMA_CREATE_CQ_PAGE_SIZE_SHIFT;
@@ -1973,10 +1972,9 @@ static int ocrdma_set_create_qp_sq_cmd(struct ocrdma_create_qp_req *cmd,
 	qp->sq.max_cnt = max_wqe_allocated;
 	len = (hw_pages * hw_page_size);
 
-	qp->sq.va = dma_alloc_coherent(&pdev->dev, len, &pa, GFP_KERNEL);
+	qp->sq.va = dma_zalloc_coherent(&pdev->dev, len, &pa, GFP_KERNEL);
 	if (!qp->sq.va)
 		return -EINVAL;
-	memset(qp->sq.va, 0, len);
 	qp->sq.len = len;
 	qp->sq.pa = pa;
 	qp->sq.entry_size = dev->attr.wqe_size;
@@ -2023,10 +2021,9 @@ static int ocrdma_set_create_qp_rq_cmd(struct ocrdma_create_qp_req *cmd,
 	qp->rq.max_cnt = max_rqe_allocated;
 	len = (hw_pages * hw_page_size);
 
-	qp->rq.va = dma_alloc_coherent(&pdev->dev, len, &pa, GFP_KERNEL);
+	qp->rq.va = dma_zalloc_coherent(&pdev->dev, len, &pa, GFP_KERNEL);
 	if (!qp->rq.va)
 		return -ENOMEM;
-	memset(qp->rq.va, 0, len);
 	qp->rq.pa = pa;
 	qp->rq.len = len;
 	qp->rq.entry_size = dev->attr.rqe_size;
@@ -2079,11 +2076,10 @@ static int ocrdma_set_create_qp_ird_cmd(struct ocrdma_create_qp_req *cmd,
 	if (dev->attr.ird == 0)
 		return 0;
 
-	qp->ird_q_va = dma_alloc_coherent(&pdev->dev, ird_q_len,
-					&pa, GFP_KERNEL);
+	qp->ird_q_va = dma_zalloc_coherent(&pdev->dev, ird_q_len, &pa,
+					   GFP_KERNEL);
 	if (!qp->ird_q_va)
 		return -ENOMEM;
-	memset(qp->ird_q_va, 0, ird_q_len);
 	ocrdma_build_q_pages(&cmd->ird_addr[0], dev->attr.num_ird_pages,
 			     pa, ird_page_size);
 	for (; i < ird_q_len / dev->attr.rqe_size; i++) {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 41a9aec..d5692d1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -56,15 +56,13 @@ static bool ocrdma_alloc_stats_mem(struct ocrdma_dev *dev)
 	mem->size = max_t(u32, sizeof(struct ocrdma_rdma_stats_req),
 			sizeof(struct ocrdma_rdma_stats_resp));
 
-	mem->va   = dma_alloc_coherent(&dev->nic_info.pdev->dev, mem->size,
-					 &mem->pa, GFP_KERNEL);
+	mem->va = dma_zalloc_coherent(&dev->nic_info.pdev->dev, mem->size,
+				      &mem->pa, GFP_KERNEL);
 	if (!mem->va) {
 		pr_err("%s: stats mbox allocation failed\n", __func__);
 		return false;
 	}
 
-	memset(mem->va, 0, mem->size);
-
 	/* Alloc debugfs mem */
 	mem->debugfs_mem = kzalloc(OCRDMA_MAX_DBGFS_MEM, GFP_KERNEL);
 	if (!mem->debugfs_mem) {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index edf6211..461712b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -373,13 +373,12 @@ struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 	INIT_LIST_HEAD(&ctx->mm_head);
 	mutex_init(&ctx->mm_list_lock);
 
-	ctx->ah_tbl.va = dma_alloc_coherent(&pdev->dev, map_len,
-					    &ctx->ah_tbl.pa, GFP_KERNEL);
+	ctx->ah_tbl.va = dma_zalloc_coherent(&pdev->dev, map_len,
+					     &ctx->ah_tbl.pa, GFP_KERNEL);
 	if (!ctx->ah_tbl.va) {
 		kfree(ctx);
 		return ERR_PTR(-ENOMEM);
 	}
-	memset(ctx->ah_tbl.va, 0, map_len);
 	ctx->ah_tbl.len = map_len;
 
 	memset(&resp, 0, sizeof(resp));
@@ -708,13 +707,12 @@ static int ocrdma_build_pbl_tbl(struct ocrdma_dev *dev, struct ocrdma_hw_mr *mr)
 		return -ENOMEM;
 
 	for (i = 0; i < mr->num_pbls; i++) {
-		va = dma_alloc_coherent(&pdev->dev, dma_len, &pa, GFP_KERNEL);
+		va = dma_zalloc_coherent(&pdev->dev, dma_len, &pa, GFP_KERNEL);
 		if (!va) {
 			ocrdma_free_mr_pbl_tbl(dev, mr);
 			status = -ENOMEM;
 			break;
 		}
-		memset(va, 0, dma_len);
 		mr->pbl_table[i].va = va;
 		mr->pbl_table[i].pa = pa;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

