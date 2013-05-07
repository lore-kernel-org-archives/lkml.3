Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab3EGOCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:02:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab3EGNll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 070/118] sysfs: fix use after free in case of concurrent read/write and readdir
Date: Tue,  7 May 2013 14:38:36 +0100
Message-Id: <1367933964-1564-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit f7db5e7660b122142410dcf36ba903c73d473250 upstream.

The inode->i_mutex isn't hold when updating filp->f_pos
in read()/write(), so the filp->f_pos might be read as
0 or 1 in readdir() when there is concurrent read()/write()
on this same file, then may cause use after free in readdir().

The bug can be reproduced with Li Zefan's test code on the
link:

	https://patchwork.kernel.org/patch/2160771/

This patch fixes the use after free under this situation.

Reported-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/sysfs/dir.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8777436..1a32e0f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1013,6 +1013,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	enum kobj_ns_type type;
 	const void *ns;
 	ino_t ino;
+	loff_t off;
 
 	type = sysfs_ns_type(parent_sd);
 	ns = sysfs_info(dentry->d_sb)->ns[type];
@@ -1035,6 +1036,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
+	off = filp->f_pos;
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent_sd, filp->f_pos, pos)) {
@@ -1046,19 +1048,24 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
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
1.8.1.2

