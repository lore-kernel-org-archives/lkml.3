Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbbAFV10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:27:26 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:51598 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbbAFV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:27:21 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 28/45] writeback: make writeback initiation functions handle multiple bdi_writeback's
Date: Tue,  6 Jan 2015 16:26:05 -0500
Message-Id: <1420579582-8516-29-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[try_]writeback_inodes_sb[_nr]() and sync_inodes_sb() currently only
handle dirty inodes on the root wb (bdi_writeback) of the target bdi.
This patch implements bdi_split_work_to_wbs() and use it to make these
functions handle multiple wb's.

bdi_split_work_to_wbs() takes a base wb_writeback_work and create
clones of it and issue them to the wb's of the target bdi.  The base
work's nr_pages is distributed using wb_split_bdi_pages() -
ie. according to each wb's write bandwidth's proportion in the bdi.

Cloning a bdi involves memory allocation which may fail.  In such
cases, bdi_split_work_to_wbs() issues the base work directly and waits
for its completion before proceeding to the next wb to guarantee
forward progress and correctness under memory pressure.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 91 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 008f588..4094d30 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -257,6 +257,80 @@ static long wb_split_bdi_pages(struct bdi_writeback *wb, long nr_pages)
 		return DIV_ROUND_UP_ULL((u64)nr_pages * this_bw, tot_bw);
 }
 
+/**
+ * wb_clone_and_queue_work - clone a wb_writeback_work and issue it to a wb
+ * @wb: target bdi_writeback
+ * @base_work: source wb_writeback_work
+ *
+ * Try to make a clone of @base_work and issue it to @wb.  If cloning
+ * succeeds, %true is returned; otherwise, @base_work is issued directly
+ * and %false is returned.  In the latter case, the caller is required to
+ * wait for @base_work's completion using wb_wait_for_single_work().
+ *
+ * A clone is auto-freed on completion.  @base_work never is.
+ */
+static bool wb_clone_and_queue_work(struct bdi_writeback *wb,
+				    struct wb_writeback_work *base_work)
+{
+	struct wb_writeback_work *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		*work = *base_work;
+		work->auto_free = 1;
+		work->single_wait = 0;
+	} else {
+		work = base_work;
+		work->auto_free = 0;
+		work->single_wait = 1;
+	}
+	work->single_done = 0;
+	wb_queue_work(wb, work);
+	return work != base_work;
+}
+
+/**
+ * bdi_split_work_to_wbs - split a wb_writeback_work to all wb's of a bdi
+ * @bdi: target backing_dev_info
+ * @base_work: wb_writeback_work to issue
+ * @skip_if_busy: skip wb's which already have writeback in progress
+ *
+ * Split and issue @base_work to all wb's (bdi_writeback's) of @bdi which
+ * have dirty inodes.  If @base_work->nr_page isn't %LONG_MAX, it's
+ * distributed to the busy wbs according to each wb's proportion in the
+ * total active write bandwidth of @bdi.
+ */
+static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
+				  struct wb_writeback_work *base_work,
+				  bool skip_if_busy)
+{
+	long nr_pages = base_work->nr_pages;
+	int next_blkcg_id = 0;
+	struct bdi_writeback *wb;
+	struct wb_iter iter;
+
+	might_sleep();
+
+	if (!bdi_has_dirty_io(bdi))
+		return;
+restart:
+	rcu_read_lock();
+	bdi_for_each_wb(wb, bdi, &iter, next_blkcg_id) {
+		if (!wb_has_dirty_io(wb) ||
+		    (skip_if_busy && writeback_in_progress(wb)))
+			continue;
+
+		base_work->nr_pages = wb_split_bdi_pages(wb, nr_pages);
+		if (!wb_clone_and_queue_work(wb, base_work)) {
+			next_blkcg_id = wb->blkcg_css->id + 1;
+			rcu_read_unlock();
+			wb_wait_for_single_work(bdi, base_work);
+			goto restart;
+		}
+	}
+	rcu_read_unlock();
+}
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static void init_cgwb_dirty_page_context(struct dirty_context *dctx)
@@ -269,6 +343,21 @@ static long wb_split_bdi_pages(struct bdi_writeback *wb, long nr_pages)
 	return nr_pages;
 }
 
+static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
+				  struct wb_writeback_work *base_work,
+				  bool skip_if_busy)
+{
+	might_sleep();
+
+	if (bdi_has_dirty_io(bdi) &&
+	    (!skip_if_busy || !writeback_in_progress(&bdi->wb))) {
+		base_work->auto_free = 0;
+		base_work->single_wait = 0;
+		base_work->single_done = 0;
+		wb_queue_work(&bdi->wb, base_work);
+	}
+}
+
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 /**
@@ -1562,10 +1651,7 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	if (skip_if_busy && writeback_in_progress(&bdi->wb))
-		return;
-
-	wb_queue_work(&bdi->wb, &work);
+	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
 	wb_wait_for_completion(bdi, &done);
 }
 
@@ -1663,7 +1749,7 @@ void sync_inodes_sb(struct super_block *sb)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	wb_queue_work(&bdi->wb, &work);
+	bdi_split_work_to_wbs(bdi, &work, false);
 	wb_wait_for_completion(bdi, &done);
 
 	wait_sb_inodes(sb);
-- 
2.1.0

