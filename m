Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3DZWUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:20:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:50799 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3DZWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:20:03 -0400
Date: Sat, 27 Apr 2013 00:20:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org
Subject: [ANNOUNCE] 3.8.9-rt4
Message-ID: <20130426222001.GH20927@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.9-rt4 release.

changes since v3.8.9-rt4:
- the quilt queue can be imported into git without hiccup
- a giant/ huge/ big pile of cpsw patches has been added. If you have an
  ARM AM33xx (beagle bone for instance) then your network should work.
  I merged driver related changes DaveM had in his net & net-next tree.
- i915 with tracing should not try to grab a spinlock in a
  preempt-disabled region. Reported by Joakim Hernberg
- PPC64 forgot to check the preempt counter in ret_from_except_lite().
  Patch sent by Priyanka Jain
- __schedule_bug() had a typo in a ifdef and as consequence additional
  debug output was not printed. Patch sent by Qiang Huang
- builds now on ARM/imx. Reported by Arpit Goel. 
- mce wakeup defered from a workqueue to a kthread. Steven Rostedt found
  this and sent a patch.
- a networking fix for a warning in inet_sk_rx_dst_set(). Caused by a
  route flush in the right moment. Reported by Mike Galbraith, patch by
  Eric Dumazet.
- the swap_lock has been renamed because it was not unique and caused
  trouble with weak-per-cpu defines. Reported by Mike Galbraith patch by
  Steven Rostedt.
- preempt_disable_nort() and friends use now barrier() instead of do {}
  while 0 in the unused case. Clashed with stable commit ("spinlocks
  and preemption points need to be at least compiler barriers").

Known issues:

    - SLxB is broken on PowerPC.
    - suspend / resume seems to program program the timer wrong and wait
      ages until it continues.

The delta patch against v3.8.9-rt3 without drivers/net/../ti/ is
appended below and the complete one can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.9-rt3-rt4.patch.xz

The RT patch against 3.8.9 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.9-rt4.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.9-rt4.tar.xz

Sebastian

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index c2f14e8..91fe4f1 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -349,7 +349,7 @@
 			rx_descs = <64>;
 			mac_control = <0x20>;
 			slaves = <2>;
-			cpts_active_slave = <0>;
+			active_slave = <0>;
 			cpts_clock_mult = <0x80000000>;
 			cpts_clock_shift = <29>;
 			reg = <0x4a100000 0x800
@@ -385,5 +385,19 @@
 				mac-address = [ 00 00 00 00 00 00 ];
 			};
 		};
+
+		ocmcram: ocmcram@40300000 {
+			compatible = "ti,am3352-ocmcram";
+			reg = <0x40300000 0x10000>;
+			ti,hwmods = "ocmcram";
+			ti,no_idle_on_suspend;
+		};
+
+		wkup_m3: wkup_m3@44d00000 {
+			compatible = "ti,am3353-wkup-m3";
+			reg = <0x44d00000 0x4000	/* M3 UMEM */
+			       0x44d80000 0x2000>;	/* M3 DMEM */
+			ti,hwmods = "wkup_m3";
+		};
 	};
 };
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index efdad96..9f0ca17 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -643,6 +643,8 @@ _GLOBAL(ret_from_except_lite)
 #ifdef CONFIG_PREEMPT
 	/* Check if we need to preempt */
 	lwz	r8,TI_PREEMPT(r9)
+	cmpwi	0,r8,0		/* if non-zero, just restore regs and return */
+	bne	restore
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	bne+	check_count
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b57a6ed..332e133 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -18,6 +18,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kobject.h>
 #include <linux/uaccess.h>
+#include <linux/kthread.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
 #include <linux/percpu.h>
@@ -1345,6 +1346,63 @@ static void mce_do_trigger(struct work_struct *work)
 
 static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
 
