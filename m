Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaKWTE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:04:28 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48334 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaKWTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:04:27 -0500
Message-ID: <1416769462.5864.15.camel@home.ted.local>
Subject: Re: [RFC] proc interface to show file page cache usage details
From: Vladimir Shebordaev <vladimir.shebordaev@gmail.com>
To: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?Q?=D0=92=D0=BB=D0=B0=D0=B4=D0=B8=D0=BC=D0=B8=D1=80_?=
	 =?UTF-8?Q?=D0=A8=D0=B5=D0=B1=D0=BE=D1=80=D0=B4=D0=B0=D0=B5=D0=B2?= 
	<vshebordaev@mail.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 23 Nov 2014 22:04:22 +0300
In-Reply-To: <CAKDHXDFAt3ng=+G-YUYr9XEWD0Ota_QdCqDRfhBzQvgrC+Ew6w@mail.gmail.com>
References: <CAKDHXDFAt3ng=+G-YUYr9XEWD0Ota_QdCqDRfhBzQvgrC+Ew6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-23 at 14:51 +0400, Vladimir Shebordaev wrote:
> Hi,
> 
> I would like to suggest an interface to list inodes that currently
> occupy page cache in human readable form.
> 
> A piece of code below creates a dedicated proc entry, namely,
> /proc/kpagecache. Upon read request it traverses all the inodes of
> each superblock and shows their page cache usage summary. It is done
> in a stateful way, so it needs to access super_blocks list and has to
> get and put superblocks on its own.
> 

The same thing with tabs in their places. If anybody cares.

> I am not quite sure who will give a fuck. Actually, it was a task for
> my recent job interview. I still don't know what they exactly meant. I
> just think it would be anyway nice to have such an interface.
> 
> In the hope it helps.
> 
> --
> Regards,
> Vladimir
> 

commit 7f1a8e195c7a36dd10d22ce48bf4832d7cfcb26e
Author: Vladimir Shebordaev <vshebordaev@mail.ru>
Date:   Sun Nov 23 21:19:31 2014 +0300

    added /proc/kpagecache interface to show file page cache usage

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 7151ea4..83193c0 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -29,4 +29,4 @@ proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
 proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
-proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
+proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o pagecache.o
diff --git a/fs/internal.h b/fs/internal.h
index 757ba2a..330ea78 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -88,6 +88,9 @@ extern struct dentry *mount_fs(struct file_system_type *,
 			       int, const char *, void *);
 extern struct super_block *user_get_super(dev_t);
 
+extern void __put_super(struct super_block *sb);
+extern void put_super(struct super_block *sb);
+
 /*
  * open.c
  */
diff --git a/fs/super.c b/fs/super.c
index eae088f..24ed119 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -242,7 +242,7 @@ fail:
 /*
  * Drop a superblock's refcount.  The caller must hold sb_lock.
  */
