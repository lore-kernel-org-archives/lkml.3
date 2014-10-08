Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaJHUFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:05:44 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:62584 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbaJHUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:05:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscNAEOYNVRbsGtC/2dsb2JhbABfgw65BwUBc5oIgQsXAXuEMS8jgRo3iEIBtyuOaoYgiiQdhDUFhiuLJIt2jFqJM4NlOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 1/1 linux-next] fs/affs: only call remove_header on empty directory
Date: Wed,  8 Oct 2014 22:05:40 +0200
Message-Id: <1412798740-18881-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

affs_rmdir unconditionally called affs_remove_header which had to check stype
then directory emptiness.

This patch directly checks for directory status(like ext filesystems)

remove_header is also called by affs_unlink and affs_rename but
switch(stype) seems no longer needed.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/affs.h     |  1 +
 fs/affs/amigaffs.c | 18 +-----------------
 fs/affs/namei.c    | 11 +++++++++--
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 9bca881..3a7f287 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -130,6 +130,7 @@ void affs_mark_sb_dirty(struct super_block *sb);
 extern int	affs_insert_hash(struct inode *inode, struct buffer_head *bh);
 extern int	affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh);
 extern int	affs_remove_header(struct dentry *dentry);
+extern int	affs_empty_dir(struct inode *inode);
 extern u32	affs_checksum_block(struct super_block *sb, struct buffer_head *bh);
 extern void	affs_fix_checksum(struct super_block *sb, struct buffer_head *bh);
 extern void	secs_to_datestamp(time_t secs, struct affs_date *ds);
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index abc8539..9288d28 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -229,7 +229,7 @@ done:
 }
 
 
-static int
+int
 affs_empty_dir(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
@@ -286,22 +286,6 @@ affs_remove_header(struct dentry *dentry)
 
 	affs_lock_link(inode);
 	affs_lock_dir(dir);
-	switch (be32_to_cpu(AFFS_TAIL(sb, bh)->stype)) {
-	case ST_USERDIR:
-		/* if we ever want to support links to dirs
-		 * i_hash_lock of the inode must only be
-		 * taken after some checks
-		 */
-		affs_lock_dir(inode);
-		retval = affs_empty_dir(inode);
-		affs_unlock_dir(inode);
-		if (retval)
-			goto done_unlock;
-		break;
-	default:
-		break;
-	}
-
 	retval = affs_remove_hash(dir, bh);
 	if (retval)
 		goto done_unlock;
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 035bd31..b352f78 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -321,11 +321,18 @@ affs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 int
 affs_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct inode *inode = dentry->d_inode;
+	int retval;
+
 	pr_debug("%s(dir=%u, %lu \"%.*s\")\n",
 		__func__, (u32)dir->i_ino, dentry->d_inode->i_ino,
 		 (int)dentry->d_name.len, dentry->d_name.name);
-
-	return affs_remove_header(dentry);
+	affs_lock_dir(inode);
+	retval = affs_empty_dir(inode);
+	affs_unlock_dir(inode);
+	if (!retval)
+		retval = affs_remove_header(dentry);
+	return retval;
 }
 
 int
-- 
1.9.1

