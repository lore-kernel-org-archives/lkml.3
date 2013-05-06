Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab3EFWqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:46:52 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36998 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3EFWqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:46:50 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/33] blk-throttle: add throtl_grp->service_queue
Date: Mon,  6 May 2013 15:45:55 -0700
Message-Id: <1367880372-28312-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's single service_queue per queue -
throtl_data->service_queue.  All active throtl_grp's are queued on the
queue and dispatched according to their limits.  To support hierarchy,
this will be expanded such that active throtl_grp's form a tree
anchored at throtl_data->service_queue and chained through each
intermediate throtl_grp's service_queue.

This patch adds throtl_grp->service_queue to prepare for hierarchy
support.  The initialization function - throtl_service_queue_init() -
is added and replaces the macro initializer.  The newly added
tg->service_queue isn't used yet.  Following patches will do.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ebaaaa9..7340440 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -33,9 +33,6 @@ struct throtl_service_queue {
 	unsigned long		first_pending_disptime;	/* disptime of the first tg */
 };
 
-#define THROTL_SERVICE_QUEUE_INITIALIZER				\
-	(struct throtl_service_queue){ .pending_tree = RB_ROOT }
-
 enum tg_state_flags {
 	THROTL_TG_PENDING	= 1 << 0,	/* on parent's pending tree */
 };
@@ -60,6 +57,9 @@ struct throtl_grp {
 	/* throtl_data this group belongs to */
 	struct throtl_data *td;
 
+	/* this group's service queue */
+	struct throtl_service_queue service_queue;
+
 	/*
 	 * Dispatch time in jiffies. This is the estimated time when group
 	 * will unthrottle and is ready to dispatch more bio. It is used as
@@ -190,11 +190,18 @@ alloc_stats:
 		goto alloc_stats;
 }
 
+/* init a service_queue, assumes the caller zeroed it */
+static void throtl_service_queue_init(struct throtl_service_queue *sq)
+{
+	sq->pending_tree = RB_ROOT;
+}
+
 static void throtl_pd_init(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	unsigned long flags;
 
+	throtl_service_queue_init(&tg->service_queue);
 	RB_CLEAR_NODE(&tg->rb_node);
 	tg->td = blkg->q->td;
 	bio_list_init(&tg->bio_lists[0]);
@@ -1168,8 +1175,8 @@ int blk_throtl_init(struct request_queue *q)
 	if (!td)
 		return -ENOMEM;
 
-	td->service_queue = THROTL_SERVICE_QUEUE_INITIALIZER;
 	INIT_DELAYED_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
+	throtl_service_queue_init(&td->service_queue);
 
 	q->td = td;
 	td->queue = q;
-- 
1.8.1.4

