Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaGWNSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:18:43 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:36616 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbaGWNQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:16:00 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 5/7] shmem: support RENAME_EXCHANGE
Date: Wed, 23 Jul 2014 15:15:34 +0200
Message-Id: <1406121336-1379-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This is really simple in tmpfs since the VFS already takes care of
shuffling the dentries.  Just adjust nlink on parent directories and touch
c & mtimes.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 791b05514f9a..75d5ac806f1e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2016,6 +2016,28 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 	return shmem_unlink(dir, dentry);
 }
 
+static int shmem_exchange(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
+{
+	bool old_is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
+	bool new_is_dir = S_ISDIR(new_dentry->d_inode->i_mode);
+
+	if (old_dir != new_dir && old_is_dir != new_is_dir) {
+		if (old_is_dir) {
+			drop_nlink(old_dir);
+			inc_nlink(new_dir);
+		} else {
+			drop_nlink(new_dir);
+			inc_nlink(old_dir);
+		}
+	}
+	old_dir->i_ctime = old_dir->i_mtime =
+	new_dir->i_ctime = new_dir->i_mtime =
+	old_dentry->d_inode->i_ctime =
+	new_dentry->d_inode->i_ctime = CURRENT_TIME;
+
+	return 0;
+}
+
 /*
  * The VFS layer already does all the dentry stuff for rename,
  * we just have to decrement the usage count for the target if
@@ -2027,9 +2049,12 @@ static int shmem_rename2(struct inode *old_dir, struct dentry *old_dentry, struc
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(inode->i_mode);
 
-	if (flags & ~(RENAME_NOREPLACE))
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
+	if (flags & RENAME_EXCHANGE)
+		return shmem_exchange(old_dir, old_dentry, new_dir, new_dentry);
+
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
-- 
1.8.1.4

