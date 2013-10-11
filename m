Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3JKVEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:04:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:35915 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3JKVEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:04:41 -0400
Date: Fri, 11 Oct 2013 23:04:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.10.15-rt11
Message-ID: <20131011210439.GA30137@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.10.15-rt11 patch set.

Changes since v3.10.15-rt10
- two genirq patches: one was already in v3.8-rt ("genirq: Set irq
  thread to RT priority on creation"). The second ("genirq: Set the irq
  thread policy without checking CAP_SYS_NICE") ensures that the
  priority is also assigned if the irq is requested in user contex. Patch
  by Thomas Pfaff.
- A patch from Paul Gortmaker to compile PowerPC without RT
- Four patches from Paul Gortmaker to compile with SLAB while RT is
  disabled.
- A fix for "sleeping from invalid context" in tty_ldisc. Reported by
  Luis Claudio R. Goncalves.
- A fix for "sleeping from invalid context" in the drm layer triggered
  by the i915 driver. Reported by Luis Claudio R. Goncalves.

Known issues:

      - SLAB support not working

      - The cpsw network driver shows some issues.

      - bcache is disabled.

      - an ancient race (since we got sleeping spinlocks) where the
        TASK_TRACED state is temporary replaced while waiting on a rw
        lock and the task can't be traced.

      - livelock in sem_lock(). A race fix queued for 3.10+ fixes
        the livelock issue as well, but it's not yet in 3.10.15.
        Should someone trigger, please look at 5e9d5275 ("ipc/sem.c:
        fix race in sem_lock()") or wait till it hits the stable queue.

The delta patch against v3.10.15-rt10 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.15-rt10-rt11.patch.xz

The RT patch against 3.10.15 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.15-rt11.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patches-3.10.15-rt11.tar.xz

Sebastian

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index a47400d..87f730e 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -264,7 +264,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (!arch_irq_disabled_regs(regs))
 		local_irq_enable();
 
-	if (in_atomic() || mm == NULL || current->pagefault_disabled) {
+	if (in_atomic() || mm == NULL || pagefault_disabled()) {
 		if (!user_mode(regs)) {
 			rc = SIGSEGV;
 			goto bail;
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index f92da0a..434ea84 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -628,11 +628,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 	 * code gets preempted or delayed for some reason.
 	 */
 	for (i = 0; i < DRM_TIMESTAMP_MAXRETRIES; i++) {
-		/* Disable preemption to make it very likely to
-		 * succeed in the first iteration even on PREEMPT_RT kernel.
-		 */
-		preempt_disable();
-
 		/* Get system timestamp before query. */
 		stime = ktime_get();
 
@@ -644,8 +639,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 		if (!drm_timestamp_monotonic)
 			mono_time_offset = ktime_get_monotonic_offset();
 
-		preempt_enable();
-
 		/* Return as no-op if scanout query unsupported or failed. */
 		if (!(vbl_status & DRM_SCANOUTPOS_VALID)) {
 			DRM_DEBUG("crtc %d : scanoutpos query failed [%d].\n",
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 1afe192..bc4ffe4 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -197,9 +197,10 @@ static inline void tty_ldisc_put(struct tty_ldisc *ld)
 	WARN_ON(!atomic_dec_and_test(&ld->users));
 
 	ld->ops->refcount--;
+	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+
 	module_put(ld->ops->owner);
 	kfree(ld);
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 }
 
 static void *tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c5c19ec..7d59fb1f9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -923,9 +923,6 @@ static void irq_thread_dtor(struct callback_head *unused)
 static int irq_thread(void *data)
 {
 	struct callback_head on_exit_work;
-	static const struct sched_param param = {
-		.sched_priority = MAX_USER_RT_PRIO/2,
-	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -937,8 +934,6 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
-
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, false);
 
@@ -1039,6 +1034,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (new->thread_fn && !nested) {
 		struct task_struct *t;
+		static const struct sched_param param = {
+			.sched_priority = MAX_USER_RT_PRIO/2,
+		};
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
 				   new->name);
@@ -1046,6 +1044,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			ret = PTR_ERR(t);
 			goto out_mput;
 		}
+
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
+
 		/*
 		 * We keep the reference to the task struct even if
 		 * the thread dies to avoid that the interrupt code
diff --git a/localversion-rt b/localversion-rt
index d79dde6..05c35cb 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt10
+-rt11
diff --git a/mm/slab.c b/mm/slab.c
index 0a3d6d3..1e9330f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -700,6 +700,12 @@ static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
 	return cachep->array[smp_processor_id()];
 }
 
+static inline struct array_cache *cpu_cache_get_on_cpu(struct kmem_cache *cachep,
+						       int cpu)
+{
+	return cachep->array[cpu];
+}
+
 static size_t slab_mgmt_size(size_t nr_objs, size_t align)
 {
 	return ALIGN(sizeof(struct slab)+nr_objs*sizeof(kmem_bufctl_t), align);
@@ -1233,11 +1239,11 @@ static int init_cache_node_node(int node)
 			cachep->node[node] = n;
 		}
 
-		local_spin_lock_irq(slab_lock, &cachep->nodelists[node]->list_lock);
+		local_spin_lock_irq(slab_lock, &cachep->node[node]->list_lock);
 		cachep->node[node]->free_limit =
 			(1 + nr_cpus_node(node)) *
 			cachep->batchcount + cachep->num;
-		local_spin_unlock_irq(slab_lock, &cachep->nodelists[node]->list_lock);
+		local_spin_unlock_irq(slab_lock, &cachep->node[node]->list_lock);
 	}
 	return 0;
 }
@@ -2517,7 +2523,7 @@ static void drain_array(struct kmem_cache *cachep, struct kmem_cache_node *n,
 			struct array_cache *ac,
 			int force, int node);
 
-static void __do_drain(void *arg, unsigned int cpu)+static void __do_drain(void *arg, unsigned int cpu)
+static void __do_drain(void *arg, unsigned int cpu)
 {
 	struct kmem_cache *cachep = arg;
 	struct array_cache *ac;
@@ -4058,7 +4064,7 @@ static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
 				    &cachep->node[cpu_to_mem(i)]->list_lock);
 		free_block(cachep, ccold->entry, ccold->avail, cpu_to_mem(i));
 
-		unlock_l3_and_free_delayed(&cachep->nodelists[cpu_to_mem(i)]->list_lock);
+		unlock_l3_and_free_delayed(&cachep->node[cpu_to_mem(i)]->list_lock);
 		kfree(ccold);
 	}
 	kfree(new);
diff --git a/mm/slab.h b/mm/slab.h
index 2e6c8b7..fc3c097 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -247,7 +247,11 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
  * The slab lists for all objects.
  */
 struct kmem_cache_node {
+#ifdef CONFIG_SLAB
+	spinlock_t list_lock;
+#else
 	raw_spinlock_t list_lock;
+#endif
 
 #ifdef CONFIG_SLAB
 	struct list_head slabs_partial;	/* partial list first, better asm code */
