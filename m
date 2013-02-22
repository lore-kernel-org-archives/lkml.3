Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3BVNTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:19:16 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45228 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab3BVNTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:19:12 -0500
Date: Fri, 22 Feb 2013 14:19:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking changes for v3.9
Message-ID: <20130222131908.GA8058@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   HEAD: 41ef8f826692c8f65882bec0a8211bd4d1d2d19a rwsem-spinlock: Implement writer lock-stealing for better scalability

The biggest change is the rwsem lock-steal improvements, both to 
the assembly optimized and the spinlock based variants.

The other notable change is the clean up of the seqlock 
implementation to be based on the seqcount infrastructure.

The rest is assorted smaller debuggability, cleanup and 
continued -rt locking changes.

 Thanks,

	Ingo

------------------>
Alex Shi (1):
      rwsem: Implement writer lock-stealing for better scalability

Ben Greear (1):
      lockdep: Print more info when MAX_LOCK_DEPTH is exceeded

Ingo Molnar (1):
      generic: Use raw local irq variant for generic cmpxchg

Mike Galbraith (1):
      intel_idle: Convert i7300_idle_lock to raw_spinlock

Namhyung Kim (1):
      watchdog: Use local_clock for get_timestamp()

Paul Bolle (1):
      lockdep: Silence warning if CONFIG_LOCKDEP isn't set

Srivatsa S. Bhat (1):
      lockdep: Rename print_unlock_inbalance_bug() to print_unlock_imbalance_bug()

Thomas Gleixner (5):
      locking: Various static lock initializer fixes
      ntp: Make ntp_lock raw
      seqlock: Remove unused functions
      seqlock: Use seqcount infrastructure
      futex: Revert "futex: Mark get_robust_list as deprecated"

Yong Zhang (1):
      lockdep: Selftest: convert spinlock to raw spinlock

Yuanhan Liu (2):
      locking/stat: Fix a typo
      rwsem-spinlock: Implement writer lock-stealing for better scalability


 Documentation/lockstat.txt          |   2 +-
 drivers/char/random.c               |   6 +-
 drivers/idle/i7300_idle.c           |   8 +-
 drivers/usb/chipidea/debug.c        |   2 +-
 fs/file.c                           |   2 +-
 include/asm-generic/cmpxchg-local.h |   8 +-
 include/linux/idr.h                 |   2 +-
 include/linux/lockdep.h             |   2 +-
 include/linux/seqlock.h             | 193 +++++++++++++++++-------------------
 kernel/futex.c                      |   2 -
 kernel/futex_compat.c               |   2 -
 kernel/lockdep.c                    |  15 ++-
 kernel/time/ntp.c                   |  26 ++---
 kernel/watchdog.c                   |  10 +-
 lib/locking-selftest.c              |  34 +++----
 lib/rwsem-spinlock.c                |  69 +++++--------
 lib/rwsem.c                         |  75 ++++++++------
 17 files changed, 221 insertions(+), 237 deletions(-)

diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index cef00d4..dd2f7b2 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -65,7 +65,7 @@ that had to wait on lock acquisition.
 
  - CONFIGURATION
 
-Lock statistics are enabled via CONFIG_LOCK_STATS.
+Lock statistics are enabled via CONFIG_LOCK_STAT.
 
  - USAGE
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 85e81ec..594bda9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -445,7 +445,7 @@ static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
 	.name = "input",
 	.limit = 1,
-	.lock = __SPIN_LOCK_UNLOCKED(&input_pool.lock),
+	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 	.pool = input_pool_data
 };
 
@@ -454,7 +454,7 @@ static struct entropy_store blocking_pool = {
 	.name = "blocking",
 	.limit = 1,
 	.pull = &input_pool,
-	.lock = __SPIN_LOCK_UNLOCKED(&blocking_pool.lock),
+	.lock = __SPIN_LOCK_UNLOCKED(blocking_pool.lock),
 	.pool = blocking_pool_data
 };
 
