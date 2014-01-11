Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaAKSTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:19:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaAKSTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:19:06 -0500
Date: Sat, 11 Jan 2014 19:19:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] introduce __fcheck_files() to fix
	rcu_dereference_check_fdtable(), kill rcu_my_thread_group_empty()
Message-ID: <20140111181932.GB7358@redhat.com>
References: <20140107181258.GA29288@redhat.com> <20140108132852.GF10038@linux.vnet.ibm.com> <20140108151918.GA5156@redhat.com> <20140109011650.GI10038@linux.vnet.ibm.com> <20140110153459.GA31491@redhat.com> <20140111063438.GY10038@linux.vnet.ibm.com> <20140111181908.GA7358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111181908.GA7358@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_dereference_check_fdtable() looks very wrong,

1. rcu_my_thread_group_empty() was added by 844b9a8707f1 "vfs: fix
   RCU-lockdep false positive due to /proc" but it doesn't really
   fix the problem. A CLONE_THREAD (without CLONE_FILES) task can
   hit the same race with get_files_struct().

   And otoh rcu_my_thread_group_empty() can suppress the correct
   warning if the caller is the CLONE_FILES (without CLONE_THREAD)
   task.

2. files->count == 1 check is not really right too. Even if this
   files_struct is not shared it is not safe to access it lockless
   unless the caller is the owner.

   Otoh, this check is sub-optimal. files->count == 0 always means
   it is safe to use it lockless even if files != current->files,
   but put_files_struct() has to take rcu_read_lock(). See the next
   patch.

This patch removes the buggy checks and turns fcheck_files() into
__fcheck_files() which uses rcu_dereference_raw(), the "unshared"
callers, fget_light() and fget_raw_light(), can use it to avoid
the warning from RCU-lockdep.

fcheck_files() is trivially reimplemented as rcu_lockdep_assert()
plus __fcheck_files().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/file.c                |    4 ++--
 include/linux/fdtable.h  |   35 +++++++++++++++++++++--------------
 include/linux/rcupdate.h |    2 --
 kernel/rcu/update.c      |   11 -----------
 4 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 4a78f98..957cbc0 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -707,7 +707,7 @@ struct file *fget_light(unsigned int fd, int *fput_needed)
 
 	*fput_needed = 0;
 	if (atomic_read(&files->count) == 1) {
-		file = fcheck_files(files, fd);
+		file = __fcheck_files(files, fd);
 		if (file && (file->f_mode & FMODE_PATH))
 			file = NULL;
 	} else {
@@ -735,7 +735,7 @@ struct file *fget_raw_light(unsigned int fd, int *fput_needed)
 
 	*fput_needed = 0;
 	if (atomic_read(&files->count) == 1) {
-		file = fcheck_files(files, fd);
+		file = __fcheck_files(files, fd);
 	} else {
 		rcu_read_lock();
 		file = fcheck_files(files, fd);
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 085197b..70e8e21 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -59,29 +59,36 @@ struct files_struct {
 	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
 };
 
-#define rcu_dereference_check_fdtable(files, fdtfd) \
-	(rcu_dereference_check((fdtfd), \
-			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&(files)->count) == 1 || \
-			       rcu_my_thread_group_empty()))
-
-#define files_fdtable(files) \
-		(rcu_dereference_check_fdtable((files), (files)->fdt))
-
 struct file_operations;
 struct vfsmount;
 struct dentry;
 
 extern void __init files_defer_init(void);
 
-static inline struct file * fcheck_files(struct files_struct *files, unsigned int fd)
+#define rcu_dereference_check_fdtable(files, fdtfd) \
+	rcu_dereference_check((fdtfd), lockdep_is_held(&(files)->file_lock))
+
+#define files_fdtable(files) \
+	rcu_dereference_check_fdtable((files), (files)->fdt)
+
+/*
+ * The caller must ensure that fd table isn't shared or hold rcu or file lock
+ */
+static inline struct file *__fcheck_files(struct files_struct *files, unsigned int fd)
 {
-	struct file * file = NULL;
-	struct fdtable *fdt = files_fdtable(files);
+	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
 
 	if (fd < fdt->max_fds)
-		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
-	return file;
+		return rcu_dereference_raw(fdt->fd[fd]);
+	return NULL;
+}
+
+static inline struct file *fcheck_files(struct files_struct *files, unsigned int fd)
+{
+	rcu_lockdep_assert(rcu_read_lock_held() ||
+			   lockdep_is_held(&files->file_lock),
+			   "suspicious rcu_dereference_check() usage");
+	return __fcheck_files(files, fd);
 }
 
 /*
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 39cbb88..a2482cf 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -448,8 +448,6 @@ static inline int rcu_read_lock_sched_held(void)
 
 #ifdef CONFIG_PROVE_RCU
 
-extern int rcu_my_thread_group_empty(void);
-
 /**
  * rcu_lockdep_assert - emit lockdep splat if specified condition not met
  * @c: condition to check
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 6cb3dff..a3596c8 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -195,17 +195,6 @@ void wait_rcu_gp(call_rcu_func_t crf)
 }
 EXPORT_SYMBOL_GPL(wait_rcu_gp);
 
-#ifdef CONFIG_PROVE_RCU
-/*
- * wrapper function to avoid #include problems.
- */
-int rcu_my_thread_group_empty(void)
-{
-	return thread_group_empty(current);
-}
-EXPORT_SYMBOL_GPL(rcu_my_thread_group_empty);
-#endif /* #ifdef CONFIG_PROVE_RCU */
-
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
 static inline void debug_init_rcu_head(struct rcu_head *head)
 {
-- 
1.5.5.1


