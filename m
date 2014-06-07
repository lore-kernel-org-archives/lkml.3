Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaFGQo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:44:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:59896 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbaFGQo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:44:57 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] f2fs: fix to recover data written by dio
Date: Sun,  8 Jun 2014 01:44:30 +0900
Message-Id: <1402159472-61137-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If data are overwritten through dio, previous f2fs doesn't remain the fsync mark
due to no additional node writes.

Note that this patch should resolve the xfstests:311.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c |  3 +++
 fs/f2fs/f2fs.h |  1 +
 fs/f2fs/node.c | 12 ++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8c250a5..39fe7d7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1041,6 +1041,9 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 	if (check_direct_IO(inode, rw, iov, offset, nr_segs))
 		return 0;
 
+	/* clear fsync mark to recover these blocks */
+	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
+
 	return blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
 							get_data_block);
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9684b1f..f628c3c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1168,6 +1168,7 @@ struct node_info;
 bool available_free_memory(struct f2fs_sb_info *, int);
 int is_checkpointed_node(struct f2fs_sb_info *, nid_t);
 bool fsync_mark_done(struct f2fs_sb_info *, nid_t);
+void fsync_mark_clear(struct f2fs_sb_info *, nid_t);
 void get_node_info(struct f2fs_sb_info *, nid_t, struct node_info *);
 int get_dnode_of_data(struct dnode_of_data *, pgoff_t, int);
 int truncate_inode_blocks(struct inode *, pgoff_t);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 02a59e9..a0a1f25 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -153,6 +153,18 @@ bool fsync_mark_done(struct f2fs_sb_info *sbi, nid_t nid)
 	return fsync_done;
 }
 
+void fsync_mark_clear(struct f2fs_sb_info *sbi, nid_t nid)
+{
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
+	struct nat_entry *e;
+
+	write_lock(&nm_i->nat_tree_lock);
+	e = __lookup_nat_cache(nm_i, nid);
+	if (e)
+		e->fsync_done = false;
+	write_unlock(&nm_i->nat_tree_lock);
+}
+
 static struct nat_entry *grab_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid)
 {
 	struct nat_entry *new;
-- 
1.8.5.2 (Apple Git-48)