@@ -462,7 +462,7 @@ static struct entropy_store nonblocking_pool = {
 	.poolinfo = &poolinfo_table[1],
 	.name = "nonblocking",
 	.pull = &input_pool,
-	.lock = __SPIN_LOCK_UNLOCKED(&nonblocking_pool.lock),
+	.lock = __SPIN_LOCK_UNLOCKED(nonblocking_pool.lock),
 	.pool = nonblocking_pool_data
 };
 
diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index fa080eb..ffeebc7 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -75,7 +75,7 @@ static unsigned long past_skip;
 
 static struct pci_dev *fbd_dev;
 
-static spinlock_t i7300_idle_lock;
+static raw_spinlock_t i7300_idle_lock;
 static int i7300_idle_active;
 
 static u8 i7300_idle_thrtctl_saved;
@@ -457,7 +457,7 @@ static int i7300_idle_notifier(struct notifier_block *nb, unsigned long val,
 		idle_begin_time = ktime_get();
 	}
 
-	spin_lock_irqsave(&i7300_idle_lock, flags);
+	raw_spin_lock_irqsave(&i7300_idle_lock, flags);
 	if (val == IDLE_START) {
 
 		cpumask_set_cpu(smp_processor_id(), idle_cpumask);
@@ -506,7 +506,7 @@ static int i7300_idle_notifier(struct notifier_block *nb, unsigned long val,
 		}
 	}
 end:
-	spin_unlock_irqrestore(&i7300_idle_lock, flags);
+	raw_spin_unlock_irqrestore(&i7300_idle_lock, flags);
 	return 0;
 }
 
@@ -548,7 +548,7 @@ struct debugfs_file_info {
 
 static int __init i7300_idle_init(void)
 {
-	spin_lock_init(&i7300_idle_lock);
+	raw_spin_lock_init(&i7300_idle_lock);
 	total_us = 0;
 
 	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev, forceload))
diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index 3bc244d..a62c4a4 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -222,7 +222,7 @@ static struct {
 } dbg_data = {
 	.idx = 0,
 	.tty = 0,
-	.lck = __RW_LOCK_UNLOCKED(lck)
+	.lck = __RW_LOCK_UNLOCKED(dbg_data.lck)
 };
 
 /**
diff --git a/fs/file.c b/fs/file.c
index 2b3570b..3906d95 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -516,7 +516,7 @@ struct files_struct init_files = {
 		.close_on_exec	= init_files.close_on_exec_init,
 		.open_fds	= init_files.open_fds_init,
 	},
-	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
+	.file_lock	= __SPIN_LOCK_UNLOCKED(init_files.file_lock),
 };
 
 /*
diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
index 2533fdd..d8d4c89 100644
--- a/include/asm-generic/cmpxchg-local.h
+++ b/include/asm-generic/cmpxchg-local.h
@@ -21,7 +21,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
 	if (size == 8 && sizeof(unsigned long) != 8)
 		wrong_size_cmpxchg(ptr);
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	switch (size) {
 	case 1: prev = *(u8 *)ptr;
 		if (prev == old)
@@ -42,7 +42,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
 	default:
 		wrong_size_cmpxchg(ptr);
 	}
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 	return prev;
 }
 
@@ -55,11 +55,11 @@ static inline u64 __cmpxchg64_local_generic(volatile void *ptr,
 	u64 prev;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	prev = *(u64 *)ptr;
 	if (prev == old)
 		*(u64 *)ptr = new;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 	return prev;
 }
 
diff --git a/include/linux/idr.h b/include/linux/idr.h
index de7e190..e5eb125 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -136,7 +136,7 @@ struct ida {
 	struct ida_bitmap	*free_bitmap;
 };
 
-#define IDA_INIT(name)		{ .idr = IDR_INIT(name), .free_bitmap = NULL, }
+#define IDA_INIT(name)		{ .idr = IDR_INIT((name).idr), .free_bitmap = NULL, }
 #define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
 
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask);
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2bca44b..f05631e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -410,7 +410,7 @@ struct lock_class_key { };
 
 #define lockdep_depth(tsk)	(0)
 
-#define lockdep_assert_held(l)			do { } while (0)
+#define lockdep_assert_held(l)			do { (void)(l); } while (0)
 
 #define lockdep_recursing(tsk)			(0)
 
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 600060e2..1829905 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -30,92 +30,12 @@
 #include <linux/preempt.h>
 #include <asm/processor.h>
 
-typedef struct {
-	unsigned sequence;
-	spinlock_t lock;
-} seqlock_t;
-
-/*
- * These macros triggered gcc-3.x compile-time problems.  We think these are
- * OK now.  Be cautious.
- */
-#define __SEQLOCK_UNLOCKED(lockname) \
-		 { 0, __SPIN_LOCK_UNLOCKED(lockname) }
-
-#define seqlock_init(x)					\
-	do {						\
-		(x)->sequence = 0;			\
-		spin_lock_init(&(x)->lock);		\
-	} while (0)
-
-#define DEFINE_SEQLOCK(x) \
-		seqlock_t x = __SEQLOCK_UNLOCKED(x)
-
-/* Lock out other writers and update the count.
- * Acts like a normal spin_lock/unlock.
- * Don't need preempt_disable() because that is in the spin_lock already.
- */
-static inline void write_seqlock(seqlock_t *sl)
-{
-	spin_lock(&sl->lock);
-	++sl->sequence;
-	smp_wmb();
-}
-
-static inline void write_sequnlock(seqlock_t *sl)
-{
-	smp_wmb();
-	sl->sequence++;
-	spin_unlock(&sl->lock);
-}
-
-static inline int write_tryseqlock(seqlock_t *sl)
-{
-	int ret = spin_trylock(&sl->lock);
-
-	if (ret) {
-		++sl->sequence;
-		smp_wmb();
-	}
-	return ret;
-}
-
-/* Start of read calculation -- fetch last complete writer token */
-static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
-{
-	unsigned ret;
-
-repeat:
-	ret = ACCESS_ONCE(sl->sequence);
-	if (unlikely(ret & 1)) {
-		cpu_relax();
-		goto repeat;
-	}
-	smp_rmb();
-
-	return ret;
-}
-
-/*
- * Test if reader processed invalid data.
- *
- * If sequence value changed then writer changed data while in section.
- */
-static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
-{
-	smp_rmb();
-
-	return unlikely(sl->sequence != start);
-}
-
-
 /*
  * Version using sequence counter only.
  * This can be used when code has its own mutex protecting the
  * updating starting before the write_seqcountbeqin() and ending
  * after the write_seqcount_end().
  */
-
 typedef struct seqcount {
 	unsigned sequence;
 } seqcount_t;
@@ -218,7 +138,6 @@ static inline int __read_seqcount_retry(const seqcount_t *s, unsigned start)
 static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 {
 	smp_rmb();
-
 	return __read_seqcount_retry(s, start);
 }
 
@@ -252,31 +171,101 @@ static inline void write_seqcount_barrier(seqcount_t *s)
 	s->sequence+=2;
 }
 
+typedef struct {
+	struct seqcount seqcount;
+	spinlock_t lock;
+} seqlock_t;
+
 /*
- * Possible sw/hw IRQ protected versions of the interfaces.
+ * These macros triggered gcc-3.x compile-time problems.  We think these are
+ * OK now.  Be cautious.
  */
