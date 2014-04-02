Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaDBAzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:55:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61215 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaDBAzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:55:44 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-9e-533b600f1f7b
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH 1/2 v2] f2fs: avoid free slab cache under spinlock
Date: Wed, 02 Apr 2014 08:55:00 +0800
Message-id: <000e01cf4e0e$46007ee0$d2017ca0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ODd/NoFbz2ESZRWWpLcuKjlXovg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAV3+BOtgg/f9KhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZSw6uZu1YI1WRcuP
	fsYGxp9KXYycHBICJhIrH61jgrDFJC7cW8/WxcjFISSwiFHi3Pw3zBDOD0aJbwsnMoJUsQmo
	SCzv+A/WISKgKLHh/QZ2EJtZIFPiXtMMZhBbWMBX4mfHI6BJHBwsAqoS118LgIR5BSwl7s07
	xgRhC0r8mHyPBaJVS2L9zuNMELa8xOY1b5khDlKQ2HH2NSPEKj2JXxMes0HUiEtsPHKLZQKj
	wCwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO5GdSOxhXNlgc
	YhTgYFTi4T1w3ipYiDWxrLgy9xCjBAezkgjvd1/rYCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
	B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2M1eVuCy82RcrKxS/ssdguwm5r/Mv2pfjU1xFNk248
	Zt3QUWf03Of8jxXsdq1bDG7ldv0Nd1v40J11yjUDlt2no674HU5xPCfy8qcev5Pdq8vFE22U
	3OcU8YeviU2Mjd53KEI3x2RbRavnzmub1z3QPr45Tdby66yNRk07Dwd+NLuoslTj0Co9JZbi
	jERDLeai4kQA1D9C82ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move kmem_cache_free out of spinlock protection region for better performance.

Change log from v1:
 o remove spinlock protection for kmem_cache_free in destroy_node_manager
suggested by Jaegeuk Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |   27 +++++++++++++++++----------
 fs/f2fs/node.c       |   17 ++++++++++++++++-
 2 files changed, 33 insertions(+), 11 deletions(-)

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
index eced8d7..de1e946 100644
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
@@ -1926,6 +1938,9 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 		f2fs_bug_on(i->state == NID_ALLOC);
 		__del_from_free_nid_list(nm_i, i);
 		nm_i->fcnt--;
+		spin_unlock(&nm_i->free_nid_list_lock);
+		kmem_cache_free(free_nid_slab, i);
+		spin_lock(&nm_i->free_nid_list_lock);
 	}
 	f2fs_bug_on(nm_i->fcnt);
 	spin_unlock(&nm_i->free_nid_list_lock);
-- 
1.7.9.5


