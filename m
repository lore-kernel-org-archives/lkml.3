Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3KPTqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 14:46:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:44676 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3KPTqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 14:46:36 -0500
Date: Sat, 16 Nov 2013 20:46:33 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.0-rt2
Message-ID: <20131116194633.GD11518@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.0-rt2 patch set.

Changes since v3.12.0-rt1
- fix for iwlwifi which tried to take a sleeping in irq context. Patch
  has been available & disabled in the queue and is now enabled after Clark
  recently reported that it works.
- tried to fix AT91's "already-free IRQ" and highres problem. Michael
  Langfinge reported it initially and Sami Pietikäinen sent a patch for
  the "already-free IRQ" problem. Based on another patch I looked at the
  highres patch and tried to fix it. As I don't have the hardware, some
  feedback would be nice.
- a fix for cpu down on !RT. Patch by Tiejun Chen.
- Mike Galbraith and Matt Cowell reported a dead lock with CONFIG_NO_HZ_FULL. 
  To fix this trylock deadlock, the sleeping lock is now taken with irqs off.
  I would be interrested if this change causes any noticable latencys
  for anyone.

Known issues:

      - bcache is disabled.

      - an ancient race (since we got sleeping spinlocks) where the
        TASK_TRACED state is temporary replaced while waiting on a rw
        lock and the task can't be traced.

The delta patch against v3.12.0-rt1 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.0-rt1-rt2.patch.xz

The RT patch against 3.12 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.0-rt2.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.0-rt2.tar.xz

Sebastian

diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index 0bbd8e6..35f7b26 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -134,7 +134,7 @@ clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-		remove_irq(AT91_ID_SYS, &at91rm9200_timer_irq);
+		remove_irq(NR_IRQS_LEGACY + AT91_ID_SYS, &at91rm9200_timer_irq);
 	case CLOCK_EVT_MODE_RESUME:
 		irqmask = 0;
 		break;
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 01681e6..1c4c487 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -87,7 +87,7 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* Set up irq handler */
-		setup_irq(AT91_ID_SYS, &at91sam926x_pit_irq);
+		setup_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
 		/* update clocksource counter */
 		pit_cnt += pit_cycle * PIT_PICNT(pit_read(AT91_PIT_PIVR));
 		pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN
@@ -100,7 +100,7 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 	case CLOCK_EVT_MODE_UNUSED:
 		/* disable irq, leaving the clocksource active */
 		pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN);
-		remove_irq(AT91_ID_SYS, &at91sam926x_pit_irq);
+		remove_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		break;
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index c08ec1d..74fe7f7 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -182,9 +182,10 @@ static struct irqaction tc_irqaction = {
 	.handler	= ch2_irq,
 };
 
-static void __init setup_clkevents(struct atmel_tc *tc, int divisor_idx)
+static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 {
-	unsigned divisor = atmel_tc_divisors[divisor_idx];
+	unsigned divisor = atmel_tc_divisors[clk32k_divisor_idx];
+	u32 freq;
 	struct clk *t2_clk = tc->clk[2];
 	int irq = tc->irq[2];
 
@@ -193,10 +194,14 @@ static void __init setup_clkevents(struct atmel_tc *tc, int divisor_idx)
 	tc_irqaction.dev_id = &clkevt;
 
 	timer_clock = clk32k_divisor_idx;
+	if (!divisor)
+		freq = 32768;
+	else
+		freq = clk_get_rate(t2_clk) / divisor;
 
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
+	clockevents_config_and_register(&clkevt.clkevt, freq, 1, 0xffff);
 
 	setup_irq(irq, &tc_irqaction);
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index c3f904d..d07cdca 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1375,6 +1375,20 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.set_bits_mask = iwl_trans_pcie_set_bits_mask,
 };
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+static irqreturn_t iwl_rt_irq_handler(int irq, void *dev_id)
+{
+	irqreturn_t ret;
+
+	local_bh_disable();
+	ret = iwl_pcie_isr_ict(irq, dev_id);
+	local_bh_enable();
+	if (ret == IRQ_WAKE_THREAD)
+		ret = iwl_pcie_irq_handler(irq, dev_id);
+	return ret;
+}
+#endif
+
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				       const struct pci_device_id *ent,
 				       const struct iwl_cfg *cfg)
@@ -1493,9 +1507,14 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	if (iwl_pcie_alloc_ict(trans))
 		goto out_free_cmd_pool;
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+	err = request_threaded_irq(pdev->irq, NULL, iwl_rt_irq_handler,
+				IRQF_SHARED | IRQF_ONESHOT, DRV_NAME, trans);
+#else
 	err = request_threaded_irq(pdev->irq, iwl_pcie_isr_ict,
 				   iwl_pcie_irq_handler,
 				   IRQF_SHARED, DRV_NAME, trans);
