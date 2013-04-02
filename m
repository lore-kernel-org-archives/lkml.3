Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab3DBXWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:22:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3DBWL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:11:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [ 009/124] sysfs: fix race between readdir and lseek
Date: Tue,  2 Apr 2013 15:09:51 -0700
Message-Id: <20130402221105.301706285@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit 991f76f837bf22c5bb07261cfd86525a0a96650c upstream.

While readdir() is running, lseek() may set filp->f_pos as zero,
then may leave filp->private_data pointing to one sysfs_dirent
object without holding its reference counter, so the sysfs_dirent
object may be used after free in next readdir().

This patch holds inode->i_mutex to avoid the problem since
the lock is always held in readdir path.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/sysfs/dir.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1058,10 +1058,21 @@ static int sysfs_readdir(struct file * f
 	return 0;
 }
 
+static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
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


