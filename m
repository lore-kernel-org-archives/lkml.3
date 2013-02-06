Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3BFNnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:43:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60455 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3BFNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:43:22 -0500
Date: Wed, 6 Feb 2013 05:42:58 -0800
From: tip-bot for Chuansheng Liu <chuansheng.liu@intel.com>
Message-ID: <tip-b29f39c7c3e75a741a7da88244ec707f293ec04c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, chuansheng.liu@intel.com
In-Reply-To: <1360163901.24670.13.camel@cliu38-desktop-build>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] smp: Give WARN()ing if in_interrupt()
  when calling smp_call_function_many()/single()
Git-Commit-ID: b29f39c7c3e75a741a7da88244ec707f293ec04c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 05:43:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b29f39c7c3e75a741a7da88244ec707f293ec04c
Gitweb:     http://git.kernel.org/tip/b29f39c7c3e75a741a7da88244ec707f293ec04c
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Wed, 6 Feb 2013 23:18:21 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Feb 2013 12:00:30 +0100

smp: Give WARN()ing if in_interrupt() when calling smp_call_function_many()/single()

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

So we should give a warning in the in_interrupt() case as well.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Cc: jun.zhang@intel.com
Cc: peterz@infradead.org
Cc: jbeulich@suse.com
Cc: paulmck@linux.vnet.ibm.com
Cc: mina86@mina86.org
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360163901.24670.13.camel@cliu38-desktop-build
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/smp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 29dd40a..fec45aa 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 #include "smpboot.h"
 
@@ -318,7 +319,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
+	WARN_ON_ONCE(cpu_online(this_cpu) && (irqs_disabled() || in_interrupt())
 		     && !oops_in_progress);
 
 	if (cpu == this_cpu) {
@@ -416,8 +417,9 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
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
