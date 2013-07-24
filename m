Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3GXMH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab3GXMHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:07:54 -0400
Date: Wed, 24 Jul 2013 15:06:48 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
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
Message-ID: <20130724120647.GG16400@redhat.com>
References: <20130722061631.24737.75508.sendpatchset@codeblue>
 <20130722062016.24737.54554.sendpatchset@codeblue>
 <20130723150748.GC6029@redhat.com>
 <51EFA24E.2060103@linux.vnet.ibm.com>
 <20130724103907.GF16400@redhat.com>
 <51EFC1D4.9060800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFC1D4.9060800@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 05:30:20PM +0530, Raghavendra K T wrote:
> On 07/24/2013 04:09 PM, Gleb Natapov wrote:
> >On Wed, Jul 24, 2013 at 03:15:50PM +0530, Raghavendra K T wrote:
> >>On 07/23/2013 08:37 PM, Gleb Natapov wrote:
> >>>On Mon, Jul 22, 2013 at 11:50:16AM +0530, Raghavendra K T wrote:
> >>>>+static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
> >>[...]
> >>>>+
> >>>>+	/*
> >>>>+	 * halt until it's our turn and kicked. Note that we do safe halt
> >>>>+	 * for irq enabled case to avoid hang when lock info is overwritten
> >>>>+	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
> >>>>+	 */
> >>>>+	if (arch_irqs_disabled_flags(flags))
> >>>>+		halt();
> >>>>+	else
> >>>>+		safe_halt();
> >>>>+
> >>>>+out:
> >>>So here now interrupts can be either disabled or enabled. Previous
> >>>version disabled interrupts here, so are we sure it is safe to have them
> >>>enabled at this point? I do not see any problem yet, will keep thinking.
> >>
> >>If we enable interrupt here, then
> >>
> >>
> >>>>+	cpumask_clear_cpu(cpu, &waiting_cpus);
> >>
> >>and if we start serving lock for an interrupt that came here,
> >>cpumask clear and w->lock=null may not happen atomically.
> >>if irq spinlock does not take slow path we would have non null value
> >>for lock, but with no information in waitingcpu.
> >>
> >>I am still thinking what would be problem with that.
> >>
> >Exactly, for kicker waiting_cpus and w->lock updates are
> >non atomic anyway.
> >
> >>>>+	w->lock = NULL;
> >>>>+	local_irq_restore(flags);
> >>>>+	spin_time_accum_blocked(start);
> >>>>+}
> >>>>+PV_CALLEE_SAVE_REGS_THUNK(kvm_lock_spinning);
> >>>>+
> >>>>+/* Kick vcpu waiting on @lock->head to reach value @ticket */
> >>>>+static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
> >>>>+{
> >>>>+	int cpu;
> >>>>+
> >>>>+	add_stats(RELEASED_SLOW, 1);
> >>>>+	for_each_cpu(cpu, &waiting_cpus) {
> >>>>+		const struct kvm_lock_waiting *w = &per_cpu(lock_waiting, cpu);
> >>>>+		if (ACCESS_ONCE(w->lock) == lock &&
> >>>>+		    ACCESS_ONCE(w->want) == ticket) {
> >>>>+			add_stats(RELEASED_SLOW_KICKED, 1);
> >>>>+			kvm_kick_cpu(cpu);
> >>>What about using NMI to wake sleepers? I think it was discussed, but
> >>>forgot why it was dismissed.
> >>
> >>I think I have missed that discussion. 'll go back and check. so
> >>what is the idea here? we can easily wake up the halted vcpus that
> >>have interrupt disabled?
> >We can of course. IIRC the objection was that NMI handling path is very
> >fragile and handling NMI on each wakeup will be more expensive then
> >waking up a guest without injecting an event, but it is still interesting
> >to see the numbers.
> >
> 
> Haam, now I remember, We had tried request based mechanism. (new
> request like REQ_UNHALT) and process that. It had worked, but had some
> complex hacks in vcpu_enter_guest to avoid guest hang in case of
> request cleared.  So had left it there..
> 
> https://lkml.org/lkml/2012/4/30/67
> 
> But I do not remember performance impact though.
No, this is something different. Wakeup with NMI does not need KVM changes at
all. Instead of kvm_kick_cpu(cpu) in kvm_unlock_kick you send NMI IPI.

--
			Gleb.
