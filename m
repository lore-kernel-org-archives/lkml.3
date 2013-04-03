Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684Ab3DCC6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:58:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37939 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760751Ab3DCC6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:58:38 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] sysfs: check if one entry has been removed before freeing
Date: Wed,  3 Apr 2013 10:58:23 +0800
Message-Id: <1364957903-10341-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might be a kernel disaster if one sysfs entry is freed but
still referenced by sysfs tree.

Recently Dave and Sasha reported one use-after-free problem on
sysfs entry, and the problem has been troubleshooted with help
of debug message added in this patch.

Given sysfs_get_dirent/sysfs_put are exported APIs, even inside
sysfs they are called in many contexts(kobject/attribe add/delete,
inode init/drop, dentry lookup/release, readdir, ...), it is healthful
to check the removed flag before freeing one entry and dump message
if it is freeing without being removed first.

Cc: Dave Jones <davej@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/sysfs/dir.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1bf016b..328ef9b 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -268,6 +268,13 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	 */
 	parent_sd = sd->s_parent;
 
+	if (unlikely(!(sd->s_flags & SYSFS_FLAG_REMOVED))) {
+		printk(KERN_ERR "sysfs: free using entry: %s/%s\n",
+			parent_sd ? parent_sd->s_name : "",
+			sd->s_name);
+		BUG();
+	}
+
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
 		sysfs_put(sd->s_symlink.target_sd);
 	if (sysfs_type(sd) & SYSFS_COPY_NAME)
@@ -386,7 +393,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	sd->s_name = name;
 	sd->s_mode = mode;
-	sd->s_flags = type;
+	sd->s_flags = type | SYSFS_FLAG_REMOVED;
 
 	return sd;
 
@@ -466,6 +473,9 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
 	}
 
+	/* Mark the entry added into directory tree */
+	sd->s_flags &= ~SYSFS_FLAG_REMOVED;
+
 	return 0;
 }
 
-- 
1.7.9.5

