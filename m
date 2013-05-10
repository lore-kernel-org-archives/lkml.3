Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3EJOvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:51:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56861 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839Ab3EJOTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Li Zefan" <lizefan@huawei.com>, "Ming Lei" <ming.lei@canonical.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.524023728@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [014/118] sysfs: fix use after free in case of concurrent
 read/write and readdir
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: file position is child inode number, not hash]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/sysfs/dir.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -977,6 +977,7 @@ static int sysfs_readdir(struct file * f
 	enum kobj_ns_type type;
 	const void *ns;
 	ino_t ino;
+	loff_t off;
 
 	type = sysfs_ns_type(parent_sd);
 	ns = sysfs_info(dentry->d_sb)->ns[type];
@@ -999,6 +1000,7 @@ static int sysfs_readdir(struct file * f
 			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
+	off = filp->f_pos;
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent_sd, filp->f_pos, pos)) {
@@ -1010,19 +1012,24 @@ static int sysfs_readdir(struct file * f
 		len = strlen(name);
 		ino = pos->s_ino;
 		type = dt_type(pos);
-		filp->f_pos = ino;
+		off = filp->f_pos = ino;
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

