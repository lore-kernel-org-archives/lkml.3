Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909Ab3BPFHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:07:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:9865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab3BPFHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:07:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,676,1355126400"; 
   d="scan'208";a="291931043"
Subject: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: mingo@kernel.org
Cc: peterz@infradead.org, jbeulich@suse.com, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mina86@mina86.org,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        jun.zhang@intel.com, fengguang.wu@intel.com, chuansheng.liu@intel.com
In-Reply-To: <1361023075.11130.12.camel@cliu38-desktop-build>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
	 <1361023075.11130.12.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Feb 2013 22:10:12 +0800
Message-ID: <1361023812.11130.15.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the functions smp_call_function_many()/single() will
give a WARN()ing only in the case of irqs_disabled(), but that
check is not enough to guarantee execution of the SMP
cross-calls.

In many other cases such as softirq handling/interrupt handling,
the two APIs still can not be called, just as the
smp_call_function_many() comments say:

  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler. Preemption
  * must be disabled when calling this function.

There is a real case for softirq DEADLOCK case:

CPUA                            CPUB
                                spin_lock(&spinlock)
                                Any irq coming, call the irq handler
                                irq_exit()
spin_lock_irq(&spinlock)
<== Blocking here due to
CPUB hold it
                                  __do_softirq()
                                    run_timer_softirq()
                                      timer_cb()
                                        call smp_call_function_many()
                                          send IPI interrupt to CPUA
                                            wait_csd()

Then both CPUA and CPUB will be deadlocked here.

So we should give a warning in the nmi, hardirq or softirq context as well.

Moreover, adding one new macro in_serving_irq() which indicates
we are processing nmi, hardirq or sofirq.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 include/linux/hardirq.h |    5 +++++
 kernel/smp.c            |   11 +++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 624ef3f..e07663f 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -94,6 +94,11 @@
  */
 #define in_nmi()	(preempt_count() & NMI_MASK)
 
+/*
+ * Are we in nmi,irq context, or softirq context?
+ */
+#define in_serving_irq() (in_nmi() || in_irq() || in_serving_softirq())
+
 #if defined(CONFIG_PREEMPT_COUNT)
 # define PREEMPT_CHECK_OFFSET 1
 #else
diff --git a/kernel/smp.c b/kernel/smp.c
index 69f38bd..b0a5d21 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 #include "smpboot.h"
 
@@ -323,8 +324,9 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
-		     && !oops_in_progress);
+	WARN_ON_ONCE(cpu_online(this_cpu)
+		&& (irqs_disabled() || in_serving_irq())
+		&& !oops_in_progress);
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
@@ -462,8 +464,9 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
-		     && !oops_in_progress && !early_boot_irqs_disabled);
+	WARN_ON_ONCE(cpu_online(this_cpu)
+		&& (irqs_disabled() || in_serving_irq())
+		&& !oops_in_progress && !early_boot_irqs_disabled);
 
 	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
-- 
1.7.0.4



