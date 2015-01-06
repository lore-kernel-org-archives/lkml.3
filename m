Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbbAFT3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:29:49 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50042 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbbAFT3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:29:42 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, Tejun Heo <tj@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 11/16] writeback: move lingering dirty IO lists transfer from bdi_destroy() to wb_exit()
Date: Tue,  6 Jan 2015 14:29:12 -0500
Message-Id: <1420572557-11572-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a bdi still has dirty IOs on destruction, bdi_destroy() transfers
them to the default bdi; however, dirty IO lists belong to wb
(bdi_writeback) not bdi (backing_dev_info) and after the recent
changes we now have wb_exit() which handles destruction of a wb.  Move
the transfer logic to wb_exit().

This patch is pure reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/backing-dev.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 4a41567..dbd321e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -491,6 +491,30 @@ static void wb_exit(struct bdi_writeback *wb)
 
 	WARN_ON(delayed_work_pending(&wb->dwork));
 
+	/*
+	 * Splice our entries to the default_backing_dev_info.  This
+	 * condition shouldn't happen.  @wb must be empty at this point and
+	 * dirty inodes on it might cause other issues.  This workaround is
+	 * added by ce5f8e779519 ("writeback: splice dirty inode entries to
+	 * default bdi on bdi_destroy()") without root-causing the issue.
+	 *
+	 * http://lkml.kernel.org/g/1253038617-30204-11-git-send-email-jens.axboe@oracle.com
+	 * http://thread.gmane.org/gmane.linux.file-systems/35341/focus=35350
+	 *
+	 * We should probably add WARN_ON() to find out whether it still
+	 * happens and track it down if so.
+	 */
+	if (wb_has_dirty_io(wb)) {
+		struct bdi_writeback *dst = &default_backing_dev_info.wb;
+
+		bdi_lock_two(wb, dst);
+		list_splice(&wb->b_dirty, &dst->b_dirty);
+		list_splice(&wb->b_io, &dst->b_io);
+		list_splice(&wb->b_more_io, &dst->b_more_io);
+		spin_unlock(&wb->list_lock);
+		spin_unlock(&dst->list_lock);
+	}
+
 	for (i = 0; i < NR_WB_STAT_ITEMS; i++)
 		percpu_counter_destroy(&wb->stat[i]);
 
@@ -518,30 +542,6 @@ EXPORT_SYMBOL(bdi_init);
 
 void bdi_destroy(struct backing_dev_info *bdi)
 {
-	/*
-	 * Splice our entries to the default_backing_dev_info.  This
-	 * condition shouldn't happen.  @wb must be empty at this point and
-	 * dirty inodes on it might cause other issues.  This workaround is
-	 * added by ce5f8e779519 ("writeback: splice dirty inode entries to
-	 * default bdi on bdi_destroy()") without root-causing the issue.
-	 *
-	 * http://lkml.kernel.org/g/1253038617-30204-11-git-send-email-jens.axboe@oracle.com
-	 * http://thread.gmane.org/gmane.linux.file-systems/35341/focus=35350
-	 *
-	 * We should probably add WARN_ON() to find out whether it still
-	 * happens and track it down if so.
-	 */
-	if (bdi_has_dirty_io(bdi)) {
-		struct bdi_writeback *dst = &default_backing_dev_info.wb;
-
-		bdi_lock_two(&bdi->wb, dst);
-		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
-		list_splice(&bdi->wb.b_io, &dst->b_io);
-		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
-		spin_unlock(&bdi->wb.list_lock);
-		spin_unlock(&dst->list_lock);
-	}
-
 	bdi_unregister(bdi);
 	wb_exit(&bdi->wb);
 }
-- 
2.1.0

