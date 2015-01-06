Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbbAFViq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:38:46 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:52082 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbbAFV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:26:49 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/45] writeback, blkcg: propagate non-root blkcg congestion state
Date: Tue,  6 Jan 2015 16:25:48 -0500
Message-Id: <1420579582-8516-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that bdi layer can handle per cgwb (cgroup bdi_writeback)
congestion state, blk_{set|clear}_congested() can propagate non-root
blkcg congestion state to them.

This can be easily achieved by disabling the root_rl tests in
blk_{set|clear}_congested().  Note that we still need those tests when
!CONFIG_CGROUP_WRITEBACK as otherwise we'll end up flipping root blkcg
wb's congestion state for events happening on other blkcgs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c9a7d6c..d731f1a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -65,23 +65,26 @@ static struct workqueue_struct *kblockd_workqueue;
 
 static void blk_clear_congested(struct request_list *rl, int sync)
 {
-	if (rl != &rl->q->root_rl)
-		return;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	clear_wb_congested(rl->blkg->wb, sync);
 #else
-	clear_wb_congested(&rl->q->backing_dev_info.wb, sync);
+	/*
+	 * If !CGROUP_WRITEBACK, all blkg's map to bdi->wb and we shouldn't
+	 * flip its congestion state for events on other blkcgs.
+	 */
+	if (rl == &rl->q->root_rl)
+		clear_wb_congested(&rl->q->backing_dev_info.wb, sync);
 #endif
 }
 
 static void blk_set_congested(struct request_list *rl, int sync)
 {
-	if (rl != &rl->q->root_rl)
-		return;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	set_wb_congested(rl->blkg->wb, sync);
 #else
-	set_wb_congested(&rl->q->backing_dev_info.wb, sync);
+	/* see blk_clear_congested() */
+	if (rl == &rl->q->root_rl)
+		set_wb_congested(&rl->q->backing_dev_info.wb, sync);
 #endif
 }
 
-- 
2.1.0

