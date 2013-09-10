Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3IJTSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:18:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53037 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3IJTSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:18:11 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] [RFC v2] seqcount: Add lockdep functionality to seqcount/seqlock structures
Date: Tue, 10 Sep 2013 12:17:57 -0700
Message-Id: <1378840677-21635-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently seqlocks and seqcounts don't support lockdep.

After running across a seqcount related deadlock in the timekeeping
code, I used a less-refined and more focused varient of this patch
to narrow down the cause of the issue.

This is a first-pass attempt to properly enable lockdep functionality
on seqlocks and seqcounts.

Since seqcounts are used in the vdso gettimeofday code, I've provided
lockdep accessors.

I've also handled one cases where there were nested seqlock writers
but there may be more edge cases yet to address.

Comments and feedback would be appreciated!

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
v2:
 * Update to new simplified lockdep.h
 * vdso accessor simplifications
 * removed needless preempt_disable
 * removed unneeded ifdefs

 arch/x86/vdso/vclock_gettime.c |  8 ++---
 fs/dcache.c                    |  4 +--
 fs/fs_struct.c                 |  2 +-
 include/linux/init_task.h      |  8 ++---
 include/linux/lockdep.h        |  8 +++--
 include/linux/seqlock.h        | 79 ++++++++++++++++++++++++++++++++++++++----
 mm/filemap_xip.c               |  2 +-
 7 files changed, 91 insertions(+), 20 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 72074d5..2ada505 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -178,7 +178,7 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 
 	ts->tv_nsec = 0;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = read_seqcount_begin_no_lockdep(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
 		ns = gtod->wall_time_snsec;
@@ -198,7 +198,7 @@ notrace static int do_monotonic(struct timespec *ts)
 
 	ts->tv_nsec = 0;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = read_seqcount_begin_no_lockdep(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->monotonic_time_sec;
 		ns = gtod->monotonic_time_snsec;
@@ -214,7 +214,7 @@ notrace static int do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = read_seqcount_begin_no_lockdep(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
@@ -225,7 +225,7 @@ notrace static int do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = read_seqcount_begin_no_lockdep(&gtod->seq);
 		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
diff --git a/fs/dcache.c b/fs/dcache.c
index ca8e9cd..5e59bd3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2396,7 +2396,7 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
 	dentry_lock_for_move(dentry, target);
 
 	write_seqcount_begin(&dentry->d_seq);
-	write_seqcount_begin(&target->d_seq);
+	write_seqcount_begin_nested(&target->d_seq, DENTRY_D_LOCK_NESTED);
 
 	/* __d_drop does write_seqcount_barrier, but they're OK to nest. */
 
@@ -2528,7 +2528,7 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	dentry_lock_for_move(anon, dentry);
 
 	write_seqcount_begin(&dentry->d_seq);
-	write_seqcount_begin(&anon->d_seq);
+	write_seqcount_begin_nested(&anon->d_seq, DENTRY_D_LOCK_NESTED);
 
 	dparent = dentry->d_parent;
 
diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index d8ac61d..7dca743 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -161,6 +161,6 @@ EXPORT_SYMBOL(current_umask);
 struct fs_struct init_fs = {
 	.users		= 1,
 	.lock		= __SPIN_LOCK_UNLOCKED(init_fs.lock),
-	.seq		= SEQCNT_ZERO,
+	.seq		= SEQCNT_ZERO(init_fs.seq),
 	.umask		= 0022,
 };
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 5cd0f09..b0ed422 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -32,10 +32,10 @@ extern struct fs_struct init_fs;
 #endif
 
 #ifdef CONFIG_CPUSETS
-#define INIT_CPUSET_SEQ							\
-	.mems_allowed_seq = SEQCNT_ZERO,
+#define INIT_CPUSET_SEQ(tsk)							\
+	.mems_allowed_seq = SEQCNT_ZERO(tsk.mems_allowed_seq),
 #else
-#define INIT_CPUSET_SEQ
+#define INIT_CPUSET_SEQ(tsk)
 #endif
 
 #define INIT_SIGNALS(sig) {						\
@@ -220,7 +220,7 @@ extern struct task_group root_task_group;
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
-	INIT_CPUSET_SEQ							\
+	INIT_CPUSET_SEQ(tsk)						\
 	INIT_VTIME(tsk)							\
 }
 
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index cfc2f11..92b1bfc 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -497,6 +497,10 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 #define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
 #define rwlock_release(l, n, i)			lock_release(l, n, i)
 
+#define seqcount_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define seqcount_acquire_read(l, s, t, i)	lock_acquire_shared_recursive(l, s, t, NULL, i)
+#define seqcount_release(l, n, i)		lock_release(l, n, i)
+
 #define mutex_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
 #define mutex_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
 #define mutex_release(l, n, i)			lock_release(l, n, i)
@@ -504,11 +508,11 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 #define rwsem_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
 #define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
 #define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared(l, s, t, NULL, i)
-# define rwsem_release(l, n, i)			lock_release(l, n, i)
+#define rwsem_release(l, n, i)			lock_release(l, n, i)
 
 #define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
 #define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
-# define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
+#define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
 
 #ifdef CONFIG_PROVE_LOCKING
 # define might_lock(lock) 						\
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 1829905..c633b5d 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -28,6 +28,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/preempt.h>
+#include <linux/lockdep.h>
 #include <asm/processor.h>
 
 /*
@@ -38,10 +39,50 @@
  */
 typedef struct seqcount {
 	unsigned sequence;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
 } seqcount_t;
 
-#define SEQCNT_ZERO { 0 }
-#define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
+static inline void __seqcount_init(seqcount_t *s, const char *name,
+					  struct lock_class_key *key)
+{
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	lockdep_init_map(&s->dep_map, name, key, 0);
+	s->sequence = 0;
+}
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define SEQCOUNT_DEP_MAP_INIT(lockname) \
+		.dep_map = { .name = #lockname } \
+
+# define seqcount_init(s)				\
+	do {						\
+		static struct lock_class_key __key;	\
+		__seqcount_init((s), #s, &__key);	\
+	} while (0)
+
+static inline void seqcount_lockdep_reader_access(const seqcount_t *s)
+{
+	seqcount_t *l = (seqcount_t *)s;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	seqcount_acquire_read(&l->dep_map, 0, 0, _RET_IP_);
+	seqcount_release(&l->dep_map, 1, _RET_IP_);
+	local_irq_restore(flags);
+}
+
+#else
+# define SEQCOUNT_DEP_MAP_INIT(lockname)
+# define seqcount_init(s) __seqcount_init(s, NULL, NULL)
+# define seqcount_lockdep_reader_access(x)
+#endif
+
+#define SEQCNT_ZERO(lockname) { .sequence = 0, SEQCOUNT_DEP_MAP_INIT(lockname)}
+
 
 /**
  * __read_seqcount_begin - begin a seq-read critical section (without barrier)
@@ -70,6 +111,22 @@ repeat:
 }
 
 /**
+ * read_seqcount_begin_no_lockdep - start seq-read critical section w/o lockdep
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * read_seqcount_begin_no_lockdep opens a read critical section of the given
+ * seqcount, but without any lockdep checking. Validity of the critical
+ * section is tested by checking read_seqcount_retry function.
+ */
+static inline unsigned read_seqcount_begin_no_lockdep(const seqcount_t *s)
+{
+	unsigned ret = __read_seqcount_begin(s);
+	smp_rmb();
+	return ret;
+}
+
+/**
  * read_seqcount_begin - begin a seq-read critical section
  * @s: pointer to seqcount_t
  * Returns: count to be passed to read_seqcount_retry
@@ -80,9 +137,8 @@ repeat:
  */
 static inline unsigned read_seqcount_begin(const seqcount_t *s)
 {
-	unsigned ret = __read_seqcount_begin(s);
-	smp_rmb();
-	return ret;
+	seqcount_lockdep_reader_access(s);
+	return read_seqcount_begin_no_lockdep(s);
 }
 
 /**
@@ -102,6 +158,8 @@ static inline unsigned read_seqcount_begin(const seqcount_t *s)
 static inline unsigned raw_seqcount_begin(const seqcount_t *s)
 {
 	unsigned ret = ACCESS_ONCE(s->sequence);
+
+	seqcount_lockdep_reader_access(s);
 	smp_rmb();
 	return ret & ~1;
 }
@@ -150,10 +208,19 @@ static inline void write_seqcount_begin(seqcount_t *s)
 {
 	s->sequence++;
 	smp_wmb();
+	seqcount_acquire(&s->dep_map, 0, 0, _RET_IP_);
+}
+
+static inline void write_seqcount_begin_nested(seqcount_t *s, int subclass)
+{
+	s->sequence++;
+	smp_wmb();
+	seqcount_acquire(&s->dep_map, subclass, 0, _RET_IP_);
 }
 
 static inline void write_seqcount_end(seqcount_t *s)
 {
+	seqcount_release(&s->dep_map, 1, _RET_IP_);
 	smp_wmb();
 	s->sequence++;
 }
@@ -182,7 +249,7 @@ typedef struct {
  */
 #define __SEQLOCK_UNLOCKED(lockname)			\
 	{						\
-		.seqcount = SEQCNT_ZERO,		\
+		.seqcount = SEQCNT_ZERO(lockname),	\
 		.lock =	__SPIN_LOCK_UNLOCKED(lockname)	\
 	}
 
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 28fe26b..d8d9fe3 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -26,7 +26,7 @@
  * of ZERO_PAGE(), such as /dev/zero
  */
 static DEFINE_MUTEX(xip_sparse_mutex);
-static seqcount_t xip_sparse_seq = SEQCNT_ZERO;
+static seqcount_t xip_sparse_seq = SEQCNT_ZERO(xip_sparse_seq);
 static struct page *__xip_sparse_page;
 
 /* called under xip_sparse_mutex */
-- 
1.8.1.2

