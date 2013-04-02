Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab3DBCMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:12:39 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39357 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab3DBCMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:12:37 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Ming Lei <ming.lei@canonical.com>, <stable@vger.kernel.org>
Subject: [PATCH] sysfs: fix use after free in case of concurrent read/write and readdir
Date: Tue,  2 Apr 2013 10:12:26 +0800
Message-Id: <1364868746-5405-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inode->i_mutex isn't hold when updating filp->f_pos
in read()/write(), so the filp->f_pos might be read as
0 or 1 in readdir() when there is concurrent read()/write()
on this same file, then may cause use after free in readdir().

The bug can be reproduced with Li Zefan's test code on the
link:

	https://patchwork.kernel.org/patch/2160771/

This patch fixes the use after free under this situation.

Cc: <stable@vger.kernel.org>
Reported-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/sysfs/dir.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 79a0fd2..484f25e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1022,6 +1022,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	enum kobj_ns_type type;
 	const void *ns;
 	ino_t ino;
+	loff_t off;
 
 	type = sysfs_ns_type(parent_sd);
 	ns = sysfs_info(dentry->d_sb)->ns[type];
@@ -1044,6 +1045,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
+	off = filp->f_pos;
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent_sd, filp->f_pos, pos)) {
@@ -1055,19 +1057,24 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		len = strlen(name);
 		ino = pos->s_ino;
 		type = dt_type(pos);
-		filp->f_pos = pos->s_hash;
+		off = filp->f_pos = pos->s_hash;
 		filp->private_data = sysfs_get(pos);
 
 		mutex_unlock(&sysfs_mutex);
-		ret = filldir(dirent, name, len, filp->f_pos, ino, type);
+		ret = filldir(dirent, name, len, off, ino, type);
 		mutex_lock(&sysfs_mutex);
 		if (ret < 0)
 			break;
 	}
 	mutex_unlock(&sysfs_mutex);
-	if ((filp->f_pos > 1) && !pos) { /* EOF */
-		filp->f_pos = INT_MAX;
+
+	/* don't reference last entry if its refcount is dropped */
+	if (!pos) {
 		filp->private_data = NULL;
+
+		/* EOF and not changed as 0 or 1 in read/write path */
+		if (off == filp->f_pos && off > 1)
+			filp->f_pos = INT_MAX;
 	}
 	return 0;
 }
-- 
1.7.9.5

