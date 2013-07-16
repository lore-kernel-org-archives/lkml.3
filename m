Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab3GPDec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:34:32 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51767 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3GPDea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:34:30 -0400
Message-ID: <51E4C011.4060803@linux.vnet.ibm.com>
Date: Tue, 16 Jul 2013 09:07:53 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com> <20130624124342.27508.44656.sendpatchset@codeblue.in.ibm.com> <20130714131241.GA11772@redhat.com> <51E3C5CE.7000009@linux.vnet.ibm.com> <20130715103648.GN11772@redhat.com>
In-Reply-To: <20130715103648.GN11772@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071603-2000-0000-0000-00000CE6F262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 04:06 PM, Gleb Natapov wrote:
> On Mon, Jul 15, 2013 at 03:20:06PM +0530, Raghavendra K T wrote:
>> On 07/14/2013 06:42 PM, Gleb Natapov wrote:
>>> On Mon, Jun 24, 2013 at 06:13:42PM +0530, Raghavendra K T wrote:
>>>> kvm : Paravirtual ticketlocks support for linux guests running on KVM hypervisor
>>>>
>>>> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>>>>
>> trimming
>> [...]
>>>> +
>>>> +static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
>>>> +{
>>>> +	struct kvm_lock_waiting *w;
>>>> +	int cpu;
>>>> +	u64 start;
>>>> +	unsigned long flags;
>>>> +
>>>> +	w = &__get_cpu_var(lock_waiting);
>>>> +	cpu = smp_processor_id();
>>>> +	start = spin_time_start();
>>>> +
>>>> +	/*
>>>> +	 * Make sure an interrupt handler can't upset things in a
>>>> +	 * partially setup state.
>>>> +	 */
>>>> +	local_irq_save(flags);
>>>> +
>>>> +	/*
>>>> +	 * The ordering protocol on this is that the "lock" pointer
>>>> +	 * may only be set non-NULL if the "want" ticket is correct.
>>>> +	 * If we're updating "want", we must first clear "lock".
>>>> +	 */
>>>> +	w->lock = NULL;
>>>> +	smp_wmb();
>>>> +	w->want = want;
>>>> +	smp_wmb();
>>>> +	w->lock = lock;
>>>> +
>>>> +	add_stats(TAKEN_SLOW, 1);
>>>> +
>>>> +	/*
>>>> +	 * This uses set_bit, which is atomic but we should not rely on its
>>>> +	 * reordering gurantees. So barrier is needed after this call.
>>>> +	 */
>>>> +	cpumask_set_cpu(cpu, &waiting_cpus);
>>>> +
>>>> +	barrier();
>>>> +
>>>> +	/*
>>>> +	 * Mark entry to slowpath before doing the pickup test to make
>>>> +	 * sure we don't deadlock with an unlocker.
>>>> +	 */
>>>> +	__ticket_enter_slowpath(lock);
>>>> +
>>>> +	/*
>>>> +	 * check again make sure it didn't become free while
>>>> +	 * we weren't looking.
>>>> +	 */
>>>> +	if (ACCESS_ONCE(lock->tickets.head) == want) {
>>>> +		add_stats(TAKEN_SLOW_PICKUP, 1);
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	/* Allow interrupts while blocked */
>>>> +	local_irq_restore(flags);
>>>> +
>>> So what happens if an interrupt comes here and an interrupt handler
>>> takes another spinlock that goes into the slow path? As far as I see
>>> lock_waiting will become overwritten and cpu will be cleared from
>>> waiting_cpus bitmap by nested kvm_lock_spinning(), so when halt is
>>> called here after returning from the interrupt handler nobody is going
>>> to wake this lock holder. Next random interrupt will "fix" it, but it
>>> may be several milliseconds away, or never. We should probably check
>>> if interrupt were enabled and call native_safe_halt() here.
>>>
>>
>> Okay you mean something like below should be done.
>> if irq_enabled()
>>    native_safe_halt()
>> else
>>    halt()
>>
>> It is been a complex stuff for analysis for me.
>>
>> So in our discussion stack would looking like this.
>>
>> spinlock()
>>    kvm_lock_spinning()
>>                    <------ interrupt here
>>            halt()
>>
>>
>>  From the halt if we trace
>>
> It is to early to trace the halt since it was not executed yet. Guest
> stack trace will look something like this:
>
> spinlock(a)
>    kvm_lock_spinning(a)
>     lock_waiting = a
>     set bit in waiting_cpus
>                  <------ interrupt here
>                  spinlock(b)
>                    kvm_lock_spinning(b)
>                      lock_waiting = b
>                      set bit in waiting_cpus
>                      halt()
>                      unset bit in waiting_cpus
>                      lock_waiting = NULL
>       ----------> ret from interrupt
>     halt()
>
> Now at the time of the last halt above lock_waiting == NULL and
> waiting_cpus is empty and not interrupt it pending, so who will unhalt
> the waiter?
>

Yes. if an interrupt occurs between
local_irq_restore() and halt(), this is possible. and since this is 
rarest of rare (possiility of irq entering slowpath and then no random 
irq to do spurious wakeup), we had never hit this problem in the past.

So I am,
1. trying to artificially reproduce this.

2. I replaced the halt with below code,
        if (arch_irqs_disabled())
                 halt();

and ran benchmarks.
But this results in degradation because, it means we again go back and 
spin in irq enabled case.

3. Now I am analyzing the performance overhead of safe_halt in irq 
enabled case.
       if (arch_irqs_disabled())
                halt();
       else
                safe_halt();

