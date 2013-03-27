Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3C0NSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:18:22 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:61877 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3C0NSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:18:20 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org,
        Steve Wise <swise@opengridcomputing.com>,
        Tom Tucker <tom@opengridcomputing.com>, linux-rdma@vger.kernel.org
Subject: [PATCH v1 2/6] amso1100: convert to using idr_alloc_cyclic
Date: Wed, 27 Mar 2013 09:18:04 -0400
Message-Id: <1364390288-30968-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Note: compile-tested only)

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/amso1100/c2.h    | 1 -
 drivers/infiniband/hw/amso1100/c2_qp.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/infiniband/hw/amso1100/c2.h
index ba7a1208..d619d73 100644
--- a/drivers/infiniband/hw/amso1100/c2.h
+++ b/drivers/infiniband/hw/amso1100/c2.h
@@ -265,7 +265,6 @@ struct c2_pd_table {
 struct c2_qp_table {
 	struct idr idr;
 	spinlock_t lock;
-	int last;
 };
 
 struct c2_element {
diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/infiniband/hw/amso1100/c2_qp.c
index 0ab826b..703b33f 100644
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -385,8 +385,7 @@ static int c2_alloc_qpn(struct c2_dev *c2dev, struct c2_qp *qp)
 	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&c2dev->qp_table.lock);
 
-	ret = idr_alloc(&c2dev->qp_table.idr, qp, c2dev->qp_table.last++, 0,
-			GFP_NOWAIT);
+	ret = idr_alloc_cyclic(&c2dev->qp_table.idr, qp, 0, 0, GFP_NOWAIT);
 	if (ret >= 0)
 		qp->qpn = ret;
 
@@ -1016,7 +1015,7 @@ out:
 void c2_init_qp_table(struct c2_dev *c2dev)
 {
 	spin_lock_init(&c2dev->qp_table.lock);
-	idr_init(&c2dev->qp_table.idr);
+	idr_init_cyclic(&c2dev->qp_table.idr, 0);
 }
 
 void c2_cleanup_qp_table(struct c2_dev *c2dev)
-- 
1.7.11.7

