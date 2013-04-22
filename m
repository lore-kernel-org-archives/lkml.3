Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3DVNkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:40:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab3DVNkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:40:16 -0400
Date: Mon, 22 Apr 2013 15:40:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3.0-stable] Revert "sysfs: fix race between readdir and
 lseek"
Message-ID: <alpine.LNX.2.00.1304221537480.1341@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 991f76f837bf22c5bb07261cfd86525a0a96650c in Linus' 
tree which is f366c8f271888f48e15cc7c0ab70f184c220c8a4 in 
linux-stable.git

It depends on ef3d0fd27e90f ("vfs: do (nearly) lockless generic_file_llseek")
which is available only in 3.2+.

When applied on 3.0 codebase, it causes A-A deadlock, whenever anyone does
seek() on sysfs, as both generic_file_llseek() and sysfs_dir_llseek() obtain
i_mutex.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/sysfs/dir.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

Index: linux-3.0-SLE11-SP3-sysfs-hang-debug/fs/sysfs/dir.c
===================================================================
--- linux-3.0-SLE11-SP3-sysfs-hang-debug.orig/fs/sysfs/dir.c
+++ linux-3.0-SLE11-SP3-sysfs-hang-debug/fs/sysfs/dir.c
@@ -961,21 +961,9 @@ static int sysfs_readdir(struct file * f
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

-- 
Jiri Kosina
SUSE Labs
