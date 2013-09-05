Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935643Ab3IEJ3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:29:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935601Ab3IEJ2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:50 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/6] GFS2: dirty inode correctly in gfs2_write_end
Date: Thu,  5 Sep 2013 10:02:12 +0100
Message-Id: <1378371732-3947-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
References: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

GFS2 was only setting I_DIRTY_DATASYNC on files that it wrote to, when
it actually increased the file size.  If gfs2_fsync was called without
I_DIRTY_DATASYNC set, it didn't flush the incore data to the log before
returning, so any metadata or journaled data changes were not getting
fsynced. This meant that writes to the middle of files were not always
getting fsynced properly.

This patch makes gfs2 set I_DIRTY_DATASYNC whenever metadata has been
updated during a write. It also make gfs2_sync flush the incore log
if I_DIRTY_PAGES is set, and the file is using data journalling. This
will make sure that all incore logged data gets written to disk before
returning from a fsync.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index a9ea6f0..1f7d805 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -815,6 +815,8 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	unsigned int from = pos & (PAGE_CACHE_SIZE - 1);
 	unsigned int to = from + len;
 	int ret;
+	struct gfs2_trans *tr = current->journal_info;
+	BUG_ON(!tr);
 
 	BUG_ON(gfs2_glock_is_locked_by_me(ip->i_gl) == NULL);
 
@@ -825,8 +827,6 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 		goto failed;
 	}
 
-	gfs2_trans_add_meta(ip->i_gl, dibh);
-
 	if (gfs2_is_stuffed(ip))
 		return gfs2_stuffed_write_end(inode, dibh, pos, len, copied, page);
 
@@ -834,6 +834,11 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 		gfs2_page_add_databufs(ip, page, from, to);
 
 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (tr->tr_num_buf_new)
+		__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
+	else
+		gfs2_trans_add_meta(ip->i_gl, dibh);
+
 
 	if (inode == sdp->sd_rindex) {
 		adjust_fs_space(inode);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 72c3866..0621b46 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -650,7 +650,7 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 {
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
-	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
+	int sync_state = inode->i_state & I_DIRTY;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	int ret = 0, ret1 = 0;
 
@@ -660,6 +660,8 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 			return ret1;
 	}
 
+	if (!gfs2_is_jdata(ip))
+		sync_state &= ~I_DIRTY_PAGES;
 	if (datasync)
 		sync_state &= ~I_DIRTY_SYNC;
 
-- 
1.7.4

