Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaEEMts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:49:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41011 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Derek Basehore <dbasehore@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 18/50] bdi: avoid oops on device removal
Date: Mon,  5 May 2014 14:43:00 +0200
Message-Id: <fa48decc1df0ec789d7bb2ea737f823f649a3cc3.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5acda9d12dcf1ad0d9a5a2a7c646de3472fa7555 upstream.

After commit 839a8e8660b6 ("writeback: replace custom worker pool
implementation with unbound workqueue") when device is removed while we
are writing to it we crash in bdi_writeback_workfn() ->
set_worker_desc() because bdi->dev is NULL.

This can happen because even though bdi_unregister() cancels all pending
flushing work, nothing really prevents new ones from being queued from
balance_dirty_pages() or other places.

Fix the problem by clearing BDI_registered bit in bdi_unregister() and
checking it before scheduling of any flushing work.

Fixes: 839a8e8660b6777e7fe4e80af1a048aebe2b5977

Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Derek Basehore <dbasehore@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/fs-writeback.c           | 23 ++++++++++++++++++-----
 include/linux/backing-dev.h |  2 +-
 mm/backing-dev.c            | 13 +++++++++----
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6abd284754e2..5bbec31440a4 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -88,16 +88,29 @@ static inline struct inode *wb_inode(struct list_head *head)
 #define CREATE_TRACE_POINTS
 #include <trace/events/writeback.h>
 
+static void bdi_wakeup_thread(struct backing_dev_info *bdi)
+{
+	spin_lock_bh(&bdi->wb_lock);
+	if (test_bit(BDI_registered, &bdi->state))
+		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+	spin_unlock_bh(&bdi->wb_lock);
+}
+
 static void bdi_queue_work(struct backing_dev_info *bdi,
 			   struct wb_writeback_work *work)
 {
 	trace_writeback_queue(bdi, work);
 
 	spin_lock_bh(&bdi->wb_lock);
+	if (!test_bit(BDI_registered, &bdi->state)) {
+		if (work->done)
+			complete(work->done);
+		goto out_unlock;
+	}
 	list_add_tail(&work->list, &bdi->work_list);
-	spin_unlock_bh(&bdi->wb_lock);
-
 	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+out_unlock:
+	spin_unlock_bh(&bdi->wb_lock);
 }
 
 static void
@@ -113,7 +126,7 @@ __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work) {
 		trace_writeback_nowork(bdi);
-		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+		bdi_wakeup_thread(bdi);
 		return;
 	}
 
@@ -160,7 +173,7 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
 	 * writeback as soon as there is no other work to do.
 	 */
 	trace_writeback_wake_background(bdi);
-	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+	bdi_wakeup_thread(bdi);
 }
 
 /*
@@ -1016,7 +1029,7 @@ void bdi_writeback_workfn(struct work_struct *work)
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
-		   list_empty(&bdi->bdi_list))) {
+		   !test_bit(BDI_registered, &bdi->state))) {
 		/*
 		 * The normal path.  Keep writing back @bdi until its
 		 * work_list is empty.  Note that this path is also taken
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 5f66d519a726..a4cf599ecfc8 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -95,7 +95,7 @@ struct backing_dev_info {
 	unsigned int max_ratio, max_prop_frac;
 
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
-	spinlock_t wb_lock;	  /* protects work_list */
+	spinlock_t wb_lock;	  /* protects work_list & wb.dwork scheduling */
 
 	struct list_head work_list;
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index fab8401fc54e..09d9591b7708 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -297,7 +297,10 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	spin_lock_bh(&bdi->wb_lock);
+	if (test_bit(BDI_registered, &bdi->state))
+		queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	spin_unlock_bh(&bdi->wb_lock);
 }
 
 /*
@@ -310,9 +313,6 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
 	spin_unlock_bh(&bdi_lock);
 
 	synchronize_rcu_expedited();
-
-	/* bdi_list is now unused, clear it to mark @bdi dying */
-	INIT_LIST_HEAD(&bdi->bdi_list);
 }
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
@@ -363,6 +363,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 */
 	bdi_remove_from_list(bdi);
 
+	/* Make sure nobody queues further work */
+	spin_lock_bh(&bdi->wb_lock);
+	clear_bit(BDI_registered, &bdi->state);
+	spin_unlock_bh(&bdi->wb_lock);
+
 	/*
 	 * Drain work list and shutdown the delayed_work.  At this point,
 	 * @bdi->bdi_list is empty telling bdi_Writeback_workfn() that @bdi
-- 
1.9.2

