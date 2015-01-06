Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbbAFV1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:27:52 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40107 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbbAFV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:27:42 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 40/45] writeback: make write_cache_pages() cgroup writeback aware
Date: Tue,  6 Jan 2015 16:26:17 -0500
Message-Id: <1420579582-8516-41-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_cache_pages() is used to implement generic do_writepages().  Up
until now, the function targeted all dirty pages; however, for cgroup
writeback, it needs to be more restrained.  As writeback for each wb
cgroup (bdi_writeback) will be executed separately, do_writepages()
needs to write out only the pages dirtied against the wb being
serviced.

This patch introduces wbc_skip_page() which is used by
write_cache_pages() to determine whether a page should be skipped
because it is dirtied against a different wb.  wbc->iwbl_mismatch is
also added to keep track of whether pages were skipped, which will be
used later.

Filesystems which don't use write_cache_pages() for its
address_space_operation->writepages() should update its ->writepages()
to use wbc_skip_page() directly to support cgroup writeback.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 include/linux/backing-dev.h | 27 +++++++++++++++++++++++++++
 include/linux/writeback.h   |  1 +
 mm/page-writeback.c         |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 5d919bc..173d218 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -648,6 +648,27 @@ wbc_blkcg_css(struct writeback_control *wbc)
 	return wbc->iwbl ? iwbl_to_wb(wbc->iwbl)->blkcg_css : NULL;
 }
 
+/**
+ * wbc_skip_page - determine whether to skip a page during writeback
+ * @wbc: writeback_control in effect
+ * @page: page being considered
+ *
+ * Determine whether @page should be written back during a writeback
+ * controlled by @wbc.  This function also accounts the number of skipped
+ * pages in @wbc and should only be called once per page.
+ */
+static inline bool wbc_skip_page(struct writeback_control *wbc,
+				 struct page *page)
+{
+	struct cgroup_subsys_state *blkcg_css = wbc_blkcg_css(wbc);
+
+	if (blkcg_css && blkcg_css != page_blkcg_dirty(page)) {
+		wbc->iwbl_mismatch = 1;
+		return true;
+	}
+	return false;
+}
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static inline bool mapping_cgwb_enabled(struct address_space *mapping)
@@ -760,6 +781,12 @@ wbc_blkcg_css(struct writeback_control *wbc)
 	return NULL;
 }
 
+static inline bool wbc_skip_page(struct writeback_control *wbc,
+				 struct page *page)
+{
+	return false;
+}
+
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 static inline int mapping_read_congested(struct address_space *mapping,
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index dad1953..a225a33 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -85,6 +85,7 @@ struct writeback_control {
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
 #ifdef CONFIG_CGROUP_WRITEBACK
+	unsigned iwbl_mismatch:1;	/* pages skipped due to iwbl mismatch */
 	struct inode_wb_link *iwbl;	/* iwbl this writeback is for */
 #endif
 };
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index dd15bb3..0edf749 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1977,6 +1977,9 @@ retry:
 
 			done_index = page->index;
 
+			if (wbc_skip_page(wbc, page))
+				continue;
+
 			lock_page(page);
 
 			/*
-- 
2.1.0

