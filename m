Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbaEISMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:12:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:38078 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbaEISMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:12:16 -0400
Date: Fri, 9 May 2014 20:12:14 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.14.3-rt5
Message-ID: <20140509181214.GK29014@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.14.3-rt5 patch set.

Changes since v3.14.3-rt4
- remove one of the two identical rt_mutex_init() definitions. A patch
  from Steven Rostedt
- use EXPORT_SYMBOL() on __rt_mutex_init() and
  rt_down_write_nested_lock(). The former was dropped accidently and is
  needed by some binary only modules, the latter was requsted by the f2fs
  module. Patch by Joakim Hernberg.
- during v3.14 porting I accidently dropped preempt_check_resched() in
  the non-preempt case which means configs non-preempt configs did not
  build. Reported by Yang Honggang.
- NETCONSOLE is no longer disabled on RT. Daniel Bristot de Oliveira did
  some testing and did not find anything wrong it. That means it can be
  enabled if someone needs/wants it.
- rt_read_lock() uses rwlock_acquire() instead of rwlock_acquire_read()
  for lockdep annotation. It was different compared to what the trylock
  variant used and on RT both act the same way. Patch by Mike Galbraith.
- the tracing code wrongly disable preemption while shrinking the ring
  buffer. Reported by Stanislav Meduna.

Known issues:

      - bcache is disabled.

      - lazy preempt on x86_64 leads to a crash with some load.

      - CPU hotplug works in general. Steven's test script however
        deadlocks usually on the second invocation.

The delta patch against v3.14.3-rt4 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/incr/patch-3.14.3-rt4-rt5.patch.xz

The RT patch against 3.14.3 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patch-3.14.3-rt5.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patches-3.14.3-rt5.tar.xz

Sebastian

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 33a4a85..494b888 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -160,7 +160,6 @@ config VXLAN
 
 config NETCONSOLE
 	tristate "Network console logging support"
-	depends on !PREEMPT_RT_FULL
 	---help---
 	If you want to log kernel messages over the network, enable this.
 	See <file:Documentation/networking/netconsole.txt> for details.
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 5b2cdf4..66587bf 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -149,6 +149,7 @@ do { \
 #define sched_preempt_enable_no_resched()	barrier()
 #define preempt_enable_no_resched()		barrier()
 #define preempt_enable()			barrier()
+#define preempt_check_resched()			do { } while (0)
 
 #define preempt_disable_notrace()		barrier()
 #define preempt_enable_no_resched_notrace()	barrier()
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index f8f3dfdd2..edb77fd 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -59,23 +59,18 @@ struct hrtimer_sleeper;
 # define rt_mutex_debug_check_no_locks_held(task)	do { } while (0)
 #endif
 
-#ifdef CONFIG_DEBUG_RT_MUTEXES
-# define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
-	, .name = #mutexname, .file = __FILE__, .line = __LINE__
 # define rt_mutex_init(mutex)					\
 	do {							\
 		raw_spin_lock_init(&(mutex)->wait_lock);	\
 		__rt_mutex_init(mutex, #mutex);			\
 	} while (0)
 
+#ifdef CONFIG_DEBUG_RT_MUTEXES
+# define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
+	, .name = #mutexname, .file = __FILE__, .line = __LINE__
  extern void rt_mutex_debug_task_free(struct task_struct *tsk);
 #else
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname)
-# define rt_mutex_init(mutex)					\
-	 do {							\
-		 raw_spin_lock_init(&(mutex)->wait_lock);	\
-		 __rt_mutex_init(mutex, #mutex);		\
-	 } while (0)
 # define rt_mutex_debug_task_free(t)			do { } while (0)
 #endif
 
diff --git a/kernel/locking/rt.c b/kernel/locking/rt.c
index 055a3df..90b8ba0 100644
--- a/kernel/locking/rt.c
+++ b/kernel/locking/rt.c
@@ -250,7 +250,7 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 	 */
 	if (rt_mutex_owner(lock) != current) {
 		migrate_disable();
-		rwlock_acquire_read(&rwlock->dep_map, 0, 0, _RET_IP_);
+		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
 		__rt_spin_lock(lock);
 	}
 	rwlock->read_depth++;
@@ -366,6 +366,7 @@ void rt_down_write_nested_lock(struct rw_semaphore *rwsem,
 	rwsem_acquire_nest(&rwsem->dep_map, 0, 0, nest, _RET_IP_);
 	rt_mutex_lock(&rwsem->lock);
 }
+EXPORT_SYMBOL(rt_down_write_nested_lock);
 
 int  rt_down_read_trylock(struct rw_semaphore *rwsem)
 {
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 5c5cc76..fbf152b 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1552,7 +1552,7 @@ void __rt_mutex_init(struct rt_mutex *lock, const char *name)
 
 	debug_rt_mutex_init(lock, name);
 }
-EXPORT_SYMBOL_GPL(__rt_mutex_init);
+EXPORT_SYMBOL(__rt_mutex_init);
 
 /**
  * rt_mutex_init_proxy_locked - initialize and lock a rt_mutex on behalf of a
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index fc4da2d..112d4a5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1682,28 +1682,22 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 		 * We can't schedule on offline CPUs, but it's not necessary
 		 * since we can change their buffer sizes without any race.
 		 */
+		migrate_disable();
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer = buffer->buffers[cpu];
 			if (!cpu_buffer->nr_pages_to_update)
 				continue;
 
 			/* The update must run on the CPU that is being updated. */
-			preempt_disable();
 			if (cpu == smp_processor_id() || !cpu_online(cpu)) {
 				rb_update_pages(cpu_buffer);
 				cpu_buffer->nr_pages_to_update = 0;
 			} else {
-				/*
-				 * Can not disable preemption for schedule_work_on()
-				 * on PREEMPT_RT.
-				 */
-				preempt_enable();
 				schedule_work_on(cpu,
 						&cpu_buffer->update_pages_work);
-				preempt_disable();
 			}
-			preempt_enable();
 		}
+		migrate_enable();
 
 		/* wait for all the updates to complete */
 		for_each_buffer_cpu(buffer, cpu) {
@@ -1740,22 +1734,16 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 
 		get_online_cpus();
 
-		preempt_disable();
+		migrate_disable();
 		/* The update must run on the CPU that is being updated. */
 		if (cpu_id == smp_processor_id() || !cpu_online(cpu_id))
 			rb_update_pages(cpu_buffer);
 		else {
-			/*
-			 * Can not disable preemption for schedule_work_on()
-			 * on PREEMPT_RT.
-			 */
-			preempt_enable();
 			schedule_work_on(cpu_id,
 					 &cpu_buffer->update_pages_work);
 			wait_for_completion(&cpu_buffer->update_done);
-			preempt_disable();
 		}
-		preempt_enable();
+		migrate_enable();
 
 		cpu_buffer->nr_pages_to_update = 0;
 		put_online_cpus();
