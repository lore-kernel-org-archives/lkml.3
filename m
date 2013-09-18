Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3IRHDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 03:03:14 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61197 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3IRHDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 03:03:12 -0400
Subject: [RFC PATCH] seqlock: add lockdep support
From: Lin Ming <minggr@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, "; John Stultz" <john.stultz@linaro.org>,
        "; Peter Zijlstra" <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 18 Sep 2013 14:57:13 +0800
Message-ID: <1379487433.19121.29.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

lockdep support for seqlock was discussed at:
http://marc.info/?l=linux-kernel&m=137875860600648&w=2

This is very draft patch to add lockdep support for seqlock.
Actually, it doesn't work yet. I throw it out to get comments and help.

TODO:
- fix seqlock usage in vdso code

I got below with this patch applied.
There should be something wrong with this patch.
Any idea?

Thanks.

[    0.000000] =================================
[    0.000000] [ INFO: inconsistent lock state ]
[    0.000000] 3.11.0-08716-g26b0332-dirty #54 Not tainted
[    0.000000] ---------------------------------
[    0.000000] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-R} usage.
[    0.000000] swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[    0.000000]  (timekeeper_seq){-+.-..}, at: [<c10730d9>] tick_check_oneshot_change+0x3a/0xcc
[    0.000000] {IN-HARDIRQ-W} state was registered at:
[    0.000000]   [<c10795b1>] __lock_acquire+0x516/0x8e7
[    0.000000]   [<c1079a10>] lock_acquire+0x8e/0xad
[    0.000000]   [<c106d967>] do_timer+0x8c8/0x933
[    0.000000]   [<c107226b>] tick_periodic+0x58/0x99
[    0.000000]   [<c10722ca>] tick_handle_periodic+0x1e/0x6f
[    0.000000]   [<c1003962>] timer_interrupt+0x12/0x19
[    0.000000]   [<c1090f70>] handle_irq_event_percpu+0x5c/0x171
[    0.000000]   [<c10910b6>] handle_irq_event+0x31/0x48
[    0.000000]   [<c109325b>] handle_level_irq+0x8c/0xb8
[    0.000000] irq event stamp: 352
[    0.000000] hardirqs last  enabled at (352): [<c103a488>] __do_softirq+0x76/0x1b0
[    0.000000] hardirqs last disabled at (348): [<c132d2ca>] common_interrupt+0x2a/0x38
[    0.000000] softirqs last  enabled at (350): [<c103a694>] _local_bh_enable+0x12/0x14
[    0.000000] softirqs last disabled at (351): [<c103a648>] irq_exit+0x49/0x83
[    0.000000] 
[    0.000000] other info that might help us debug this:
[    0.000000]  Possible unsafe locking scenario:
[    0.000000] 
[    0.000000]        CPU0
[    0.000000]        ----
[    0.000000]   lock(timekeeper_seq);
[    0.000000]   <Interrupt>
[    0.000000]     lock(timekeeper_seq);
[    0.000000] 
[    0.000000]  *** DEADLOCK ***
[    0.000000] 
[    0.000000] no locks held by swapper/0/0.
[    0.000000] 
[    0.000000] stack backtrace:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-08716-g26b0332-dirty #54
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  c1868358 c14e3da8 c1327f1d c14ed934 c14e3dc8 c1075e2f c145afe6 c145b32a
[    0.000000]  c145bc44 c14eddb8 00000003 00000000 c14e3de8 c1076107 00000003 c1076c27
[    0.000000]  c14ed934 c14ed934 c14eddb4 c1735fb4 c14e3e24 c10795fb c14e3e28 c132fb1c
[    0.000000] Call Trace:
[    0.000000]  [<c1327f1d>] dump_stack+0x41/0x54
[    0.000000]  [<c1075e2f>] print_usage_bug+0x230/0x23c
[    0.000000]  [<c1076107>] mark_lock+0x2cc/0x4f0
[    0.000000]  [<c1076c27>] ? check_usage_forwards+0xb8/0xb8
[    0.000000]  [<c10795fb>] __lock_acquire+0x560/0x8e7
[    0.000000]  [<c1079a10>] lock_acquire+0x8e/0xad
[    0.000000]  [<c10730d9>] ? tick_check_oneshot_change+0x3a/0xcc
[    0.000000]  [<c106b94c>] timekeeping_valid_for_hres+0x21/0x61
[    0.000000]  [<c10730d9>] ? tick_check_oneshot_change+0x3a/0xcc
[    0.000000]  [<c10730d9>] tick_check_oneshot_change+0x3a/0xcc
[    0.000000]  [<c1051ef9>] hrtimer_run_pending+0x2a/0xe8
[    0.000000]  [<c103fbb6>] run_timer_softirq+0x1a/0x1b2
[    0.000000]  [<c103a488>] ? __do_softirq+0x76/0x1b0
[    0.000000]  [<c1076695>] ? trace_hardirqs_on_caller+0x121/0x16e
[    0.000000]  [<c103a4e3>] __do_softirq+0xd1/0x1b0
[    0.000000]  [<c103a648>] irq_exit+0x49/0x83
[    0.000000]  [<c1002e89>] do_IRQ+0x81/0x95
[    0.000000]  [<c132d2d1>] common_interrupt+0x31/0x38
[    0.000000]  [<c107007b>] ? timer_list_next+0x1d/0x4d
[    0.000000]  [<c132c176>] ? _raw_spin_unlock_irqrestore+0x3d/0x41
[    0.000000]  [<c1091faf>] __setup_irq+0x2bb/0x35c
[    0.000000]  [<c1092328>] setup_irq+0x50/0x68
[    0.000000]  [<c1547d82>] setup_default_timer_irq+0xf/0x11
[    0.000000]  [<c1547d9a>] hpet_time_init+0x16/0x18
[    0.000000]  [<c1547d6c>] x86_late_time_init+0x9/0x10
[    0.000000]  [<c15459fc>] start_kernel+0x28a/0x311
[    0.000000]  [<c15452a3>] i386_start_kernel+0x79/0x7d

