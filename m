Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaGWNQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:16:01 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50280 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbaGWNP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:15:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Chris Mason <clm@fb.com>
Subject: [PATCH 3/7] btrfs: add RENAME_NOREPLACE
Date: Wed, 23 Jul 2014 15:15:32 +0200
Message-Id: <1406121336-1379-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

RENAME_NOREPLACE is trivial to implement for most filesystems: switch over
to ->rename2() and check for the supported flags.  The rest is done by the
VFS.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Chris Mason <clm@fb.com>
---
 fs/btrfs/inode.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048e16f8..3183742d6f0d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8476,6 +8476,16 @@ out_notrans:
 	return ret;
 }
 
+static int btrfs_rename2(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry,
+			 unsigned int flags)
+{
+	if (flags & ~RENAME_NOREPLACE)
+		return -EINVAL;
+
+	return btrfs_rename(old_dir, old_dentry, new_dir, new_dentry);
+}
+
 static void btrfs_run_delalloc_work(struct btrfs_work *work)
 {
 	struct btrfs_delalloc_work *delalloc_work;
@@ -9019,7 +9029,7 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.link		= btrfs_link,
 	.mkdir		= btrfs_mkdir,
 	.rmdir		= btrfs_rmdir,
-	.rename		= btrfs_rename,
+	.rename2	= btrfs_rename2,
 	.symlink	= btrfs_symlink,
 	.setattr	= btrfs_setattr,
 	.mknod		= btrfs_mknod,
-- 
1.8.1.4

