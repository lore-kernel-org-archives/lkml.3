Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbbAFV1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:27:20 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:43328 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbbAFV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:27:16 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/45] writeback: implement bdi_wait_for_completion()
Date: Tue,  6 Jan 2015 16:26:02 -0500
Message-Id: <1420579582-8516-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the completion of a wb_writeback_work can be waited upon by setting
its ->done to a struct completion and waiting on it; however, for
cgroup writeback support, it's necessary to issue multiple work items
to multiple bdi_writebacks and wait for the completion of all.

This patch implements wb_completion which can wait for multiple work
items and replaces the struct completion with it.  It can be defined
using DEFINE_WB_COMPLETION_ONSTACK(), used for multiple work items and
waited for by wb_wait_for_completion().

Nobody currently issues multiple work items and this patch doesn't
introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c                | 57 +++++++++++++++++++++++++++++++---------
 include/linux/backing-dev-defs.h |  2 ++
 mm/backing-dev.c                 |  1 +
 3 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3c012b8..6527692 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -34,6 +34,10 @@
  */
 #define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_CACHE_SHIFT - 10))
 
+struct wb_completion {
+	atomic_t		cnt;
+};
+
 /*
  * Passed into wb_writeback(), essentially a subset of writeback_control
  */
@@ -51,9 +55,21 @@ struct wb_writeback_work {
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
-	struct completion *done;	/* set if the caller waits */
+	struct wb_completion *done;	/* set if the caller waits */
 };
 
+/*
+ * If one wants to wait for one or more wb_writeback_works, each work's
+ * ->done should be set to a wb_completion defined using the following
+ * macro.  Once all work items are issued with wb_queue_work(), the caller
+ * can wait for the completion of all using wb_wait_for_completion().  Work
+ * items which are waited upon aren't freed automatically on completion.
+ */
+#define DEFINE_WB_COMPLETION_ONSTACK(cmpl)				\
+	struct wb_completion cmpl = {					\
+		.cnt		= ATOMIC_INIT(1),			\
+	}
+
 static inline struct inode *wb_inode(struct list_head *head)
 {
 	return list_entry(head, struct inode, i_wb_list);
@@ -83,17 +99,34 @@ static void wb_queue_work(struct bdi_writeback *wb,
 	trace_writeback_queue(wb->bdi, work);
 
 	spin_lock_bh(&wb->work_lock);
-	if (!test_bit(WB_registered, &wb->state)) {
-		if (work->done)
-			complete(work->done);
+	if (!test_bit(WB_registered, &wb->state))
 		goto out_unlock;
-	}
+	if (work->done)
+		atomic_inc(&work->done->cnt);
 	list_add_tail(&work->list, &wb->work_list);
 	mod_delayed_work(bdi_wq, &wb->dwork, 0);
 out_unlock:
 	spin_unlock_bh(&wb->work_lock);
 }
 
+/**
+ * wb_wait_for_completion - wait for completion of bdi_writeback_works
+ * @bdi: bdi work items were issued to
+ * @done: target wb_completion
+ *
+ * Wait for one or more work items issued to @bdi with their ->done field
+ * set to @done, which should have been defined with
+ * DEFINE_WB_COMPLETION_ONSTACK().  This function returns after all such
+ * work items are completed.  Work items which are waited upon aren't freed
+ * automatically on completion.
+ */
+static void wb_wait_for_completion(struct backing_dev_info *bdi,
+				   struct wb_completion *done)
+{
+	atomic_dec(&done->cnt);		/* put down the initial count */
+	wait_event(bdi->wb_waitq, !atomic_read(&done->cnt));
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 /**
@@ -1175,7 +1208,7 @@ static long wb_do_writeback(struct bdi_writeback *wb)
 
 	set_bit(WB_writeback_running, &wb->state);
 	while ((work = get_next_work_item(wb)) != NULL) {
-		struct completion *done = work->done;
+		struct wb_completion *done = work->done;
 
 		trace_writeback_exec(wb->bdi, work);
 
@@ -1183,8 +1216,8 @@ static long wb_do_writeback(struct bdi_writeback *wb)
 
 		if (work->auto_free)
 			kfree(work);
-		if (done)
-			complete(done);
+		if (done && atomic_dec_and_test(&done->cnt))
+			wake_up_all(&wb->bdi->wb_waitq);
 	}
 
 	/*
@@ -1482,7 +1515,7 @@ void writeback_inodes_sb_nr(struct super_block *sb,
 			    unsigned long nr,
 			    enum wb_reason reason)
 {
-	DECLARE_COMPLETION_ONSTACK(done);
+	DEFINE_WB_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
 		.sb			= sb,
 		.sync_mode		= WB_SYNC_NONE,
@@ -1497,7 +1530,7 @@ void writeback_inodes_sb_nr(struct super_block *sb,
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 	wb_queue_work(&bdi->wb, &work);
-	wait_for_completion(&done);
+	wb_wait_for_completion(bdi, &done);
 }
 EXPORT_SYMBOL(writeback_inodes_sb_nr);
 
@@ -1564,7 +1597,7 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb);
  */
 void sync_inodes_sb(struct super_block *sb)
 {
-	DECLARE_COMPLETION_ONSTACK(done);
+	DEFINE_WB_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
@@ -1582,7 +1615,7 @@ void sync_inodes_sb(struct super_block *sb)
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	wb_queue_work(&bdi->wb, &work);
-	wait_for_completion(&done);
+	wb_wait_for_completion(bdi, &done);
 
 	wait_sb_inodes(sb);
 }
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 4ceda83..bc1b9e7 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -110,6 +110,8 @@ struct backing_dev_info {
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct radix_tree_root cgwb_tree; /* radix tree of !root cgroup wbs */
 #endif
+	wait_queue_head_t wb_waitq;
+
 	struct device *dev;
 
 	struct timer_list laptop_mode_wb_timer;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b4a5d9b..171fffd 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -631,6 +631,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 	INIT_LIST_HEAD(&bdi->bdi_list);
+	init_waitqueue_head(&bdi->wb_waitq);
 
 	err = wb_init(&bdi->wb, bdi, GFP_KERNEL);
 	if (err)
-- 
2.1.0