-static void __put_super(struct super_block *sb)
+void __put_super(struct super_block *sb)
 {
 	if (!--sb->s_count) {
 		list_del_init(&sb->s_list);
@@ -257,7 +257,7 @@ static void __put_super(struct super_block *sb)
  *	Drops a temporary reference, frees superblock if there's no
  *	references left.
  */
-static void put_super(struct super_block *sb)
+void put_super(struct super_block *sb)
 {
 	spin_lock(&sb_lock);
 	__put_super(sb);
diff --git a/fs/proc/pagecache.c b/fs/proc/pagecache.c
new file mode 100644
index 0000000..d940f35
--- /dev/null
+++ b/fs/proc/pagecache.c
@@ -0,0 +1,412 @@
+/*
+ *  fs/proc/pagecache.c
+ *
+ *  Copyright (C) 2014
+ *
+ *  Author: Vladimir Shebordaev <vshebordaev@mail.ru>
+ *
+ *  /proc/kpagecache interface to show file page cache usage
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+#include <linux/nsproxy.h>
+#include <linux/backing-dev.h>
+#include <linux/page-flags.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/path.h>
+#include <linux/fs_struct.h>
+#include <linux/mount.h>
+#include <linux/ctype.h>
+#include <linux/unistd.h>
+
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+#include <linux/errno.h>
+
+#include "../internal.h"
+
+#define NR_PAGES (PAGE_ALIGN(PATH_MAX) >> PAGE_SHIFT)
+#define BUFSIZE (NR_PAGES << PAGE_SHIFT)
+
+struct iter {
+	struct inode *inode;
+	char *buf;
+};
+
+struct iter *iter_next(struct iter *iter) 
+{
+	struct super_block *sb, *p;
+	struct inode *inode, *prev;
+
+	inode = iter->inode;
+	prev = inode;
+	sb = inode->i_sb;
+
+	spin_lock(&inode_sb_list_lock);
+next:
+	inode = list_next_entry(inode, i_sb_list);
+check:
+	if (&inode->i_sb_list == &sb->s_inodes)
+		inode = NULL;
+	if (inode) {
+		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		   !(mapping_cap_writeback_dirty(inode->i_mapping)) ||
+		    (inode->i_mapping->nrpages == 0) ||
+		    hlist_empty(&inode->i_dentry)) {
+			spin_unlock(&inode->i_lock);
+			goto next;
+		}
+		__iget(inode);
+		spin_unlock(&inode->i_lock);
+	}
+	spin_unlock(&inode_sb_list_lock);
+
+	iput(prev);
+	prev = NULL;
+
+	if (inode)
+		goto out;
+
+	up_read(&sb->s_umount);
+	p = sb;
+	spin_lock(&sb_lock);
+retry:
+	sb = list_next_entry(sb, s_list);
+	if (&sb->s_list == &super_blocks) 
+		sb = NULL;
+	if (sb) {
+		if (hlist_unhashed(&sb->s_instances))
+			goto retry;
+		sb->s_count++;
+	}
+	if (p) {
+		__put_super(p);
+		p = NULL;
+	}
+	spin_unlock(&sb_lock);
+
+	if (sb) {
+		down_read(&sb->s_umount);
+		if (!sb->s_root || !(sb->s_flags & MS_BORN) || !sb->s_bdi || 
+		    !bdi_cap_writeback_dirty(sb->s_bdi)) {
+			up_read(&sb->s_umount);
+			p = sb;
+			spin_lock(&sb_lock);
+			goto retry;
+		}	
+		spin_lock(&inode_sb_list_lock);
+		if (list_empty(&sb->s_inodes)) {
+			spin_unlock(&inode_sb_list_lock);
+			up_read(&sb->s_umount);
+			p = sb;
+			spin_lock(&sb_lock);
+			goto retry;
+		}
+		inode = list_first_entry(&sb->s_inodes, struct inode, i_sb_list);
+		goto check;
+	}
+out:
+	iter->inode = inode;
+	return inode ? iter : NULL;
+}
+
+struct iter *iter_first(struct iter *iter)
+{
+	struct super_block *sb, *p;
+	struct inode *inode;
+
+	inode = NULL;
+	p = NULL;
+
+	spin_lock(&sb_lock);
+	sb = list_first_entry(&super_blocks, struct super_block, s_list);
+check:
+	if (&sb->s_list == &super_blocks)
+		sb = NULL;
+	if (sb) {
+		if (hlist_unhashed(&sb->s_instances)) {
+retry:
+			sb = list_next_entry(sb, s_list);
+			goto check;
+		}
+		sb->s_count++;
+	}
+	if (p) {
+		__put_super(p);
+		p = NULL;
+	}
+	spin_unlock(&sb_lock);
+	
+	if (!sb)
+		goto out;
+
+	down_read(&sb->s_umount);
+	if (!sb->s_root || !(sb->s_flags & MS_BORN) || !sb->s_bdi || 
+	    !bdi_cap_writeback_dirty(sb->s_bdi)) {
+		up_read(&sb->s_umount);
+		p = sb;
+		spin_lock(&sb_lock);
+		goto retry;
+	}	
+	
+	spin_lock(&inode_sb_list_lock);
+	if (list_empty(&sb->s_inodes)) {
+		spin_unlock(&inode_sb_list_lock);
+		up_read(&sb->s_umount);
+		p = sb;
+		spin_lock(&sb_lock);
+		goto retry;
+	}
+		
+	inode = list_first_entry(&sb->s_inodes, struct inode, i_sb_list);
+next:
+	if (&inode->i_sb_list == &sb->s_inodes) {
+		spin_unlock(&inode_sb_list_lock);
+		up_read(&sb->s_umount);
+		inode = NULL;
+		p = sb;
+		spin_lock(&sb_lock);
+		goto retry;
+	}
+
+	if (inode) {
+		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		   !(mapping_cap_writeback_dirty(inode->i_mapping)) ||
+		    (inode->i_mapping->nrpages == 0) ||
+		    hlist_empty(&inode->i_dentry)) {
+			spin_unlock(&inode->i_lock);
+			inode = list_next_entry(inode, i_sb_list);
+			goto next;
+		}
+		__iget(inode);
+		spin_unlock(&inode->i_lock);
+	}
+	spin_unlock(&inode_sb_list_lock);
+out:
+	iter->inode = inode;
+	return inode ? iter : NULL;
+}
+
+static int iter_init(struct iter *iter)
+{
+	memset(iter, 0, sizeof(*iter));
+	iter->buf = (char *)__get_free_pages(GFP_TEMPORARY, order_base_2(NR_PAGES));
+
+	return iter->buf ? 0 : -ENOMEM;
+}
+
+static void iter_destroy(struct iter *iter)
+{
+	free_pages((unsigned long)iter->buf, order_base_2(NR_PAGES));
+}
+
+struct inode_stat {
+	unsigned long nr_pages;
+	unsigned long nr_shadow;
+	unsigned long nr_dirty;
+	unsigned long nr_active;
+	unsigned long nr_mlocked;
+	unsigned long nr_locked;
+	unsigned long nr_reclaim;
+};
+
+static int get_inode_stat(struct inode *inode, struct inode_stat *stat)
+{
+	int ret;
+	void **slot;
+	struct radix_tree_iter iter;
+
+	ret = 0;
+	memset(stat, 0, sizeof(*stat));
+
+	rcu_read_lock();
+retry:
+	radix_tree_for_each_slot(slot, &inode->i_mapping->page_tree, &iter, 0) {
+		struct page *page;
+
+		page = radix_tree_deref_slot(slot);
+		if (unlikely(!page))
+			continue;
+		if (radix_tree_exception(page)) {
+			if (radix_tree_deref_retry(page))
+				goto retry;
+			/* we are to avoid swap backed mappings */
+			BUG();
+		}
+		if (PageDirty(page))
+			++stat->nr_dirty;
+		if (PageLocked(page))
+			++stat->nr_locked;
+		if (PageActive(page))
+			++stat->nr_active;
+		if (PageMlocked(page))
+			++stat->nr_mlocked;
+		if (PageReclaim(page))
+			++stat->nr_reclaim;
+		++ret;
+	}
+	rcu_read_unlock();
+
+	stat->nr_pages = ret;
+
+	return ret;
+}
+
+static int seq_show(struct seq_file *m, void *priv)
+{
+	int ret;
+	struct iter *iter;
+	struct inode *inode;
+	struct inode_stat stat;
+	struct path path;
+
+	if (unlikely(priv == SEQ_START_TOKEN)) {
+		seq_printf(m, "              pages               "
+			      "\t              device/path\n"
+			      "    lo     ml     di     ac     re  total\n");
+		return 0;
+	}
+
+	iter = priv;
+	inode = iter->inode;
+
+	ret = get_inode_stat(inode, &stat);
+	if (ret < 0)
+		goto out;
+
+	get_fs_root(current->fs, &path);
+	dput(path.dentry);
+	
+	/* only the name of the last instantiated link is displayed */
+	path.dentry = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
+
+	seq_printf(m, "% 6ld % 6ld % 6ld % 6ld % 6ld % 6ld\t(%u:%u)%s\n", 
+			stat.nr_locked, stat.nr_mlocked, stat.nr_dirty, 
+			stat.nr_active, stat.nr_reclaim, stat.nr_pages,
+			MAJOR(inode->i_sb->s_dev), 
+			MINOR(inode->i_sb->s_dev), 
+			d_path(&path, iter->buf, BUFSIZE));
+
+	mntput(path.mnt);
+out:
+	return 0;
+}
+
+static void *seq_next(struct seq_file *m, void *priv, loff_t *pos)
+{
+	++(*pos);
+	return (priv == SEQ_START_TOKEN) ?
+			iter_first(m->private) : 
+			iter_next(priv);
+}
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct iter *iter;
+	loff_t off;
+
+	if (!*pos)
+		return SEQ_START_TOKEN;
+
+	iter = iter_first(m->private);
+
+	for (off = 1; iter && off < *pos; ++off)
+		iter = iter_next(iter);
+
+	return iter;
+}
+
+static void seq_stop(struct seq_file *m, void *priv)
+{
+	struct iter *iter;
+	struct inode *inode;
+	struct super_block *sb;
+
+	if (priv == SEQ_START_TOKEN)
+		return;
+
+	iter = priv;
+	if (!iter)
+		return;
+	
+	inode = iter->inode;
+	if (inode) {
+		sb = inode->i_sb;
+		iput(inode);
+		up_read(&sb->s_umount);
+		put_super(sb);
+	}
+}
+
+static const struct seq_operations seq_ops = {
+	.start = seq_start,
+	.next = seq_next,
+	.stop = seq_stop,
+	.show = seq_show
+};
+
+static int page_cache_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	struct iter *iter;
+
+	ret = -ENOMEM;
+	iter = __seq_open_private(file, &seq_ops, sizeof(*iter));
+	if (!iter)
+		goto out;
+
+	ret = iter_init(iter);
+out:
+	return ret;
+}
+
+static int page_cache_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq;
+
+	seq = file->private_data;
+	iter_destroy(seq->private);
+	kfree(seq->private);
+	return seq_release(inode, file);
+}
+
+static const struct file_operations page_cache_fops = {
+	.open = page_cache_open,
+	.read = seq_read,
+	.llseek = seq_lseek, 
+	.release = page_cache_release
+};
+
+#ifndef PROCENTRY
+#define PROCENTRY "kpagecache"
+#endif
+
+static int __init page_cache_init(void)
+{
+	int ret;
+
+	ret = -ENOENT;
+
+	if (!proc_create(PROCENTRY, S_IFREG|0400, NULL, &page_cache_fops))
+		goto out;
+
+	ret = 0;
+out:
+	return ret;
+}
+module_init(page_cache_init);
+
+static void __exit page_cache_exit(void)
+{
+	remove_proc_entry(PROCENTRY, NULL);
+}
+module_exit(page_cache_exit);
+
+MODULE_LICENSE("GPL");



