Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936221Ab3DKU4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:56:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935854Ab3DKUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:26 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=W0xBtrvU45AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=isD_XOAqu6EA:10 a=DfNHnWVPAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=lBRciGGoxdUA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202559.162210855@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 079/171 ] sysfs: fix race between readdir and lseek
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0079-sysfs-fix-race-between-readdir-and-lseek.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

[ Upstream commit 991f76f837bf22c5bb07261cfd86525a0a96650c ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/sysfs/dir.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2fbdff6..b65a354 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1058,10 +1058,21 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	return 0;
 }
 
+static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode =  file->f_path.dentry->d_inode;
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
1.7.10.4


