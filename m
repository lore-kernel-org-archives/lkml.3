Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3GXJie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:38:34 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38423 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3GXJic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:38:32 -0400
Message-ID: <51EFA24E.2060103@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 15:15:50 +0530
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
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
References: <20130722061631.24737.75508.sendpatchset@codeblue> <20130722062016.24737.54554.sendpatchset@codeblue> <20130723150748.GC6029@redhat.com>
In-Reply-To: <20130723150748.GC6029@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072409-5816-0000-0000-0000091124B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 08:37 PM, Gleb Natapov wrote:
> On Mon, Jul 22, 2013 at 11:50:16AM +0530, Raghavendra K T wrote:
>> +static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
[...]
>> +
>> +	/*
>> +	 * halt until it's our turn and kicked. Note that we do safe halt
>> +	 * for irq enabled case to avoid hang when lock info is overwritten
>> +	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
>> +	 */
>> +	if (arch_irqs_disabled_flags(flags))
>> +		halt();
>> +	else
>> +		safe_halt();
>> +
>> +out:
> So here now interrupts can be either disabled or enabled. Previous
> version disabled interrupts here, so are we sure it is safe to have them
> enabled at this point? I do not see any problem yet, will keep thinking.

If we enable interrupt here, then


>> +	cpumask_clear_cpu(cpu, &waiting_cpus);

and if we start serving lock for an interrupt that came here,
cpumask clear and w->lock=null may not happen atomically.
if irq spinlock does not take slow path we would have non null value for 
lock, but with no information in waitingcpu.

I am still thinking what would be problem with that.

>> +	w->lock = NULL;
>> +	local_irq_restore(flags);
>> +	spin_time_accum_blocked(start);
>> +}
>> +PV_CALLEE_SAVE_REGS_THUNK(kvm_lock_spinning);
>> +
>> +/* Kick vcpu waiting on @lock->head to reach value @ticket */
>> +static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
>> +{
>> +	int cpu;
>> +
>> +	add_stats(RELEASED_SLOW, 1);
>> +	for_each_cpu(cpu, &waiting_cpus) {
>> +		const struct kvm_lock_waiting *w = &per_cpu(lock_waiting, cpu);
>> +		if (ACCESS_ONCE(w->lock) == lock &&
>> +		    ACCESS_ONCE(w->want) == ticket) {
>> +			add_stats(RELEASED_SLOW_KICKED, 1);
>> +			kvm_kick_cpu(cpu);
> What about using NMI to wake sleepers? I think it was discussed, but
> forgot why it was dismissed.

I think I have missed that discussion. 'll go back and check. so what is 
the idea here? we can easily wake up the halted vcpus that have 
interrupt disabled?

