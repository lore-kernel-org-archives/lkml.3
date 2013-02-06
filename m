Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3BFGHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:07:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:48264 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3BFGHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:07:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,613,1355126400"; 
   d="scan'208";a="287194294"
Subject: [PATCH] smp: give WARN in case of in_interrupt() when calling
 smp_call_function_many/single
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: mingo@kernel.org, peterz@infradead.org, jbeulich@suse.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mina86@mina86.org, srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, jun.zhang@intel.com,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Feb 2013 23:18:21 +0800
Message-ID: <1360163901.24670.13.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, in function smp_call_function_many/single, it will give WARN just in case
of irqs_disabled(), but it is not enough.

In many other cases such as softirq handling/interrupt handling, the two APIs still
can not be called, just as the smp_call_function_many() comments said:
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

Then both CPUA and CPUB will be DEADLOCK here.

So we should give WARN in case of in_interrupt(), not only irqd_disabled().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/smp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 69f38bd..a2f0b2c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 #include "smpboot.h"
 
@@ -323,7 +324,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
+	WARN_ON_ONCE(cpu_online(this_cpu) && (irqs_disabled() || in_interrupt())
 		     && !oops_in_progress);
 
 	if (cpu == this_cpu) {
@@ -421,8 +422,9 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
-		     && !oops_in_progress);
+	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait
+			&& (irqs_disabled() || in_interrupt())
+			&& !oops_in_progress);
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
-- 
1.7.0.4



