Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3LFB3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:29:31 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:38645 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3LFB33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:29:29 -0500
Message-ID: <52A1286E.9000606@gmail.com>
Date: Fri, 06 Dec 2013 05:29:18 +0400
From: Max Filippov <jcmvbkbc@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, jbeulich@suse.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, mina86@mina86.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, jun.zhang@intel.com,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alex Nemirovsky <Alex.Nemirovsky@cortina-systems.com>,
        Artemi Ivanov <artemi.ivanov@cogentembedded.com>
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling smp_call_function_many()/single()
 in serving irq
References: <1360163901.24670.13.camel@cliu38-desktop-build> <1361023075.11130.12.camel@cliu38-desktop-build> <1361023812.11130.15.camel@cliu38-desktop-build> <alpine.DEB.2.02.1307051548430.32106@ionos.tec.linutronix.de> <alpine.DEB.2.02.1307051615100.32106@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307051615100.32106@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, Jul 5, 2013 at 6:37 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 5 Jul 2013, Thomas Gleixner wrote:
>> On Sat, 16 Feb 2013, Chuansheng Liu wrote:
>> > Currently the functions smp_call_function_many()/single() will
>> > give a WARN()ing only in the case of irqs_disabled(), but that
>> > check is not enough to guarantee execution of the SMP
>> > cross-calls.
>> >
>> > In many other cases such as softirq handling/interrupt handling,
>> > the two APIs still can not be called, just as the
>> > smp_call_function_many() comments say:
>> >
>> >   * You must not call this function with disabled interrupts or from a
>> >   * hardware interrupt handler or from a bottom half handler. Preemption
>> >   * must be disabled when calling this function.
>> >
>> > There is a real case for softirq DEADLOCK case:
>> >
>> > CPUA                            CPUB
>> >                                 spin_lock(&spinlock)
>> >                                 Any irq coming, call the irq handler
>> >                                 irq_exit()
>> > spin_lock_irq(&spinlock)
>> > <== Blocking here due to
>> > CPUB hold it
>> >                                   __do_softirq()
>> >                                     run_timer_softirq()
>> >                                       timer_cb()
>> >                                         call smp_call_function_many()
>> >                                           send IPI interrupt to CPUA
>> >                                             wait_csd()
>> >
>> > Then both CPUA and CPUB will be deadlocked here.
>>
>> That's not true if called with wait = 0 as we won't wait for the csd
>> in that case. The function will be invoked on cpuA after it reenables
>> interrupt. So for callers who don't care about synchronous execution
>> it should not warn in softirq context.
>
> Hmm, even there it matters, because of the following scenario:
>
> CPU 0
> smp_call_function_single(CPU 1)
>     csd_lock(CPU 1)
>     irq_enter()
>     irq_exit()
>     __do_softirq()
>     smp_call_function_many()
>       setup csd (CPU 1)
>         csd_lock(CPU 1) ==> CPU 0 deadlocked itself.
>
> And this is even more likely to happen than the lock issue.

I've observed similar deadlock in a real system which has network
driver that uses smp_call_function_single in the softirq context.

The proposed fix below keeps IRQs disabled on the sending CPU
during the period between marking csd locked and sending IPI,
making it possible to use smp_call_function_single from the softirq
context. What do you think?

--->8---
>From 5fa496ce12eaf994debab202cde618b9da7d9402 Mon Sep 17 00:00:00 2001
From: Max Filippov <jcmvbkbc@gmail.com>
Date: Fri, 6 Dec 2013 04:50:03 +0400
Subject: [PATCH] smp: allow calling smp_call_function_single from softirq

This prevents the following deadlocks on the sending CPU by eliminating
interrupts between the point where CSD is locked and IPI is sent to peer
CPU.

Case 1:
 CPU 0
 smp_call_function_single(CPU 1, wait = 0)
     csd_lock(CPU 0)
     irq_enter()
     irq_exit()
     __do_softirq()
     smp_call_function_single(CPU 1, wait = 0)
       csd_lock(CPU 0) => deadlock, as csd will never be unlocked

Case 2:
 CPU 0
 smp_call_function_single(CPU 1, wait = 1)
     csd_lock(on stack)
     queue csd to CPU 1 call_single_queue
     irq_enter()
     irq_exit()
     __do_softirq()
     smp_call_function_single(CPU 1, wait = 1)
       setup csd (on stack)
       queue csd to CPU 1 call_single_queue
       csd_lock_wait => never returns, as IPI was never sent to CPU 1

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 kernel/smp.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 0564571..7bc9a01 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -122,6 +122,30 @@ static void csd_lock(struct call_single_data *csd)
 	smp_mb();
 }

+static unsigned long csd_lock_irqsave(struct call_single_data *csd)
+{
+	unsigned long flags;
+
+	for (;;) {
+		csd_lock_wait(csd);
+		local_irq_save(flags);
+		if (csd->flags & CSD_FLAG_LOCK)
+			local_irq_restore(flags);
+		else
+			break;
+	}
+	csd->flags |= CSD_FLAG_LOCK;
+
+	/*
+	 * prevent CPU from reordering the above assignment
+	 * to ->flags with any subsequent assignments to other
+	 * fields of the specified call_single_data structure:
+	 */
+	smp_mb();
+
+	return flags;
+}
+
 static void csd_unlock(struct call_single_data *csd)
 {
 	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
@@ -140,16 +164,20 @@ static void csd_unlock(struct call_single_data *csd)
  * ->func, ->info, and ->flags set.
  */
 static
-void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
+void generic_exec_single(int cpu, struct call_single_data *csd,
+			 smp_call_func_t func, void *info, int wait)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
-	unsigned long flags;
+	unsigned long flags = csd_lock_irqsave(csd);
 	int ipi;

-	raw_spin_lock_irqsave(&dst->lock, flags);
+	csd->func = func;
+	csd->info = info;
+
+	raw_spin_lock(&dst->lock);
 	ipi = list_empty(&dst->list);
 	list_add_tail(&csd->list, &dst->list);
-	raw_spin_unlock_irqrestore(&dst->lock, flags);
+	raw_spin_unlock(&dst->lock);

 	/*
 	 * The list addition should be visible before sending the IPI
@@ -165,6 +193,8 @@ void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 	if (ipi)
 		arch_send_call_function_single_ipi(cpu);

+	local_irq_restore(flags);
+
 	if (wait)
 		csd_lock_wait(csd);
 }
@@ -245,11 +275,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 			if (!wait)
 				csd = &__get_cpu_var(csd_data);

-			csd_lock(csd);
-
-			csd->func = func;
-			csd->info = info;
-			generic_exec_single(cpu, csd, wait);
+			generic_exec_single(cpu, csd, func, info, wait);
 		} else {
 			err = -ENXIO;	/* CPU not online */
 		}
@@ -335,8 +361,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *csd,
 		csd->func(csd->info);
 		local_irq_restore(flags);
 	} else {
-		csd_lock(csd);
-		generic_exec_single(cpu, csd, wait);
+		generic_exec_single(cpu, csd, csd->func, csd->info, wait);
 	}
 	put_cpu();
 }
-- 
1.8.1.4


-- 
Thanks.
-- Max
