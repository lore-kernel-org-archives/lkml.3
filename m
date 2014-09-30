Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaI3CmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:42:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbaI3Cl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:41:57 -0400
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Date: Tue, 30 Sep 2014 12:33:34 +1000
Subject: [PATCH 1/2] sysfs - allow attributes to request write buffer be
 pre-allocated.
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20140930023334.13407.83407.stgit@notabene.brown>
In-Reply-To: <20140930022205.13407.99210.stgit@notabene.brown>
References: <20140930022205.13407.99210.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

md/raid allows metadata management to be performed in user-space.
A various times, particularly on device failure, the metadata needs
to be updated before further writes can be permitted.
This means that the user-space program which updates metadata much
not block on writeout, and so must not allocate memory.

mlockall(MCL_CURRENT|MCL_FUTURE) and pre-allocation can avoid all
memory allocation issues for user-memory, but that does not help
kernel memory.
Several kernel objects can be pre-allocated.  e.g. files opened before
any writes to the array are permitted.
However some kernel allocation happen in places that cannot be
pre-allocated.
In particular, writes to sysfs files (to tell md that it can now
allow writes to the array) allocate a buffer using GFP_KERNEL.

This patch allows attributes to be marked as "PREALLOC".  In that case
the maximal buffer is allocated when the file is opened, and then used
on each write instead of allocating a new buffer.

As the same buffer is now shared for all writes on the same file
description, the mutex is extended to cover full use of the buffer
including the copy_from_user().

The new __ATTR_PREALLOC() 'or's a new flag in to the 'mode', which is
inspected by sysfs_add_file_mode_ns to determine if the file should be
marked as requiring prealloc.

Signed-off-by: NeilBrown  <neilb@suse.de>
---
 fs/kernfs/file.c       |   35 ++++++++++++++++++++++++-----------
 fs/sysfs/file.c        |   31 ++++++++++++++++++++++++-------
 include/linux/kernfs.h |    2 ++
 include/linux/sysfs.h  |    9 +++++++++
 4 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 4429d6d9217f..73bd5ed143cd 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -278,16 +278,12 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
 		len = min_t(size_t, count, PAGE_SIZE);
 	}
 
-	buf = kmalloc(len + 1, GFP_KERNEL);
+	buf = of->buf;
+	if (!buf)
+		buf = kmalloc(len + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	if (copy_from_user(buf, user_buf, len)) {
-		len = -EFAULT;
-		goto out_free;
-	}
-	buf[len] = '\0';	/* guarantee string termination */
-
 	/*
 	 * @of->mutex nests outside active ref and is just to ensure that
 	 * the ops aren't called concurrently for the same open file.
@@ -299,19 +295,27 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
 		goto out_free;
 	}
 
+	if (copy_from_user(buf, user_buf, len)) {
+		len = -EFAULT;
+		goto out_unlock;
+	}
+	buf[len] = '\0';	/* guarantee string termination */
+
 	ops = kernfs_ops(of->kn);
 	if (ops->write)
 		len = ops->write(of, buf, len, *ppos);
 	else
 		len = -EINVAL;
 
-	kernfs_put_active(of->kn);
-	mutex_unlock(&of->mutex);
-
 	if (len > 0)
 		*ppos += len;
+
+out_unlock:
+	kernfs_put_active(of->kn);
+	mutex_unlock(&of->mutex);
 out_free:
-	kfree(buf);
+	if (buf != of->buf)
+		kfree(buf);
 	return len;
 }
 
@@ -685,6 +689,13 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	 */
 	of->atomic_write_len = ops->atomic_write_len;
 
