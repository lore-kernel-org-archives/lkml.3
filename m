Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445AbaLEAuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:50:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:44916 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903AbaLEAuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:50:09 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] f2fs: call radix_tree_preload before radix_tree_insert
Date: Thu,  4 Dec 2014 16:49:43 -0800
Message-Id: <1417740583-1681-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417740583-1681-1-git-send-email-jaegeuk@kernel.org>
References: <1417740583-1681-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to fix:

 BUG: using smp_processor_id() in preemptible [00000000] code: f2fs_gc-254:0/384
  (radix_tree_node_alloc+0x14/0x74) from [<c033d8a0>] (radix_tree_insert+0x110/0x200)
  (radix_tree_insert+0x110/0x200) from [<c02e8264>] (gc_data_segment+0x340/0x52c)
  (gc_data_segment+0x340/0x52c) from [<c02e8658>] (f2fs_gc+0x208/0x400)
  (f2fs_gc+0x208/0x400) from [<c02e8a98>] (gc_thread_func+0x248/0x28c)
  (gc_thread_func+0x248/0x28c) from [<c0139944>] (kthread+0xa0/0xac)
  (kthread+0xa0/0xac) from [<c0105ef8>] (ret_from_fork+0x14/0x3c)

The reason is that f2fs calls radix_tree_insert under enabled preemption.
So, before calling it, we need to call radix_tree_preload.

Otherwise, we should use _GFP_WAIT for the radix tree, and use mutex or
semaphore to cover the radix tree operations.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 8 ++++++++
 fs/f2fs/gc.c         | 6 ++----
 fs/f2fs/node.c       | 6 +++---
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 20a917b..6a81b73 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -304,6 +304,11 @@ static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 	struct inode_management *im = &sbi->im[type];
 	struct ino_entry *e;
 retry:
+	if (radix_tree_preload(GFP_NOFS)) {
+		cond_resched();
+		goto retry;
+	}
+
 	spin_lock(&im->ino_lock);
 
 	e = radix_tree_lookup(&im->ino_root, ino);
@@ -311,11 +316,13 @@ retry:
 		e = kmem_cache_alloc(ino_entry_slab, GFP_ATOMIC);
 		if (!e) {
 			spin_unlock(&im->ino_lock);
+			radix_tree_preload_end();
 			goto retry;
 		}
 		if (radix_tree_insert(&im->ino_root, ino, e)) {
 			spin_unlock(&im->ino_lock);
 			kmem_cache_free(ino_entry_slab, e);
+			radix_tree_preload_end();
 			goto retry;
 		}
 		memset(e, 0, sizeof(struct ino_entry));
@@ -326,6 +333,7 @@ retry:
 			im->ino_num++;
 	}
 	spin_unlock(&im->ino_lock);
+	radix_tree_preload_end();
 }
 
 static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index a1af74f..2c58c58 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -351,7 +351,6 @@ static struct inode *find_gc_inode(struct gc_inode_list *gc_list, nid_t ino)
 static void add_gc_inode(struct gc_inode_list *gc_list, struct inode *inode)
 {
 	struct inode_entry *new_ie;
-	int ret;
 
 	if (inode == find_gc_inode(gc_list, inode->i_ino)) {
 		iput(inode);
@@ -361,8 +360,7 @@ retry:
 	new_ie = f2fs_kmem_cache_alloc(winode_slab, GFP_NOFS);
 	new_ie->inode = inode;
 
-	ret = radix_tree_insert(&gc_list->iroot, inode->i_ino, new_ie);
-	if (ret) {
+	if (radix_tree_insert(&gc_list->iroot, inode->i_ino, new_ie)) {
 		kmem_cache_free(winode_slab, new_ie);
 		goto retry;
 	}
@@ -703,7 +701,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi)
 	struct cp_control cpc;
 	struct gc_inode_list gc_list = {
 		.ilist = LIST_HEAD_INIT(gc_list.ilist),
-		.iroot = RADIX_TREE_INIT(GFP_ATOMIC),
+		.iroot = RADIX_TREE_INIT(GFP_NOFS),
 	};
 
 	cpc.reason = test_opt(sbi, FASTBOOT) ? CP_UMOUNT : CP_SYNC;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b47555f..fa115d0 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1992,10 +1992,10 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	nm_i->nat_cnt = 0;
 	nm_i->ram_thresh = DEF_RAM_THRESHOLD;
 
-	INIT_RADIX_TREE(&nm_i->free_nid_root, GFP_ATOMIC);
+	INIT_RADIX_TREE(&nm_i->free_nid_root, GFP_NOIO);
 	INIT_LIST_HEAD(&nm_i->free_nid_list);
-	INIT_RADIX_TREE(&nm_i->nat_root, GFP_ATOMIC);
-	INIT_RADIX_TREE(&nm_i->nat_set_root, GFP_ATOMIC);
+	INIT_RADIX_TREE(&nm_i->nat_root, GFP_NOIO);
+	INIT_RADIX_TREE(&nm_i->nat_set_root, GFP_NOIO);
 	INIT_LIST_HEAD(&nm_i->nat_entries);
 
 	mutex_init(&nm_i->build_lock);
-- 
2.1.1

