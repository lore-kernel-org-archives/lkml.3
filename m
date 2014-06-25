Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaFYJz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:55:56 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53225 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaFYJzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:55:55 -0400
Message-ID: <53AA9C43.3020903@linux.vnet.ibm.com>
Date: Wed, 25 Jun 2014 15:24:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 2/6] irq_work: Implement remote queueing
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com> <1402413309-3415-3-git-send-email-fweisbec@gmail.com> <53A9E0A5.5040402@wwwdotorg.org> <20140625051234.GD6758@twins.programming.kicks-ass.net> <20140625051721.GG3588@twins.programming.kicks-ass.net> <53AA6E11.1000404@linux.vnet.ibm.com> <20140625093657.GN19860@laptop.programming.kicks-ass.net> <20140625093944.GV16155@laptop.programming.kicks-ass.net> <53AA9B68.4050104@linux.vnet.ibm.com>
In-Reply-To: <53AA9B68.4050104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062509-3568-0000-0000-000005BFA8A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 03:20 PM, Srivatsa S. Bhat wrote:
> On 06/25/2014 03:09 PM, Peter Zijlstra wrote:
>> On Wed, Jun 25, 2014 at 11:36:57AM +0200, Peter Zijlstra wrote:
>>> On Wed, Jun 25, 2014 at 12:07:05PM +0530, Srivatsa S. Bhat wrote:
>>>> I don't think irqs_disabled() is the problematic condition, since
>>>> hotplug_cfg() invokes irq_work_run() from CPU_DYING context (which has
>>>> irqs disabled). I guess you meant to remove the in_irq() check inside
>>>> irq_work_run() instead?
>>>
>>> Yes, clearly I should not get up at 6am.. :-) Let me go do a new one.
>>
>> ---
>> Subject: irq_work: Remove BUG_ON in irq_work_run()
>> From: Peter Zijlstra <peterz@infradead.org>
>> Date: Wed Jun 25 07:13:07 CEST 2014
>>
>> Because of a collision with 8d056c48e486 ("CPU hotplug, smp: flush any
>> pending IPI callbacks before CPU offline"), which ends up calling
>> hotplug_cfd()->flush_smp_call_function_queue()->irq_work_run(), which
>> is not from IRQ context.
>>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Reported-by: Stephen Warren <swarren@wwwdotorg.org>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> Link: http://lkml.kernel.org/n/tip-busatzs2gvz4v62258agipuf@git.kernel.org
>> ---
>>  kernel/irq_work.c |   12 +-----------
>>  1 file changed, 1 insertion(+), 11 deletions(-)
>>
>> Index: linux-2.6/kernel/irq_work.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/irq_work.c
>> +++ linux-2.6/kernel/irq_work.c
>> @@ -160,21 +160,11 @@ static void irq_work_run_list(struct lli
>>  	}
>>  }
>>
>> -static void __irq_work_run(void)
> 
> Hmm, irq_work_cpu_notify() calls __irq_work_run() in the CPU_DYING
> phase, to by-pass BUG_ON(!in_irq()). How about doing the same thing
> from hotplug_cfd() as well?
> 

Wait, that was a stupid idea. hotplug_cfd() already invokes irq_work_run
indirectly via flush_smp_call_function_queue(). So irq_work_cpu_notify()
doesn't need to invoke it again, AFAIU. So perhaps we can get rid of
irq_work_cpu_notify() altogether?

Regards,
Srivatsa S. Bhat

>> +static void irq_work_run(void)
>>  {
>>  	irq_work_run_list(&__get_cpu_var(raised_list));
>>  	irq_work_run_list(&__get_cpu_var(lazy_list));
>>  }
>> -
>> -/*
>> - * Run the irq_work entries on this cpu. Requires to be ran from hardirq
>> - * context with local IRQs disabled.
>> - */
>> -void irq_work_run(void)
>> -{
>> -	BUG_ON(!in_irq());
>> -	__irq_work_run();
>> -}
>>  EXPORT_SYMBOL_GPL(irq_work_run);
>>
>>  /*
>>
> 

