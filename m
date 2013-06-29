Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3F2Rmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 13:42:37 -0400
Received: from relay.parallels.com ([195.214.232.42]:51386 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3F2RmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 13:42:20 -0400
Subject: [PATCH 01/16] fuse: Linking file to inode helper
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: riel@redhat.com, dev@parallels.com, xemul@parallels.com,
        fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        linux-mm@kvack.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, devel@openvz.org, mgorman@suse.de
Date: Sat, 29 Jun 2013 21:42:10 +0400
Message-ID: <20130629174154.20175.73142.stgit@maximpc.sw.ru>
In-Reply-To: <20130629172211.20175.70154.stgit@maximpc.sw.ru>
References: <20130629172211.20175.70154.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>

When writeback is ON every writeable file should be in per-inode write list,
not only mmap-ed ones. Thus introduce a helper for this linkage.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/fuse/file.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 35f2810..cc858ee 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -171,6 +171,22 @@ int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 }
 EXPORT_SYMBOL_GPL(fuse_do_open);
 
+static void fuse_link_write_file(struct file *file)
+{
+	struct inode *inode = file_inode(file);
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
@@ -1615,20 +1631,9 @@ static const struct vm_operations_struct fuse_file_vm_ops = {
 
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE)) {
-		struct inode *inode = file_inode(file);
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

