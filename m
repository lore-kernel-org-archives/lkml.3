Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab3BFUAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:00:31 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:51307 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab3BFTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:37 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 44/77] IB/mlx4: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:16 -0800
Message-Id: <1360179649-22465-45-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/mlx4/cm.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index dbc99d4..80e59ed 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -203,7 +203,7 @@ static void sl_id_map_add(struct ib_device *ibdev, struct id_map_entry *new)
 static struct id_map_entry *
 id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 {
-	int ret, id;
+	int ret;
 	static int next_id;
 	struct id_map_entry *ent;
 	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
@@ -220,25 +220,23 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 	ent->dev = to_mdev(ibdev);
 	INIT_DELAYED_WORK(&ent->timeout, id_map_ent_timeout);
 
-	do {
-		spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
-		ret = idr_get_new_above(&sriov->pv_id_table, ent,
-					next_id, &id);
-		if (!ret) {
-			next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
-			ent->pv_cm_id = (u32)id;
-			sl_id_map_add(ibdev, ent);
-		}
+	idr_preload(GFP_KERNEL);
+	spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
 
-		spin_unlock(&sriov->id_map_lock);
-	} while (ret == -EAGAIN && idr_pre_get(&sriov->pv_id_table, GFP_KERNEL));
-	/*the function idr_get_new_above can return -ENOSPC, so don't insert in that case.*/
-	if (!ret) {
-		spin_lock(&sriov->id_map_lock);
+	ret = idr_alloc(&sriov->pv_id_table, ent, next_id, 0, GFP_NOWAIT);
+	if (ret >= 0) {
+		next_id = ((unsigned)ret + 1) & MAX_IDR_MASK;
+		ent->pv_cm_id = (u32)ret;
+		sl_id_map_add(ibdev, ent);
 		list_add_tail(&ent->list, &sriov->cm_list);
-		spin_unlock(&sriov->id_map_lock);
-		return ent;
 	}
+
+	spin_unlock(&sriov->id_map_lock);
+	idr_preload_end();
+
+	if (ret >= 0)
+		return ent;
+
 	/*error flow*/
 	kfree(ent);
 	mlx4_ib_warn(ibdev, "No more space in the idr (err:0x%x)\n", ret);
-- 
1.8.1

