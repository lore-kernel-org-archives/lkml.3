Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab3EFWqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:46:34 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:48120 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab3EFWqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:46:31 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/33] blkcg: move bulk of blkcg_gq release operations to the RCU callback
Date: Mon,  6 May 2013 15:45:44 -0700
Message-Id: <1367880372-28312-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when the last reference of a blkcg_gq is put, all then
release operations sans the actual freeing happen directly in
blkg_put().  As blkg_put() may be called under queue_lock, all
pd_exit_fn()s may be too.  This makes it impossible for pd_exit_fn()s
to use del_timer_sync() on timers which grab the queue_lock which is
an irq-safe lock due to the deadlock possibility described in the
comment on top of del_timer_sync().

This can be easily avoided by perfoming the release operations in the
RCU callback instead of directly from blkg_put().  This patch moves
the blkcg_gq release operations to the RCU callback.

As this leaves __blkg_release() with only call_rcu() invocation,
blkg_rcu_free() is renamed to __blkg_release_rcu(), exported and
call_rcu() invocation is now done directly from blkg_put() instead of
going through __blkg_release() which is removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 34 ++++++++++++++++------------------
 block/blk-cgroup.h |  4 ++--
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f13cf95..af2ca27 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -369,13 +369,17 @@ static void blkg_destroy_all(struct request_queue *q)
 	q->root_rl.blkg = NULL;
 }
 
-static void blkg_rcu_free(struct rcu_head *rcu_head)
-{
-	blkg_free(container_of(rcu_head, struct blkcg_gq, rcu_head));
-}
-
-void __blkg_release(struct blkcg_gq *blkg)
+/*
+ * A group is RCU protected, but having an rcu lock does not mean that one
+ * can access all the fields of blkg and assume these are valid.  For
+ * example, don't try to follow throtl_data and request queue links.
+ *
+ * Having a reference to blkg under an rcu allows accesses to only values
+ * local to groups like group stats and group rate limits.
+ */
+void __blkg_release_rcu(struct rcu_head *rcu_head)
 {
+	struct blkcg_gq *blkg = container_of(rcu_head, struct blkcg_gq, rcu_head);
 	int i;
 
 	/* tell policies that this one is being freed */
@@ -388,21 +392,15 @@ void __blkg_release(struct blkcg_gq *blkg)
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
-	if (blkg->parent)
+	if (blkg->parent) {
+		spin_lock_irq(blkg->q->queue_lock);
 		blkg_put(blkg->parent);
+		spin_unlock_irq(blkg->q->queue_lock);
+	}
 
-	/*
-	 * A group is freed in rcu manner. But having an rcu lock does not
-	 * mean that one can access all the fields of blkg and assume these
-	 * are valid. For example, don't try to follow throtl_data and
-	 * request queue links.
-	 *
-	 * Having a reference to blkg under an rcu allows acess to only
-	 * values local to groups like group stats and group rate limits
-	 */
-	call_rcu(&blkg->rcu_head, blkg_rcu_free);
+	blkg_free(blkg);
 }
-EXPORT_SYMBOL_GPL(__blkg_release);
+EXPORT_SYMBOL_GPL(__blkg_release_rcu);
 
 /*
  * The next function used by blk_queue_for_each_rl().  It's a bit tricky
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index e15f731..8056c03 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -266,7 +266,7 @@ static inline void blkg_get(struct blkcg_gq *blkg)
 	blkg->refcnt++;
 }
 
-void __blkg_release(struct blkcg_gq *blkg);
+void __blkg_release_rcu(struct rcu_head *rcu);
 
 /**
  * blkg_put - put a blkg reference
@@ -279,7 +279,7 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 	lockdep_assert_held(blkg->q->queue_lock);
 	WARN_ON_ONCE(blkg->refcnt <= 0);
 	if (!--blkg->refcnt)
-		__blkg_release(blkg);
+		call_rcu(&blkg->rcu_head, __blkg_release_rcu);
 }
 
 struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg, struct request_queue *q,
-- 
1.8.1.4

