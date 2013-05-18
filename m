Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3ERCWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:22:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab3ERCQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:53 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3gAJuXuBra0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FSDhrqmUApwA:10 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=ag1SF4gXAAAA:8 a=YrRph-dhETDbrzscM20A:9 a=lBRciGGoxdUA:10 a=hPjdaMEvmhQA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021647.546880307@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 036/136 ] sysfs: fix use after free in case of concurrent read/write and
 readdir
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0036-sysfs-fix-use-after-free-in-case-of-concurrent-read-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

[ Upstream commit f7db5e7660b122142410dcf36ba903c73d473250 ]

The inode->i_mutex isn't hold when updating filp->f_pos
in read()/write(), so the filp->f_pos might be read as
0 or 1 in readdir() when there is concurrent read()/write()
on this same file, then may cause use after free in readdir().

The bug can be reproduced with Li Zefan's test code on the
link:

	https://patchwork.kernel.org/patch/2160771/

This patch fixes the use after free under this situation.

Cc: stable <stable@vger.kernel.org>
Reported-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/sysfs/dir.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4b93159..76f38eb 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1012,6 +1012,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	enum kobj_ns_type type;
 	const void *ns;
 	ino_t ino;
+	loff_t off;
 
 	type = sysfs_ns_type(parent_sd);
 	ns = sysfs_info(dentry->d_sb)->ns[type];
@@ -1034,6 +1035,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
+	off = filp->f_pos;
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent_sd, filp->f_pos, pos)) {
@@ -1045,19 +1047,24 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
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
1.7.10.4


