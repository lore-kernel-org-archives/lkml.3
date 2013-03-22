Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423348Ab3CVV47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:56:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:38994 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab3CVV46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:56:58 -0400
Date: Fri, 22 Mar 2013 22:56:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.6.11-rt31
Message-ID: <alpine.LFD.2.02.1303222227160.22263@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.11-rt31 release.

Changes since 3.6.11-rt31:

   1) Highmem fixes (Sebastian Siewior)

   2) Futex locking fix

   3) Add a missing timer check (Zhao Hongjiang)

   4) Make simple wait exports EXPORT_SYMBOL. As much as I hate it,
      but we have the policy that we do not break out of tree stuff
      when we move an existing interface to some other internal
      infrastructure. For further information see:
      http://www.youtube.com/watch?v=_36yNWw_07g

   5) irq poll fixup (Paul Gortmaker)

All credits for this update go to Sebastian Siewior, AKA bigeasy, who
took up the work to get this out. He's on my companies engineering
team and I hope you trust him as much as I do.

This is the last release for the 3.6 kernel from my side. Steven is
going to take over and maintain it until 3.8-rt is stabilized.

The delta patch against 3.6.11-rt30 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11-rt30-rt31.pa
tch.xz

The RT patch against 3.6.11 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-rt31.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11-rt31.tar.xz

Enjoy,

        tglx

---

Index: linux-stable/arch/arm/mm/highmem.c
===================================================================
--- linux-stable.orig/arch/arm/mm/highmem.c
+++ linux-stable/arch/arm/mm/highmem.c
@@ -97,12 +97,15 @@ void __kunmap_atomic(void *kvaddr)
 
 		if (cache_is_vivt())
 			__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);
+#ifdef CONFIG_PREEMPT_RT_FULL
+		current->kmap_pte[type] = __pte(0);
+#endif
 #ifdef CONFIG_DEBUG_HIGHMEM
 		BUG_ON(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
-		set_top_pte(vaddr, __pte(0));
 #else
 		(void) idx;  /* to kill a warning */
 #endif
+		set_top_pte(vaddr, __pte(0));
 		kmap_atomic_idx_pop();
 	} else if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
 		/* this address was obtained through kmap_high_get() */
@@ -163,8 +166,9 @@ void switch_kmaps(struct task_struct *pr
 	for (i = 0; i < next_p->kmap_idx; i++) {
 		int idx = i + KM_TYPE_NR * smp_processor_id();
 
-		set_top_pte(__fix_to_virt(FIX_KMAP_BEGIN + idx),
-			    next_p->kmap_pte[i]);
+		if (!pte_none(next_p->kmap_pte[i]))
+			set_top_pte(__fix_to_virt(FIX_KMAP_BEGIN + idx),
+					next_p->kmap_pte[i]);
 	}
 }
 #endif
Index: linux-stable/arch/x86/kernel/process_32.c
===================================================================
--- linux-stable.orig/arch/x86/kernel/process_32.c
+++ linux-stable/arch/x86/kernel/process_32.c
@@ -218,7 +218,8 @@ static void switch_kmaps(struct task_str
 	for (i = 0; i < next_p->kmap_idx; i++) {
 		int idx = i + KM_TYPE_NR * smp_processor_id();
 
-		set_pte(kmap_pte - idx, next_p->kmap_pte[i]);
+		if (!pte_none(next_p->kmap_pte[i]))
+			set_pte(kmap_pte - idx, next_p->kmap_pte[i]);
 	}
 }
 #else
Index: linux-stable/arch/x86/mm/highmem_32.c
===================================================================
--- linux-stable.orig/arch/x86/mm/highmem_32.c
+++ linux-stable/arch/x86/mm/highmem_32.c
@@ -91,6 +91,9 @@ void __kunmap_atomic(void *kvaddr)
 		 * is a bad idea also, in case the page changes cacheability
 		 * attributes or becomes a protected page in a hypervisor.
 		 */
+#ifdef CONFIG_PREEMPT_RT_FULL
+		current->kmap_pte[type] = __pte(0);
+#endif
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 		kmap_atomic_idx_pop();
 		arch_flush_lazy_mmu_mode();
Index: linux-stable/arch/x86/mm/iomap_32.c
===================================================================
--- linux-stable.orig/arch/x86/mm/iomap_32.c
+++ linux-stable/arch/x86/mm/iomap_32.c
@@ -65,6 +65,8 @@ void *kmap_atomic_prot_pfn(unsigned long
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	WARN_ON(!pte_none(*(kmap_pte - idx)));
+
 #ifdef CONFIG_PREEMPT_RT_FULL
 	current->kmap_pte[type] = pte;
 #endif
@@ -114,6 +116,9 @@ iounmap_atomic(void __iomem *kvaddr)
 		 * is a bad idea also, in case the page changes cacheability
 		 * attributes or becomes a protected page in a hypervisor.
 		 */
+#ifdef CONFIG_PREEMPT_RT_FULL
+		current->kmap_pte[type] = __pte(0);
+#endif
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 		kmap_atomic_idx_pop();
 	}
