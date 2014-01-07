Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaAGSOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:14:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaAGSOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:14:01 -0500
Date: Tue, 7 Jan 2014 19:13:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] introduce __fcheck_files() to fix
	rcu_dereference_check_fdtable(), kill rcu_my_thread_group_empty()
Message-ID: <20140107181317.GA29306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107181258.GA29288@redhat.com>
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

This patch removes the buggy checks and adds the new helper which
simply does rcu_lock_acquire/release around fcheck_files(). The
files->count == 1 callers, fget_light() and fget_raw_light(), can
use this helper to avoid the warning from RCU-lockdep.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/file.c                |    4 ++--
 include/linux/fdtable.h  |   19 +++++++++++++------
 include/linux/rcupdate.h |    2 --
 kernel/rcu/update.c      |   11 -----------
 4 files changed, 15 insertions(+), 21 deletions(-)

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
index 085197b..f39d50a 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -60,10 +60,7 @@ struct files_struct {
 };
 
 #define rcu_dereference_check_fdtable(files, fdtfd) \
-	(rcu_dereference_check((fdtfd), \
-			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&(files)->count) == 1 || \
-			       rcu_my_thread_group_empty()))
+	rcu_dereference_check((fdtfd), lockdep_is_held(&(files)->file_lock))
 
 #define files_fdtable(files) \
 		(rcu_dereference_check_fdtable((files), (files)->fdt))
@@ -74,9 +71,9 @@ struct dentry;
 
 extern void __init files_defer_init(void);
 
-static inline struct file * fcheck_files(struct files_struct *files, unsigned int fd)
+static inline struct file *fcheck_files(struct files_struct *files, unsigned int fd)
 {
-	struct file * file = NULL;
+	struct file *file = NULL;
 	struct fdtable *fdt = files_fdtable(files);
 
 	if (fd < fdt->max_fds)
@@ -84,6 +81,16 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
 	return file;
 }
 
+/* The caller must ensure that fd table isn't shared */
+static inline struct file *__fcheck_files(struct files_struct *files, unsigned int fd)
+{
+	struct file *file;
+	/* make rcu_dereference_check_fdtable() happy */
+	rcu_lock_acquire(&rcu_lock_map);
+	file = fcheck_files(files, fd);
+	rcu_lock_release(&rcu_lock_map);
+	return file;
+}
 /*
  * Check whether the specified fd has an open file.
  */
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

