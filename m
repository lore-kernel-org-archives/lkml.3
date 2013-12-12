Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3LLOW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:22:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36057 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3LLOVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:21:18 -0500
Message-Id: <20131212141654.757388820@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Dec 2013 15:08:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] preempt, locking: Rework local_bh_{dis,en}able()
References: <20131212140835.729222186@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-inline-local_bh_disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently local_bh_disable() is out-of-line for no apparent reason.
So inline it to save a few cycles on call/return nonsense, the
function body is a single add on x86 (a few loads and store extra on
load/store archs).

Also expose two new local_bh functions:

  __local_bh_{dis,en}able_ip(unsigned long ip, unsigned int cnt);

Which implement the actual local_bh_{dis,en}able() behaviour.

The next patch uses the exposed @cnt argument to optimize bh lock
functions.

With build fixes from Jacob Pan.

Cc: rjw@rjwysocki.net
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/bottom_half.h  |   32 +++++++++++++++++++++++++++++---
 include/linux/hardirq.h      |    1 +
 include/linux/preempt_mask.h |    1 -
 kernel/softirq.c             |   35 ++++++-----------------------------
 4 files changed, 36 insertions(+), 33 deletions(-)

--- a/include/linux/bottom_half.h
+++ b/include/linux/bottom_half.h
@@ -1,9 +1,35 @@
 #ifndef _LINUX_BH_H
 #define _LINUX_BH_H
 
-extern void local_bh_disable(void);
+#include <linux/preempt.h>
+#include <linux/preempt_mask.h>
+
+#ifdef CONFIG_TRACE_IRQFLAGS
+extern void __local_bh_disable_ip(unsigned long ip, unsigned int cnt);
+#else
+static __always_inline void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
+{
+	preempt_count_add(cnt);
+	barrier();
+}
+#endif
+
+static inline void local_bh_disable(void)
+{
+	__local_bh_disable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
+}
+
 extern void _local_bh_enable(void);
-extern void local_bh_enable(void);
-extern void local_bh_enable_ip(unsigned long ip);
+extern void __local_bh_enable_ip(unsigned long ip, unsigned int cnt);
+
+static inline void local_bh_enable_ip(unsigned long ip)
+{
+	__local_bh_enable_ip(ip, SOFTIRQ_DISABLE_OFFSET);
+}
+
+static inline void local_bh_enable(void)
+{
+	__local_bh_enable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
+}
 
 #endif /* _LINUX_BH_H */
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -5,6 +5,7 @@
 #include <linux/lockdep.h>
 #include <linux/ftrace_irq.h>
 #include <linux/vtime.h>
+#include <asm/hardirq.h>
 
 
 extern void synchronize_irq(unsigned int irq);
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -2,7 +2,6 @@
 #define LINUX_PREEMPT_MASK_H
 
 #include <linux/preempt.h>
-#include <asm/hardirq.h>
 
 /*
  * We put the hardirq and softirq counter into the preemption
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -89,7 +89,7 @@ static void wakeup_softirqd(void)
  * where hardirqs are disabled legitimately:
  */
 #ifdef CONFIG_TRACE_IRQFLAGS
-static void __local_bh_disable(unsigned long ip, unsigned int cnt)
+void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
 {
 	unsigned long flags;
 
@@ -114,21 +114,9 @@ static void __local_bh_disable(unsigned
 	if (preempt_count() == cnt)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
-#else /* !CONFIG_TRACE_IRQFLAGS */
-static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
-{
-	preempt_count_add(cnt);
-	barrier();
-}
+EXPORT_SYMBOL(__local_bh_disable_ip);
 #endif /* CONFIG_TRACE_IRQFLAGS */
 
-void local_bh_disable(void)
-{
-	__local_bh_disable(_RET_IP_, SOFTIRQ_DISABLE_OFFSET);
-}
-
-EXPORT_SYMBOL(local_bh_disable);
-
 static void __local_bh_enable(unsigned int cnt)
 {
 	WARN_ON_ONCE(!irqs_disabled());
@@ -151,7 +139,7 @@ void _local_bh_enable(void)
 
 EXPORT_SYMBOL(_local_bh_enable);
 
-static inline void _local_bh_enable_ip(unsigned long ip)
+void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 {
 	WARN_ON_ONCE(in_irq() || irqs_disabled());
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -166,7 +154,7 @@ static inline void _local_bh_enable_ip(u
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
  	 */
-	preempt_count_sub(SOFTIRQ_DISABLE_OFFSET - 1);
+	preempt_count_sub(cnt - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending())) {
 		/*
@@ -182,18 +170,7 @@ static inline void _local_bh_enable_ip(u
 #endif
 	preempt_check_resched();
 }
-
-void local_bh_enable(void)
-{
-	_local_bh_enable_ip(_RET_IP_);
-}
-EXPORT_SYMBOL(local_bh_enable);
-
-void local_bh_enable_ip(unsigned long ip)
-{
-	_local_bh_enable_ip(ip);
-}
-EXPORT_SYMBOL(local_bh_enable_ip);
+EXPORT_SYMBOL(__local_bh_enable_ip);
 
 /*
  * We restart softirq processing for at most MAX_SOFTIRQ_RESTART times,
@@ -264,7 +241,7 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_irq_enter_time(current);
 
-	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_OFFSET);
 	in_hardirq = lockdep_softirq_start();
 
 	cpu = smp_processor_id();


