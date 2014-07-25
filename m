Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028AbaGYWse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:48:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:48696 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbaGYWsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:48:32 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 04/11] f2fs: use radix_tree for ino management
Date: Fri, 25 Jul 2014 15:47:18 -0700
Message-Id: <1406328445-63707-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better ino management, this patch replaces the data structure from list
to radix tree.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 48 ++++++++++++++++++++++++++----------------------
 fs/f2fs/f2fs.h       |  1 +
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index f93d154..d35094a 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -284,24 +284,26 @@ const struct address_space_operations f2fs_meta_aops = {
 
 static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 {
-	struct ino_entry *new, *e;
-
-	new = f2fs_kmem_cache_alloc(ino_entry_slab, GFP_ATOMIC);
-	new->ino = ino;
-
+	struct ino_entry *e;
+retry:
 	spin_lock(&sbi->ino_lock[type]);
-	list_for_each_entry(e, &sbi->ino_list[type], list) {
-		if (e->ino == ino) {
+
+	e = radix_tree_lookup(&sbi->ino_root[type], ino);
+	if (!e) {
+		e = kmem_cache_alloc(ino_entry_slab, GFP_ATOMIC);
+		if (!e) {
 			spin_unlock(&sbi->ino_lock[type]);
-			kmem_cache_free(ino_entry_slab, new);
-			return;
+			goto retry;
 		}
-		if (e->ino > ino)
-			break;
-	}
+		if (radix_tree_insert(&sbi->ino_root[type], ino, e)) {
+			spin_unlock(&sbi->ino_lock[type]);
+			goto retry;
+		}
+		memset(e, 0, sizeof(struct ino_entry));
+		e->ino = ino;
 
-	/* add new entry into list which is sorted by inode number */
-	list_add_tail(&new->list, &e->list);
+		list_add_tail(&e->list, &sbi->ino_list[type]);
+	}
 	spin_unlock(&sbi->ino_lock[type]);
 }
 
@@ -310,14 +312,15 @@ static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 	struct ino_entry *e;
 
 	spin_lock(&sbi->ino_lock[type]);
-	list_for_each_entry(e, &sbi->ino_list[type], list) {
-		if (e->ino == ino) {
-			list_del(&e->list);
+	e = radix_tree_lookup(&sbi->ino_root[type], ino);
+	if (e) {
+		list_del(&e->list);
+		radix_tree_delete(&sbi->ino_root[type], ino);
+		if (type == ORPHAN_INO)
 			sbi->n_orphans--;
-			spin_unlock(&sbi->ino_lock[type]);
-			kmem_cache_free(ino_entry_slab, e);
-			return;
-		}
+		spin_unlock(&sbi->ino_lock[type]);
+		kmem_cache_free(ino_entry_slab, e);
+		return;
 	}
 	spin_unlock(&sbi->ino_lock[type]);
 }
@@ -346,7 +349,7 @@ void release_orphan_inode(struct f2fs_sb_info *sbi)
 
 void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 {
-	/* add new orphan entry into list which is sorted by inode number */
+	/* add new orphan ino entry into list */
 	__add_ino_entry(sbi, ino, ORPHAN_INO);
 }
 
@@ -943,6 +946,7 @@ void init_ino_entry_info(struct f2fs_sb_info *sbi)
 	int i;
 
 	for (i = 0; i < MAX_INO_ENTRY; i++) {
+		INIT_RADIX_TREE(&sbi->ino_root[i], GFP_ATOMIC);
 		spin_lock_init(&sbi->ino_lock[i]);
 		INIT_LIST_HEAD(&sbi->ino_list[i]);
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b6fa6ec..4454caa 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -456,6 +456,7 @@ struct f2fs_sb_info {
 	wait_queue_head_t cp_wait;
 
 	/* for inode management */
+	struct radix_tree_root ino_root[MAX_INO_ENTRY];	/* ino entry array */
 	spinlock_t ino_lock[MAX_INO_ENTRY];		/* for ino entry lock */
 	struct list_head ino_list[MAX_INO_ENTRY];	/* inode list head */
 
-- 
1.8.5.2 (Apple Git-48)

