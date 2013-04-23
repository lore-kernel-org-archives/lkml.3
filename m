Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab3DWV7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:59:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab3DWV4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:56:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 15/23] Revert "sysfs: fix race between readdir and lseek"
Date: Tue, 23 Apr 2013 14:56:22 -0700
Message-Id: <20130423215457.836814569@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215456.307216898@linuxfoundation.org>
References: <20130423215456.307216898@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

This reverts commit 991f76f837bf22c5bb07261cfd86525a0a96650c in Linus'
tree which is f366c8f271888f48e15cc7c0ab70f184c220c8a4 in
linux-stable.git

It depends on ef3d0fd27e90f ("vfs: do (nearly) lockless generic_file_llseek")
which is available only in 3.2+.

When applied on 3.0 codebase, it causes A-A deadlock, whenever anyone does
seek() on sysfs, as both generic_file_llseek() and sysfs_dir_llseek() obtain
i_mutex.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/sysfs/dir.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -959,21 +959,9 @@ static int sysfs_readdir(struct file * f
 	return 0;
 }
 
-static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
-{
-	struct inode *inode = file->f_path.dentry->d_inode;
-	loff_t ret;
-
-	mutex_lock(&inode->i_mutex);
-	ret = generic_file_llseek(file, offset, whence);
-	mutex_unlock(&inode->i_mutex);
-
-	return ret;
-}
-
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
 	.release	= sysfs_dir_release,
-	.llseek		= sysfs_dir_llseek,
+	.llseek		= generic_file_llseek,
 };


