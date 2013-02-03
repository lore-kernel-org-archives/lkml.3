Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3BCBWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:22:08 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36193 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3BCBWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:03 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 23/62] infiniband/amso1100: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:24 -0800
Message-Id: <1359854463-2538-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/infiniband/hw/amso1100/c2_qp.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/infiniband/hw/amso1100/c2_qp.c
index 28cd5cb..0ab826b 100644
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -382,14 +382,17 @@ static int c2_alloc_qpn(struct c2_dev *c2dev, struct c2_qp *qp)
 {
 	int ret;
 
-        do {
-		spin_lock_irq(&c2dev->qp_table.lock);
-		ret = idr_get_new_above(&c2dev->qp_table.idr, qp,
-					c2dev->qp_table.last++, &qp->qpn);
-		spin_unlock_irq(&c2dev->qp_table.lock);
-        } while ((ret == -EAGAIN) &&
-	 	 idr_pre_get(&c2dev->qp_table.idr, GFP_KERNEL));
-	return ret;
+	idr_preload(GFP_KERNEL);
+	spin_lock_irq(&c2dev->qp_table.lock);
+
+	ret = idr_alloc(&c2dev->qp_table.idr, qp, c2dev->qp_table.last++, 0,
+			GFP_NOWAIT);
+	if (ret >= 0)
+		qp->qpn = ret;
+
+	spin_unlock_irq(&c2dev->qp_table.lock);
+	idr_preload_end();
+	return ret < 0 ? ret : 0;
 }
 
 static void c2_free_qpn(struct c2_dev *c2dev, int qpn)
-- 
1.8.1

