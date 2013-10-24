Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3JXPuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:50:08 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54805 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3JXPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:50:05 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/34] sysfs, kernfs: prepare llseek path for kernfs
Date: Thu, 24 Oct 2013 11:49:22 -0400
Message-Id: <1382629780-10006-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in the process of separating out core sysfs functionality into
kernfs which will deal with sysfs_dirents directly.  This patch
introduces kernfs_file_llseek() which invokes either
generic_file_llseek() or seq_lseek() depending on the file type so
that both regular and bin files eventually can use the same
file_operations, which is necessary to separate out kernfs.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 2736ea9..4f99da5 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -356,6 +356,16 @@ out_free:
 	return len;
 }
 
+static loff_t kernfs_file_llseek(struct file *file, loff_t off, int whence)
+{
+	struct sysfs_open_file *of = sysfs_of(file);
+
+	if (sysfs_is_bin(of->sd))
+		return generic_file_llseek(file, off, whence);
+	else
+		return seq_lseek(file, off, whence);
+}
+
 static void sysfs_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
@@ -854,7 +864,7 @@ EXPORT_SYMBOL_GPL(sysfs_notify);
 const struct file_operations sysfs_file_operations = {
 	.read		= kernfs_file_read,
 	.write		= kernfs_file_write,
-	.llseek		= seq_lseek,
+	.llseek		= kernfs_file_llseek,
 	.open		= sysfs_open_file,
 	.release	= sysfs_release,
 	.poll		= sysfs_poll,
@@ -863,7 +873,7 @@ const struct file_operations sysfs_file_operations = {
 const struct file_operations sysfs_bin_operations = {
 	.read		= kernfs_file_read,
 	.write		= kernfs_file_write,
-	.llseek		= generic_file_llseek,
+	.llseek		= kernfs_file_llseek,
 	.mmap		= sysfs_bin_mmap,
 	.open		= sysfs_open_file,
 	.release	= sysfs_release,
-- 
1.8.3.1