---
 include/linux/lockdep.h |    4 ++++
 include/linux/seqlock.h |   32 +++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index cfc2f11..d190e7d 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -506,6 +506,10 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 #define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared(l, s, t, NULL, i)
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
 
+#define seqlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define seqlock_acquire_read(l, s, t, i)	lock_acquire_shared(l, s, t, NULL, i)
+#define seqlock_release(l, n, i)		lock_release(l, n, i)
+
 #define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
 #define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 1829905..a1bc7c1 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -38,10 +38,19 @@
  */
 typedef struct seqcount {
 	unsigned sequence;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
 } seqcount_t;
 
 #define SEQCNT_ZERO { 0 }
-#define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
+#define seqcount_init(x)				\
+do {							\
+	static struct lock_class_key __key;		\
+							\
+	lockdep_init_map(&(x)->dep_map, #x, &__key, 0);	\
+	*(x) = (seqcount_t) SEQCNT_ZERO;		\
+} while (0)
 
 /**
  * __read_seqcount_begin - begin a seq-read critical section (without barrier)
@@ -60,6 +69,8 @@ static inline unsigned __read_seqcount_begin(const seqcount_t *s)
 {
 	unsigned ret;
 
+	seqlock_acquire_read((struct lockdep_map *)&s->dep_map, 0, 0, _RET_IP_);
+
 repeat:
 	ret = ACCESS_ONCE(s->sequence);
 	if (unlikely(ret & 1)) {
@@ -101,7 +112,11 @@ static inline unsigned read_seqcount_begin(const seqcount_t *s)
  */
 static inline unsigned raw_seqcount_begin(const seqcount_t *s)
 {
-	unsigned ret = ACCESS_ONCE(s->sequence);
+	unsigned ret;
+
+	seqlock_acquire_read((struct lockdep_map *)&s->dep_map, 0, 0, _RET_IP_);
+
+	ret = ACCESS_ONCE(s->sequence);
 	smp_rmb();
 	return ret & ~1;
 }
@@ -122,6 +137,7 @@ static inline unsigned raw_seqcount_begin(const seqcount_t *s)
  */
 static inline int __read_seqcount_retry(const seqcount_t *s, unsigned start)
 {
+	seqlock_release((struct lockdep_map *)&s->dep_map, 1, _RET_IP_);
 	return unlikely(s->sequence != start);
 }
 
@@ -148,12 +164,14 @@ static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
  */
 static inline void write_seqcount_begin(seqcount_t *s)
 {
+	seqlock_acquire((struct lockdep_map *)&s->dep_map, 0, 0, _RET_IP_);
 	s->sequence++;
 	smp_wmb();
 }
 
 static inline void write_seqcount_end(seqcount_t *s)
 {
+	seqlock_release((struct lockdep_map *)&s->dep_map, 1, _RET_IP_);
 	smp_wmb();
 	s->sequence++;
 }
@@ -167,6 +185,7 @@ static inline void write_seqcount_end(seqcount_t *s)
  */
 static inline void write_seqcount_barrier(seqcount_t *s)
 {
+	seqlock_acquire((struct lockdep_map *)&s->dep_map, 0, 0, _RET_IP_);
 	smp_wmb();
 	s->sequence+=2;
 }
@@ -176,13 +195,20 @@ typedef struct {
 	spinlock_t lock;
 } seqlock_t;
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define __SEQLOCK_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+#else
+# define __SEQLOCK_DEP_MAP_INIT(lockname)
+#endif
+
 /*
  * These macros triggered gcc-3.x compile-time problems.  We think these are
  * OK now.  Be cautious.
  */
 #define __SEQLOCK_UNLOCKED(lockname)			\
 	{						\
-		.seqcount = SEQCNT_ZERO,		\
+		.seqcount = {.sequence = 0		\
+		__SEQLOCK_DEP_MAP_INIT(lockname)},	\
 		.lock =	__SPIN_LOCK_UNLOCKED(lockname)	\
 	}
 


