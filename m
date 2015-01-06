Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbbAFVjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:39:42 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:45160 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbbAFV0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:26:46 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/45] writeback: make congestion functions per bdi_writeback
Date: Tue,  6 Jan 2015 16:25:46 -0500
Message-Id: <1420579582-8516-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all congestion functions take bdi (backing_dev_info) and
always operate on the root wb (bdi->wb) and the congestion state from
the block layer is propagated only for the root blkcg.  This patch
introduces {set|clear}_wb_congested() and wb_congested() which take
@wb and operate on it.  The bdi counteparts are now wrappers invoking
the wb based functions on @bdi->wb.

While converting clear_bdi_congested() to clear_wb_congested(), the
local variable declaration order between @wqh and @bit is swapped for
cosmetic reason.

This patch just adds the new wb based functions.  The following
patches will apply them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 include/linux/backing-dev-defs.h | 14 +++++++++++--
 include/linux/backing-dev.h      | 43 +++++++++++++++++++++++-----------------
 mm/backing-dev.c                 | 22 ++++++++++----------
 3 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 511066f..54a3a9c 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -122,7 +122,17 @@ enum {
 	BLK_RW_SYNC	= 1,
 };
 
-void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
-void set_bdi_congested(struct backing_dev_info *bdi, int sync);
+void clear_wb_congested(struct bdi_writeback *wb, int sync);
+void set_wb_congested(struct bdi_writeback *wb, int sync);
+
+static inline void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
+{
+	clear_wb_congested(&bdi->wb, sync);
+}
+
+static inline void set_bdi_congested(struct backing_dev_info *bdi, int sync)
+{
+	set_wb_congested(&bdi->wb, sync);
+}
 
 #endif	/* __LINUX_BACKING_DEV_DEFS_H */
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3722796..be66668 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -182,27 +182,13 @@ extern struct backing_dev_info noop_backing_dev_info;
 
 int writeback_in_progress(struct backing_dev_info *bdi);
 
-static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
+static inline int wb_congested(struct bdi_writeback *wb, int bdi_bits)
 {
+	struct backing_dev_info *bdi = wb->bdi;
+
 	if (bdi->congested_fn)
 		return bdi->congested_fn(bdi->congested_data, bdi_bits);
-	return (bdi->wb.state & bdi_bits);
-}
-
-static inline int bdi_read_congested(struct backing_dev_info *bdi)
-{
-	return bdi_congested(bdi, 1 << WB_sync_congested);
-}
-
-static inline int bdi_write_congested(struct backing_dev_info *bdi)
-{
-	return bdi_congested(bdi, 1 << WB_async_congested);
-}
-
-static inline int bdi_rw_congested(struct backing_dev_info *bdi)
-{
-	return bdi_congested(bdi, (1 << WB_sync_congested) |
-				  (1 << WB_async_congested));
+	return wb->state & bdi_bits;
 }
 
 long congestion_wait(int sync, long timeout);
@@ -422,4 +408,25 @@ static inline struct bdi_writeback *page_cgwb_wb(struct page *page)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
+static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
+{
+	return wb_congested(&bdi->wb, bdi_bits);
+}
+
+static inline int bdi_read_congested(struct backing_dev_info *bdi)
+{
+	return bdi_congested(bdi, 1 << WB_sync_congested);
+}
+
+static inline int bdi_write_congested(struct backing_dev_info *bdi)
+{
+	return bdi_congested(bdi, 1 << WB_async_congested);
+}
+
+static inline int bdi_rw_congested(struct backing_dev_info *bdi)
+{
+	return bdi_congested(bdi, (1 << WB_sync_congested) |
+				  (1 << WB_async_congested));
+}
+
 #endif		/* _LINUX_BACKING_DEV_H */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index c6dda82..2851278 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -767,31 +767,31 @@ static wait_queue_head_t congestion_wqh[2] = {
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
 	};
-static atomic_t nr_bdi_congested[2];
+static atomic_t nr_wb_congested[2];
 
-void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
+void clear_wb_congested(struct bdi_writeback *wb, int sync)
 {
-	enum wb_state bit;
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
+	enum wb_state bit;
 
 	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (test_and_clear_bit(bit, &bdi->wb.state))
-		atomic_dec(&nr_bdi_congested[sync]);
+	if (test_and_clear_bit(bit, &wb->state))
+		atomic_dec(&nr_wb_congested[sync]);
 	smp_mb__after_atomic();
 	if (waitqueue_active(wqh))
 		wake_up(wqh);
 }
-EXPORT_SYMBOL(clear_bdi_congested);
+EXPORT_SYMBOL(clear_wb_congested);
 
-void set_bdi_congested(struct backing_dev_info *bdi, int sync)
+void set_wb_congested(struct bdi_writeback *wb, int sync)
 {
 	enum wb_state bit;
 
 	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (!test_and_set_bit(bit, &bdi->wb.state))
-		atomic_inc(&nr_bdi_congested[sync]);
+	if (!test_and_set_bit(bit, &wb->state))
+		atomic_inc(&nr_wb_congested[sync]);
 }
-EXPORT_SYMBOL(set_bdi_congested);
+EXPORT_SYMBOL(set_wb_congested);
 
 /**
  * congestion_wait - wait for a backing_dev to become uncongested
@@ -850,7 +850,7 @@ long wait_iff_congested(struct zone *zone, int sync, long timeout)
 	 * encountered in the current zone, yield if necessary instead
 	 * of sleeping on the congestion queue
 	 */
-	if (atomic_read(&nr_bdi_congested[sync]) == 0 ||
+	if (atomic_read(&nr_wb_congested[sync]) == 0 ||
 	    !test_bit(ZONE_CONGESTED, &zone->flags)) {
 		cond_resched();
 
-- 
2.1.0

