Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161334Ab3FUMcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:32:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4157 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161083Ab3FUMci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:32:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,912,1363132800"; 
   d="scan'208";a="31076386"
Message-ID: <51C447E3.9030009@citrix.com>
Date: Fri, 21 Jun 2013 13:32:35 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] hrtimers: provide a hrtimers_late_resume() call
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-2-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210947410.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306210947410.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/13 08:53, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> Xen suspends (and resumes) without disabling non-boot CPUs as doing so
>> adds considerable delay to live migrations.  A 4 VCPU guest had more
>> than 200 ms of additional downtime if disable_nonboot_cpus() was
>> called prior to suspending.
>>
>> As a consequence, only high resolution timers on the current CPU are
>> retriggered when resuming.  The Xen resume path worked around this
>> with a call to clock_was_set() to retrigger timers on all the CPUs.
>>
>> A subsequent change will make clock_was_set() internal to hrtimers so
>> add an new call (hrtimers_late_resume()) to do the same job.
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  drivers/xen/manage.c    |    8 ++++++--
>>  include/linux/hrtimer.h |    1 +
>>  kernel/hrtimer.c        |    9 +++++++++
>>  3 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
>> index 412b96c..75bc2d5 100644
>> --- a/drivers/xen/manage.c
>> +++ b/drivers/xen/manage.c
>> @@ -166,8 +166,12 @@ out_resume:
>>  
>>  	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
>>  
>> -	/* Make sure timer events get retriggered on all CPUs */
>> -	clock_was_set();
>> +	/*
>> +	 * syscore_resume() ends up calling hrtimer_resume() but this
>> +	 * only retriggers timer events on the current CPU.  We need
>> +	 * to retrigger the events on all the other CPUS.
>> +	 */
>> +	hrtimers_late_resume();
> 
> This is the completely wrong approach. If an architecture does not
> shut down the non boot cpus on suspend, then this wants to be handled
> in the core code and not in some random arch specific driver.

Agreed.  Does the following meet your requirements?

David

8<-------------------------------------------------------
hrtimers: support resuming with two or more CPUs online (but stopped)

hrtimers_resume() only reprograms the timers for the current CPU as it
assumes that all other CPUs are offline at this point in the resume
process.  If other CPUs are online then their timers will not be
corrected and they may fire at the wrong time.

When running as a Xen guest, this assumption is not true.  Non-boot
CPUs are only stopped with IRQs disabled instead of offlining them.
This is a performance optimization as disabling the CPUs would add an
unacceptable amount of additional downtime during a live migration (>
200 ms for a 4 VCPU guest).

hrtimers_resume() cannot call on_each_cpu(retrigger_next_event,...)
as the other CPUs will be stopped with IRQs disabled.  Instead, defer
the call to the next softirq.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/manage.c |    3 ---
 kernel/hrtimer.c     |   10 +++++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..421da85 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -166,9 +166,6 @@ out_resume:
 
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
-	/* Make sure timer events get retriggered on all CPUs */
-	clock_was_set();
-
 out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index fd4b13b..74aa7c5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -773,15 +773,19 @@ void clock_was_set(void)
 
 /*
  * During resume we might have to reprogram the high resolution timer
- * interrupt (on the local CPU):
+ * interrupt on all online CPUs.  However, all other CPUs will be
+ * stopped with IRQs interrupts disabled at this point so defer this
+ * to the softirq.
  */
 void hrtimers_resume(void)
 {
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
 	WARN_ONCE(!irqs_disabled(),
 		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
 
-	retrigger_next_event(NULL);
-	timerfd_clock_was_set();
+	cpu_base->clock_was_set = 1;
+	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
 }
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
-- 
1.7.2.5
