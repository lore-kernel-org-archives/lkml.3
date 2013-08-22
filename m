Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3HVFwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:52:18 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38879 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3HVFwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:52:16 -0400
Message-ID: <5215A676.6040504@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 11:19:42 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, rjw@sisk.pl,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        michael@ellerman.id.au, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC V2 PATCH 2/6] powerpc: Implement broadcast timer interrupt
 as an IPI message
References: <20130814115311.5193.32212.stgit@preeti.in.ibm.com> <20130814115602.5193.60835.stgit@preeti.in.ibm.com> <1377141057.25016.265.camel@pasglop>
In-Reply-To: <1377141057.25016.265.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082205-5816-0000-0000-0000098747D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben

On 08/22/2013 08:40 AM, Benjamin Herrenschmidt wrote:
> On Wed, 2013-08-14 at 17:26 +0530, Preeti U Murthy wrote:
>> -static irqreturn_t unused_action(int irq, void *data)
>> +static irqreturn_t timer_action(int irq, void *data)
>>  {
>> -       /* This slot is unused and hence available for use, if needed
>> */
>> +       timer_interrupt();
>>         return IRQ_HANDLED;
>>  }
>>  
> 
> That means we'll do irq_enter/irq_exit twice no ? And things like
> may_hard_irq_enable() are also already done by do_IRQ so you
> don't need timer_interrupt() to do it again.
> 
> We probably are better off breaking timer_interrupt in two:
> 
> void __timer_interrupt(struct pt_regs * regs)
> 
> Does the current stuff between irq_enter and irq_exit, timer_interrupt
> does the remaining around it and calls __timer_interrupt.
> 
> Then from timer_action, you call __timer_interrupt()

We actually tried out this approach. The implementation was have a
set_dec(0) in the timer_action(). This would ensure that we actually do
get a timer interrupt.

But the problem with either this approach or the one that you
suggest,i.e. calling __timer_interrupt is in the following flow.

do_IRQ() -> irq_exit() -> tick_irq_exit() -> tick_nohz_irq_exit()
-> tick_nohz_stop_sched_tick()

The problem lies in the function tick_nohz_stop_sched_tick(). This
function checks for the next timer interrupt pending on this cpu, and
programs the decrementer_next_event to the time of the next event, which
is of course > now.

As a result when in the timer_action() above, we do call
__timer_interrupt() or try to trigger a timer interrupt through
set_dec(0), the condition  if(now >= *next_tb) in timer_interrupt() or
__timer_interrupt() will fail, and will not call the timer interrupt
event handler.

---> if (now >= *next_tb) {
             *next_tb = ~(u64)0;
             if (evt->event_handler)
                evt->event_handler(evt);
      } else {

The broadcast IPI , is meant to make the target CPU of this IPI believe
that it woke up from a timer interrupt, and not from an IPI. (The reason
for this I will explain in the reply to the next patch). The target CPU
should then ideally do what it would have done had it received a real
timer interrupt, call the timer interrupt event handler.

But due to the above code flow this does  not happen.
Hence as the next patch PATCH 3/6 shows, we simply call the event
handler of a timer interrupt without this explicit now >= *next_tb check.

This problem arises only in the implementation of this patchset, because
a timer interrupt is pseudo triggered from an IPI. So the effects of the
IPI handler will be felt on the timer interrupt handler triggered from
this IPI, like above.

Regards
Preeti U Murthy

