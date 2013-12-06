Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422766Ab3LFW1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:27:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161133Ab3LFVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.12 77/83] rework aio migrate pages to use aio fs
Date: Fri,  6 Dec 2013 13:52:07 -0800
Message-Id: <20131206214647.203289145@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit 71ad7490c1f32bd7829df76360f9fa17829868f3 upstream.

Don't abuse anon_inodes.c to host private files needed by aio;
we can bloody well declare a mini-fs of our own instead of
patching up what anon_inodes can create for us.

Tested-by: Benjamin LaHaise <bcrl@kvack.org>
Acked-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 6 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -36,10 +36,10 @@
 #include <linux/eventfd.h>
 #include <linux/blkdev.h>
 #include <linux/compat.h>
-#include <linux/anon_inodes.h>
 #include <linux/migrate.h>
 #include <linux/ramfs.h>
 #include <linux/percpu-refcount.h>
+#include <linux/mount.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -153,12 +153,67 @@ unsigned long aio_max_nr = 0x10000; /* s
 static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
 
+static struct vfsmount *aio_mnt;
+
+static const struct file_operations aio_ring_fops;
+static const struct address_space_operations aio_ctx_aops;
+
+static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
+{
+	struct qstr this = QSTR_INIT("[aio]", 5);
+	struct file *file;
+	struct path path;
+	struct inode *inode = alloc_anon_inode(aio_mnt->mnt_sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_mapping->a_ops = &aio_ctx_aops;
+	inode->i_mapping->private_data = ctx;
+	inode->i_size = PAGE_SIZE * nr_pages;
+
+	path.dentry = d_alloc_pseudo(aio_mnt->mnt_sb, &this);
+	if (!path.dentry) {
+		iput(inode);
+		return ERR_PTR(-ENOMEM);
+	}
+	path.mnt = mntget(aio_mnt);
+
+	d_instantiate(path.dentry, inode);
+	file = alloc_file(&path, FMODE_READ | FMODE_WRITE, &aio_ring_fops);
+	if (IS_ERR(file)) {
+		path_put(&path);
+		return file;
+	}
+
+	file->f_flags = O_RDWR;
+	file->private_data = ctx;
+	return file;
+}
+
+static struct dentry *aio_mount(struct file_system_type *fs_type,
+				int flags, const char *dev_name, void *data)
+{
+	static const struct dentry_operations ops = {
+		.d_dname	= simple_dname,
+	};
+	return mount_pseudo(fs_type, "aio:", NULL, &ops, 0xa10a10a1);
+}
+
 /* aio_setup
  *	Creates the slab caches used by the aio routines, panic on
  *	failure as this is done early during the boot sequence.
  */
 static int __init aio_setup(void)
 {
+	static struct file_system_type aio_fs = {
+		.name		= "aio",
+		.mount		= aio_mount,
+		.kill_sb	= kill_anon_super,
+	};
+	aio_mnt = kern_mount(&aio_fs);
+	if (IS_ERR(aio_mnt))
+		panic("Failed to create aio fs mount.");
+
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
@@ -284,16 +339,12 @@ static int aio_setup_ring(struct kioctx
 	if (nr_pages < 0)
 		return -EINVAL;
 
-	file = anon_inode_getfile_private("[aio]", &aio_ring_fops, ctx, O_RDWR);
+	file = aio_private_file(ctx, nr_pages);
 	if (IS_ERR(file)) {
 		ctx->aio_ring_file = NULL;
 		return -EAGAIN;
 	}
 
-	file->f_inode->i_mapping->a_ops = &aio_ctx_aops;
-	file->f_inode->i_mapping->private_data = ctx;
-	file->f_inode->i_size = PAGE_SIZE * (loff_t)nr_pages;
-
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
 		page = find_or_create_page(file->f_inode->i_mapping,


