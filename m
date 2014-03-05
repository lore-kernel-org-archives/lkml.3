Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbaCEO0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41171 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaCEO0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Ben Myers <bpm@sgi.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 092/131] fs: fix iversion handling
Date: Wed,  5 Mar 2014 14:23:36 +0000
Message-Id: <1394029455-23128-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit dff6efc326a4d5f305797d4a6bba14f374fdd633 upstream.

Currently notify_change directly updates i_version for size updates,
which not only is counter to how all other fields are updated through
struct iattr, but also breaks XFS, which need inode updates to happen
under its own lock, and synchronized to the structure that gets written
to the log.

Remove the update in the common code, and it to btrfs and ext4,
XFS already does a proper updaste internally and currently gets a
double update with the existing code.

IMHO this is 3.13 and -stable material and should go in through the XFS
tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/attr.c        | 5 -----
 fs/btrfs/inode.c | 8 ++++++--
 fs/ext4/inode.c  | 4 ++++
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 1449adb..8dd5825 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -182,11 +182,6 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			return -EPERM;
 	}
 
-	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
-		if (attr->ia_size != inode->i_size)
-			inode_inc_iversion(inode);
-	}
-
 	if ((ia_valid & ATTR_MODE)) {
 		umode_t amode = attr->ia_mode;
 		/* Flag setting protected by i_mutex */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f992daf..bfe5f39 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4413,8 +4413,12 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 	 * these flags set.  For all other operations the VFS set these flags
 	 * explicitly if it wants a timestamp update.
 	 */
-	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME))))
-		inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
+	if (newsize != oldsize) {
+		inode_inc_iversion(inode);
+		if (!(mask & (ATTR_CTIME | ATTR_MTIME)))
+			inode->i_ctime = inode->i_mtime =
+				current_fs_time(inode->i_sb);
+	}
 
 	if (newsize > oldsize) {
 		truncate_pagecache(inode, oldsize, newsize);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d343bb7..0ea5961 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4598,6 +4598,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			if (attr->ia_size > sbi->s_bitmap_maxbytes)
 				return -EFBIG;
 		}
+
+		if (IS_I_VERSION(inode) && attr->ia_size != inode->i_size)
+			inode_inc_iversion(inode);
+
 		if (S_ISREG(inode->i_mode) &&
 		    (attr->ia_size < inode->i_size)) {
 			if (ext4_should_order_data(inode)) {
-- 
1.9.0