-#define write_seqlock_irqsave(lock, flags)				\
-	do { local_irq_save(flags); write_seqlock(lock); } while (0)
-#define write_seqlock_irq(lock)						\
-	do { local_irq_disable();   write_seqlock(lock); } while (0)
-#define write_seqlock_bh(lock)						\
-        do { local_bh_disable();    write_seqlock(lock); } while (0)
+#define __SEQLOCK_UNLOCKED(lockname)			\
+	{						\
+		.seqcount = SEQCNT_ZERO,		\
+		.lock =	__SPIN_LOCK_UNLOCKED(lockname)	\
+	}
+
+#define seqlock_init(x)					\
+	do {						\
+		seqcount_init(&(x)->seqcount);		\
+		spin_lock_init(&(x)->lock);		\
+	} while (0)
 
-#define write_sequnlock_irqrestore(lock, flags)				\
-	do { write_sequnlock(lock); local_irq_restore(flags); } while(0)
-#define write_sequnlock_irq(lock)					\
-	do { write_sequnlock(lock); local_irq_enable(); } while(0)
-#define write_sequnlock_bh(lock)					\
-	do { write_sequnlock(lock); local_bh_enable(); } while(0)
+#define DEFINE_SEQLOCK(x) \
+		seqlock_t x = __SEQLOCK_UNLOCKED(x)
 
-#define read_seqbegin_irqsave(lock, flags)				\
-	({ local_irq_save(flags);   read_seqbegin(lock); })
+/*
+ * Read side functions for starting and finalizing a read side section.
+ */
+static inline unsigned read_seqbegin(const seqlock_t *sl)
+{
+	return read_seqcount_begin(&sl->seqcount);
+}
 
-#define read_seqretry_irqrestore(lock, iv, flags)			\
-	({								\
-		int ret = read_seqretry(lock, iv);			\
-		local_irq_restore(flags);				\
-		ret;							\
-	})
+static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
+{
+	return read_seqcount_retry(&sl->seqcount, start);
+}
+
+/*
+ * Lock out other writers and update the count.
+ * Acts like a normal spin_lock/unlock.
+ * Don't need preempt_disable() because that is in the spin_lock already.
+ */
+static inline void write_seqlock(seqlock_t *sl)
+{
+	spin_lock(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_sequnlock(seqlock_t *sl)
+{
+	write_seqcount_end(&sl->seqcount);
+	spin_unlock(&sl->lock);
+}
+
+static inline void write_seqlock_bh(seqlock_t *sl)
+{
+	spin_lock_bh(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_sequnlock_bh(seqlock_t *sl)
+{
+	write_seqcount_end(&sl->seqcount);
+	spin_unlock_bh(&sl->lock);
+}
+
+static inline void write_seqlock_irq(seqlock_t *sl)
+{
+	spin_lock_irq(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_sequnlock_irq(seqlock_t *sl)
+{
+	write_seqcount_end(&sl->seqcount);
+	spin_unlock_irq(&sl->lock);
+}
+
+static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sl->lock, flags);
+	write_seqcount_begin(&sl->seqcount);
+	return flags;
+}
+
+#define write_seqlock_irqsave(lock, flags)				\
+	do { flags = __write_seqlock_irqsave(lock); } while (0)
+
+static inline void
+write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
+{
+	write_seqcount_end(&sl->seqcount);
+	spin_unlock_irqrestore(&sl->lock, flags);
+}
 
 #endif /* __LINUX_SEQLOCK_H */
diff --git a/kernel/futex.c b/kernel/futex.c
index 19eb089..8879430 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2471,8 +2471,6 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 83e368b..a9642d5 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -142,8 +142,6 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7981e5b..8a0efac 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3190,9 +3190,14 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 #endif
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
-		printk("BUG: MAX_LOCK_DEPTH too low!\n");
+		printk("BUG: MAX_LOCK_DEPTH too low, depth: %i  max: %lu!\n",
+		       curr->lockdep_depth, MAX_LOCK_DEPTH);
 		printk("turning off the locking correctness validator.\n");
+
+		lockdep_print_held_locks(current);
+		debug_show_all_locks();
 		dump_stack();
+
 		return 0;
 	}
 
@@ -3203,7 +3208,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 }
 
 static int
-print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
+print_unlock_imbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 			   unsigned long ip)
 {
 	if (!debug_locks_off())
@@ -3246,7 +3251,7 @@ static int check_unlock(struct task_struct *curr, struct lockdep_map *lock,
 		return 0;
 
 	if (curr->lockdep_depth <= 0)
-		return print_unlock_inbalance_bug(curr, lock, ip);
+		return print_unlock_imbalance_bug(curr, lock, ip);
 
 	return 1;
 }
@@ -3317,7 +3322,7 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 			goto found_it;
 		prev_hlock = hlock;
 	}
-	return print_unlock_inbalance_bug(curr, lock, ip);
+	return print_unlock_imbalance_bug(curr, lock, ip);
 
 found_it:
 	lockdep_init_map(lock, name, key, 0);
@@ -3384,7 +3389,7 @@ lock_release_non_nested(struct task_struct *curr,
 			goto found_it;
 		prev_hlock = hlock;
 	}
-	return print_unlock_inbalance_bug(curr, lock, ip);
+	return print_unlock_imbalance_bug(curr, lock, ip);
 
 found_it:
 	if (hlock->instance == lock)
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 24174b4..bb1edfa 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -22,7 +22,7 @@
  * NTP timekeeping variables:
  */
 
-DEFINE_SPINLOCK(ntp_lock);
+DEFINE_RAW_SPINLOCK(ntp_lock);
 
 
 /* USER_HZ period (usecs): */
@@ -347,7 +347,7 @@ void ntp_clear(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ntp_lock, flags);
+	raw_spin_lock_irqsave(&ntp_lock, flags);
 
 	time_adjust	= 0;		/* stop active adjtime() */
 	time_status	|= STA_UNSYNC;
@@ -361,7 +361,7 @@ void ntp_clear(void)
 
 	/* Clear PPS state variables */
 	pps_clear();
-	spin_unlock_irqrestore(&ntp_lock, flags);
+	raw_spin_unlock_irqrestore(&ntp_lock, flags);
 
 }
 
