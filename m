Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3IJEnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:43:04 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34104 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3IJEnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:43:02 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] [RFC] seqcount: Add lockdep functionality to seqcount/seqlock structures
Date: Mon,  9 Sep 2013 21:42:46 -0700
Message-Id: <1378788166-18474-1-git-send-email-john.stultz@linaro.org>
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

Due to seqlocks/seqcounts having slightly different possible semantics
then standard locks (ie: reader->reader and reader->writer recursion is
fine, but writer->reader is not), this implementation is probably not
as exact as I'd like (currently using a hack by only spot checking
readers), and may be overly strict in some cases.

I've handled one cases where there were nested seqlock writers, and
there may be more edge cases, as while I've gotten it to run cleanly,
depending on config its reporting issues that I'm not sure if they are
flaws in the implementation or actual bugs. But I wanted to send this
out for some initial thoughts as until today I hadn't looked at much
of the lockdep infrastructure. So I'm sure there are improvements
that could be made.

Comments and feedback would be appreciated!

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/x86/vdso/vclock_gettime.c | 24 +++++++++-----
 fs/dcache.c                    |  4 +--
 fs/fs_struct.c                 |  2 +-
 include/linux/init_task.h      |  8 ++---
 include/linux/lockdep.h        | 15 +++++++++
 include/linux/seqlock.h        | 72 ++++++++++++++++++++++++++++++++++++++++--
 mm/filemap_xip.c               |  2 +-
 7 files changed, 108 insertions(+), 19 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index c74436e..1797387 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -178,13 +178,15 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 
 	ts->tv_nsec = 0;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = __read_seqcount_begin(&gtod->seq);
+		smp_rmb();
 		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
 		ns = gtod->wall_time_snsec;
 		ns += vgetsns(&mode);
 		ns >>= gtod->clock.shift;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+		smp_rmb();
+	} while (unlikely(__read_seqcount_retry(&gtod->seq, seq)));
 
 	timespec_add_ns(ts, ns);
 	return mode;
@@ -198,13 +200,15 @@ notrace static int do_monotonic(struct timespec *ts)
 
 	ts->tv_nsec = 0;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = __read_seqcount_begin(&gtod->seq);
+		smp_rmb();
 		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->monotonic_time_sec;
 		ns = gtod->monotonic_time_snsec;
 		ns += vgetsns(&mode);
 		ns >>= gtod->clock.shift;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+		smp_rmb();
+	} while (unlikely(__read_seqcount_retry(&gtod->seq, seq)));
 	timespec_add_ns(ts, ns);
 
 	return mode;
@@ -214,10 +218,12 @@ notrace static int do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = __read_seqcount_begin(&gtod->seq);
+		smp_rmb();
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+		smp_rmb();
+	} while (unlikely(__read_seqcount_retry(&gtod->seq, seq)));
 	return 0;
 }
 
@@ -225,10 +231,12 @@ notrace static int do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = read_seqcount_begin(&gtod->seq);
+		seq = __read_seqcount_begin(&gtod->seq);
+		smp_rmb();
 		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+		smp_rmb();
+	} while (unlikely(__read_seqcount_retry(&gtod->seq, seq)));
 
 	return 0;
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index 96655f4..9f97a88 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2259,7 +2259,7 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
 	dentry_lock_for_move(dentry, target);
 
 	write_seqcount_begin(&dentry->d_seq);
-	write_seqcount_begin(&target->d_seq);
+	write_seqcount_begin_nested(&target->d_seq, DENTRY_D_LOCK_NESTED);
 
 	/* __d_drop does write_seqcount_barrier, but they're OK to nest. */
 
@@ -2391,7 +2391,7 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
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
index f1e877b..75e33fa 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -510,6 +510,21 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
+#  define seqcount_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define seqcount_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
+# else
+#  define seqcount_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define seqcount_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
+# endif
+# define seqcount_release(l, n, i)		lock_release(l, n, i)
+#else
+# define seqcount_acquire(l, s, t, i)		do { } while (0)
+# define seqcount_acquire_read(l, s, t, i)	do { } while (0)
+# define seqcount_release(l, n, i)		do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
 #  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 # else
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 1829905..2178aea 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -28,6 +28,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/preempt.h>
+#include <linux/lockdep.h>
 #include <asm/processor.h>
 
 /*
@@ -38,10 +39,58 @@
  */
 typedef struct seqcount {
 	unsigned sequence;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
 } seqcount_t;
 
-#define SEQCNT_ZERO { 0 }
-#define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
+
+
+
+static inline void __seqcount_init(seqcount_t *s, const char *name,
+					  struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	lockdep_init_map(&s->dep_map, name, key, 0);
+#endif
+	s->sequence = 0;
+}
+
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
+static inline void seqcount_reader_access(const seqcount_t *s)
+{
+	seqcount_t *l = (seqcount_t *)s;
+	unsigned long flags;
+
+	preempt_disable();
+	local_irq_save(flags);
+	seqcount_acquire_read(&l->dep_map, 0, 0, _RET_IP_);
+	seqcount_release(&l->dep_map, 1, _RET_IP_);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+#else
+# define SEQCOUNT_DEP_MAP_INIT(lockname)
+# define seqcount_init(s) __seqcount_init(s, NULL, NULL)
+# define seqcount_reader_access(x)
+#endif
+
+#define SEQCNT_ZERO(lockname) { .sequence = 0, SEQCOUNT_DEP_MAP_INIT(lockname)}
+
 
 /**
  * __read_seqcount_begin - begin a seq-read critical section (without barrier)
@@ -81,6 +130,8 @@ repeat:
 static inline unsigned read_seqcount_begin(const seqcount_t *s)
 {
 	unsigned ret = __read_seqcount_begin(s);
+
+	seqcount_reader_access(s);
 	smp_rmb();
 	return ret;
 }
@@ -102,6 +153,8 @@ static inline unsigned read_seqcount_begin(const seqcount_t *s)
 static inline unsigned raw_seqcount_begin(const seqcount_t *s)
 {
 	unsigned ret = ACCESS_ONCE(s->sequence);
+
+	seqcount_reader_access(s);
 	smp_rmb();
 	return ret & ~1;
 }
@@ -150,10 +203,23 @@ static inline void write_seqcount_begin(seqcount_t *s)
 {
 	s->sequence++;
 	smp_wmb();
+	seqcount_acquire(&s->dep_map, 0, 0, _RET_IP_);
+}
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static inline void write_seqcount_begin_nested(seqcount_t *s, int subclass)
+{
+	s->sequence++;
+	smp_wmb();
+	seqcount_acquire(&s->dep_map, subclass, 0, _RET_IP_);
 }
+#else
+# define write_seqcount_begin_nested(s, subclass)	write_seqcount_begin(s)
+#endif
 
 static inline void write_seqcount_end(seqcount_t *s)
 {
+	seqcount_release(&s->dep_map, 1, _RET_IP_);
 	smp_wmb();
 	s->sequence++;
 }
@@ -182,7 +248,7 @@ typedef struct {
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

