Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab3EFWro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:47:44 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44974 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3EFWrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:47:20 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 33/33] blk-throttle: implement proper hierarchy support
Date: Mon,  6 May 2013 15:46:12 -0700
Message-Id: <1367880372-28312-34-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent updates, blk-throttle is finally ready for proper
hierarchy support.  Dispatching now honors service_queue->parent_sq
and propagates correctly.  The only thing missing is setting
->parent_sq correctly so that throtl_grp hierarchy matches the cgroup
hierarchy.

This patch updates throtl_pd_init() such that service_queues form the
same hierarchy as the cgroup hierarchy if sane_behavior is enabled.
As this concludes proper hierarchy support for blkcg, the shameful
.broken_hierarchy tag is removed from blkio_subsys.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 block/blk-cgroup.c     |  8 --------
 block/blk-throttle.c   | 22 +++++++++++++++++++++-
 include/linux/cgroup.h |  2 ++
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index af2ca27..8d9edc8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -911,14 +911,6 @@ struct cgroup_subsys blkio_subsys = {
 	.subsys_id = blkio_subsys_id,
 	.base_cftypes = blkcg_files,
 	.module = THIS_MODULE,
-
-	/*
-	 * blkio subsystem is utterly broken in terms of hierarchy support.
-	 * It treats all cgroups equally regardless of where they're
-	 * located in the hierarchy - all cgroups are treated as if they're
-	 * right below the root.  Fix it and remove the following.
-	 */
-	.broken_hierarchy = true,
 };
 EXPORT_SYMBOL_GPL(blkio_subsys);
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 27f006b..08a32df 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -397,10 +397,30 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct throtl_data *td = blkg->q->td;
+	struct throtl_service_queue *parent_sq;
 	unsigned long flags;
 	int rw;
 
-	throtl_service_queue_init(&tg->service_queue, &td->service_queue);
+	/*
+	 * If sane_hierarchy is enabled, we switch to properly hierarchical
+	 * behavior where limits on a given throtl_grp are applied to the
+	 * whole subtree rather than just the group itself.  e.g. If 16M
+	 * read_bps limit is set on the root group, the whole system can't
+	 * exceed 16M for the device.
+	 *
+	 * If sane_hierarchy is not enabled, the broken flat hierarchy
+	 * behavior is retained where all throtl_grps are treated as if
+	 * they're all separate root groups right below throtl_data.
+	 * Limits of a group don't interact with limits of other groups
+	 * regardless of the position of the group in the hierarchy.
+	 */
+	parent_sq = &td->service_queue;
+
+	if (cgroup_sane_behavior(blkg->blkcg->css.cgroup) && blkg->parent)
+		parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
+
+	throtl_service_queue_init(&tg->service_queue, parent_sq);
+
 	for (rw = READ; rw <= WRITE; rw++) {
 		throtl_qnode_init(&tg->qnode_on_self[rw], tg);
 		throtl_qnode_init(&tg->qnode_on_parent[rw], tg);
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c371888..3c5f780 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -271,6 +271,8 @@ enum {
 	 * - memcg: use_hierarchy is on by default and the cgroup file for
 	 *   the flag is not created.
 	 *
+	 * - blkcg: blk-throttle becomes properly hierarchical.
+	 *
 	 * The followings are planned changes.
 	 *
 	 * - release_agent will be disallowed once replacement notification
-- 
1.8.1.4

