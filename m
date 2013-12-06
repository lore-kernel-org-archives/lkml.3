Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab3LFSbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:31:24 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:38760 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3LFSbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:31:23 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1312061459190.30673@ionos.tec.linutronix.de>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
	<1361023075.11130.12.camel@cliu38-desktop-build>
	<1361023812.11130.15.camel@cliu38-desktop-build>
	<alpine.DEB.2.02.1307051548430.32106@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1307051615100.32106@ionos.tec.linutronix.de>
	<52A1286E.9000606@gmail.com>
	<alpine.DEB.2.02.1312061459190.30673@ionos.tec.linutronix.de>
Date: Fri, 6 Dec 2013 22:31:22 +0400
Message-ID: <CAMo8BfLC6eeRb8Qpx=_fh9U8Ve1exJb4a+RzPp8u=gWi6i4Crw@mail.gmail.com>
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling smp_call_function_many()/single()
 in serving irq
From: Max Filippov <jcmvbkbc@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, jbeulich@suse.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, jun.zhang@intel.com,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alex Nemirovsky <Alex.Nemirovsky@cortina-systems.com>,
        Artemi Ivanov <artemi.ivanov@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 6:02 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 6 Dec 2013, Max Filippov wrote:
>> Hi Thomas,
>
>> On Fri, Jul 5, 2013 at 6:37 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Fri, 5 Jul 2013, Thomas Gleixner wrote:
>> >> On Sat, 16 Feb 2013, Chuansheng Liu wrote:
>> >> > Currently the functions smp_call_function_many()/single() will
>> >> > give a WARN()ing only in the case of irqs_disabled(), but that
>> >> > check is not enough to guarantee execution of the SMP
>> >> > cross-calls.
>> >> >
>> >> > In many other cases such as softirq handling/interrupt handling,
>> >> > the two APIs still can not be called, just as the
>> >> > smp_call_function_many() comments say:
>> >> >
>> >> >   * You must not call this function with disabled interrupts or from a
>> >> >   * hardware interrupt handler or from a bottom half handler. Preemption
>> >> >   * must be disabled when calling this function.
>> >> >
>> >> > There is a real case for softirq DEADLOCK case:
>> >> >
>> >> > CPUA                            CPUB
>> >> >                                 spin_lock(&spinlock)
>> >> >                                 Any irq coming, call the irq handler
>> >> >                                 irq_exit()
>> >> > spin_lock_irq(&spinlock)
>> >> > <== Blocking here due to
>> >> > CPUB hold it
>> >> >                                   __do_softirq()
>> >> >                                     run_timer_softirq()
>> >> >                                       timer_cb()
>> >> >                                         call smp_call_function_many()
>> >> >                                           send IPI interrupt to CPUA
>> >> >                                             wait_csd()
>> >> >
>> >> > Then both CPUA and CPUB will be deadlocked here.
>> >>
>> >> That's not true if called with wait = 0 as we won't wait for the csd
>> >> in that case. The function will be invoked on cpuA after it reenables
>> >> interrupt. So for callers who don't care about synchronous execution
>> >> it should not warn in softirq context.
>> >
>> > Hmm, even there it matters, because of the following scenario:
>> >
>> > CPU 0
>> > smp_call_function_single(CPU 1)
>> >     csd_lock(CPU 1)
>> >     irq_enter()
>> >     irq_exit()
>> >     __do_softirq()
>> >     smp_call_function_many()
>> >       setup csd (CPU 1)
>> >         csd_lock(CPU 1) ==> CPU 0 deadlocked itself.
>> >
>> > And this is even more likely to happen than the lock issue.
>>
>> I've observed similar deadlock in a real system which has network
>> driver that uses smp_call_function_single in the softirq context.
>>
>> The proposed fix below keeps IRQs disabled on the sending CPU
>> during the period between marking csd locked and sending IPI,
>> making it possible to use smp_call_function_single from the softirq
>> context. What do you think?
>
> I'm not really exited to encourage IPIs from irq context. Just because
> some network driver uses it, is definitely not a good argument. If we
> really want to support that, then we need a proper justification why
> it is necessary in the first place.

Then there should be at least a comment for smp_call_function_single
similar to the one for smp_call_function_many, for those who still
believe it's possible?

diff --git a/kernel/smp.c b/kernel/smp.c
index 0564571..fe31b77 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -208,6 +208,10 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct
call_single_data, csd_data);
  * @wait: If true, wait until function has completed on other CPUs.
  *
  * Returns 0 on success, else a negative status code.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler. Preemption
+ * must be disabled when calling this function.
  */
 int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
                             int wait)

-- 
Thanks.
-- Max
