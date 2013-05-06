Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab3EFWym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:54:42 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43797 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787Ab3EFWq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:46:29 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/33] blkcg: invoke blkcg_policy->pd_init() after parent is linked
Date: Mon,  6 May 2013 15:45:43 -0700
Message-Id: <1367880372-28312-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when creating a new blkcg_gq, each policy's pd_init_fn() is
invoked in blkg_alloc() before the parent is linked.  This makes it
difficult for policies to perform initializations which are dependent
on the parent.

This patch moves pd_init_fn() invocations to blkg_create() after the
parent blkg is linked where the new blkg is fully initialized.  As
this means that blkg_free() can't assume that pd's are initialized,
pd_exit_fn() invocations are moved to __blkg_release().  This
guarantees that pd_exit_fn() is also invoked with fully initialized
blkgs with valid parent pointers.

This will help implementing hierarchy support in blk-throttle.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 6b10d5c..f13cf95 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -51,18 +51,8 @@ static void blkg_free(struct blkcg_gq *blkg)
 	if (!blkg)
 		return;
 
-	for (i = 0; i < BLKCG_MAX_POLS; i++) {
-		struct blkcg_policy *pol = blkcg_policy[i];
-		struct blkg_policy_data *pd = blkg->pd[i];
-
-		if (!pd)
-			continue;
-
-		if (pol && pol->pd_exit_fn)
-			pol->pd_exit_fn(blkg);
-
-		kfree(pd);
-	}
+	for (i = 0; i < BLKCG_MAX_POLS; i++)
+		kfree(blkg->pd[i]);
 
 	blk_exit_rl(&blkg->rl);
 	kfree(blkg);
@@ -114,10 +104,6 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
 		pd->plid = i;
-
-		/* invoke per-policy init */
-		if (pol->pd_init_fn)
-			pol->pd_init_fn(blkg);
 	}
 
 	return blkg;
@@ -214,7 +200,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	}
 	blkg = new_blkg;
 
-	/* link parent and insert */
+	/* link parent */
 	if (blkcg_parent(blkcg)) {
 		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
 		if (WARN_ON_ONCE(!blkg->parent)) {
@@ -224,6 +210,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 		blkg_get(blkg->parent);
 	}
 
+	/* invoke per-policy init */
+	for (i = 0; i < BLKCG_MAX_POLS; i++) {
+		struct blkcg_policy *pol = blkcg_policy[i];
+
+		if (blkg->pd[i] && pol->pd_init_fn)
+			pol->pd_init_fn(blkg);
+	}
+
+	/* insert */
 	spin_lock(&blkcg->lock);
 	ret = radix_tree_insert(&blkcg->blkg_tree, q->id, blkg);
 	if (likely(!ret)) {
@@ -381,6 +376,16 @@ static void blkg_rcu_free(struct rcu_head *rcu_head)
 
 void __blkg_release(struct blkcg_gq *blkg)
 {
+	int i;
+
+	/* tell policies that this one is being freed */
+	for (i = 0; i < BLKCG_MAX_POLS; i++) {
+		struct blkcg_policy *pol = blkcg_policy[i];
+
+		if (blkg->pd[i] && pol->pd_exit_fn)
+			pol->pd_exit_fn(blkg);
+	}
+
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
 	if (blkg->parent)
-- 
1.8.1.4