+#endif
 	if (err) {
 		IWL_ERR(trans, "Error allocating IRQ %d\n", pdev->irq);
 		goto out_free_ict;
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f07af96..c36b075 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -593,6 +593,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		err = -EBUSY;
 		goto restore_cpus;
 	}
+	migrate_enable();
 
 	cpu_hotplug_begin();
 	err = cpu_unplug_begin(cpu);
@@ -646,7 +647,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 out_release:
 	cpu_unplug_done(cpu);
 out_cancel:
-	migrate_enable();
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
diff --git a/kernel/futex.c b/kernel/futex.c
index 0ef419d..404d0bd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -891,7 +891,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	if (pi_state->owner != current)
 		return -EINVAL;
 
-	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
@@ -917,21 +917,21 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 		else if (curval != uval)
 			ret = -EINVAL;
 		if (ret) {
-			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
+			raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 			return ret;
 		}
 	}
 
-	raw_spin_lock_irq(&pi_state->owner->pi_lock);
+	raw_spin_lock(&pi_state->owner->pi_lock);
 	WARN_ON(list_empty(&pi_state->list));
 	list_del_init(&pi_state->list);
-	raw_spin_unlock_irq(&pi_state->owner->pi_lock);
+	raw_spin_unlock(&pi_state->owner->pi_lock);
 
-	raw_spin_lock_irq(&new_owner->pi_lock);
+	raw_spin_lock(&new_owner->pi_lock);
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &new_owner->pi_state_list);
 	pi_state->owner = new_owner;
-	raw_spin_unlock_irq(&new_owner->pi_lock);
+	raw_spin_unlock(&new_owner->pi_lock);
 
 	raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 	rt_mutex_unlock(&pi_state->pi_mutex);
@@ -1762,11 +1762,11 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		 * we returned due to timeout or signal without taking the
 		 * rt_mutex. Too late.
 		 */
-		raw_spin_lock(&q->pi_state->pi_mutex.wait_lock);
+		raw_spin_lock_irq(&q->pi_state->pi_mutex.wait_lock);
 		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
 		if (!owner)
 			owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
-		raw_spin_unlock(&q->pi_state->pi_mutex.wait_lock);
+		raw_spin_unlock_irq(&q->pi_state->pi_mutex.wait_lock);
 		ret = fixup_pi_state_owner(uaddr, q, owner);
 		goto out;
 	}
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index b4c651e..c2f3f63 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -298,7 +298,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
 	/* Release the task */
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock);
 	if (!rt_mutex_owner(lock)) {
 		struct rt_mutex_waiter *lock_top_waiter;
 
@@ -309,7 +309,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		lock_top_waiter = rt_mutex_top_waiter(lock);
 		if (top_waiter != lock_top_waiter)
 			rt_mutex_wake_waiter(lock_top_waiter);
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		goto out_put_task;
 	}
 	put_task_struct(task);
@@ -317,7 +317,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	/* Grab the next task */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock(&task->pi_lock);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/* Boost the owner */
@@ -335,10 +335,10 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		__rt_mutex_adjust_prio(task);
 	}
 
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock);
 
 	top_waiter = rt_mutex_top_waiter(lock);
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	if (!detect_deadlock && waiter != top_waiter)
 		goto out_put_task;
@@ -425,10 +425,9 @@ __try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 	/* We got the lock. */
 
 	if (waiter || rt_mutex_has_waiters(lock)) {
-		unsigned long flags;
 		struct rt_mutex_waiter *top;
 
-		raw_spin_lock_irqsave(&task->pi_lock, flags);
+		raw_spin_lock(&task->pi_lock);
 
 		/* remove the queued waiter. */
 		if (waiter) {
@@ -445,7 +444,7 @@ __try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 			top->pi_list_entry.prio = top->list_entry.prio;
 			plist_add(&top->pi_list_entry, &task->pi_waiters);
 		}
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock(&task->pi_lock);
 	}
 
 	debug_rt_mutex_lock(lock);
@@ -478,10 +477,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
-	unsigned long flags;
 	int chain_walk = 0, res;
 
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock(&task->pi_lock);
 
 	/*
 	 * In the case of futex requeue PI, this will be a proxy
@@ -493,7 +491,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 * the task if PI_WAKEUP_INPROGRESS is set.
 	 */
 	if (task != current && task->pi_blocked_on == PI_WAKEUP_INPROGRESS) {
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock(&task->pi_lock);
 		return -EAGAIN;
 	}
 
