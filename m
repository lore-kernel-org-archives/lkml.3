Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbaHLS6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:58:42 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37656 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaHLS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:57:36 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 2/4] vfs: add revoke() helpers
Date: Tue, 12 Aug 2014 20:54:06 +0200
Message-Id: <1407869648-1449-3-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
References: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds generic VFS helpers to revoke file access. By default,
revoke() support is disabled for all files. Drivers need to call
make_revokable() in their f_op->open() callback to enable it for a given
file.

If a file is marked revokable, VFS core tracks all tasks inside file->f_op
callbacks. Once a file is revoked, we prevent new tasks from entering
those callbacks and synchronously wait for existing tasks to leave them.
Once all tasks are done, we call f_op->release() early, so the device
driver can detach the file.

Each file description can be revoked independently by calling
revoke_file(). This prevents new tasks from entering any file->f_op
callbacks, but does *not* wait for existing tasks. You have to call
drain_file() to explicitly wait for any pending file-operations to finish.
In between revoke_file() and drain_file(), you must wake up any sleeping
file-operations to make sure drain_file() can complete in finite time.
This makes drain_file() device dependent. In case we want to implement
generic revoke() syscalls, we need a f_op->kick() callback that is called
in between both calls.

Once make_revokable() was called, file->f_revoke points to a
"struct revokable_file" object which contains revoke() management data.
Additionally, each revokable file must be linked to an object of type
"struct revokable_device". The device object is usually attached to the
parent inode of the revokable files, but no such restriction is enforced.
Revokable devices manage attached files and can be used to revoke access
to all attached files at once. That is, calling revoke_device() is
equivalent to calling revoke_file() on *all* open file descriptions
attached to the device. This is non-trivial, though. Hence, we provide a
generic implementation for it.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 fs/Makefile            |   2 +-
 fs/file_table.c        |   4 +-
 fs/revoke.c            | 194 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h     |   2 +
 include/linux/revoke.h | 124 +++++++++++++++++++++++++++++++
 5 files changed, 323 insertions(+), 3 deletions(-)
 create mode 100644 fs/revoke.c
 create mode 100644 include/linux/revoke.h

diff --git a/fs/Makefile b/fs/Makefile
index 4030cbf..33ac82d 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o revoke.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o block_dev.o direct-io.o mpage.o
diff --git a/fs/file_table.c b/fs/file_table.c
index 385bfd3..a8555cc 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -26,6 +26,7 @@
 #include <linux/hardirq.h>
 #include <linux/task_work.h>
 #include <linux/ima.h>
+#include <linux/revoke.h>
 
 #include <linux/atomic.h>
 
@@ -212,8 +213,7 @@ static void __fput(struct file *file)
 			file->f_op->fasync(-1, file, 0);
 	}
 	ima_file_free(file);
