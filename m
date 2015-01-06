Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbbAFTbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:31:32 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:41387 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbbAFT3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:29:49 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, Tejun Heo <tj@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 14/16] writeback: cosmetic change in account_page_dirtied()
Date: Tue,  6 Jan 2015 14:29:15 -0500
Message-Id: <1420572557-11572-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flip the polarity of mapping_cap_account_dirty() test so that the body
of page accounting can be moved outside the if () block.  This will
help adding cgroup writeback support.

This causes no logic changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 026c91b..d73539f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2094,15 +2094,16 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 {
 	trace_writeback_dirty_page(page, mapping);
 
-	if (mapping_cap_account_dirty(mapping)) {
-		__inc_zone_page_state(page, NR_FILE_DIRTY);
-		__inc_zone_page_state(page, NR_DIRTIED);
-		__inc_wb_stat(&mapping->backing_dev_info->wb, WB_RECLAIMABLE);
-		__inc_wb_stat(&mapping->backing_dev_info->wb, WB_DIRTIED);
-		task_io_account_write(PAGE_CACHE_SIZE);
-		current->nr_dirtied++;
-		this_cpu_inc(bdp_ratelimits);
-	}
+	if (!mapping_cap_account_dirty(mapping))
+		return;
+
+	__inc_zone_page_state(page, NR_FILE_DIRTY);
+	__inc_zone_page_state(page, NR_DIRTIED);
+	__inc_wb_stat(&mapping->backing_dev_info->wb, WB_RECLAIMABLE);
+	__inc_wb_stat(&mapping->backing_dev_info->wb, WB_DIRTIED);
+	task_io_account_write(PAGE_CACHE_SIZE);
+	current->nr_dirtied++;
+	this_cpu_inc(bdp_ratelimits);
 }
 EXPORT_SYMBOL(account_page_dirtied);
 
-- 
2.1.0

