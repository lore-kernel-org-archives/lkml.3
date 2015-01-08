Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbbAHSLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:11:20 -0500
Received: from mail.kernel.org ([198.145.29.136]:58449 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbbAHSLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:11:16 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/6] f2fs: free radix_tree_nodes used by nat_set entries
Date: Thu,  8 Jan 2015 10:10:58 -0800
Message-Id: <1420740661-72288-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
References: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the normal case, the radix_tree_nodes are freed successfully.
But, when cp_error was detected, we should destroy them forcefully.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 21 +++++++++++++++++++--
 fs/f2fs/node.h |  1 +
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9bed016..d7c1436 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1894,7 +1894,7 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
-	struct nat_entry_set *setvec[NATVEC_SIZE];
+	struct nat_entry_set *setvec[SETVEC_SIZE];
 	struct nat_entry_set *set, *tmp;
 	unsigned int found;
 	nid_t set_idx = 0;
@@ -1911,7 +1911,7 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 		remove_nats_in_journal(sbi);
 
 	while ((found = __gang_lookup_nat_set(nm_i,
-					set_idx, NATVEC_SIZE, setvec))) {
+					set_idx, SETVEC_SIZE, setvec))) {
 		unsigned idx;
 		set_idx = setvec[found - 1]->set + 1;
 		for (idx = 0; idx < found; idx++)
@@ -1991,6 +1991,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i, *next_i;
 	struct nat_entry *natvec[NATVEC_SIZE];
+	struct nat_entry_set *setvec[SETVEC_SIZE];
 	nid_t nid = 0;
 	unsigned int found;
 
@@ -2015,11 +2016,27 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	while ((found = __gang_lookup_nat_cache(nm_i,
 					nid, NATVEC_SIZE, natvec))) {
 		unsigned idx;
+
 		nid = nat_get_nid(natvec[found - 1]) + 1;
 		for (idx = 0; idx < found; idx++)
 			__del_from_nat_cache(nm_i, natvec[idx]);
 	}
 	f2fs_bug_on(sbi, nm_i->nat_cnt);
+
+	/* destroy nat set cache */
+	nid = 0;
+	while ((found = __gang_lookup_nat_set(nm_i,
+					nid, SETVEC_SIZE, setvec))) {
+		unsigned idx;
+
+		nid = setvec[found - 1]->set + 1;
+		for (idx = 0; idx < found; idx++) {
+			/* entry_cnt is not zero, when cp_error was occurred */
+			f2fs_bug_on(sbi, !list_empty(&setvec[idx]->entry_list));
+			radix_tree_delete(&nm_i->nat_set_root, setvec[idx]->set);
+			kmem_cache_free(nat_entry_set_slab, setvec[idx]);
+		}
+	}
 	up_write(&nm_i->nat_tree_lock);
 
 	kfree(nm_i->nat_bitmap);
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index cac8a3d..f405bbf 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -25,6 +25,7 @@
 
 /* vector size for gang look-up from nat cache that consists of radix tree */
 #define NATVEC_SIZE	64
+#define SETVEC_SIZE	32
 
 /* return value for read_node_page */
 #define LOCKED_PAGE	1
-- 
2.1.1

