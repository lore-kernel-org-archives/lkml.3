Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbbAFVfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:35:15 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49691 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbbAFV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:27:05 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/45] writeback: make laptop_mode_timer_fn() handle multiple bdi_writeback's
Date: Tue,  6 Jan 2015 16:25:57 -0500
Message-Id: <1420579582-8516-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For cgroup writeback support, all bdi-wide operations should be
distributed to all its wb's (bdi_writeback's).

This patch updates laptop_mode_timer_fn() so that it invokes
wb_start_writeback() on all wb's rather than just the root one.  As
the intent is writing out all dirty data, there's no reason to split
the number of pages to write.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 18bf51d..190e2a2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1725,14 +1725,20 @@ void laptop_mode_timer_fn(unsigned long data)
 	struct request_queue *q = (struct request_queue *)data;
 	int nr_pages = global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS);
+	struct bdi_writeback *wb;
+	struct wb_iter iter;
 
 	/*
 	 * We want to write everything out, not just down to the dirty
 	 * threshold
 	 */
-	if (bdi_has_dirty_io(&q->backing_dev_info))
-		wb_start_writeback(&q->backing_dev_info.wb, nr_pages, true,
-				   WB_REASON_LAPTOP_TIMER);
+	if (!bdi_has_dirty_io(&q->backing_dev_info))
+		return;
+
+	bdi_for_each_wb(wb, &q->backing_dev_info, &iter, 0)
+		if (wb_has_dirty_io(wb))
+			wb_start_writeback(wb, nr_pages, true,
+					   WB_REASON_LAPTOP_TIMER);
 }
 
 /*
-- 
2.1.0

