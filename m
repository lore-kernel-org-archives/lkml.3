Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3DAKkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:40:14 -0400
Received: from relay.parallels.com ([195.214.232.42]:54419 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab3DAKkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:40:11 -0400
Subject: [PATCH 01/14] fuse: Linking file to inode helper
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:40:44 +0400
Message-ID: <20130401104021.19027.25729.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writeback is ON every writeable file should be in per-inode write list,
not only mmap-ed ones. Thus introduce a helper for this linkage.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/fuse/file.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c807176..356610c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -167,6 +167,22 @@ int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 }
 EXPORT_SYMBOL_GPL(fuse_do_open);
 
+static void fuse_link_write_file(struct file *file)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_file *ff = file->private_data;
+	/*
+	 * file may be written through mmap, so chain it onto the
+	 * inodes's write_file list
+	 */
+	spin_lock(&fc->lock);
+	if (list_empty(&ff->write_entry))
+		list_add(&ff->write_entry, &fi->write_files);
+	spin_unlock(&fc->lock);
+}
+
 void fuse_finish_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
@@ -1484,20 +1500,9 @@ static const struct vm_operations_struct fuse_file_vm_ops = {
 
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE)) {
-		struct inode *inode = file->f_dentry->d_inode;
-		struct fuse_conn *fc = get_fuse_conn(inode);
-		struct fuse_inode *fi = get_fuse_inode(inode);
-		struct fuse_file *ff = file->private_data;
-		/*
-		 * file may be written through mmap, so chain it onto the
-		 * inodes's write_file list
-		 */
-		spin_lock(&fc->lock);
-		if (list_empty(&ff->write_entry))
-			list_add(&ff->write_entry, &fi->write_files);
-		spin_unlock(&fc->lock);
-	}
+	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+		fuse_link_write_file(file);
+
 	file_accessed(file);
 	vma->vm_ops = &fuse_file_vm_ops;
 	return 0;

