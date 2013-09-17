Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3IQOS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:18:27 -0400
Received: from kanga.kvack.org ([205.233.56.17]:47789 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3IQOS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:18:26 -0400
Date: Tue, 17 Sep 2013 10:18:25 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@osdl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: [rfc] rework aio migrate pages to use aio fs
Message-ID: <20130917141825.GF11526@kvack.org>
References: <20130913165937.GL2517@kvack.org> <20130913184204.GS13318@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913184204.GS13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Fri, Sep 13, 2013 at 07:42:04PM +0100, Al Viro wrote:
> OK...  As for objections against anon_inodes.c stuff, it can be dealt with
> after merge.  Basically, I don't like using anon_inodes as a dumping ground -
> look how little of what that sucker is doing has anything to do with the
> code in anon_inodes.c; you override practically everything anyway.  It's
> just a "filesystems are hard, let's go shopping".  Look, declaring an
> fs takes about 20 lines.  Total.  All you really use from anon_inodes.c is
...
> Note that anon_inodes.c reason to exist was "it's for situations where
> all context lives on struct file and we don't need separate inode for
> them".  Going from that to "it happens to contain a handy function for inode
> allocation"...

The main reason for re-using anon_inodes.c was more to avoid duplicating 
code.  In any case, the below reworks things as suggested, and it seems to 
work in basic testing (the migrate pages test passes, as well as some basic 
operations generating events).  Could you please review changes below?  If 
it looks okay, I'll add it to my next bug fix pull.  Credit goes to Al for 
having written most of this code in his previous email.

		-ben

 aio.c |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 129 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 6b868f0..3acca84 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -36,10 +36,11 @@
 #include <linux/eventfd.h>
 #include <linux/blkdev.h>
 #include <linux/compat.h>
-#include <linux/anon_inodes.h>
 #include <linux/migrate.h>
 #include <linux/ramfs.h>
 #include <linux/percpu-refcount.h>
+#include <linux/module.h>
+#include <linux/mount.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -152,12 +153,138 @@ unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio request
 static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
 
+static struct vfsmount *aio_mnt;
+
+static const struct file_operations aio_ring_fops;
+
+static int aio_set_page_dirty(struct page *page)
+{
+	return 0;
+};
+
+static const struct address_space_operations aio_aops = {
+	.set_page_dirty = aio_set_page_dirty,
+};
+
+/*
+ * A single inode exists for each aio_inode file.  The inodes are only
+ * used for mapping the event ring buffers in order to make it possible
+ * to provide migration ops to the vm.
+ */
+static struct inode *aio_inode_mkinode(struct super_block *s)
+{
+	struct inode *inode = new_inode_pseudo(s);
+
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_ino = get_next_ino();
+	inode->i_fop = &aio_ring_fops;
+	inode->i_mapping->a_ops = &aio_aops;
+
+	/*
+	 * Mark the inode dirty from the very beginning,
+	 * that way it will never be moved to the dirty
+	 * list because mark_inode_dirty() will think
+	 * that it already _is_ on the dirty list.
+	 */
+	inode->i_state = I_DIRTY;
+	inode->i_mode = S_IRUSR | S_IWUSR;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
+	inode->i_flags |= S_PRIVATE;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	return inode;
+}
+
+/**
+ * aio_inode_getfile_private - creates a new file instance by hooking it up to
+ * an anonymous inode, and a dentry that describe the "class" of the file.
+ *
+ * @name:    [in]    name of the "class" of the new file
+ * @fops:    [in]    file operations for the new file
+ * @priv:    [in]    private data for the new file (will be file's private_data)
+ * @flags:   [in]    flags
+ *
+ *
+ * Similar to aio_inode_getfile, but each file holds a single inode.
+ *
+ */
+struct file *aio_inode_getfile_private(const char *name,
+				       const struct file_operations *fops,
+				       void *priv, int flags)
+{
+	struct qstr this;
+	struct path path;
+	struct file *file;
+	struct inode *inode;
+
+	if (fops->owner && !try_module_get(fops->owner))
+		return ERR_PTR(-ENOENT);
+
+	inode = aio_inode_mkinode(aio_mnt->mnt_sb);
+	if (IS_ERR(inode)) {
+		file = ERR_PTR(-ENOMEM);
+		goto err_module;
+	}
+
+	/*
+	 * Link the inode to a directory entry by creating a unique name
+	 * using the inode sequence number.
+	 */
+	file = ERR_PTR(-ENOMEM);
+	this.name = name;
+	this.len = strlen(name);
+	this.hash = 0;
+	path.dentry = d_alloc_pseudo(aio_mnt->mnt_sb, &this);
+	if (!path.dentry)
+		goto err_module;
+
+	path.mnt = mntget(aio_mnt);
+
+	d_instantiate(path.dentry, inode);
+
+	file = alloc_file(&path, OPEN_FMODE(flags), fops);
+	if (IS_ERR(file))
+		goto err_dput;
+
+	file->f_mapping = inode->i_mapping;
+	file->f_flags = flags & (O_ACCMODE | O_NONBLOCK);
+	file->private_data = priv;
+
+	return file;
+
+err_dput:
+	path_put(&path);
+err_module:
+	module_put(fops->owner);
+	return file;
+}
+
+static struct dentry *aio_mount(struct file_system_type *fs_type,
+				int flags, const char *dev_name, void *data)
+{
+	static const struct dentry_operations ops = {
+		.d_dname	= simple_dname,
+	};
+        return mount_pseudo(fs_type, "aio:", NULL, &ops, 0xa10a10a1);
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
 
@@ -198,11 +325,6 @@ static const struct file_operations aio_ring_fops = {
 	.mmap = aio_ring_mmap,
 };
 
-static int aio_set_page_dirty(struct page *page)
-{
-	return 0;
-}
-
 #if IS_ENABLED(CONFIG_MIGRATION)
 static int aio_migratepage(struct address_space *mapping, struct page *new,
 			struct page *old, enum migrate_mode mode)
@@ -260,7 +382,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 	if (nr_pages < 0)
 		return -EINVAL;
 
-	file = anon_inode_getfile_private("[aio]", &aio_ring_fops, ctx, O_RDWR);
+	file = aio_inode_getfile_private("[aio]", &aio_ring_fops, ctx, O_RDWR);
 	if (IS_ERR(file)) {
 		ctx->aio_ring_file = NULL;
 		return -EAGAIN;
-- 
"Thought is the essence of where you are now."
