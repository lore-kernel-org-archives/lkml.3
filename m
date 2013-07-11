Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3GKLHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:07:55 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49404 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab3GKLHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:07:52 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: viro@ZenIV.linux.org.uk
Cc: linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [PATCH 1/2] vfs: partial revoke implementation suggested by Al Viro
Date: Thu, 11 Jul 2013 19:07:20 +0800
Message-Id: <1373540841-30807-2-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373540841-30807-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1373540841-30807-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071110-5816-0000-0000-000008DCDF4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to partially implement what Al Viro suggested in
https://lkml.org/lkml/2013/4/5/15

Code also mostly copied from the above link

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 fs/Makefile            |    2 +-
 fs/revoke.c            |  133 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h     |    2 +
 include/linux/revoke.h |   50 ++++++++++++++++++
 4 files changed, 186 insertions(+), 1 deletion(-)
 create mode 100644 fs/revoke.c
 create mode 100644 include/linux/revoke.h

diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..af0a622 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o revoke.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/revoke.c b/fs/revoke.c
new file mode 100644
index 0000000..bcda9ba
--- /dev/null
+++ b/fs/revoke.c
@@ -0,0 +1,133 @@
+#include <linux/revoke.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+
+bool __start_using(struct revoke *revoke)
+{
+	struct revokable *r;
+	rcu_read_lock();
+	r = rcu_dereference(revoke->revokable);
+	if (unlikely(!r)) {
+		rcu_read_unlock();
+		return false;	/* revoked */
+	}
+
+	if (likely(atomic_inc_unless_negative(&r->in_use))) {
+		rcu_read_unlock();
+		return true;	/* we are using it now */
+	}
+
+	rcu_read_unlock();
+	return false;		/* it's being revoked right now */
+}
+
+#define BIAS (-1U<<31)
+
+void __stop_using(struct revoke *revoke)
+{
+	struct revokable *r;
+	r = rcu_dereference_protected(revoke->revokable, 1);
+	BUG_ON(!r);
+	if (atomic_dec_return(&r->in_use) == BIAS)
+		complete(r->c);
+}
+
+/* called with r->lock held by caller, unlocks it */
+static void __release_revoke(struct revokable *r, struct revoke *revoke)
+{
+	if (revoke->closing) {
+		DECLARE_COMPLETION_ONSTACK(c);
+		revoke->c = &c;
+		spin_unlock(&r->lock);
+		wait_for_completion(&c);
+	} else {
+		struct file *file;
+		revoke->closing = 1;
+		spin_unlock(&r->lock);
+		file = revoke->file;
+		if (file->f_op->release)
+			file->f_op->release(file_inode(file), file);
+		spin_lock(&r->lock);
+		hlist_del_init(&revoke->node);
+		rcu_assign_pointer(revoke->revokable, NULL);
+		rcu_read_lock();	/* prevent freeing of r */
+		if (revoke->c)
+			complete(revoke->c);
+		spin_unlock(&r->lock);
+		rcu_read_unlock();
+	}
+}
+
+void release_revoke(struct revoke *revoke)
+{
+	struct revokable *r;
+	rcu_read_lock();
+	r = rcu_dereference(revoke->revokable);
+	if (!r) {
+		/* already closed by revokation */
+		rcu_read_unlock();
+		goto out;
+	}
+
+	spin_lock(&r->lock);
+	if (unlikely(hlist_unhashed(&revoke->node))) {
+		/* just been revoked */
+		spin_unlock(&r->lock);
+		rcu_read_unlock();
+		goto out;
+	}
+
+	/*
+	 * Ok, revoke_it() couldn't have been finished yet
+	 * it'll have to get r->lock before it's through, so
+	 * we can drop rcu_read_lock
+	 */
+	rcu_read_unlock();
+	__release_revoke(r, revoke);
+out:
+	kfree(revoke);
+}
+
+void revoke_it(struct revokable *r)
+{
+	DECLARE_COMPLETION_ONSTACK(c);
+	r->c = &c;
+	if (atomic_add_return(BIAS, &r->in_use) != BIAS) {
+		if (r->kick)
+			r->kick(r);
+		wait_for_completion(&c);
+	}
+
+	while (1) {
+		struct hlist_node *p;
+		spin_lock(&r->lock);
+		p = r->list.first;
+		if (!p)
+			break;
+		__release_revoke(r, hlist_entry(p, struct revoke, node));
+	}
+	spin_unlock(&r->lock);
+}
+
+int make_revokable(struct file *f, struct revokable *r)
+{
+	struct revoke *revoke = kzalloc(sizeof(struct revoke), GFP_KERNEL);
+	if (!revoke)
+		return -ENOMEM;
+
+	if (!atomic_inc_unless_negative(&r->in_use)) {
+		kfree(revoke);
+		return -ENOENT;
+	}
+
+	revoke->file = f;
+	revoke->revokable = r;
+	f->f_revoke = revoke;
+
+	spin_lock(&r->lock);
+	hlist_add_head(&revoke->node, &r->list);
+	spin_unlock(&r->lock);
+
+	__stop_using(revoke);
+	return 0;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99be011..4ec9437 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -45,6 +45,7 @@ struct vfsmount;
 struct cred;
 struct swap_info_struct;
 struct seq_file;
+struct revoke;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -807,6 +808,7 @@ struct file {
 #ifdef CONFIG_DEBUG_WRITECOUNT
 	unsigned long f_mnt_write_state;
 #endif
+	struct revoke *f_revoke;
 };
 
 struct file_handle {
diff --git a/include/linux/revoke.h b/include/linux/revoke.h
new file mode 100644
index 0000000..263569b
--- /dev/null
+++ b/include/linux/revoke.h
@@ -0,0 +1,50 @@
+#ifndef _LINUX_REVOKE_H
+#define _LINUX_REVOKE_H
+
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/atomic.h>
+#include <linux/completion.h>
+#include <linux/fs.h>
+
+struct revokable {
+	atomic_t in_use;	/* number of threads in methods,*/
+				/* negative => going away */
+	spinlock_t lock;
+	struct hlist_head list;	/* protected by ->lock, goes through */
+				/* struct revoke->node */
+	struct completion *c;
+	void (*kick)(struct revokable *);
+};
+
+struct revoke {
+	struct file *file;
+	struct revokable *revokable;
+	struct hlist_node node;
+	bool closing;
+	struct completion *c;
+};
+
+bool __start_using(struct revoke *revoke);
+void __stop_using(struct revoke *revoke);
+
+static inline bool start_using(struct file *f)
+{
+	struct revoke *revoke = f->f_revoke;
+	if (likely(!revoke))
+		return true;	/* non-revokable file */
+	return __start_using(revoke);
+}
+
+static inline void stop_using(struct file *f)
+{
+	struct revoke *revoke = f->f_revoke;
+	if (unlikely(revoke))
+		__stop_using(revoke);
+}
+
+void release_revoke(struct revoke *revoke);
+void revoke_it(struct revokable *r);
+int make_revokable(struct file *f, struct revokable *r);
+
+#endif /* __LINUX_REVOKE_H */
-- 
1.7.9.5