-	if (file->f_op->release)
-		file->f_op->release(inode, file);
+	release_file(file);
 	security_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
 		     !(file->f_mode & FMODE_PATH))) {
diff --git a/fs/revoke.c b/fs/revoke.c
new file mode 100644
index 0000000..6a38f78
--- /dev/null
+++ b/fs/revoke.c
@@ -0,0 +1,194 @@
+/*
+ * File Access Revocation
+ * Written 2014 by David Herrmann <dh.herrmann@gmail.com>
+ */
+
+#include <linux/atomic.h>
+#include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/kactive.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/revoke.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+
+static void release_drained_file(struct revokable_file *rf)
+{
+	struct revokable_device *dev = rf->device;
+	struct file *file = rf->file;
+
+	hlist_del_init(&rf->node);
+	hlist_add_head(&rf->node, &dev->revoked_files);
+	rf->device = NULL;
+
+	spin_unlock_irq(&dev->lock);
+	if (file->f_op->release)
+		file->f_op->release(file->f_inode, file);
+	spin_lock_irq(&dev->lock);
+
+	hlist_del_init(&rf->node);
+}
+
+/* callback for locked kactive_disable() */
+static void ____release_drained_revokable(struct kactive *active)
+{
+	release_drained_file(container_of(active, struct revokable_file,
+					  active));
+}
+
+/* callback for unlocked kactive_disable() */
+void __release_drained_revokable(struct kactive *active)
+{
+	struct revokable_file *rf = container_of(active, struct revokable_file,
+						 active);
+	struct revokable_device *dev = rf->device;
+
+	spin_lock_irq(&dev->lock);
+	release_drained_file(rf);
+	spin_unlock_irq(&dev->lock);
+}
+EXPORT_SYMBOL_GPL(__release_drained_revokable);
+
+int make_revokable(struct revokable_device *dev, struct file *file)
+{
+	struct revokable_file *rf;
+	int retval;
+
+	if (dev->revoked)
+		return -ENODEV;
+
+	rf = kzalloc(sizeof(*rf), GFP_KERNEL);
+	if (!rf)
+		return -ENOMEM;
+
+	INIT_HLIST_NODE(&rf->node);
+	rf->waitq = &dev->waitq;
+	rf->file = file;
+	rf->device = dev;
+	kactive_init(&rf->active);
+	kactive_enable(&rf->active);
+	atomic_set(&rf->drain_count, 0);
+
+	spin_lock_irq(&dev->lock);
+	if (dev->revoked) {
+		retval = -ENODEV;
+	} else {
+		file->f_revoke = rf;
+		hlist_add_head(&rf->node, &dev->active_files);
+		retval = 0;
+	}
+	spin_unlock_irq(&dev->lock);
+
+	if (retval)
+		kfree(rf);
+	return retval;
+}
+EXPORT_SYMBOL_GPL(make_revokable);
+
+void release_file(struct file *file)
+{
+	struct revokable_file *rf = file->f_revoke;
+
+	if (rf) {
+		/*
+		 * There cannot be any active ref left, so all kactive_drain()
+		 * does is wait for possible parallel kactive_disable() calls
+		 * to finish.
+		 */
+		kactive_disable(&rf->active, rf->waitq,
+				__release_drained_revokable);
+		kactive_drain(&rf->active, rf->waitq);
+		kfree(rf);
+	} else if (file->f_op->release) {
+		file->f_op->release(file->f_inode, file);
+	}
+}
+
+void revoke_file(struct file *file)
+{
+	struct revokable_file *rf = file->f_revoke;
+
+	if (WARN_ON(!rf))
+		return;
+
+	kactive_disable(&rf->active, rf->waitq, __release_drained_revokable);
+}
+EXPORT_SYMBOL_GPL(revoke_file);
+
+void drain_file(struct file *file)
+{
+	struct revokable_file *rf = file->f_revoke;
+
+	if (WARN_ON(!rf))
+		return;
+
+	revoke_file(file);
+	kactive_drain(&rf->active, rf->waitq);
+}
+EXPORT_SYMBOL_GPL(drain_file);
+
+void drain_file_self(struct file *file)
+{
+	struct revokable_file *rf = file->f_revoke;
+
+	if (WARN_ON(!rf))
+		return;
+
+	revoke_file(file);
+	kactive_drain_self(&rf->active, rf->waitq, 1, &rf->drain_count);
+}
+EXPORT_SYMBOL_GPL(drain_file_self);
+
+void init_revokable_device(struct revokable_device *dev)
+{
+	INIT_HLIST_HEAD(&dev->active_files);
+	INIT_HLIST_HEAD(&dev->revoked_files);
+	init_waitqueue_head(&dev->waitq);
+	spin_lock_init(&dev->lock);
+	dev->revoked = false;
+}
+EXPORT_SYMBOL_GPL(init_revokable_device);
+
+void revoke_device(struct revokable_device *dev)
+{
+	struct revokable_file *rf;
+
+	spin_lock_irq(&dev->lock);
+	dev->revoked = true;
+	while (!hlist_empty(&dev->active_files)) {
+		rf = to_revokable_safe(dev->active_files.first);
+		hlist_del_init(&rf->node);
+		hlist_add_head(&rf->node, &dev->revoked_files);
+
+		/*
+		 * Call kactive_disable() with device->lock held to protect
+		 * against parallel file release. It might drop the lock
+		 * temporarily when calling into f_op->release(), though.
+		 */
+		kactive_disable(&rf->active, rf->waitq,
+				____release_drained_revokable);
+	}
+	spin_unlock_irq(&dev->lock);
+}
+EXPORT_SYMBOL_GPL(revoke_device);
+
+static bool device_is_drained(struct revokable_device *dev)
+{
+	bool drained;
+
+	spin_lock_irq(&dev->lock);
+	drained = dev->revoked &&
+			hlist_empty(&dev->active_files) &&
+			hlist_empty(&dev->revoked_files);
+	spin_unlock_irq(&dev->lock);
+
+	return drained;
+}
+
+void drain_device(struct revokable_device *dev)
+{
+	revoke_device(dev);
+	wait_event(dev->waitq, device_is_drained(dev));
+}
+EXPORT_SYMBOL_GPL(drain_device);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f0890e4..6230f29 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -49,6 +49,7 @@ struct swap_info_struct;
 struct seq_file;
 struct workqueue_struct;
 struct iov_iter;
+struct revokable_file;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -792,6 +793,7 @@ struct file {
 	struct fown_struct	f_owner;
 	const struct cred	*f_cred;
 	struct file_ra_state	f_ra;
+	struct revokable_file	*f_revoke;
 
 	u64			f_version;
 #ifdef CONFIG_SECURITY
diff --git a/include/linux/revoke.h b/include/linux/revoke.h
new file mode 100644
index 0000000..a466902
--- /dev/null
+++ b/include/linux/revoke.h
@@ -0,0 +1,124 @@
+#ifndef _LINUX_REVOKE_H
+#define _LINUX_REVOKE_H
+
+/*
+ * File Access Revocation
+ * Written 2014 by David Herrmann <dh.herrmann@gmail.com>
+ */
+
+#include <linux/atomic.h>
+#include <linux/fs.h>
+#include <linux/kactive.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/wait.h>
+
+struct revokable_device {
+	struct hlist_head		active_files;
+	struct hlist_head		revoked_files;
+	wait_queue_head_t		waitq;
+	spinlock_t			lock;
+	bool				revoked : 1;
+};
+
+struct revokable_file {
+	struct hlist_node		node;
+	wait_queue_head_t		*waitq;
+	struct file			*file;
+	struct revokable_device		*device;
+	struct kactive			active;
+	atomic_t			drain_count;
+};
+
+#define to_revokable_safe(_hlist_node) hlist_entry_safe((_hlist_node), \
+						struct revokable_file, node)
+
+void init_revokable_device(struct revokable_device *dev);
+void revoke_device(struct revokable_device *dev);
+void drain_device(struct revokable_device *dev);
+
+int make_revokable(struct revokable_device *dev, struct file *file);
+void __release_drained_revokable(struct kactive *active);
+void release_file(struct file *file);
+void revoke_file(struct file *file);
+void drain_file(struct file *file);
+void drain_file_self(struct file *file);
+
+static inline bool device_is_revoked(struct revokable_device *dev)
+{
+	return dev->revoked;
+}
+
+static inline bool file_is_revoked(struct file *file)
+{
+	return file->f_revoke && kactive_is_disabled(&file->f_revoke->active);
+}
+
+static inline bool enter_file(struct file *file)
+{
+	return file->f_revoke ? kactive_get(&file->f_revoke->active) : true;
+}
+
+static inline void leave_file(struct file *file)
+{
+	if (file->f_revoke)
+		kactive_put(&file->f_revoke->active,
+			    file->f_revoke->waitq,
+			    __release_drained_revokable);
+}
+
+/*
+ * revokable_device iterator
+ */
+
+struct revokable_iter {
+	struct hlist_node *pos;
+	unsigned int current_list : 2;
+};
+
+static inline struct revokable_file*
+__next_revokable(struct revokable_device *dev, struct revokable_iter *iter)
+{
+	do {
+		if (iter->pos) {
+			iter->pos = iter->pos->next;
+		} else {
+			--iter->current_list;
+			if (iter->current_list == 2)
+				iter->pos = dev->active_files.first;
+			else if (iter->current_list == 1)
+				iter->pos = dev->revoked_files.first;
+		}
+	} while ((iter->pos && !to_revokable_safe(iter->pos)->device) ||
+		 (!iter->pos && iter->current_list > 0));
+	return to_revokable_safe(iter->pos);
+}
+
+static inline void *__next_revokable_private(struct revokable_device *dev,
+					     struct revokable_iter *iter)
+{
+	__next_revokable(dev, iter);
+	if (!iter->pos)
+		return NULL;
+	return to_revokable_safe(iter->pos)->file->private_data;
+}
+
+#define REVOKABLE_ITER_INIT \
+		((struct revokable_iter){ .pos = NULL, .current_list = 3 })
+
+static inline void revokable_iter_init(struct revokable_iter *iter)
+{
+	*iter = REVOKABLE_ITER_INIT;
+}
+
+#define for_each_revokable(_pos, _iter, _dev)				\
+	for (_pos = __next_revokable((_dev), (_iter));			\
+		(_iter)->pos;						\
+		_pos = __next_revokable((_dev), (_iter)))
+
+#define for_each_revokable_private(_pos, _iter, _dev)			\
+	for (_pos = __next_revokable_private((_dev), (_iter));		\
+		(_iter)->pos;						\
+		_pos = __next_revokable_private((_dev), (_iter)))
+
+#endif /* _LINUX_REVOKE_H */
-- 
2.0.4

