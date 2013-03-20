Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3CTP0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:26:44 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:57434 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3CTP0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:26:43 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] sysfs: fix race between readdir and lseek
Date: Wed, 20 Mar 2013 23:25:24 +0800
Message-Id: <1363793126-11510-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While readdir() is running, lseek() may set filp->f_pos as zero,
then may leave filp->private_data pointing to one sysfs_dirent
object without holding its reference counter, so the sysfs_dirent
object may be used after free in next readdir().

This patch holds inode->i_mutex to avoid the problem since
the lock is always held in readdir path.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/sysfs/dir.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2fbdff6..c9e1660 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1058,10 +1058,21 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	return 0;
 }
 
+static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file_inode(file);
+	loff_t ret;
+
+	mutex_lock(&inode->i_mutex);
+	ret = generic_file_llseek(file, offset, whence);
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
+}
 
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
 	.release	= sysfs_dir_release,
-	.llseek		= generic_file_llseek,
+	.llseek		= sysfs_dir_llseek,
 };
-- 
1.7.9.5