Index: linux-stable/include/linux/highmem.h
===================================================================
--- linux-stable.orig/include/linux/highmem.h
+++ linux-stable/include/linux/highmem.h
@@ -101,7 +101,9 @@ static inline int kmap_atomic_idx_push(v
 # endif
 	return idx;
 #else
-	return current->kmap_idx++;
+	current->kmap_idx++;
+	BUG_ON(current->kmap_idx > KM_TYPE_NR);
+	return current->kmap_idx - 1;
 #endif
 }
 
Index: linux-stable/kernel/Kconfig.preempt
===================================================================
--- linux-stable.orig/kernel/Kconfig.preempt
+++ linux-stable/kernel/Kconfig.preempt
@@ -77,6 +77,7 @@ config PREEMPT_RT_FULL
 	bool "Fully Preemptible Kernel (RT)"
 	depends on IRQ_FORCED_THREADING
 	select PREEMPT_RT_BASE
+	select PREEMPT_RCU
 	help
 	  All and everything
 
Index: linux-stable/kernel/futex.c
===================================================================
--- linux-stable.orig/kernel/futex.c
+++ linux-stable/kernel/futex.c
@@ -568,7 +568,9 @@ void exit_pi_state_list(struct task_stru
 		 * task still owns the PI-state:
 		 */
 		if (head->next != next) {
+			raw_spin_unlock_irq(&curr->pi_lock);
 			spin_unlock(&hb->lock);
+			raw_spin_lock_irq(&curr->pi_lock);
 			continue;
 		}
 
Index: linux-stable/kernel/hrtimer.c
===================================================================
--- linux-stable.orig/kernel/hrtimer.c
+++ linux-stable/kernel/hrtimer.c
@@ -1427,7 +1427,11 @@ static int hrtimer_rt_defer(struct hrtim
 
 #else
 
-static inline void hrtimer_rt_run_pending(void) { }
+static inline void hrtimer_rt_run_pending(void)
+{
+	hrtimer_peek_ahead_timers();
+}
+
 static inline int hrtimer_rt_defer(struct hrtimer *timer) { return 0; }
 
 #endif
Index: linux-stable/kernel/irq/spurious.c
===================================================================
--- linux-stable.orig/kernel/irq/spurious.c
+++ linux-stable/kernel/irq/spurious.c
@@ -343,7 +343,7 @@ static int __init irqfixup_setup(char *s
 {
 #ifdef CONFIG_PREEMPT_RT_BASE
 	printk(KERN_WARNING "irqfixup boot option not supported "
-		"w/ CONFIG_PREEMPT_RT\n");
+		"w/ CONFIG_PREEMPT_RT_BASE\n");
 	return 1;
 #endif
 	irqfixup = 1;
@@ -360,7 +360,7 @@ static int __init irqpoll_setup(char *st
 {
 #ifdef CONFIG_PREEMPT_RT_BASE
 	printk(KERN_WARNING "irqpoll boot option not supported "
-		"w/ CONFIG_PREEMPT_RT\n");
+		"w/ CONFIG_PREEMPT_RT_BASE\n");
 	return 1;
 #endif
 	irqfixup = 2;
Index: linux-stable/kernel/wait-simple.c
===================================================================
--- linux-stable.orig/kernel/wait-simple.c
+++ linux-stable/kernel/wait-simple.c
@@ -36,7 +36,7 @@ void __init_swait_head(struct swait_head
 	lockdep_set_class(&head->lock, key);
 	INIT_LIST_HEAD(&head->list);
 }
-EXPORT_SYMBOL_GPL(__init_swait_head);
+EXPORT_SYMBOL(__init_swait_head);
 
 void swait_prepare_locked(struct swait_head *head, struct swaiter *w)
 {
@@ -54,7 +54,7 @@ void swait_prepare(struct swait_head *he
 	__set_current_state(state);
 	raw_spin_unlock_irqrestore(&head->lock, flags);
 }
-EXPORT_SYMBOL_GPL(swait_prepare);
+EXPORT_SYMBOL(swait_prepare);
 
 void swait_finish_locked(struct swait_head *head, struct swaiter *w)
 {
@@ -74,7 +74,7 @@ void swait_finish(struct swait_head *hea
 		raw_spin_unlock_irqrestore(&head->lock, flags);
 	}
 }
-EXPORT_SYMBOL_GPL(swait_finish);
+EXPORT_SYMBOL(swait_finish);
 
 unsigned int
 __swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int num)
@@ -116,4 +116,4 @@ __swait_wake(struct swait_head *head, un
 	raw_spin_unlock_irqrestore(&head->lock, flags);
 	return woken;
 }
-EXPORT_SYMBOL_GPL(__swait_wake);
+EXPORT_SYMBOL(__swait_wake);
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt30
+-rt31