+static void __mce_notify_work(void)
+{
+	/* Not more than two messages every minute */
+	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
+
+	/* wake processes polling /dev/mcelog */
+	wake_up_interruptible(&mce_chrdev_wait);
+
+	/*
+	 * There is no risk of missing notifications because
+	 * work_pending is always cleared before the function is
+	 * executed.
+	 */
+	if (mce_helper[0] && !work_pending(&mce_trigger_work))
+		schedule_work(&mce_trigger_work);
+
+	if (__ratelimit(&ratelimit))
+		pr_info(HW_ERR "Machine check events logged\n");
+}
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+struct task_struct *mce_notify_helper;
+
+static int mce_notify_helper_thread(void *unused)
+{
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+		if (kthread_should_stop())
+			break;
+		__mce_notify_work();
+	}
+	return 0;
+}
+
+static int mce_notify_work_init(void)
+{
+	mce_notify_helper = kthread_run(mce_notify_helper_thread, NULL,
+					   "mce-notify");
+	if (!mce_notify_helper)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void mce_notify_work(void)
+{
+	wake_up_process(mce_notify_helper);
+}
+#else
+static void mce_notify_work(void)
+{
+	__mce_notify_work();
+}
+static inline int mce_notify_work_init(void) { return 0; }
+#endif
+
 /*
  * Notify the user(s) about new machine check events.
  * Can be called from interrupt context, but not from machine check/NMI
@@ -1352,24 +1410,8 @@ static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
  */
 int mce_notify_irq(void)
 {
-	/* Not more than two messages every minute */
-	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
-		/* wake processes polling /dev/mcelog */
-		wake_up_interruptible(&mce_chrdev_wait);
-
-		/*
-		 * There is no risk of missing notifications because
-		 * work_pending is always cleared before the function is
-		 * executed.
-		 */
-		if (mce_helper[0] && !work_pending(&mce_trigger_work))
-			schedule_work(&mce_trigger_work);
-
-		if (__ratelimit(&ratelimit))
-			pr_info(HW_ERR "Machine check events logged\n");
-
+		mce_notify_work();
 		return 1;
 	}
 	return 0;
@@ -2431,6 +2473,8 @@ static __init int mcheck_init_device(void)
 	/* register character device /dev/mcelog */
 	misc_register(&mce_chrdev_device);
 
+	err = mce_notify_work_init();
+
 	return err;
 }
 device_initcall_sync(mcheck_init_device);
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index ba8805a..81125de 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1069,6 +1069,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	}
 
 	trace_i915_gem_ring_dispatch(ring, intel_ring_get_seqno(ring), flags);
+	i915_trace_irq_get(ring, seqno);
 
 	i915_gem_execbuffer_move_to_active(&objects, ring);
 	i915_gem_execbuffer_retire_commands(dev, file, ring);
diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index 3db4a68..29217db 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -244,7 +244,6 @@ TRACE_EVENT(i915_gem_ring_dispatch,
 			   __entry->ring = ring->id;
 			   __entry->seqno = seqno;
 			   __entry->flags = flags;
-			   i915_trace_irq_get(ring, seqno);
 			   ),
 
 	    TP_printk("dev=%u, ring=%u, seqno=%u, flags=%x",
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index 6af87cd..8b5e4ae 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -232,8 +232,10 @@ static inline u32 intel_ring_get_seqno(struct intel_ring_buffer *ring)
 
 static inline void i915_trace_irq_get(struct intel_ring_buffer *ring, u32 seqno)
 {
+#ifdef CONFIG_TRACEPOINTS
 	if (ring->trace_irq_seqno == 0 && ring->irq_get(ring))
 		ring->trace_irq_seqno = seqno;
+#endif
 }
 
 /* DRI warts */
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 5a0c0b6..c84696c 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -796,13 +796,13 @@ void fscache_invalidate_writes(struct fscache_cookie *cookie)
 
 	_enter("");
 
-	do  {
-		spin_lock(&cookie->stores_lock);
+	spin_lock(&cookie->stores_lock);
+	while (1) {
 		n = radix_tree_gang_lookup_tag(&cookie->stores, results, 0,
-				ARRAY_SIZE(results),
-				FSCACHE_COOKIE_PENDING_TAG);
-	       if (n == 0)
-		       break;
+					       ARRAY_SIZE(results),
+					       FSCACHE_COOKIE_PENDING_TAG);
+		if (n == 0)
+			break;
 		for (i = n - 1; i >= 0; i--) {
 			page = results[i];
 			radix_tree_delete(&cookie->stores, page->index);
@@ -812,7 +812,8 @@ void fscache_invalidate_writes(struct fscache_cookie *cookie)
 
 		for (i = n - 1; i >= 0; i--)
 			page_cache_release(results[i]);
-	} while (1);
+		spin_lock(&cookie->stores_lock);
+	}
 
 	spin_unlock(&cookie->stores_lock);
 	_leave("");
diff --git a/include/linux/platform_data/cpsw.h b/include/linux/platform_data/cpsw.h
index 24368a2..bb3cd58 100644
--- a/include/linux/platform_data/cpsw.h
+++ b/include/linux/platform_data/cpsw.h
@@ -21,6 +21,8 @@ struct cpsw_slave_data {
 	char		phy_id[MII_BUS_ID_SIZE];
 	int		phy_if;
 	u8		mac_addr[ETH_ALEN];
+	u16		dual_emac_res_vlan;	/* Reserved VLAN for DualEMAC */
+
 };
 
 struct cpsw_platform_data {
@@ -28,13 +30,15 @@ struct cpsw_platform_data {
 	u32	channels;	/* number of cpdma channels (symmetric) */
 	u32	slaves;		/* number of slave cpgmac ports */
 	struct cpsw_slave_data	*slave_data;
-	u32	cpts_active_slave; /* time stamping slave */
+	u32	active_slave; /* time stamping, ethtool and SIOCGMIIPHY slave */
 	u32	cpts_clock_mult;  /* convert input clock ticks to nanoseconds */
 	u32	cpts_clock_shift; /* convert input clock ticks to nanoseconds */
 	u32	ale_entries;	/* ale table size */
 	u32	bd_ram_size;  /*buffer descriptor ram size */
 	u32	rx_descs;	/* Number of Rx Descriptios */
 	u32	mac_control;	/* Mac control register */
+	u16	default_vlan;	/* Def VLAN for ALE lookup in VLAN aware mode*/
+	bool	dual_emac;	/* Enable Dual EMAC mode */
 };
 
 #endif /* __CPSW_H__ */
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 2263bf6..a7f4212 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -85,7 +85,7 @@ do { \
 
 #ifndef CONFIG_PREEMPT_RT_BASE
 # define preempt_enable_no_resched()	sched_preempt_enable_no_resched()
-# define preempt_check_resched_rt()	do { } while (0)
+# define preempt_check_resched_rt()	barrier()
 #else
 # define preempt_enable_no_resched()	preempt_enable()
 # define preempt_check_resched_rt()	preempt_check_resched()
@@ -149,25 +149,25 @@ do { \
 #define preempt_disable_notrace()		barrier()
 #define preempt_enable_no_resched_notrace()	barrier()
 #define preempt_enable_notrace()		barrier()
-#define preempt_check_resched_rt()		do { } while (0)
+#define preempt_check_resched_rt()		barrier()
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
 #ifdef CONFIG_PREEMPT_RT_FULL
 # define preempt_disable_rt()		preempt_disable()
 # define preempt_enable_rt()		preempt_enable()
-# define preempt_disable_nort()		do { } while (0)
-# define preempt_enable_nort()		do { } while (0)
+# define preempt_disable_nort()		barrier()
+# define preempt_enable_nort()		barrier()
 # ifdef CONFIG_SMP
    extern void migrate_disable(void);
    extern void migrate_enable(void);
 # else /* CONFIG_SMP */
-#  define migrate_disable()		do { } while (0)
-#  define migrate_enable()		do { } while (0)
+#  define migrate_disable()		barrier()
+#  define migrate_enable()		barrier()
 # endif /* CONFIG_SMP */
 #else
-# define preempt_disable_rt()		do { } while (0)
-# define preempt_enable_rt()		do { } while (0)
+# define preempt_disable_rt()		barrier()
+# define preempt_enable_rt()		barrier()
 # define preempt_disable_nort()		preempt_disable()
 # define preempt_enable_nort()		preempt_enable()
 # define migrate_disable()		preempt_disable()
diff --git a/include/linux/spinlock_types_rt.h b/include/linux/spinlock_types_rt.h
index 1fe8fc0..9fd4319 100644
--- a/include/linux/spinlock_types_rt.h
+++ b/include/linux/spinlock_types_rt.h
@@ -5,6 +5,8 @@
 #error "Do not include directly. Include spinlock_types.h instead"
 #endif
 
+#include <linux/cache.h>
+
 /*
  * PREEMPT_RT: spinlocks - an RT mutex plus lock-break field:
  */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index aed42c7..4da2167 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1045,6 +1045,7 @@ static inline bool tcp_prequeue(struct sock *sk, struct sk_buff *skb)
 	if (sysctl_tcp_low_latency || !tp->ucopy.task)
 		return false;
 
+	skb_dst_force(skb);
 	__skb_queue_tail(&tp->ucopy.prequeue, skb);
 	tp->ucopy.memory += skb->truesize;
 	if (tp->ucopy.memory > sk->sk_rcvbuf) {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cf93d6b..1ec9d1f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2885,7 +2885,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	print_modules();
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
-#ifdef DEBUG_PREEMPT
+#ifdef CONFIG_DEBUG_PREEMPT
 	if (in_atomic_preempt_off()) {
 		pr_err("Preemption disabled at:");
 		print_ip_sym(current->preempt_disable_ip);
@@ -7412,7 +7412,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	debug_show_held_locks(current);
 	if (irqs_disabled())
 		print_irqtrace_events(current);
-#ifdef DEBUG_PREEMPT
+#ifdef CONFIG_DEBUG_PREEMPT
 	if (!preempt_count_equals(preempt_offset)) {
 		pr_err("Preemption disabled at:");
 		print_ip_sym(current->preempt_disable_ip);
diff --git a/localversion-rt b/localversion-rt
index 1445cd6..ad3da1b 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt3
+-rt4
diff --git a/mm/swap.c b/mm/swap.c
index 63f42b8..5812f96 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -42,7 +42,7 @@ static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
 static DEFINE_LOCAL_IRQ_LOCK(rotate_lock);
-static DEFINE_LOCAL_IRQ_LOCK(swap_lock);
+static DEFINE_LOCAL_IRQ_LOCK(swapvec_lock);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -407,13 +407,13 @@ static void activate_page_drain(int cpu)
 void activate_page(struct page *page)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-		struct pagevec *pvec = &get_locked_var(swap_lock,
+		struct pagevec *pvec = &get_locked_var(swapvec_lock,
 						       activate_page_pvecs);
 
 		page_cache_get(page);
 		if (!pagevec_add(pvec, page))
 			pagevec_lru_move_fn(pvec, __activate_page, NULL);
-		put_locked_var(swap_lock, activate_page_pvecs);
+		put_locked_var(swapvec_lock, activate_page_pvecs);
 	}
 }
 
@@ -461,13 +461,13 @@ EXPORT_SYMBOL(mark_page_accessed);
  */
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
-	struct pagevec *pvec = &get_locked_var(swap_lock, lru_add_pvecs)[lru];
+	struct pagevec *pvec = &get_locked_var(swapvec_lock, lru_add_pvecs)[lru];
 
 	page_cache_get(page);
 	if (!pagevec_space(pvec))
 		__pagevec_lru_add(pvec, lru);
 	pagevec_add(pvec, page);
-	put_locked_var(swap_lock, lru_add_pvecs);
+	put_locked_var(swapvec_lock, lru_add_pvecs);
 }
 EXPORT_SYMBOL(__lru_cache_add);
 
@@ -632,19 +632,19 @@ void deactivate_page(struct page *page)
 		return;
 
 	if (likely(get_page_unless_zero(page))) {
-		struct pagevec *pvec = &get_locked_var(swap_lock,
+		struct pagevec *pvec = &get_locked_var(swapvec_lock,
 						       lru_deactivate_pvecs);
 
 		if (!pagevec_add(pvec, page))
 			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
-		put_locked_var(swap_lock, lru_deactivate_pvecs);
+		put_locked_var(swapvec_lock, lru_deactivate_pvecs);
 	}
 }
 
 void lru_add_drain(void)
 {
-	lru_add_drain_cpu(local_lock_cpu(swap_lock));
-	local_unlock_cpu(swap_lock);
+	lru_add_drain_cpu(local_lock_cpu(swapvec_lock));
+	local_unlock_cpu(swapvec_lock);
 }
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
