Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaKRIjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:39:02 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54965 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaKRIhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:37:46 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, Tejun Heo <tj@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 08/10] writeback: cosmetic change in account_page_dirtied()
Date: Tue, 18 Nov 2014 03:37:26 -0500
Message-Id: <1416299848-22112-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416299848-22112-1-git-send-email-tj@kernel.org>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
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
index 7c721b4..29d5bd2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2104,15 +2104,16 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
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
1.9.3