@@ -371,9 +371,9 @@ u64 ntp_tick_length(void)
 	unsigned long flags;
 	s64 ret;
 
-	spin_lock_irqsave(&ntp_lock, flags);
+	raw_spin_lock_irqsave(&ntp_lock, flags);
 	ret = tick_length;
-	spin_unlock_irqrestore(&ntp_lock, flags);
+	raw_spin_unlock_irqrestore(&ntp_lock, flags);
 	return ret;
 }
 
@@ -394,7 +394,7 @@ int second_overflow(unsigned long secs)
 	int leap = 0;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ntp_lock, flags);
+	raw_spin_lock_irqsave(&ntp_lock, flags);
 
 	/*
 	 * Leap second processing. If in leap-insert state at the end of the
@@ -478,7 +478,7 @@ int second_overflow(unsigned long secs)
 	time_adjust = 0;
 
 out:
-	spin_unlock_irqrestore(&ntp_lock, flags);
+	raw_spin_unlock_irqrestore(&ntp_lock, flags);
 
 	return leap;
 }
@@ -660,7 +660,7 @@ int do_adjtimex(struct timex *txc)
 
 	getnstimeofday(&ts);
 
-	spin_lock_irq(&ntp_lock);
+	raw_spin_lock_irq(&ntp_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
@@ -702,7 +702,7 @@ int do_adjtimex(struct timex *txc)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	spin_unlock_irq(&ntp_lock);
+	raw_spin_unlock_irq(&ntp_lock);
 
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
@@ -900,7 +900,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-	spin_lock_irqsave(&ntp_lock, flags);
+	raw_spin_lock_irqsave(&ntp_lock, flags);
 
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
@@ -913,7 +913,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		spin_unlock_irqrestore(&ntp_lock, flags);
+		raw_spin_unlock_irqrestore(&ntp_lock, flags);
 		return;
 	}
 
@@ -928,7 +928,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		spin_unlock_irqrestore(&ntp_lock, flags);
+		raw_spin_unlock_irqrestore(&ntp_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -945,7 +945,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	spin_unlock_irqrestore(&ntp_lock, flags);
+	raw_spin_unlock_irqrestore(&ntp_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..082ca68 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -112,9 +112,9 @@ static int get_softlockup_thresh(void)
  * resolution, and we don't need to waste time with a big divide when
  * 2^30ns == 1.074s.
  */
