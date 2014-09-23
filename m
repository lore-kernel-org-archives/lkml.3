Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaIWKYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:24:11 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46538 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaIWKYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:24:09 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH 1/1] nilfs2: improve the performance of fdatasync()
Date: Tue, 23 Sep 2014 19:18:50 +0900
Message-Id: <1411467530-5949-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <1411467530-5949-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1411467530-5949-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20110525(IM151)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Rohner <andreas.rohner@gmx.net>

Support for fdatasync() has been implemented in NILFS2 for a long time,
but whenever the corresponding inode is dirty the implementation falls
back to a full-flegded sync(). Since every write operation has to update
the modification time of the file, the inode will almost always be dirty
and fdatasync() will fall back to sync() most of the time. But this
fallback is only necessary for a change of the file size and not for
a change of the various timestamps.

This patch adds a new flag NILFS_I_INODE_SYNC to differentiate between
those two situations.

 * If it is set the file size was changed and a full sync is necessary.
 * If it is not set then only the timestamps were updated and
   fdatasync() can go ahead.

There is already a similar flag I_DIRTY_DATASYNC on the VFS layer with
the exact same semantics. Unfortunately it cannot be used directly,
because NILFS2 doesn't implement write_inode() and doesn't clear the VFS
flags when inodes are written out. So the VFS writeback thread can
clear I_DIRTY_DATASYNC at any time without notifying NILFS2. So
I_DIRTY_DATASYNC has to be mapped onto NILFS_I_INODE_SYNC in
nilfs_update_inode().

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/inode.c   |   13 +++++++------
 fs/nilfs2/nilfs.h   |   14 +++++++++++---
 fs/nilfs2/segment.c |    4 ++--
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 9e3c525..f276fe1 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -125,7 +125,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 			nilfs_transaction_abort(inode->i_sb);
 			goto out;
 		}
-		nilfs_mark_inode_dirty(inode);
+		nilfs_mark_inode_dirty_sync(inode);
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 		/* Error handling should be detailed */
 		set_buffer_new(bh_result);
@@ -671,7 +671,7 @@ void nilfs_write_inode_common(struct inode *inode,
 	   for substitutions of appended fields */
 }
 
-void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
+void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh, int flags)
 {
 	ino_t ino = inode->i_ino;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
@@ -682,7 +682,8 @@ void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
 
 	if (test_and_clear_bit(NILFS_I_NEW, &ii->i_state))
 		memset(raw_inode, 0, NILFS_MDT(ifile)->mi_entry_size);
-	set_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
+	if (flags & I_DIRTY_DATASYNC)
+		set_bit(NILFS_I_INODE_SYNC, &ii->i_state);
 
 	nilfs_write_inode_common(inode, raw_inode, 0);
 		/* XXX: call with has_bmap = 0 is a workaround to avoid
@@ -938,7 +939,7 @@ int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
 	return 0;
 }
 
-int nilfs_mark_inode_dirty(struct inode *inode)
+int __nilfs_mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct buffer_head *ibh;
 	int err;
@@ -949,7 +950,7 @@ int nilfs_mark_inode_dirty(struct inode *inode)
 			      "failed to reget inode block.\n");
 		return err;
 	}
-	nilfs_update_inode(inode, ibh);
+	nilfs_update_inode(inode, ibh, flags);
 	mark_buffer_dirty(ibh);
 	nilfs_mdt_mark_dirty(NILFS_I(inode)->i_root->ifile);
 	brelse(ibh);
@@ -982,7 +983,7 @@ void nilfs_dirty_inode(struct inode *inode, int flags)
 		return;
 	}
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
-	nilfs_mark_inode_dirty(inode);
+	__nilfs_mark_inode_dirty(inode, flags);
 	nilfs_transaction_commit(inode->i_sb); /* never fails */
 }
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 0696161..91093cd 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -104,7 +104,7 @@ enum {
 					   constructor */
 	NILFS_I_COLLECTED,		/* All dirty blocks are collected */
 	NILFS_I_UPDATED,		/* The file has been written back */
-	NILFS_I_INODE_DIRTY,		/* write_inode is requested */
+	NILFS_I_INODE_SYNC,		/* dsync is not allowed for inode */
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
 	NILFS_I_GCINODE,		/* inode for GC, on memory only */
 };
@@ -273,7 +273,7 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 			 unsigned long ino);
 extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
 				       unsigned long ino, __u64 cno);
-extern void nilfs_update_inode(struct inode *, struct buffer_head *);
+extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
 extern int nilfs_setattr(struct dentry *, struct iattr *);
@@ -282,10 +282,18 @@ int nilfs_permission(struct inode *inode, int mask);
 int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh);
 extern int nilfs_inode_dirty(struct inode *);
 int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty);
-extern int nilfs_mark_inode_dirty(struct inode *);
+extern int __nilfs_mark_inode_dirty(struct inode *, int);
 extern void nilfs_dirty_inode(struct inode *, int flags);
 int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 __u64 start, __u64 len);
+static inline int nilfs_mark_inode_dirty(struct inode *inode)
+{
+	return __nilfs_mark_inode_dirty(inode, I_DIRTY);
+}
+static inline int nilfs_mark_inode_dirty_sync(struct inode *inode)
+{
+	return __nilfs_mark_inode_dirty(inode, I_DIRTY_SYNC);
+}
 
 /* super.c */
 extern struct inode *nilfs_alloc_inode(struct super_block *);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0b7d2ca..7ef18fc 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -930,7 +930,7 @@ static void nilfs_drop_collected_inodes(struct list_head *head)
 		if (!test_and_clear_bit(NILFS_I_COLLECTED, &ii->i_state))
 			continue;
 
-		clear_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
+		clear_bit(NILFS_I_INODE_SYNC, &ii->i_state);
 		set_bit(NILFS_I_UPDATED, &ii->i_state);
 	}
 }
@@ -2195,7 +2195,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	nilfs_transaction_lock(sb, &ti, 0);
 
 	ii = NILFS_I(inode);
-	if (test_bit(NILFS_I_INODE_DIRTY, &ii->i_state) ||
+	if (test_bit(NILFS_I_INODE_SYNC, &ii->i_state) ||
 	    nilfs_test_opt(nilfs, STRICT_ORDER) ||
 	    test_bit(NILFS_SC_UNCLOSED, &sci->sc_flags) ||
 	    nilfs_discontinued(nilfs)) {
-- 
1.7.9.4

