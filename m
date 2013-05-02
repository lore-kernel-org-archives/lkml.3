Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab3EBAk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:40:58 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62334 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878Ab3EBAkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:40:45 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/31] blk-throttle: relocate throtl_schedule_delayed_work()
Date: Wed,  1 May 2013 17:39:27 -0700
Message-Id: <1367455189-6957-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move throtl_schedule_delayed_work() above its first user so that the
forward declaration can be removed.

This patch is pure relocaiton.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index d50d8d1..00e72f4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -25,8 +25,6 @@ static struct blkcg_policy blkcg_policy_throtl;
 
 /* A workqueue to queue throttle related work */
 static struct workqueue_struct *kthrotld_workqueue;
-static void throtl_schedule_delayed_work(struct throtl_data *td,
-				unsigned long delay);
 
 struct throtl_rb_root {
 	struct rb_root rb;
@@ -398,6 +396,19 @@ static void throtl_dequeue_tg(struct throtl_data *td, struct throtl_grp *tg)
 		__throtl_dequeue_tg(td, tg);
 }
 
+/* Call with queue lock held */
+static void throtl_schedule_delayed_work(struct throtl_data *td,
+					 unsigned long delay)
+{
+	struct delayed_work *dwork = &td->dispatch_work;
+
+	if (total_nr_queued(td)) {
+		mod_delayed_work(kthrotld_workqueue, dwork, delay);
+		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
+			   delay, jiffies);
+	}
+}
+
 static void throtl_schedule_next_dispatch(struct throtl_data *td)
 {
 	struct throtl_rb_root *st = &td->tg_service_tree;
@@ -863,20 +874,6 @@ out:
 	}
 }
 
-/* Call with queue lock held */
-static void
-throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
-{
-
-	struct delayed_work *dwork = &td->dispatch_work;
-
-	if (total_nr_queued(td)) {
-		mod_delayed_work(kthrotld_workqueue, dwork, delay);
-		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
-				delay, jiffies);
-	}
-}
-
 static u64 tg_prfill_cpu_rwstat(struct seq_file *sf,
 				struct blkg_policy_data *pd, int off)
 {
-- 
1.8.1.4

