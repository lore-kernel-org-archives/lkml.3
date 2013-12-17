Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3LQCKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:10:52 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:6483 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752188Ab3LQCKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:10:51 -0500
Date: Mon, 16 Dec 2013 21:10:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.8.13.13-rt26
Message-ID: <20131216211049.31d6ca0f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.8.13.13-rt26 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.8-rt
  Head SHA1: 97e7e161945d7fa1c3641d6c2f7ec1e7ef7d2eb8


Or to build 3.8.13.13-rt26 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/stable/patch-3.8.13.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.13-rt26.patch.xz



You can also build from 3.8.13.13-rt25 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13.13-rt25-rt26.patch.xz



Enjoy,

-- Steve


Changes from v3.8.13.13-rt25:

---

Peter Zijlstra (1):
      lockdep: Correctly annotate hardirq context in irq_exit()

Sebastian Andrzej Siewior (2):
      swait: Add a few more users
      rtmutex: use a trylock for waiter lock in trylock

Sebastian Siewior (1):
      net: make neigh_priv_len in struct net_device 16bit instead of 8bit

Steven Rostedt (Red Hat) (1):
      Linux 3.8.13.13-rt26

Tiejun Chen (1):
      cpu_down: move migrate_enable() back

----
 drivers/net/wireless/orinoco/orinoco_usb.c |  2 +-
 drivers/usb/gadget/f_fs.c                  |  2 +-
 drivers/usb/gadget/inode.c                 |  4 +--
 include/linux/netdevice.h                  |  2 +-
 include/linux/spinlock_rt.h                |  1 +
 kernel/cpu.c                               |  2 +-
 kernel/rtmutex.c                           | 31 +++++++++++++++++---
 kernel/softirq.c                           | 45 ++++++++++++++++++++++++++++--
 kernel/timer.c                             |  2 +-
 localversion-rt                            |  2 +-
 10 files changed, 78 insertions(+), 15 deletions(-)
