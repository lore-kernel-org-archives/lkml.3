Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaAYNpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 08:45:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:32788 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaAYNpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 08:45:24 -0500
Date: Sat, 25 Jan 2014 14:45:19 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.8-rt11
Message-ID: <20140125134519.GA9845@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.8-rt11 patch set.

Changes since v3.12.8-rt10
- The "do not to raise the timer softirq unconditionally" resulted a few
  boot lockups on a few boxes. Steven found the problem and sent a fix.
  Thank you Steven.
- A compile fix to "do not to raise the timer softirq unconditionally"
  patch to compile without RT enabled.
- Brian Silverman reported a BUG (Debian #723180) where gdb's
  record command does something nasty and causes a double fault on
  x86-64 kernel with 32bit userland (the debugged application).
  The problem was a RT specific patch which has been reverted
- Sami Pietikäinen reported a crash in __ip_make_skb(). Nicholas
  Mc Guire posted a patch for it, thank you Nicholas.
- A patch from Steven to document why we need a spinlock in struct
  hotplug_pcp
- Don't unwind on ARM if called from irq_disabled() regions. This may
  cause a lockup with debug object enabled while loading a module.

There is also a patch in the queue from Paul E. McKenney to move RCU
processing from softirq into its own thread. After Mike Galbraith
reported a few RCU stalls I decided to keep it disabled for now.
Steven's fix may have fixed the problem. If nothing else comes up I will
try to enable it in the next release.

Known issues:

      - bcache is disabled.

The delta patch against v3.12.8-rt11 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.8-rt10-rt11.patch.xz

The RT patch against 3.12.8 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.8-rt11.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.8-rt11.tar.xz

Sebastian

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..2af232d 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -195,6 +195,11 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 		/* module unwind tables */
 		struct unwind_table *table;
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+		if (irqs_disabled())
+			goto out;
+#endif
+
 		spin_lock_irqsave(&unwind_lock, flags);
 		list_for_each_entry(table, &unwind_tables, list) {
 			if (addr >= table->begin_addr &&
@@ -211,6 +216,7 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 	}
 
 	pr_debug("%s: idx = %p\n", __func__, idx);
+out:
 	return idx;
 }
 
@@ -345,7 +351,9 @@ int unwind_frame(struct stackframe *frame)
 
 	idx = unwind_find_idx(frame->pc);
 	if (!idx) {
+#ifndef CONFIG_PREEMPT_RT_FULL
 		pr_warning("unwind: Index not found %08lx\n", frame->pc);
+#endif
 		return -URC_FAILURE;
 	}
 
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 695e04d..43dcd80 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -14,21 +14,12 @@
 #define IRQ_STACK_ORDER 2
 #define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-# define STACKFAULT_STACK 0
-# define DOUBLEFAULT_STACK 1
-# define NMI_STACK 2
-# define DEBUG_STACK 0
-# define MCE_STACK 3
-# define N_EXCEPTION_STACKS 3  /* hw limit: 7 */
-#else
-# define STACKFAULT_STACK 1
-# define DOUBLEFAULT_STACK 2
-# define NMI_STACK 3
-# define DEBUG_STACK 4
-# define MCE_STACK 5
-# define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
-#endif
+#define STACKFAULT_STACK 1
+#define DOUBLEFAULT_STACK 2
+#define NMI_STACK 3
+#define DEBUG_STACK 4
+#define MCE_STACK 5
+#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c0dcf06..2793d1f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1105,9 +1105,7 @@ DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
  */
 static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
 	  [0 ... N_EXCEPTION_STACKS - 1]	= EXCEPTION_STKSZ,
-#if DEBUG_STACK > 0
 	  [DEBUG_STACK - 1]			= DEBUG_STKSZ
-#endif
 };
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 52b4bcd..addb207 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -21,14 +21,10 @@
 		(N_EXCEPTION_STACKS + DEBUG_STKSZ/EXCEPTION_STKSZ - 2)
 
 static char x86_stack_ids[][8] = {
-#if DEBUG_STACK > 0
 		[ DEBUG_STACK-1			]	= "#DB",
-#endif
 		[ NMI_STACK-1			]	= "NMI",
 		[ DOUBLEFAULT_STACK-1		]	= "#DF",
-#if STACKFAULT_STACK > 0
 		[ STACKFAULT_STACK-1		]	= "#SS",
-#endif
 		[ MCE_STACK-1			]	= "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
 		[ N_EXCEPTION_STACKS ...
diff --git a/kernel/cpu.c b/kernel/cpu.c
index c36b075..ba7416b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -85,6 +85,14 @@ struct hotplug_pcp {
 	struct completion synced;
 	struct completion unplug_wait;
 #ifdef CONFIG_PREEMPT_RT_FULL
+	/*
+	 * Note, on PREEMPT_RT, the hotplug lock must save the state of
+	 * the task, otherwise the mutex will cause the task to fail
+	 * to sleep when required. (Because it's called from migrate_disable())
+	 *
+	 * The spinlock_t on PREEMPT_RT is a mutex that saves the task's
+	 * state.
+	 */
 	spinlock_t lock;
 #else
 	struct mutex mutex;
diff --git a/kernel/timer.c b/kernel/timer.c
index 46467be..106968f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1460,19 +1460,29 @@ void run_local_timers(void)
 	 * interrupt. If there are no timers queued, nothing to do in
 	 * the timer softirq.
 	 */
+#ifdef CONFIG_PREEMPT_RT_FULL
 	if (!spin_do_trylock(&base->lock)) {
 		raise_softirq(TIMER_SOFTIRQ);
 		return;
 	}
-	if (!base->active_timers)
-		goto out;
+#endif
+	if (!base->active_timers) {
+#ifdef CONFIG_PREEMPT_RT_FULL
+		/* On RT, irq work runs from softirq */
+		if (!irq_work_needs_cpu())
+#endif
+			goto out;
+	}
 
 	/* Check whether the next pending timer has expired */
 	if (time_before_eq(base->next_timer, jiffies))
 		raise_softirq(TIMER_SOFTIRQ);
 out:
+#ifdef CONFIG_PREEMPT_RT_FULL
 	rt_spin_unlock_after_trylock_in_irq(&base->lock);
-
+#endif
+	/* The ; ensures that gcc won't complain in the !RT case */
+	;
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
diff --git a/localversion-rt b/localversion-rt
index d79dde6..05c35cb 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt10
+-rt11
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index e9fa68c..8bb3b4a 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -79,6 +79,7 @@
 #include <linux/mroute.h>
 #include <linux/netlink.h>
 #include <linux/tcp.h>
+#include <linux/locallock.h>
 
 int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
 EXPORT_SYMBOL(sysctl_ip_default_ttl);
@@ -1468,6 +1469,9 @@ static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
 	.uc_ttl		= -1,
 };
 
+/* serialize concurrent calls on the same CPU to ip_send_unicast_reply */
+static DEFINE_LOCAL_IRQ_LOCK(unicast_lock);
+
 void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 			   __be32 saddr, const struct ip_reply_arg *arg,
 			   unsigned int len)
@@ -1505,8 +1509,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 	if (IS_ERR(rt))
 		return;
 
-	get_cpu_light();
-	inet = &__get_cpu_var(unicast_sock);
+	inet = &get_locked_var(unicast_lock, unicast_sock);
 
 	inet->tos = arg->tos;
 	sk = &inet->sk;
@@ -1530,7 +1533,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		ip_push_pending_frames(sk, &fl4);
 	}
 
-	put_cpu_light();
+	put_locked_var(unicast_lock, unicast_sock);
 
 	ip_rt_put(rt);
 }
