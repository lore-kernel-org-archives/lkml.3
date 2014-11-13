Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556AbaKMWLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:11:45 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:58602 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765AbaKMWLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:11:43 -0500
Date: Thu, 13 Nov 2014 17:11:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
Message-ID: <20141113221139.GG2598@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113220927.GF2598@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inode->i_devices is a list_head used to link device inodes to the
corresponding block_device or cdev.  This patch makes block_device and
cdev usfe ptrset to keep track of the inodes instead of linking
inode->i_devices allowing removal of the field and thus reduction of
struct inode by two pointers.

The conversion is staright-forward.  list_add() is replaced with
preloaded ptrset_add(), list_del_init() with ptrset_del(), and list
iteration with ptrset_for_each().  The only part which isn't direct
one-to-one mapping is the error handling after ptrset_add() failure.

The saved two pointers will be used by cgroup writback support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/block_dev.c       |   39 +++++++++++++++++++++++----------------
 fs/char_dev.c        |   25 +++++++++++++++----------
 fs/inode.c           |    1 -
 include/linux/cdev.h |    4 ++--
 include/linux/fs.h   |    4 ++--
 5 files changed, 42 insertions(+), 31 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -458,7 +458,7 @@ static void init_once(void *foo)
 
 	memset(bdev, 0, sizeof(*bdev));
 	mutex_init(&bdev->bd_mutex);
-	INIT_LIST_HEAD(&bdev->bd_inodes);
+	ptrset_init(&bdev->bd_inodes);
 	INIT_LIST_HEAD(&bdev->bd_list);
 #ifdef CONFIG_SYSFS
 	INIT_LIST_HEAD(&bdev->bd_holder_disks);
@@ -470,7 +470,7 @@ static void init_once(void *foo)
 
 static inline void __bd_forget(struct inode *inode)
 {
-	list_del_init(&inode->i_devices);
+	ptrset_del(inode, &inode->i_bdev->bd_inodes);
 	inode->i_bdev = NULL;
 	inode->i_mapping = &inode->i_data;
 }
@@ -478,14 +478,15 @@ static inline void __bd_forget(struct in
 static void bdev_evict_inode(struct inode *inode)
 {
 	struct block_device *bdev = &BDEV_I(inode)->bdev;
-	struct list_head *p;
+	struct ptrset_iter iter;
+	struct inode *bd_inode;
+
 	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode); /* is it needed here? */
 	clear_inode(inode);
 	spin_lock(&bdev_lock);
-	while ( (p = bdev->bd_inodes.next) != &bdev->bd_inodes ) {
-		__bd_forget(list_entry(p, struct inode, i_devices));
-	}
+	ptrset_for_each(bd_inode, &bdev->bd_inodes, &iter)
+		__bd_forget(bd_inode);
 	list_del_init(&bdev->bd_list);
 	spin_unlock(&bdev_lock);
 }
@@ -634,20 +635,26 @@ static struct block_device *bd_acquire(s
 
 	bdev = bdget(inode->i_rdev);
 	if (bdev) {
+		ptrset_preload(GFP_KERNEL);
 		spin_lock(&bdev_lock);
 		if (!inode->i_bdev) {
-			/*
-			 * We take an additional reference to bd_inode,
-			 * and it's released in clear_inode() of inode.
-			 * So, we can access it via ->i_mapping always
-			 * without igrab().
-			 */
-			ihold(bdev->bd_inode);
-			inode->i_bdev = bdev;
-			inode->i_mapping = bdev->bd_inode->i_mapping;
-			list_add(&inode->i_devices, &bdev->bd_inodes);
+			if (!ptrset_add(inode, &bdev->bd_inodes, GFP_NOWAIT)) {
+				/*
+				 * We take an additional reference to bd_inode,
+				 * and it's released in clear_inode() of inode.
+				 * So, we can access it via ->i_mapping always
+				 * without igrab().
+				 */
+				ihold(bdev->bd_inode);
+				inode->i_bdev = bdev;
+				inode->i_mapping = bdev->bd_inode->i_mapping;
+			} else {
+				bdput(bdev);
+				bdev = NULL;
+			}
 		}
 		spin_unlock(&bdev_lock);
+		ptrset_preload_end();
 	}
 	return bdev;
 }
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -383,16 +383,20 @@ static int chrdev_open(struct inode *ino
 		if (!kobj)
 			return -ENXIO;
 		new = container_of(kobj, struct cdev, kobj);
+		ptrset_preload(GFP_KERNEL);
 		spin_lock(&cdev_lock);
 		/* Check i_cdev again in case somebody beat us to it while
 		   we dropped the lock. */
 		p = inode->i_cdev;
 		if (!p) {
-			inode->i_cdev = p = new;
-			list_add(&inode->i_devices, &p->list);
-			new = NULL;
+			ret = ptrset_add(inode, &new->inodes, GFP_NOWAIT);
+			if (!ret) {
+				inode->i_cdev = p = new;
+				new = NULL;
+			}
 		} else if (!cdev_get(p))
 			ret = -ENXIO;
+		ptrset_preload_end();
 	} else if (!cdev_get(p))
 		ret = -ENXIO;
 	spin_unlock(&cdev_lock);