---------------------------
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 01624dc..b0f9d2c 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -714,7 +714,7 @@ static void ezusb_req_ctx_wait(struct ezusb_priv *upriv,
 			while (!ctx->done.done && msecs--)
 				udelay(1000);
 		} else {
-			wait_event_interruptible(ctx->done.wait,
+			swait_event_interruptible(ctx->done.wait,
 						 ctx->done.done);
 		}
 		break;
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index de3e266..5b2a068 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1284,7 +1284,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
 		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
-		       waitqueue_active(&ffs->ep0req_completion.wait));
+		       swaitqueue_active(&ffs->ep0req_completion.wait));
 		kfree(ffs->dev_name);
 		kfree(ffs);
 	}
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 8ac840f..fe85df7 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -338,7 +338,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 	spin_unlock_irq (&epdata->dev->lock);
 
 	if (likely (value == 0)) {
-		value = wait_event_interruptible (done.wait, done.done);
+		value = swait_event_interruptible (done.wait, done.done);
 		if (value != 0) {
 			spin_lock_irq (&epdata->dev->lock);
 			if (likely (epdata->ep != NULL)) {
@@ -347,7 +347,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 				usb_ep_dequeue (epdata->ep, epdata->req);
 				spin_unlock_irq (&epdata->dev->lock);
 
-				wait_event (done.wait, done.done);
+				swait_event (done.wait, done.done);
 				if (epdata->status == -ECONNRESET)
 					epdata->status = -EINTR;
 			} else {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0b58fd6..bc45789 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1123,7 +1123,7 @@ struct net_device {
 	unsigned char		perm_addr[MAX_ADDR_LEN]; /* permanent hw address */
 	unsigned char		addr_assign_type; /* hw address assignment type */
 	unsigned char		addr_len;	/* hardware address length	*/
-	unsigned char		neigh_priv_len;
+	unsigned short		neigh_priv_len;
 	unsigned short          dev_id;		/* for shared network cards */
 
 	spinlock_t		addr_list_lock;
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 0618387..b3c504b 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -22,6 +22,7 @@ extern void __lockfunc rt_spin_lock(spinlock_t *lock);
 extern unsigned long __lockfunc rt_spin_lock_trace_flags(spinlock_t *lock);
 extern void __lockfunc rt_spin_lock_nested(spinlock_t *lock, int subclass);
 extern void __lockfunc rt_spin_unlock(spinlock_t *lock);
+extern void __lockfunc rt_spin_unlock_after_trylock_in_irq(spinlock_t *lock);
 extern void __lockfunc rt_spin_unlock_wait(spinlock_t *lock);
 extern int __lockfunc rt_spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags);
 extern int __lockfunc rt_spin_trylock_bh(spinlock_t *lock);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 98f2ea3..da6e128 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -594,6 +594,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		err = -EBUSY;
 		goto restore_cpus;
 	}
+	migrate_enable();
 
 	cpu_hotplug_begin();
 	err = cpu_unplug_begin(cpu);
@@ -647,7 +648,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 out_release:
 	cpu_unplug_done(cpu);
 out_cancel:
-	migrate_enable();
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 20742e7..3825e1c 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -801,10 +801,8 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 /*
  * Slow path to release a rt_mutex spin_lock style
  */
-static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
+static void __sched __rt_spin_lock_slowunlock(struct rt_mutex *lock)
 {
-	raw_spin_lock(&lock->wait_lock);
-
 	debug_rt_mutex_unlock(lock);
 
 	rt_mutex_deadlock_account_unlock(current);
@@ -823,6 +821,23 @@ static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
 	rt_mutex_adjust_prio(current);
 }
 
+static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
+{
+	raw_spin_lock(&lock->wait_lock);
+	__rt_spin_lock_slowunlock(lock);
+}
+
+static void  noinline __sched rt_spin_lock_slowunlock_hirq(struct rt_mutex *lock)
+{
+	int ret;
+
+	do {
+		ret = raw_spin_trylock(&lock->wait_lock);
+	} while (!ret);
+
+	__rt_spin_lock_slowunlock(lock);
+}
+
 void __lockfunc rt_spin_lock(spinlock_t *lock)
 {
 	rt_spin_lock_fastlock(&lock->lock, rt_spin_lock_slowlock);
@@ -853,6 +868,13 @@ void __lockfunc rt_spin_unlock(spinlock_t *lock)
 }
 EXPORT_SYMBOL(rt_spin_unlock);
 
+void __lockfunc rt_spin_unlock_after_trylock_in_irq(spinlock_t *lock)
+{
+	/* NOTE: we always pass in '1' for nested, for simplicity */
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	rt_spin_lock_fastunlock(&lock->lock, rt_spin_lock_slowunlock_hirq);
+}
+
 void __lockfunc __rt_spin_unlock(struct rt_mutex *lock)
 {
 	rt_spin_lock_fastunlock(lock, rt_spin_lock_slowunlock);
@@ -1056,7 +1078,8 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 {
 	int ret = 0;
 
-	raw_spin_lock(&lock->wait_lock);
+	if (!raw_spin_trylock(&lock->wait_lock))
+		return ret;
 	init_lists(lock);
 
 	if (likely(rt_mutex_owner(lock) != current)) {
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 8447c8d..42b121f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -350,6 +350,44 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  */
 #define MAX_SOFTIRQ_RESTART 10
 
+#ifdef CONFIG_TRACE_IRQFLAGS
+/*
+ * Convoluted means of passing __do_softirq() a message through the various
+ * architecture execute_on_stack() bits.
+ *
+ * When we run softirqs from irq_exit() and thus on the hardirq stack we need
+ * to keep the lockdep irq context tracking as tight as possible in order to
+ * not miss-qualify lock contexts and miss possible deadlocks.
+ */
+static DEFINE_PER_CPU(int, softirq_from_hardirq);
+
+static inline void lockdep_softirq_from_hardirq(void)
+{
+	this_cpu_write(softirq_from_hardirq, 1);
+}
+
+static inline void lockdep_softirq_start(void)
+{
+	if (this_cpu_read(softirq_from_hardirq))
+		trace_hardirq_exit();
+	lockdep_softirq_enter();
+}
+
+static inline void lockdep_softirq_end(void)
+{
+	lockdep_softirq_exit();
+	if (this_cpu_read(softirq_from_hardirq)) {
+		this_cpu_write(softirq_from_hardirq, 0);
+		trace_hardirq_enter();
+	}
+}
+
+#else
+static inline void lockdep_softirq_from_hardirq(void) { }
+static inline void lockdep_softirq_start(void) { }
+static inline void lockdep_softirq_end(void) { }
+#endif
+
 asmlinkage void __do_softirq(void)
 {
 	__u32 pending;
@@ -369,7 +407,7 @@ asmlinkage void __do_softirq(void)
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 			   SOFTIRQ_OFFSET);
-	lockdep_softirq_enter();
+	lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -385,7 +423,7 @@ restart:
 	if (pending)
 		wakeup_softirqd();
 
-	lockdep_softirq_exit();
+	lockdep_softirq_end();
 
 	vtime_account_irq_exit(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
@@ -692,6 +730,7 @@ static inline void invoke_softirq(void)
 {
 #ifndef CONFIG_PREEMPT_RT_FULL
 	if (!force_irqthreads) {
+		lockdep_softirq_from_hardirq();
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
 #else
@@ -720,7 +759,6 @@ static inline void invoke_softirq(void)
 void irq_exit(void)
 {
 	vtime_account_irq_exit(current);
-	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
@@ -731,6 +769,7 @@ void irq_exit(void)
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
+	trace_hardirq_exit(); /* must be last! */
 	sched_preempt_enable_no_resched();
 }
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 3bb957e..330221b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1398,7 +1398,7 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 		expires = base->next_timer;
 	}
 #ifdef CONFIG_PREEMPT_RT_FULL
-	rt_spin_unlock(&base->lock);
+	rt_spin_unlock_after_trylock_in_irq(&base->lock);
 #else
 	spin_unlock(&base->lock);
 #endif
diff --git a/localversion-rt b/localversion-rt
index c5b71f9..2e9afd4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt25
+-rt26
