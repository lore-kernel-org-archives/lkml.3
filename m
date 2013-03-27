Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab3C0NTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:19:23 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53506 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3C0NSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:18:21 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org
Subject: [PATCH v1 3/6] mlx4: convert to using idr_alloc_cyclic
Date: Wed, 27 Mar 2013 09:18:05 -0400
Message-Id: <1364390288-30968-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Note: compile tested only)

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/mlx4/cm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index add98d0..524e168 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -204,7 +204,6 @@ static struct id_map_entry *
 id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 {
 	int ret;
-	static int next_id;
 	struct id_map_entry *ent;
 	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
 
@@ -223,9 +222,8 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 	idr_preload(GFP_KERNEL);
 	spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
 
-	ret = idr_alloc(&sriov->pv_id_table, ent, next_id, 0, GFP_NOWAIT);
+	ret = idr_alloc_cyclic(&sriov->pv_id_table, ent, 0, 0, GFP_NOWAIT);
 	if (ret >= 0) {
-		next_id = max(ret + 1, 0);
 		ent->pv_cm_id = (u32)ret;
 		sl_id_map_add(ibdev, ent);
 		list_add_tail(&ent->list, &sriov->cm_list);
@@ -361,7 +359,7 @@ void mlx4_ib_cm_paravirt_init(struct mlx4_ib_dev *dev)
 	spin_lock_init(&dev->sriov.id_map_lock);
 	INIT_LIST_HEAD(&dev->sriov.cm_list);
 	dev->sriov.sl_id_map = RB_ROOT;
-	idr_init(&dev->sriov.pv_id_table);
+	idr_init_cyclic(&dev->sriov.pv_id_table, 0);
 }
 
 /* slave = -1 ==> all slaves */
-- 
1.7.11.7

