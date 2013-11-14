Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3KNG7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 01:59:33 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37517 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3KNG7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 01:59:24 -0500
Message-ID: <1384412359.28992.3.camel@phoenix>
Subject: [PATCH] ramfs: Fix memory leak on ramfs_fill_super error paths
From: Axel Lin <axel.lin@ingics.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Nov 2013 14:59:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory leak was introduced by commit 318ceed0884
"tidy up after d_make_root() conversion".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 fs/ramfs/inode.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 39d1465..868a41e 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -221,7 +221,7 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	err = ramfs_parse_options(data, &fsi->mount_opts);
 	if (err)
-		return err;
+		goto fail;
 
 	sb->s_maxbytes		= MAX_LFS_FILESIZE;
 	sb->s_blocksize		= PAGE_CACHE_SIZE;
@@ -232,10 +232,16 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	inode = ramfs_get_inode(sb, NULL, S_IFDIR | fsi->mount_opts.mode, 0);
 	sb->s_root = d_make_root(inode);
-	if (!sb->s_root)
-		return -ENOMEM;
+	if (!sb->s_root) {
+		err = -ENOMEM;
+		goto fail;
+	}
 
 	return 0;
+fail:
+	kfree(fsi);
+	sb->s_fs_info = NULL;
+	return err;
 }
 
 struct dentry *ramfs_mount(struct file_system_type *fs_type,
-- 
1.8.1.2



