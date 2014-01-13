Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaAMQnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:43:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbaAMQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:43:07 -0500
Date: Mon, 13 Jan 2014 08:42:25 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-0bd3a173d711857fc9f583eb5825386cc08f3948@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        arjan@linux.intel.com, peterz@infradead.org, bitbucket@online.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, peterz@infradead.org, bitbucket@online.de,
        tglx@linutronix.de
In-Reply-To: <20131119151338.GF3694@twins.programming.kicks-ass.net>
References: <20131119151338.GF3694@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/preempt, locking: Rework local_bh_{dis,
 en}able()
Git-Commit-ID: 0bd3a173d711857fc9f583eb5825386cc08f3948
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 08:42:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bd3a173d711857fc9f583eb5825386cc08f3948
Gitweb:     http://git.kernel.org/tip/0bd3a173d711857fc9f583eb5825386cc08f3948
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 19 Nov 2013 16:13:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 17:32:27 +0100

sched/preempt, locking: Rework local_bh_{dis,en}able()

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
Cc: hpa@zytor.com
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131119151338.GF3694@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/bottom_half.h  | 32 +++++++++++++++++++++++++++++---
 include/linux/hardirq.h      |  1 +
 include/linux/preempt_mask.h |  1 -
 kernel/softirq.c             | 35 ++++++-----------------------------
 4 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
index 27b1bcf..86c12c9 100644
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
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d9cf963..12d5f97 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -5,6 +5,7 @@
 #include <linux/lockdep.h>
 #include <linux/ftrace_irq.h>
 #include <linux/vtime.h>
+#include <asm/hardirq.h>
 
 
 extern void synchronize_irq(unsigned int irq);
diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index b8d96bc..dbeec4d 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -2,7 +2,6 @@
 #define LINUX_PREEMPT_MASK_H
 
 #include <linux/preempt.h>
-#include <asm/hardirq.h>
 
 /*
  * We put the hardirq and softirq counter into the preemption
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7500cce1..9e368ef 100644
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
 
@@ -114,21 +114,9 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
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
@@ -166,7 +154,7 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
  	 */
-	preempt_count_sub(SOFTIRQ_DISABLE_OFFSET - 1);
+	preempt_count_sub(cnt - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending())) {
 		/*
@@ -182,18 +170,7 @@ static inline void _local_bh_enable_ip(unsigned long ip)
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
@@ -230,7 +207,7 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_irq_enter_time(current);
 
-	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
