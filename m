Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3BCBcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:32:01 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39383 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3BCBWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:06 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 24/62] infiniband/cxgb3: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:25 -0800
Message-Id: <1359854463-2538-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steve Wise <swise@chelsio.com>
Cc: linux-rdma@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/infiniband/hw/cxgb3/iwch.h | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch.h b/drivers/infiniband/hw/cxgb3/iwch.h
index a1c4457..8378622 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.h
+++ b/drivers/infiniband/hw/cxgb3/iwch.h
@@ -153,19 +153,17 @@ static inline int insert_handle(struct iwch_dev *rhp, struct idr *idr,
 				void *handle, u32 id)
 {
 	int ret;
-	int newid;
-
-	do {
-		if (!idr_pre_get(idr, GFP_KERNEL)) {
-			return -ENOMEM;
-		}
-		spin_lock_irq(&rhp->lock);
-		ret = idr_get_new_above(idr, handle, id, &newid);
-		BUG_ON(newid != id);
-		spin_unlock_irq(&rhp->lock);
-	} while (ret == -EAGAIN);
-
-	return ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock_irq(&rhp->lock);
+
+	ret = idr_alloc(idr, handle, id, id + 1, GFP_NOWAIT);
+
+	spin_unlock_irq(&rhp->lock);
+	idr_preload_end();
+
+	BUG_ON(ret == -ENOSPC);
+	return ret < 0 ? ret : 0;
 }
 
 static inline void remove_handle(struct iwch_dev *rhp, struct idr *idr, u32 id)
-- 
1.8.1