@@ -512,20 +510,20 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	task->pi_blocked_on = waiter;
 
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock);
 
 	if (!owner)
 		return 0;
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
+		raw_spin_lock(&owner->pi_lock);
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
 		__rt_mutex_adjust_prio(owner);
 		if (rt_mutex_real_waiter(owner->pi_blocked_on))
 			chain_walk = 1;
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+		raw_spin_unlock(&owner->pi_lock);
 	}
 	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
 		chain_walk = 1;
@@ -540,12 +538,12 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 */
 	get_task_struct(owner);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
 					 task);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irq(&lock->wait_lock);
 
 	return res;
 }
@@ -560,9 +558,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 static void wakeup_next_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *waiter;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&current->pi_lock, flags);
+	raw_spin_lock(&current->pi_lock);
 
 	waiter = rt_mutex_top_waiter(lock);
 
@@ -576,7 +573,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 
 	rt_mutex_set_owner(lock, NULL);
 
-	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+	raw_spin_unlock(&current->pi_lock);
 
 	rt_mutex_wake_waiter(waiter);
 }
@@ -592,20 +589,19 @@ static void remove_waiter(struct rt_mutex *lock,
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
-	unsigned long flags;
 	int chain_walk = 0;
 
-	raw_spin_lock_irqsave(&current->pi_lock, flags);
+	raw_spin_lock(&current->pi_lock);
 	plist_del(&waiter->list_entry, &lock->wait_list);
 	current->pi_blocked_on = NULL;
-	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+	raw_spin_unlock(&current->pi_lock);
 
 	if (!owner)
 		return;
 
 	if (first) {
 
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
+		raw_spin_lock(&owner->pi_lock);
 
 		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
 
@@ -620,7 +616,7 @@ static void remove_waiter(struct rt_mutex *lock,
 		if (rt_mutex_real_waiter(owner->pi_blocked_on))
 			chain_walk = 1;
 
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+		raw_spin_unlock(&owner->pi_lock);
 	}
 
 	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
@@ -631,11 +627,11 @@ static void remove_waiter(struct rt_mutex *lock,
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(owner);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irq(&lock->wait_lock);
 }
 
 /*
@@ -723,9 +719,6 @@ static int adaptive_wait(struct rt_mutex *lock,
 }
 #endif
 
-# define pi_lock(lock)			raw_spin_lock_irq(lock)
-# define pi_unlock(lock)		raw_spin_unlock_irq(lock)
-
 /*
  * Slow path lock function spin_lock style: this variant is very
  * careful not to miss any non-lock wakeups.
@@ -737,19 +730,22 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 {
 	struct task_struct *lock_owner, *self = current;
 	struct rt_mutex_waiter waiter, *top_waiter;
+	unsigned long flags;
 	int ret;
 
 	rt_mutex_init_waiter(&waiter, true);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_local_save_flags(flags);
+	raw_spin_lock_irq(&lock->wait_lock);
 	init_lists(lock);
 
 	if (__try_to_take_rt_mutex(lock, self, NULL, STEAL_LATERAL)) {
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return;
 	}
 
 	BUG_ON(rt_mutex_owner(lock) == self);
+	BUG_ON(arch_irqs_disabled_flags(flags));
 
 	/*
 	 * We save whatever state the task is in and we'll restore it
@@ -757,10 +753,10 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 	 * as well. We are serialized via pi_lock against wakeups. See
 	 * try_to_wake_up().
 	 */
-	pi_lock(&self->pi_lock);
+	raw_spin_lock(&self->pi_lock);
 	self->saved_state = self->state;
 	__set_current_state(TASK_UNINTERRUPTIBLE);
-	pi_unlock(&self->pi_lock);
+	raw_spin_unlock(&self->pi_lock);
 
 	ret = task_blocks_on_rt_mutex(lock, &waiter, self, 0);
 	BUG_ON(ret);
@@ -773,18 +769,18 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 		top_waiter = rt_mutex_top_waiter(lock);
 		lock_owner = rt_mutex_owner(lock);
 
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irq(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
 		if (top_waiter != &waiter || adaptive_wait(lock, lock_owner))
 			schedule_rt_mutex(lock);
 
-		raw_spin_lock(&lock->wait_lock);
+		raw_spin_lock_irq(&lock->wait_lock);
 
-		pi_lock(&self->pi_lock);
+		raw_spin_lock(&self->pi_lock);
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		pi_unlock(&self->pi_lock);
+		raw_spin_unlock(&self->pi_lock);
 	}
 
 	/*
@@ -794,10 +790,10 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 	 * happened while we were blocked. Clear saved_state so
 	 * try_to_wakeup() does not get confused.
 	 */
-	pi_lock(&self->pi_lock);
+	raw_spin_lock(&self->pi_lock);
 	__set_current_state(self->saved_state);
 	self->saved_state = TASK_RUNNING;
-	pi_unlock(&self->pi_lock);
+	raw_spin_unlock(&self->pi_lock);
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -808,7 +804,7 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 	BUG_ON(rt_mutex_has_waiters(lock) && &waiter == rt_mutex_top_waiter(lock));
 	BUG_ON(!plist_node_empty(&waiter.list_entry));
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	debug_rt_mutex_free_waiter(&waiter);
 }
@@ -818,7 +814,9 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
  */
 static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
 {
-	raw_spin_lock(&lock->wait_lock);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	debug_rt_mutex_unlock(lock);
 
@@ -826,13 +824,13 @@ static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
 
 	if (!rt_mutex_has_waiters(lock)) {
 		lock->owner = NULL;
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return;
 	}
 
 	wakeup_next_waiter(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	/* Undo pi boosting.when necessary */
 	rt_mutex_adjust_prio(current);
@@ -1032,13 +1030,13 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 				break;
 		}
 
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irq(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(waiter);
 
 		schedule_rt_mutex(lock);
 
-		raw_spin_lock(&lock->wait_lock);
+		raw_spin_lock_irq(&lock->wait_lock);
 		set_current_state(state);
 	}
 
@@ -1130,20 +1128,23 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		  int detect_deadlock, struct ww_acquire_ctx *ww_ctx)
 {
 	struct rt_mutex_waiter waiter;
+	unsigned long flags;
 	int ret = 0;
 
 	rt_mutex_init_waiter(&waiter, false);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_local_save_flags(flags);
+	raw_spin_lock_irq(&lock->wait_lock);
 	init_lists(lock);
 
 	/* Try to acquire the lock again: */
 	if (try_to_take_rt_mutex(lock, current, NULL)) {
 		if (ww_ctx)
 			ww_mutex_account_lock(lock, ww_ctx);
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return 0;
 	}
+	BUG_ON(arch_irqs_disabled_flags(flags));
 
 	set_current_state(state);
 
@@ -1172,7 +1173,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	/* Remove pending timer: */
 	if (unlikely(timeout))
@@ -1189,9 +1190,10 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 static inline int
 rt_mutex_slowtrylock(struct rt_mutex *lock)
 {
+	unsigned long flags;
 	int ret = 0;
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 	init_lists(lock);
 
 	if (likely(rt_mutex_owner(lock) != current)) {
@@ -1204,7 +1206,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 		fixup_rt_mutex_waiters(lock);
 	}
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	return ret;
 }
@@ -1215,7 +1217,9 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 static void __sched
 rt_mutex_slowunlock(struct rt_mutex *lock)
 {
-	raw_spin_lock(&lock->wait_lock);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	debug_rt_mutex_unlock(lock);
 
@@ -1223,13 +1227,13 @@ rt_mutex_slowunlock(struct rt_mutex *lock)
 
 	if (!rt_mutex_has_waiters(lock)) {
 		lock->owner = NULL;
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return;
 	}
 
 	wakeup_next_waiter(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	/* Undo pi boosting if necessary: */
 	rt_mutex_adjust_prio(current);
@@ -1489,10 +1493,10 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 {
 	int ret;
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irq(&lock->wait_lock);
 
 	if (try_to_take_rt_mutex(lock, task, NULL)) {
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irq(&lock->wait_lock);
 		return 1;
 	}
 
@@ -1515,18 +1519,17 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	 * PI_REQUEUE_INPROGRESS, so that if the task is waking up
 	 * it will know that we are in the process of requeuing it.
 	 */
-	raw_spin_lock_irq(&task->pi_lock);
+	raw_spin_lock(&task->pi_lock);
 	if (task->pi_blocked_on) {
-		raw_spin_unlock_irq(&task->pi_lock);
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock(&task->pi_lock);
+		raw_spin_unlock_irq(&lock->wait_lock);
 		return -EAGAIN;
 	}
 	task->pi_blocked_on = PI_REQUEUE_INPROGRESS;
-	raw_spin_unlock_irq(&task->pi_lock);
+	raw_spin_unlock(&task->pi_lock);
 #endif
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
-
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
 		 * Reset the return value. We might have
@@ -1540,7 +1543,7 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	if (unlikely(ret))
 		remove_waiter(lock, waiter);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	debug_rt_mutex_print_deadlock(waiter);
 
@@ -1590,12 +1593,11 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 {
 	int ret;
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irq(&lock->wait_lock);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter, NULL);
-
 	set_current_state(TASK_RUNNING);
 
 	if (unlikely(ret))
@@ -1607,7 +1609,7 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return ret;
 }
diff --git a/localversion-rt b/localversion-rt
index 6f206be..c3054d0 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt1
+-rt2