+	if (ops->prealloc) {
+		int len = of->atomic_write_len ?: PAGE_SIZE;
+		of->buf = kmalloc(len + 1, GFP_KERNEL);
+		error = -ENOMEM;
+		if (!of->buf)
+			goto err_free;
+	}
 	/*
 	 * Always instantiate seq_file even if read access doesn't use
 	 * seq_file or is not requested.  This unifies private data access
@@ -715,6 +726,7 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 err_close:
 	seq_release(inode, file);
 err_free:
+	kfree(of->buf);
 	kfree(of);
 err_out:
 	kernfs_put_active(kn);
@@ -728,6 +740,7 @@ static int kernfs_fop_release(struct inode *inode, struct file *filp)
 
 	kernfs_put_open_node(kn, of);
 	seq_release(inode, filp);
+	kfree(of->buf);
 	kfree(of);
 
 	return 0;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e9ef59b3abb1..4a959d231b43 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -184,6 +184,17 @@ static const struct kernfs_ops sysfs_file_kfops_rw = {
 	.write		= sysfs_kf_write,
 };
 
+static const struct kernfs_ops sysfs_prealloc_kfops_wo = {
+	.write		= sysfs_kf_write,
+	.prealloc	= true,
+};
+
+static const struct kernfs_ops sysfs_prealloc_kfops_rw = {
+	.seq_show	= sysfs_kf_seq_show,
+	.write		= sysfs_kf_write,
+	.prealloc	= true,
+};
+
 static const struct kernfs_ops sysfs_bin_kfops_ro = {
 	.read		= sysfs_kf_bin_read,
 };
@@ -222,13 +233,19 @@ int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 			 kobject_name(kobj)))
 			return -EINVAL;
 
-		if (sysfs_ops->show && sysfs_ops->store)
-			ops = &sysfs_file_kfops_rw;
-		else if (sysfs_ops->show)
+		if (sysfs_ops->show && sysfs_ops->store) {
+			if (mode & SYSFS_PREALLOC)
+				ops = &sysfs_prealloc_kfops_rw;
+			else
+				ops = &sysfs_file_kfops_rw;
+		} else if (sysfs_ops->show)
 			ops = &sysfs_file_kfops_ro;
-		else if (sysfs_ops->store)
-			ops = &sysfs_file_kfops_wo;
-		else
+		else if (sysfs_ops->store) {
+			if (mode & SYSFS_PREALLOC)
+				ops = &sysfs_prealloc_kfops_wo;
+			else
+				ops = &sysfs_file_kfops_wo;
+		} else
 			ops = &sysfs_file_kfops_empty;
 
 		size = PAGE_SIZE;
@@ -253,7 +270,7 @@ int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 	if (!attr->ignore_lockdep)
 		key = attr->key ?: (struct lock_class_key *)&attr->skey;
 #endif
-	kn = __kernfs_create_file(parent, attr->name, mode, size, ops,
+	kn = __kernfs_create_file(parent, attr->name, mode & 0777, size, ops,
 				  (void *)attr, ns, true, key);
 	if (IS_ERR(kn)) {
 		if (PTR_ERR(kn) == -EEXIST)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 30faf797c2c3..07c326761671 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -179,6 +179,7 @@ struct kernfs_open_file {
 	struct mutex		mutex;
 	int			event;
 	struct list_head	list;
+	char			*buf;
 
 	size_t			atomic_write_len;
 	bool			mmapped;
@@ -214,6 +215,7 @@ struct kernfs_ops {
 	 * larger ones are rejected with -E2BIG.
 	 */
 	size_t atomic_write_len;
+	bool prealloc;
 	ssize_t (*write)(struct kernfs_open_file *of, char *buf, size_t bytes,
 			 loff_t off);
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f97d0dbb59fa..ddad16148bd6 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -70,6 +70,8 @@ struct attribute_group {
  * for examples..
  */
 
+#define SYSFS_PREALLOC 010000
+
 #define __ATTR(_name, _mode, _show, _store) {				\
 	.attr = {.name = __stringify(_name),				\
 		 .mode = VERIFY_OCTAL_PERMISSIONS(_mode) },		\
@@ -77,6 +79,13 @@ struct attribute_group {
 	.store	= _store,						\
 }
 
+#define __ATTR_PREALLOC(_name, _mode, _show, _store) {			\
+	.attr = {.name = __stringify(_name),				\
+		 .mode = SYSFS_PREALLOC | VERIFY_OCTAL_PERMISSIONS(_mode) },\
+	.show	= _show,						\
+	.store	= _store,						\
+}
+
 #define __ATTR_RO(_name) {						\
 	.attr	= { .name = __stringify(_name), .mode = S_IRUGO },	\
 	.show	= _name##_show,						\


