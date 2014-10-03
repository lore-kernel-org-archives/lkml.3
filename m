Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaJCVmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:42:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbaJCVc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ruki Sekiya <sekiya.ruki@lab.ntt.co.jp>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.16 064/357] cfq-iosched: Fix wrong children_weight calculation
Date: Fri,  3 Oct 2014 14:27:30 -0700
Message-Id: <20141003212935.376790755@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/cfq-iosched.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1275,12 +1275,16 @@ __cfq_group_service_tree_add(struct cfq_
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
@@ -1299,7 +1303,7 @@ cfq_group_service_tree_add(struct cfq_rb
 	/* add to the service tree */
 	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
 
-	cfq_update_group_weight(cfqg);
+	cfq_update_group_leaf_weight(cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/*
@@ -1323,6 +1327,7 @@ cfq_group_service_tree_add(struct cfq_rb
 	 */
 	while ((parent = cfqg_parent(pos))) {
 		if (propagate) {
+			cfq_update_group_weight(pos);
 			propagate = !parent->nr_active++;
 			parent->children_weight += pos->weight;
 		}


