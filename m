Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3IPWUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:20:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49474 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3IPWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:20:28 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v5 01/10] VFS hot tracking: Define basic data structures and functions
Date: Tue, 17 Sep 2013 06:17:46 +0800
Message-Id: <1379369875-5123-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
References: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091622-9332-0000-0000-0000016FFDB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

This patch includes the basic data structure and functions needed for
VFS hot tracking.

It adds hot_inode_tree struct to keep track of frequently accessed
files, and is keyed by {inode, offset}. Trees contain hot_inode_items
representing those files and hot_range_items representing ranges in that
file.

It defines a data structure hot_info, which is associated with a mounted
filesystem, and will be used to store the inode tree and range tree for
hot items pertaining to that filesystem.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/Makefile                  |   2 +-
 fs/dcache.c                  |   2 +
 fs/hot_tracking.c            | 230 +++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |  20 ++++
 include/linux/fs.h           |   4 +
 include/linux/hot_tracking.h |  84 ++++++++++++++++
 6 files changed, 341 insertions(+), 1 deletion(-)
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..5f9b8f1 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o hot_tracking.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/dcache.c b/fs/dcache.c
index 1bd4614..cd73bb9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,6 +38,7 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/hot_tracking.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -3363,4 +3364,5 @@ void __init vfs_caches_init(unsigned long mempages)
 	mnt_init();
 	bdev_cache_init();
 	chrdev_init();
+	hot_cache_init();
 }
diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
new file mode 100644
index 0000000..bb82a8d
--- /dev/null
+++ b/fs/hot_tracking.c
@@ -0,0 +1,230 @@
+/*
+ * fs/hot_tracking.c
+ *
+ * Copyright (C) 2013 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#include <linux/list.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include "hot_tracking.h"
+
+/* kmem_cache pointers for slab caches */
+static struct kmem_cache *hot_inode_item_cachep __read_mostly;
+static struct kmem_cache *hot_range_item_cachep __read_mostly;
+
+static void hot_range_item_init(struct hot_range_item *hr,
+			struct hot_inode_item *he, loff_t start)
+{
+	kref_init(&hr->refs);
+	hr->start = start;
+	hr->len = hot_bit_shift(1, RANGE_BITS, true);
+	hr->hot_inode = he;
+}
+
+static void hot_range_item_free_cb(struct rcu_head *head)
+{
+	struct hot_range_item *hr = container_of(head,
+				struct hot_range_item, rcu);
+
+	kmem_cache_free(hot_range_item_cachep, hr);
+}
+
+static void hot_range_item_free(struct kref *kref)
+{
+	struct hot_range_item *hr = container_of(kref,
+				struct hot_range_item, refs);
+
+	rb_erase(&hr->rb_node, &hr->hot_inode->hot_range_tree);
+
+	call_rcu(&hr->rcu, hot_range_item_free_cb);
+}
+
+void hot_range_item_get(struct hot_range_item *hr)
+{
+        kref_get(&hr->refs);
+}
+EXPORT_SYMBOL_GPL(hot_range_item_get);
+
+/*
+ * Drops the reference out on hot_range_item by one
+ * and free the structure if the reference count hits zero
+ */
+void hot_range_item_put(struct hot_range_item *hr)
+{
+        kref_put(&hr->refs, hot_range_item_free);
+}
+EXPORT_SYMBOL_GPL(hot_range_item_put);
+
+/*
+ * Free the entire hot_range_tree.
+ */
+static void hot_range_tree_free(struct hot_inode_item *he)
+{
+	struct rb_node *node;
+	struct hot_range_item *hr;
+
+	/* Free hot inode and range trees on fs root */
+	spin_lock(&he->i_lock);
+	node = rb_first(&he->hot_range_tree);
+	while (node) {
+		hr = rb_entry(node, struct hot_range_item, rb_node);
+		node = rb_next(node);
+		hot_range_item_put(hr);
+	}
+	spin_unlock(&he->i_lock);
+}
+
+static void hot_inode_item_init(struct hot_inode_item *he,
+			struct hot_info *root, u64 ino)
+{
+	kref_init(&he->refs);
+	he->ino = ino;
+	he->hot_root = root;
+	spin_lock_init(&he->i_lock);
+}
+
+static void hot_inode_item_free_cb(struct rcu_head *head)
+{
+	struct hot_inode_item *he = container_of(head,
+				struct hot_inode_item, rcu);
+
+	kmem_cache_free(hot_inode_item_cachep, he);
+}
+
+static void hot_inode_item_free(struct kref *kref)
+{
+	struct hot_inode_item *he = container_of(kref,
+				struct hot_inode_item, refs);
+
+	rb_erase(&he->rb_node, &he->hot_root->hot_inode_tree);
+	hot_range_tree_free(he);
+
+	call_rcu(&he->rcu, hot_inode_item_free_cb);
+}
+
+void hot_inode_item_get(struct hot_inode_item *he)
+{
+        kref_get(&he->refs);
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_get);
+
+/*
+ * Drops the reference out on hot_inode_item by one
+ * and free the structure if the reference count hits zero
+ */
+void hot_inode_item_put(struct hot_inode_item *he)
+{
+        kref_put(&he->refs, hot_inode_item_free);
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_put);
+
+/*
+ * Initialize kmem cache for hot_inode_item and hot_range_item.
+ */
+void __init hot_cache_init(void)
+{
+	hot_inode_item_cachep = KMEM_CACHE(hot_inode_item,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD);
+	if (!hot_inode_item_cachep)
+		return;
+
+	hot_range_item_cachep = KMEM_CACHE(hot_range_item,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD);
+	if (!hot_range_item_cachep)
+		kmem_cache_destroy(hot_inode_item_cachep);
+}
+EXPORT_SYMBOL_GPL(hot_cache_init);
+
+static struct hot_info *hot_tree_init(struct super_block *sb)
+{
+	struct hot_info *root;
+	int i, j;
+
+	root = kzalloc(sizeof(struct hot_info), GFP_NOFS);
+	if (!root) {
+		printk(KERN_ERR "%s: Failed to malloc memory for "
+				"hot_info\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	root->hot_inode_tree = RB_ROOT;
+	spin_lock_init(&root->t_lock);
+
+	return root;
+}
+
+/*
+ * Frees the entire hot tree.
+ */
+static void hot_tree_exit(struct hot_info *root)
+{
+	struct hot_inode_item *he;
+	struct rb_node *node;
+
+	spin_lock(&root->t_lock);
+	node = rb_first(&root->hot_inode_tree);
+	while (node) {
+		he = rb_entry(node, struct hot_inode_item, rb_node);
+		node = rb_next(node);
+		hot_inode_item_put(he);
+	}
+	spin_unlock(&root->t_lock);
+}
+
+/*
+ * Initialize the data structures for hot tracking.
+ * This function will be called by *_fill_super()
+ * when filesystem is mounted.
+ */
+int hot_track_init(struct super_block *sb)
+{
+	struct hot_info *root;
+	int ret = 0;
+
+	if (!hot_inode_item_cachep || !hot_range_item_cachep) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	root = hot_tree_init(sb);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto err;
+	}
+
+	sb->s_hot_root = root;
+
+	printk(KERN_INFO "VFS: Turning on hot tracking\n");
+
+	return ret;
+
+err:
+	sb->s_hot_root = NULL;
+
+	printk(KERN_ERR "VFS: Fail to turn on hot tracking\n");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hot_track_init);
+
+/*
+ * This function will be called by *_put_super()
+ * when filesystem is umounted, or also by *_fill_super()
+ * in some exceptional cases.
+ */
+void hot_track_exit(struct super_block *sb)
+{
+	struct hot_info *root = sb->s_hot_root;
+
+	sb->s_hot_root = NULL;
+	hot_tree_exit(root);
+	rcu_barrier();
+	kfree(root);
+}
+EXPORT_SYMBOL_GPL(hot_track_exit);
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
new file mode 100644
index 0000000..2776092
--- /dev/null
+++ b/fs/hot_tracking.h
@@ -0,0 +1,20 @@
+/*
+ * fs/hot_tracking.h
+ *
+ * Copyright (C) 2013 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef __HOT_TRACKING__
+#define __HOT_TRACKING__
+
+#include <linux/hot_tracking.h>
+
+/* size of sub-file ranges */
+#define RANGE_BITS 20
+
+#endif /* __HOT_TRACKING__ */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a4acd3c..c0e0581 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -29,6 +29,7 @@
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/blk_types.h>
+#include <linux/hot_tracking.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1324,6 +1325,9 @@ struct super_block {
 	/* AIO completions deferred from interrupt context */
 	struct workqueue_struct *s_dio_done_wq;
 
+	/* Hot data tracking*/
+	struct hot_info *s_hot_root;
+
 	/*
 	 * Keep the lru lists last in the structure so they always sit on their
 	 * own individual cachelines.
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
new file mode 100644
index 0000000..4112af2
--- /dev/null
+++ b/include/linux/hot_tracking.h
@@ -0,0 +1,84 @@
+/*
+ *  include/linux/hot_tracking.h
+ *
+ * This file has definitions for VFS hot tracking
+ * structures etc.
+ *
+ * Copyright (C) 2013 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_HOTTRACK_H
+#define _LINUX_HOTTRACK_H
+
+#include <linux/types.h>
+#include <linux/slab.h>
+
+#ifdef __KERNEL__
+
+#include <linux/rbtree.h>
+#include <linux/kref.h>
+#include <linux/fs.h>
+
+#define MAP_BITS 8
+#define MAP_SIZE (1 << MAP_BITS)
+
+/* values for hot_freq flags */
+enum {
+	TYPE_INODE = 0,
+	TYPE_RANGE,
+	MAX_TYPES,
+};
+
+/* An item representing an inode and its access frequency */
+struct hot_inode_item {
+	struct kref refs;
+	struct rb_node rb_node;         /* rbtree index */
+	struct rcu_head rcu;
+	struct rb_root hot_range_tree;	/* tree of ranges */
+	spinlock_t i_lock;		/* protect above tree */
+	struct hot_info *hot_root;	/* associated hot_info */
+	u64 ino;			/* inode number from inode */
+};
+
+/*
+ * An item representing a range inside of
+ * an inode whose frequency is being tracked
+ */
+struct hot_range_item {
+	struct kref refs;
+	struct rb_node rb_node;                 /* rbtree index */
+	struct rcu_head rcu;
+	struct hot_inode_item *hot_inode;	/* associated hot_inode_item */
+	loff_t start;				/* offset in bytes */
+	size_t len;				/* length in bytes */
+};
+
+struct hot_info {
+	struct rb_root hot_inode_tree;
+	spinlock_t t_lock;				/* protect above tree */
+};
+
+extern void __init hot_cache_init(void);
+extern int hot_track_init(struct super_block *sb);
+extern void hot_track_exit(struct super_block *sb);
+extern void hot_range_item_put(struct hot_range_item *hr);
+extern void hot_inode_item_put(struct hot_inode_item *he);
+extern void hot_range_item_get(struct hot_range_item *hr);
+extern void hot_inode_item_get(struct hot_inode_item *he);
+
+static inline u64 hot_bit_shift(u64 counter, u32 bits, bool dir)
+{
+	if (dir)
+		return counter << bits;
+	else
+		return counter >> bits;
+}
+
+#endif /* __KERNEL__ */
+
+#endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.11.7

