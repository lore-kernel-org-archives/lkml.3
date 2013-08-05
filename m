Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3HEWqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:46:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab3HEWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:46:12 -0400
Date: Mon, 5 Aug 2013 15:46:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Lai Jiangshan <eag0628@gmail.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "mina86@mina86.org" <mina86@mina86.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Jun" <jun.zhang@intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Message-Id: <20130805154610.06db4f627755974cd314d45a@linux-foundation.org>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A2427D4@SHSMSX101.ccr.corp.intel.com>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
	<1361023075.11130.12.camel@cliu38-desktop-build>
	<1361023812.11130.15.camel@cliu38-desktop-build>
	<CACvQF51cfqYk3idypNrQ54TOYJSPYvzR+1TTRBOQ5_vH8etwWw@mail.gmail.com>
	<27240C0AC20F114CBF8149A2696CBE4A2427D4@SHSMSX101.ccr.corp.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013 03:37:11 +0000 "Liu, Chuansheng" <chuansheng.liu@intel.com> wrote:

> 
> >                                 spin_lock_bh(&lockB)
> >                                 *Blocking* heredue to
> >                                 CPUC hold it
> >                                                          call
> > smp_call_function_many()
> >                                                          send IPI
> > interrupt to CPUA
> > 
> > wait_csd()
> > 
> > *Blocking* here.
> > 
> > So it is still deadlock. but your code does not warn it.
> In your case, even you change spin_lock_bh() to spin_lock(), the deadlock is still there. So no relation with _bh() at all,
> Do not need warning for such deadlock case in smp_call_xxx() or for _bh() case.
> 
> > so in_softirq() is better than in_serving_softirq() in in_serving_irq(),
> > and results in_serving_irq() is the same as in_interrupt().
> > 
> > so please remove in_serving_irq() and use in_interrupt() instead.
> The original patch is using in_interrupt(). https://lkml.org/lkml/2013/2/6/34 
> 

(ancient thread)

It's not clear (to me) that all these issues are settled.  Can we
please take another look at this?

The patch has been in -mm and linux-next for five months with no
issues.  But as far as I know, it hasn't detected any kernel bugs, so
perhaps we just don't need it?


From: Chuansheng Liu <chuansheng.liu@intel.com>
Subject: smp: give WARN()ing when calling smp_call_function_many()/single() in serving irq

Currently the functions smp_call_function_many()/single() will give a
WARN()ing only in the case of irqs_disabled(), but that check is not
enough to guarantee execution of the SMP cross-calls.

In many other cases such as softirq handling/interrupt handling, the two
APIs still can not be called, just as the smp_call_function_many()
comments say:

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

Moreover, adding one new macro in_serving_irq() which indicates we are
processing nmi, hardirq or sofirq.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Lai Jiangshan <eag0628@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hardirq.h |    5 +++++
 kernel/smp.c            |   11 +++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN include/linux/hardirq.h~smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq include/linux/hardirq.h
--- a/include/linux/hardirq.h~smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq
+++ a/include/linux/hardirq.h
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
diff -puN kernel/smp.c~smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq kernel/smp.c
--- a/kernel/smp.c~smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq
+++ a/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 #include "smpboot.h"
 
@@ -243,8 +244,9 @@ int smp_call_function_single(int cpu, sm
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
@@ -381,8 +383,9 @@ void smp_call_function_many(const struct
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
_

