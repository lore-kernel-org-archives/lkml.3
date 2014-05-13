Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaEMOWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:22:07 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40334 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060AbaEMOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:22:03 -0400
Date: Tue, 13 May 2014 16:21:57 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] shmem: support RENAME_EXCHANGE
Message-ID: <20140513142157.GF17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This is really simple in tmpfs since the VFS already takes care of
shuffling the dentries.  Just adjust nlink on parent directories and touch
c & mtimes.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 mm/shmem.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1995,12 +1995,37 @@ static int shmem_rename(struct inode *ol
 	return 0;
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
 static int shmem_rename2(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry, unsigned int flags)
 {
-	if (flags & ~(RENAME_NOREPLACE))
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
-	return shmem_rename(old_dir, old_dentry, new_dir, new_dentry);
+	if (flags & RENAME_EXCHANGE)
+		return shmem_exchange(old_dir, old_dentry, new_dir, new_dentry);
+	else
+		return shmem_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
 
 static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
