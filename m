Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaI3Vhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaI3Vh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>, Jens Axboe <axboe@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 065/103] cfq-iosched: Fix wrong children_weight calculation
Date: Tue, 30 Sep 2014 14:31:10 -0700
Message-Id: <1412112708-27356-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

commit e15693ef18e13e3e6bffe891fe140f18b8ff6d07 upstream.

cfq_group_service_tree_add() is applying new_weight at the beginning of
the function via cfq_update_group_weight().
This actually allows weight to change between adding it to and subtracting
it from children_weight, and triggers WARN_ON_ONCE() in
cfq_group_service_tree_del(), or even causes oops by divide error during
vfr calculation in cfq_group_service_tree_add().

The detailed scenario is as follows:
1. Create blkio cgroups X and Y as a child of X.
   Set X's weight to 500 and perform some I/O to apply new_weight.
   This X's I/O completes before starting Y's I/O.
2. Y starts I/O and cfq_group_service_tree_add() is called with Y.
3. cfq_group_service_tree_add() walks up the tree during children_weight
   calculation and adds parent X's weight (500) to children_weight of root.
   children_weight becomes 500.
4. Set X's weight to 1000.
5. X starts I/O and cfq_group_service_tree_add() is called with X.
6. cfq_group_service_tree_add() applies its new_weight (1000).
7. I/O of Y completes and cfq_group_service_tree_del() is called with Y.
8. I/O of X completes and cfq_group_service_tree_del() is called with X.
9. cfq_group_service_tree_del() subtracts X's weight (1000) from
   children_weight of root. children_weight becomes -500.
   This triggers WARN_ON_ONCE().
10. Set X's weight to 500.
11. X starts I/O and cfq_group_service_tree_add() is called with X.
12. cfq_group_service_tree_add() applies its new_weight (500) and adds it
    to children_weight of root. children_weight becomes 0. Calcularion of
    vfr triggers oops by divide error.

weight should be updated right before adding it to children_weight.

Reported-by: Ruki Sekiya <sekiya.ruki@lab.ntt.co.jp>
Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/cfq-iosched.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4d5cec1..8f5fdf3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1275,12 +1275,16 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 static void
 cfq_update_group_weight(struct cfq_group *cfqg)
 {
-	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
-
 	if (cfqg->new_weight) {
 		cfqg->weight = cfqg->new_weight;
 		cfqg->new_weight = 0;
 	}
+}
+
+static void
+cfq_update_group_leaf_weight(struct cfq_group *cfqg)
+{
+	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
 
 	if (cfqg->new_leaf_weight) {
 		cfqg->leaf_weight = cfqg->new_leaf_weight;
@@ -1299,7 +1303,7 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	/* add to the service tree */
 	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
 
-	cfq_update_group_weight(cfqg);
+	cfq_update_group_leaf_weight(cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/*
@@ -1323,6 +1327,7 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	 */
 	while ((parent = cfqg_parent(pos))) {
 		if (propagate) {
+			cfq_update_group_weight(pos);
 			propagate = !parent->nr_active++;
 			parent->children_weight += pos->weight;
 		}
-- 
1.9.1

