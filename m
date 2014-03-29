Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaC2DaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 23:30:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24275 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaC2DaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 23:30:15 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-d7-53363e3acb5d
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH 1/2] f2fs: avoid free slab cache under spinlock
Date: Sat, 29 Mar 2014 11:29:14 +0800
Message-id: <000001cf4aff$295d4cd0$7c17e670$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9K/hlJayIuIvClT3CxjTS/+kDypg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAV0rO7Ngg1k/TCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjj/5RJ7wXWNio9X
	3rM1MB5S7GLk4JAQMJF4fDm+i5ETyBSTuHBvPVsXIxeHkMAiRolrB7YzQzg/GCXuv2hjAqli
	E1CRWN7xH8wWEVCU2PB+AzuIzSyQKXGvaQYziC0s4CWx/+lhVhCbRUBVYmpzK1gNr4ClxOEF
	j1ghbEGJH5PvsUD0akms33mcCcKWl9i85i0zxEUKEjvOvmaE2KUnse/BKTaIGnGJjUdusUxg
	FJiFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBgfxMagfjygaL
	Q4wCHIxKPLwCrabBQqyJZcWVuYcYJTiYlUR4M03NgoV4UxIrq1KL8uOLSnNSiw8xSnOwKInz
	Hmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUw5jm6/Zof+/yaz7yl86/w66rFmlT43+q1OChdzLpR
	YOpZTuYLhmvPnPZc2b7MyF5ur9jO6482rP1cXxG8a0Hp46gHE17uqF33/G/dNIvzcjvFlDSS
	4+ba3D+kL5B96a579ePn+1WvO+86/Oy24Y7wA3n172L81lafdn8T8n+q6MmzTQZ3bwcLTFdi
	Kc5INNRiLipOBAAAg3J8YAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move kmem_cache_free out of spinlock protection region for better performance.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |   27 +++++++++++++++++----------
 fs/f2fs/node.c       |   15 ++++++++++++++-
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index a80be51..d877f46 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -347,10 +347,11 @@ void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	list_for_each_entry(orphan, head, list) {
 		if (orphan->ino == ino) {
 			list_del(&orphan->list);
-			kmem_cache_free(orphan_entry_slab, orphan);
 			f2fs_bug_on(sbi->n_orphans == 0);
 			sbi->n_orphans--;
-			break;
+			spin_unlock(&sbi->orphan_inode_lock);
+			kmem_cache_free(orphan_entry_slab, orphan);
+			return;
 		}
 	}
 	spin_unlock(&sbi->orphan_inode_lock);
@@ -577,6 +578,7 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct dir_inode_entry *new;
+	int ret = 0;
 
 	if (!S_ISDIR(inode->i_mode))
 		return;
@@ -586,12 +588,13 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 	INIT_LIST_HEAD(&new->list);
 
 	spin_lock(&sbi->dir_inode_lock);
-	if (__add_dirty_inode(inode, new))
-		kmem_cache_free(inode_entry_slab, new);
-
+	ret = __add_dirty_inode(inode, new);
 	inode_inc_dirty_dents(inode);
 	SetPagePrivate(page);
 	spin_unlock(&sbi->dir_inode_lock);
+
+	if (ret)
+		kmem_cache_free(inode_entry_slab, new);
 }
 
 void add_dirty_dir_inode(struct inode *inode)
@@ -599,20 +602,22 @@ void add_dirty_dir_inode(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct dir_inode_entry *new =
 			f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
+	int ret = 0;
 
 	new->inode = inode;
 	INIT_LIST_HEAD(&new->list);
 
 	spin_lock(&sbi->dir_inode_lock);
-	if (__add_dirty_inode(inode, new))
-		kmem_cache_free(inode_entry_slab, new);
+	ret = __add_dirty_inode(inode, new);
 	spin_unlock(&sbi->dir_inode_lock);
+
+	if (ret)
+		kmem_cache_free(inode_entry_slab, new);
 }
 
 void remove_dirty_dir_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-
 	struct list_head *this, *head;
 
 	if (!S_ISDIR(inode->i_mode))
@@ -630,13 +635,15 @@ void remove_dirty_dir_inode(struct inode *inode)
 		entry = list_entry(this, struct dir_inode_entry, list);
 		if (entry->inode == inode) {
 			list_del(&entry->list);
-			kmem_cache_free(inode_entry_slab, entry);
 			stat_dec_dirty_dir(sbi);
-			break;
+			spin_unlock(&sbi->dir_inode_lock);
+			kmem_cache_free(inode_entry_slab, entry);
+			goto done;
 		}
 	}
 	spin_unlock(&sbi->dir_inode_lock);
 
+done:
 	/* Only from the recovery routine */
 	if (is_inode_flag_set(F2FS_I(inode), FI_DELAY_IPUT)) {
 		clear_inode_flag(F2FS_I(inode), FI_DELAY_IPUT);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index eced8d7..0021056 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1314,7 +1314,6 @@ static void __del_from_free_nid_list(struct f2fs_nm_info *nm_i,
 {
 	list_del(&i->list);
 	radix_tree_delete(&nm_i->free_nid_root, i->nid);
-	kmem_cache_free(free_nid_slab, i);
 }
 
 static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
@@ -1361,13 +1360,19 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
 static void remove_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 {
 	struct free_nid *i;
+	bool need_free = false;
+
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nm_i, nid);
 	if (i && i->state == NID_NEW) {
 		__del_from_free_nid_list(nm_i, i);
 		nm_i->fcnt--;
+		need_free = true;
 	}
 	spin_unlock(&nm_i->free_nid_list_lock);
+
+	if (need_free)
+		kmem_cache_free(free_nid_slab, i);
 }
 
 static void scan_nat_page(struct f2fs_nm_info *nm_i,
@@ -1492,6 +1497,8 @@ void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
 	f2fs_bug_on(!i || i->state != NID_ALLOC);
 	__del_from_free_nid_list(nm_i, i);
 	spin_unlock(&nm_i->free_nid_list_lock);
+
+	kmem_cache_free(free_nid_slab, i);
 }
 
 /*
@@ -1501,6 +1508,7 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i;
+	bool need_free = false;
 
 	if (!nid)
 		return;
@@ -1510,11 +1518,15 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 	f2fs_bug_on(!i || i->state != NID_ALLOC);
 	if (!available_free_memory(nm_i, FREE_NIDS)) {
 		__del_from_free_nid_list(nm_i, i);
+		need_free = true;
 	} else {
 		i->state = NID_NEW;
 		nm_i->fcnt++;
 	}
 	spin_unlock(&nm_i->free_nid_list_lock);
+
+	if (need_free)
+		kmem_cache_free(free_nid_slab, i);
 }
 
 void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
@@ -1926,6 +1938,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 		f2fs_bug_on(i->state == NID_ALLOC);
 		__del_from_free_nid_list(nm_i, i);
 		nm_i->fcnt--;
+		kmem_cache_free(free_nid_slab, i);
 	}
 	f2fs_bug_on(nm_i->fcnt);
 	spin_unlock(&nm_i->free_nid_list_lock);
-- 
1.7.9.5


