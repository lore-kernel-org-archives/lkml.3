Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3LVKMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 05:12:30 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50337 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3LVKLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 05:11:50 -0500
From: Oren Laadan <orenl@cellrox.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>,
        Serge Hallyn <serge@hallyn.com>,
        Eric Biederman <ebiederm@xmission.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Amir Goldstein <amir@cellrox.com>, Oren Laadan <orenl@cellrox.com>
Subject: [PATCH 1/2] ipc namespace: a generic per-ipc pointer and peripc_ops
Date: Sun, 22 Dec 2013 05:07:39 -0500
Message-Id: <5133673b73339dc9c5b234926e6ca9f000ddcf98.1387706794.git.orenl@cellrox.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1387706794.git.orenl@cellrox.com>
References: <cover.1387706794.git.orenl@cellrox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a void * pointer to struct ipc_namespace. The access rules are:
1. (un)register ops with (un)register_peripc_operations()
2. call ipc_assign_generic() to put private data on the ipc_namespace
3. call ipc_access_generic() to access the private data
4. do not change the pointer during the lifetime of ipc_namespace

Modeled after generic net-ns pointers (commit dec827d), but simplified
to accommodate a single user for now (reduce code churn):
5. only one caller can register at a time
6. caller must register at boot time (not to be used by modules)

Signed-off-by: Oren Laadan <orenl@cellrox.com>
Signed-off-by: Amir Goldstein <amir@cellrox.com>
---
 include/linux/ipc_namespace.h | 29 +++++++++++++++++++++
 ipc/namespace.c               |  9 +++++++
 ipc/util.c                    | 60 +++++++++++++++++++++++++++++++++++++++++++
 ipc/util.h                    |  3 +++
 4 files changed, 101 insertions(+)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index f6c82de..72da9bf 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -70,8 +70,37 @@ struct ipc_namespace {
 	struct user_namespace *user_ns;
 
 	unsigned int	proc_inum;
+
+	/* allow others to piggyback on ipc_namesspaces */
+	void *gen;			/* for others' private stuff */
 };
 
+/*
+ * To access to the per-ipc generic data:
+ * 1. (un)register ops with (un)register_peripc_operations()
+ * 2. call ipc_assign_generic() to put private data on the ipc_namespace
+ * 3. call ipc_access_generic() to access the private data
+ * 4. do not change the pointer during the lifetime of ipc_namespace
+ *
+ * Modeled after generic net-ns pointers (commit dec827d), simplified for
+ * a single user case for now:
+ * 5. only one caller can register at a time
+ * 6. caller must register at boot time (not to be used by modules)
+ */
+struct peripc_operations {
+	int (*init)(struct ipc_namespace *);
+	void (*exit)(struct ipc_namespace *);
+};
+
+static inline void ipc_assign_generic(struct ipc_namespace *ns, void *data)
+{ ns->gen = data; }
+
+static inline void *ipc_access_generic(struct ipc_namespace *ns)
+{ return ns->gen; }
+
+extern int register_peripc_ops(struct peripc_operations *ops);
+extern void unregister_peripc_ops(struct peripc_operations *ops);
+
 extern struct ipc_namespace init_ipc_ns;
 extern atomic_t nr_ipc_ns;
 
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 59451c1..83968b6 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -33,9 +33,17 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 	}
 
 	atomic_set(&ns->count, 1);
+
+	err = init_peripc_ns(ns);
+	if (err) {
+		kfree(ns);
+		return ERR_PTR(err);
+	}
+
 	err = mq_init_ns(ns);
 	if (err) {
 		proc_free_inum(ns->proc_inum);
+		exit_peripc_ns(ns);
 		kfree(ns);
 		return ERR_PTR(err);
 	}
@@ -111,6 +119,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
+	exit_peripc_ns(ns);
 	atomic_dec(&nr_ipc_ns);
 
 	/*
diff --git a/ipc/util.c b/ipc/util.c
index 3ae17a4..8cb9949 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -71,6 +71,66 @@ struct ipc_proc_iface {
 	int (*show)(struct seq_file *, void *);
 };
 
+/* allow others to piggyback on ipc_namespace */
+static DEFINE_MUTEX(peripc_mutex);
+static struct peripc_operations *peripc_ops;
+
+/*
+ * peripc_operations is a simplified pernet_operations:
+ * - allow only one entity to register
+ * - allow to register only at boot time (no modules)
+ * (these assumptions make the code much simpler)
+ */
+
+static int init_peripc_count;
+
+/* caller hold peripc_mutex */
+int init_peripc_ns(struct ipc_namespace *ns)
+{
+	int ret = 0;
+
+	if (peripc_ops && peripc_ops->init)
+		ret = peripc_ops->init(ns);
+	if (ret == 0)
+		init_peripc_count++;
+	return ret;
+}
+
+/* caller hold peripc_mutex */
+void exit_peripc_ns(struct ipc_namespace *ns)
+{
+	if (peripc_ops && peripc_ops->exit)
+		peripc_ops->exit(ns);
+	init_peripc_count--;
+}
+
+int register_peripc_ops(struct peripc_operations *ops)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&peripc_mutex);
+	/* must be first register, and only init ipc_namespace exists */
+	if (peripc_ops == NULL && init_peripc_count == 0) {
+		peripc_ops = ops;
+		ret = init_peripc_ns(&init_ipc_ns);
+		if (ret < 0)
+			peripc_ops = NULL;
+	}
+	mutex_unlock(&peripc_mutex);
+	return ret;
+}
+
+void unregister_peripc_ops(struct peripc_operations *ops)
+{
+	mutex_lock(&peripc_mutex);
+	/* sanity:  be same as registered, and no other ipc ns (beyond init) */
+	BUG_ON(peripc_ops != ops);
+	BUG_ON(init_peripc_count != 1);
+	if (ops->exit)
+		exit_peripc_ns(&init_ipc_ns);
+	peripc_ops = NULL;
+	mutex_unlock(&peripc_mutex);
+}
 static void ipc_memory_notifier(struct work_struct *work)
 {
 	ipcns_notify(IPCNS_MEMCHANGED);
diff --git a/ipc/util.h b/ipc/util.h
index 59d78aa..daee0be 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -47,6 +47,9 @@ static inline void msg_exit_ns(struct ipc_namespace *ns) { }
 static inline void shm_exit_ns(struct ipc_namespace *ns) { }
 #endif
 
+int init_peripc_ns(struct ipc_namespace *ns);
+void exit_peripc_ns(struct ipc_namespace *ns);
+
 struct ipc_rcu {
 	struct rcu_head rcu;
 	atomic_t refcount;
-- 
1.8.3.2