-static unsigned long get_timestamp(int this_cpu)
+static unsigned long get_timestamp(void)
 {
-	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
+	return local_clock() >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
 static void set_sample_period(void)
@@ -132,9 +132,7 @@ static void set_sample_period(void)
 /* Commands for resetting the watchdog */
 static void __touch_watchdog(void)
 {
-	int this_cpu = smp_processor_id();
-
-	__this_cpu_write(watchdog_touch_ts, get_timestamp(this_cpu));
+	__this_cpu_write(watchdog_touch_ts, get_timestamp());
 }
 
 void touch_softlockup_watchdog(void)
@@ -195,7 +193,7 @@ static int is_hardlockup(void)
 
 static int is_softlockup(unsigned long touch_ts)
 {
-	unsigned long now = get_timestamp(smp_processor_id());
+	unsigned long now = get_timestamp();
 
 	/* Warn about unreasonable delays: */
 	if (time_after(now, touch_ts + get_softlockup_thresh()))
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 7aae0f2..c3eb261 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -47,10 +47,10 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
  * Normal standalone locks, for the circular and irq-context
  * dependency tests:
  */
-static DEFINE_SPINLOCK(lock_A);
-static DEFINE_SPINLOCK(lock_B);
-static DEFINE_SPINLOCK(lock_C);
-static DEFINE_SPINLOCK(lock_D);
+static DEFINE_RAW_SPINLOCK(lock_A);
+static DEFINE_RAW_SPINLOCK(lock_B);
+static DEFINE_RAW_SPINLOCK(lock_C);
+static DEFINE_RAW_SPINLOCK(lock_D);
 
 static DEFINE_RWLOCK(rwlock_A);
 static DEFINE_RWLOCK(rwlock_B);
@@ -73,12 +73,12 @@ static DECLARE_RWSEM(rwsem_D);
  * but X* and Y* are different classes. We do this so that
  * we do not trigger a real lockup:
  */
-static DEFINE_SPINLOCK(lock_X1);
-static DEFINE_SPINLOCK(lock_X2);
-static DEFINE_SPINLOCK(lock_Y1);
-static DEFINE_SPINLOCK(lock_Y2);
-static DEFINE_SPINLOCK(lock_Z1);
-static DEFINE_SPINLOCK(lock_Z2);
+static DEFINE_RAW_SPINLOCK(lock_X1);
+static DEFINE_RAW_SPINLOCK(lock_X2);
+static DEFINE_RAW_SPINLOCK(lock_Y1);
+static DEFINE_RAW_SPINLOCK(lock_Y2);
+static DEFINE_RAW_SPINLOCK(lock_Z1);
+static DEFINE_RAW_SPINLOCK(lock_Z2);
 
 static DEFINE_RWLOCK(rwlock_X1);
 static DEFINE_RWLOCK(rwlock_X2);
@@ -107,10 +107,10 @@ static DECLARE_RWSEM(rwsem_Z2);
  */
 #define INIT_CLASS_FUNC(class) 				\
 static noinline void					\
-init_class_##class(spinlock_t *lock, rwlock_t *rwlock, struct mutex *mutex, \
-		 struct rw_semaphore *rwsem)		\
+init_class_##class(raw_spinlock_t *lock, rwlock_t *rwlock, \
+	struct mutex *mutex, struct rw_semaphore *rwsem)\
 {							\
-	spin_lock_init(lock);				\
+	raw_spin_lock_init(lock);			\
 	rwlock_init(rwlock);				\
 	mutex_init(mutex);				\
 	init_rwsem(rwsem);				\
@@ -168,10 +168,10 @@ static void init_shared_classes(void)
  * Shortcuts for lock/unlock API variants, to keep
  * the testcases compact:
  */
-#define L(x)			spin_lock(&lock_##x)
-#define U(x)			spin_unlock(&lock_##x)
+#define L(x)			raw_spin_lock(&lock_##x)
+#define U(x)			raw_spin_unlock(&lock_##x)
 #define LU(x)			L(x); U(x)
-#define SI(x)			spin_lock_init(&lock_##x)
+#define SI(x)			raw_spin_lock_init(&lock_##x)
 
 #define WL(x)			write_lock(&rwlock_##x)
 #define WU(x)			write_unlock(&rwlock_##x)
@@ -911,7 +911,7 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 
 #define I2(x)					\
 	do {					\
-		spin_lock_init(&lock_##x);	\
+		raw_spin_lock_init(&lock_##x);	\
 		rwlock_init(&rwlock_##x);	\
 		mutex_init(&mutex_##x);		\
 		init_rwsem(&rwsem_##x);		\
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 7e0d6a5..7542afb 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -73,20 +73,13 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 		goto dont_wake_writers;
 	}
 
-	/* if we are allowed to wake writers try to grant a single write lock
-	 * if there's a writer at the front of the queue
-	 * - we leave the 'waiting count' incremented to signify potential
-	 *   contention
+	/*
+	 * as we support write lock stealing, we can't set sem->activity
+	 * to -1 here to indicate we get the lock. Instead, we wake it up
+	 * to let it go get it again.
 	 */
 	if (waiter->flags & RWSEM_WAITING_FOR_WRITE) {
-		sem->activity = -1;
-		list_del(&waiter->list);
-		tsk = waiter->task;
-		/* Don't touch waiter after ->task has been NULLed */
-		smp_mb();
-		waiter->task = NULL;
-		wake_up_process(tsk);
-		put_task_struct(tsk);
+		wake_up_process(waiter->task);
 		goto out;
 	}
 
@@ -121,18 +114,10 @@ static inline struct rw_semaphore *
 __rwsem_wake_one_writer(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter *waiter;
-	struct task_struct *tsk;
-
-	sem->activity = -1;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	list_del(&waiter->list);
+	wake_up_process(waiter->task);
 
-	tsk = waiter->task;
-	smp_mb();
-	waiter->task = NULL;
-	wake_up_process(tsk);
-	put_task_struct(tsk);
 	return sem;
 }
 
@@ -204,7 +189,6 @@ int __down_read_trylock(struct rw_semaphore *sem)
 
 /*
  * get a write lock on the semaphore
- * - we increment the waiting count anyway to indicate an exclusive lock
  */
 void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
@@ -214,37 +198,32 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
-		/* granted */
-		sem->activity = -1;
-		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-		goto out;
-	}
-
-	tsk = current;
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-
 	/* set up my own style of waitqueue */
+	tsk = current;
 	waiter.task = tsk;
 	waiter.flags = RWSEM_WAITING_FOR_WRITE;
-	get_task_struct(tsk);
-
 	list_add_tail(&waiter.list, &sem->wait_list);
 
-	/* we don't need to touch the semaphore struct anymore */
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	/* wait to be given the lock */
+	/* wait for someone to release the lock */
 	for (;;) {
-		if (!waiter.task)
+		/*
+		 * That is the key to support write lock stealing: allows the
+		 * task already on CPU to get the lock soon rather than put
+		 * itself into sleep and waiting for system woke it or someone
+		 * else in the head of the wait list up.
+		 */
+		if (sem->activity == 0)
 			break;
-		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+		schedule();
+		raw_spin_lock_irqsave(&sem->wait_lock, flags);
 	}
+	/* got the lock */
+	sem->activity = -1;
+	list_del(&waiter.list);
 
-	tsk->state = TASK_RUNNING;
- out:
-	;
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
 void __sched __down_write(struct rw_semaphore *sem)
@@ -262,8 +241,8 @@ int __down_write_trylock(struct rw_semaphore *sem)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
-		/* granted */
+	if (sem->activity == 0) {
+		/* got the lock */
 		sem->activity = -1;
 		ret = 1;
 	}
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 8337e1b..ad5e0df 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -2,6 +2,8 @@
  *
  * Written by David Howells (dhowells@redhat.com).
  * Derived from arch/i386/kernel/semaphore.c
+ *
+ * Writer lock-stealing by Alex Shi <alex.shi@intel.com>
  */
 #include <linux/rwsem.h>
 #include <linux/sched.h>
@@ -60,7 +62,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop, adjustment;
+	signed long woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
@@ -72,30 +74,8 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 		 */
 		goto out;
 
-	/* There's a writer at the front of the queue - try to grant it the
-	 * write lock.  However, we only wake this writer if we can transition
-	 * the active part of the count from 0 -> 1
-	 */
-	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
-	if (waiter->list.next == &sem->wait_list)
-		adjustment -= RWSEM_WAITING_BIAS;
-
- try_again_write:
-	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
-	if (oldcount & RWSEM_ACTIVE_MASK)
-		/* Someone grabbed the sem already */
-		goto undo_write;
-
-	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
-	 * It is an allocated on the waiter's stack and may become invalid at
-	 * any time after that point (due to a wakeup from another source).
-	 */
-	list_del(&waiter->list);
-	tsk = waiter->task;
-	smp_mb();
-	waiter->task = NULL;
-	wake_up_process(tsk);
-	put_task_struct(tsk);
+	/* Wake up the writing waiter and let the task grab the sem: */
+	wake_up_process(waiter->task);
 	goto out;
 
  readers_only:
@@ -157,12 +137,40 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 
  out:
 	return sem;
+}
+
+/* Try to get write sem, caller holds sem->wait_lock: */
+static int try_get_writer_sem(struct rw_semaphore *sem,
+					struct rwsem_waiter *waiter)
+{
+	struct rwsem_waiter *fwaiter;
+	long oldcount, adjustment;
 
-	/* undo the change to the active count, but check for a transition
-	 * 1->0 */
- undo_write:
+	/* only steal when first waiter is writing */
+	fwaiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+	if (!(fwaiter->flags & RWSEM_WAITING_FOR_WRITE))
+		return 0;
+
+	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
+	/* Only one waiter in the queue: */
+	if (fwaiter == waiter && waiter->list.next == &sem->wait_list)
+		adjustment -= RWSEM_WAITING_BIAS;
+
+try_again_write:
+	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
+	if (!(oldcount & RWSEM_ACTIVE_MASK)) {
+		/* No active lock: */
+		struct task_struct *tsk = waiter->task;
+
+		list_del(&waiter->list);
+		smp_mb();
+		put_task_struct(tsk);
+		tsk->state = TASK_RUNNING;
+		return 1;
+	}
+	/* some one grabbed the sem already */
 	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
-		goto out;
+		return 0;
 	goto try_again_write;
 }
 
@@ -210,6 +218,15 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	for (;;) {
 		if (!waiter.task)
 			break;
+
+		raw_spin_lock_irq(&sem->wait_lock);
+		/* Try to get the writer sem, may steal from the head writer: */
+		if (flags == RWSEM_WAITING_FOR_WRITE)
+			if (try_get_writer_sem(sem, &waiter)) {
+				raw_spin_unlock_irq(&sem->wait_lock);
+				return sem;
+			}
+		raw_spin_unlock_irq(&sem->wait_lock);
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