@@ -422,18 +426,19 @@ static int chrdev_open(struct inode *ino
 void cd_forget(struct inode *inode)
 {
 	spin_lock(&cdev_lock);
-	list_del_init(&inode->i_devices);
+	ptrset_del(inode, &inode->i_cdev->inodes);
 	inode->i_cdev = NULL;
 	spin_unlock(&cdev_lock);
 }
 
 static void cdev_purge(struct cdev *cdev)
 {
+	struct inode *inode;
+	struct ptrset_iter iter;
+
 	spin_lock(&cdev_lock);
-	while (!list_empty(&cdev->list)) {
-		struct inode *inode;
-		inode = container_of(cdev->list.next, struct inode, i_devices);
-		list_del_init(&inode->i_devices);
+	ptrset_for_each(inode, &cdev->inodes, &iter) {
+		ptrset_del(inode, &cdev->inodes);
 		inode->i_cdev = NULL;
 	}
 	spin_unlock(&cdev_lock);
@@ -543,7 +548,7 @@ struct cdev *cdev_alloc(void)
 {
 	struct cdev *p = kzalloc(sizeof(struct cdev), GFP_KERNEL);
 	if (p) {
-		INIT_LIST_HEAD(&p->list);
+		ptrset_init(&p->inodes);
 		kobject_init(&p->kobj, &ktype_cdev_dynamic);
 	}
 	return p;
@@ -560,7 +565,7 @@ struct cdev *cdev_alloc(void)
 void cdev_init(struct cdev *cdev, const struct file_operations *fops)
 {
 	memset(cdev, 0, sizeof *cdev);
-	INIT_LIST_HEAD(&cdev->list);
+	ptrset_init(&cdev->inodes);
 	kobject_init(&cdev->kobj, &ktype_cdev_default);
 	cdev->ops = fops;
 }
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -366,7 +366,6 @@ void inode_init_once(struct inode *inode
 {
 	memset(inode, 0, sizeof(*inode));
 	INIT_HLIST_NODE(&inode->i_hash);
-	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_wb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
 	address_space_init_once(&inode->i_data);
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -3,7 +3,7 @@
 
 #include <linux/kobject.h>
 #include <linux/kdev_t.h>
-#include <linux/list.h>
+#include <linux/ptrset.h>
 
 struct file_operations;
 struct inode;
@@ -13,7 +13,7 @@ struct cdev {
 	struct kobject kobj;
 	struct module *owner;
 	const struct file_operations *ops;
-	struct list_head list;
+	struct ptrset inodes;
 	dev_t dev;
 	unsigned int count;
 };
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -28,6 +28,7 @@
 #include <linux/uidgid.h>
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
+#include <linux/ptrset.h>
 #include <linux/blk_types.h>
 
 #include <asm/byteorder.h>
@@ -426,7 +427,7 @@ struct block_device {
 	struct inode *		bd_inode;	/* will die */
 	struct super_block *	bd_super;
 	struct mutex		bd_mutex;	/* open/close mutex */
-	struct list_head	bd_inodes;
+	struct ptrset		bd_inodes;
 	void *			bd_claiming;
 	void *			bd_holder;
 	int			bd_holders;
@@ -609,7 +610,6 @@ struct inode {
 #ifdef CONFIG_QUOTA
 	struct dquot		*i_dquot[MAXQUOTAS];
 #endif
-	struct list_head	i_devices;
 	union {
 		struct pipe_inode_info	*i_pipe;
 		struct block_device	*i_bdev;
