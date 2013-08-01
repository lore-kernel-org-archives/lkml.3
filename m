Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3HAHql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3HAHqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:46:39 -0400
Date: Thu, 1 Aug 2013 10:45:30 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, x86@kernel.org, tglx@linutronix.de, jeremy@goop.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        drjones@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
Message-ID: <20130801074529.GO7484@redhat.com>
References: <20130724103907.GF16400@redhat.com>
 <51EFC1D4.9060800@linux.vnet.ibm.com>
 <20130724120647.GG16400@redhat.com>
 <51EFCA42.5020009@linux.vnet.ibm.com>
 <51F0ED31.3040200@linux.vnet.ibm.com>
 <20130725091509.GA22735@redhat.com>
 <51F0F202.5090001@linux.vnet.ibm.com>
 <51F7ED20.80202@linux.vnet.ibm.com>
 <20130731062440.GK28372@redhat.com>
 <51FA1087.9080908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FA1087.9080908@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 01:08:47PM +0530, Raghavendra K T wrote:
> On 07/31/2013 11:54 AM, Gleb Natapov wrote:
> >On Tue, Jul 30, 2013 at 10:13:12PM +0530, Raghavendra K T wrote:
> >>On 07/25/2013 03:08 PM, Raghavendra K T wrote:
> >>>On 07/25/2013 02:45 PM, Gleb Natapov wrote:
> >>>>On Thu, Jul 25, 2013 at 02:47:37PM +0530, Raghavendra K T wrote:
> >>>>>On 07/24/2013 06:06 PM, Raghavendra K T wrote:
> >>>>>>On 07/24/2013 05:36 PM, Gleb Natapov wrote:
> >>>>>>>On Wed, Jul 24, 2013 at 05:30:20PM +0530, Raghavendra K T wrote:
> >>>>>>>>On 07/24/2013 04:09 PM, Gleb Natapov wrote:
> >>>>>>>>>On Wed, Jul 24, 2013 at 03:15:50PM +0530, Raghavendra K T wrote:
> >>>>>>>>>>On 07/23/2013 08:37 PM, Gleb Natapov wrote:
> >>>>>>>>>>>On Mon, Jul 22, 2013 at 11:50:16AM +0530, Raghavendra K T wrote:
> >>>>>>>>>>>>+static void kvm_lock_spinning(struct arch_spinlock *lock,
> >>>>>>>>>>>>__ticket_t want)
> >>>>>>>>>>[...]
> >>>>>>>>>>>>+
> >>>>>>>>>>>>+    /*
> >>>>>>>>>>>>+     * halt until it's our turn and kicked. Note that we do safe
> >>>>>>>>>>>>halt
> >>>>>>>>>>>>+     * for irq enabled case to avoid hang when lock info is
> >>>>>>>>>>>>overwritten
> >>>>>>>>>>>>+     * in irq spinlock slowpath and no spurious interrupt occur
> >>>>>>>>>>>>to save us.
> >>>>>>>>>>>>+     */
> >>>>>>>>>>>>+    if (arch_irqs_disabled_flags(flags))
> >>>>>>>>>>>>+        halt();
> >>>>>>>>>>>>+    else
> >>>>>>>>>>>>+        safe_halt();
> >>>>>>>>>>>>+
> >>>>>>>>>>>>+out:
> >>>>>>>>>>>So here now interrupts can be either disabled or enabled. Previous
> >>>>>>>>>>>version disabled interrupts here, so are we sure it is safe to
> >>>>>>>>>>>have them
> >>>>>>>>>>>enabled at this point? I do not see any problem yet, will keep
> >>>>>>>>>>>thinking.
> >>>>>>>>>>
> >>>>>>>>>>If we enable interrupt here, then
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>>>>+    cpumask_clear_cpu(cpu, &waiting_cpus);
> >>>>>>>>>>
> >>>>>>>>>>and if we start serving lock for an interrupt that came here,
> >>>>>>>>>>cpumask clear and w->lock=null may not happen atomically.
> >>>>>>>>>>if irq spinlock does not take slow path we would have non null
> >>>>>>>>>>value
> >>>>>>>>>>for lock, but with no information in waitingcpu.
> >>>>>>>>>>
> >>>>>>>>>>I am still thinking what would be problem with that.
> >>>>>>>>>>
> >>>>>>>>>Exactly, for kicker waiting_cpus and w->lock updates are
> >>>>>>>>>non atomic anyway.
> >>>>>>>>>
> >>>>>>>>>>>>+    w->lock = NULL;
> >>>>>>>>>>>>+    local_irq_restore(flags);
> >>>>>>>>>>>>+    spin_time_accum_blocked(start);
> >>>>>>>>>>>>+}
> >>>>>>>>>>>>+PV_CALLEE_SAVE_REGS_THUNK(kvm_lock_spinning);
> >>>>>>>>>>>>+
> >>>>>>>>>>>>+/* Kick vcpu waiting on @lock->head to reach value @ticket */
> >>>>>>>>>>>>+static void kvm_unlock_kick(struct arch_spinlock *lock,
> >>>>>>>>>>>>__ticket_t ticket)
> >>>>>>>>>>>>+{
> >>>>>>>>>>>>+    int cpu;
> >>>>>>>>>>>>+
> >>>>>>>>>>>>+    add_stats(RELEASED_SLOW, 1);
> >>>>>>>>>>>>+    for_each_cpu(cpu, &waiting_cpus) {
> >>>>>>>>>>>>+        const struct kvm_lock_waiting *w =
> >>>>>>>>>>>>&per_cpu(lock_waiting, cpu);
> >>>>>>>>>>>>+        if (ACCESS_ONCE(w->lock) == lock &&
> >>>>>>>>>>>>+            ACCESS_ONCE(w->want) == ticket) {
> >>>>>>>>>>>>+            add_stats(RELEASED_SLOW_KICKED, 1);
> >>>>>>>>>>>>+            kvm_kick_cpu(cpu);
> >>>>>>>>>>>What about using NMI to wake sleepers? I think it was
> >>>>>>>>>>>discussed, but
> >>>>>>>>>>>forgot why it was dismissed.
> >>>>>>>>>>
> >>>>>>>>>>I think I have missed that discussion. 'll go back and check. so
> >>>>>>>>>>what is the idea here? we can easily wake up the halted vcpus that
> >>>>>>>>>>have interrupt disabled?
> >>>>>>>>>We can of course. IIRC the objection was that NMI handling path
> >>>>>>>>>is very
> >>>>>>>>>fragile and handling NMI on each wakeup will be more expensive then
> >>>>>>>>>waking up a guest without injecting an event, but it is still
> >>>>>>>>>interesting
> >>>>>>>>>to see the numbers.
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>>Haam, now I remember, We had tried request based mechanism. (new
> >>>>>>>>request like REQ_UNHALT) and process that. It had worked, but had
> >>>>>>>>some
> >>>>>>>>complex hacks in vcpu_enter_guest to avoid guest hang in case of
> >>>>>>>>request cleared.  So had left it there..
> >>>>>>>>
> >>>>>>>>https://lkml.org/lkml/2012/4/30/67
> >>>>>>>>
> >>>>>>>>But I do not remember performance impact though.
> >>>>>>>No, this is something different. Wakeup with NMI does not need KVM
> >>>>>>>changes at
> >>>>>>>all. Instead of kvm_kick_cpu(cpu) in kvm_unlock_kick you send NMI IPI.
> >>>>>>>
> >>>>>>
> >>>>>>True. It was not NMI.
> >>>>>>just to confirm, are you talking about something like this to be
> >>>>>>tried ?
> >>>>>>
> >>>>>>apic->send_IPI_mask(cpumask_of(cpu), APIC_DM_NMI);
> >>>>>
> >>>>>When I started benchmark, I started seeing
> >>>>>"Dazed and confused, but trying to continue" from unknown nmi error
> >>>>>handling.
> >>>>>Did I miss anything (because we did not register any NMI handler)? or
> >>>>>is it that spurious NMIs are trouble because we could get spurious NMIs
> >>>>>if next waiter already acquired the lock.
> >>>>There is a default NMI handler that tries to detect the reason why NMI
> >>>>happened (which is no so easy on x86) and prints this message if it
> >>>>fails. You need to add logic to detect spinlock slow path there. Check
> >>>>bit in waiting_cpus for instance.
> >>>
> >>>aha.. Okay. will check that.
> >>
> >>yes. Thanks.. that did the trick.
> >>
> >>I did like below in unknown_nmi_error():
> >>if (cpumask_test_cpu(smp_processor_id(), &waiting_cpus))
> >>    return;
> >>
> >>But I believe you asked NMI method only for experimental purpose to
> >>check the upperbound. because as I doubted above, for spurious NMI
> >>(i.e. when unlocker kicks when waiter already got the lock), we would
> >>still hit unknown NMI error.
> >>
> >>I had hit spurious NMI over 1656 times over entire benchmark run.
> >>along with
> >>INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too
> >>long to run: 24.886 msecs etc...
> >>
> >I wonder why this happens.
> >
> >>(and we cannot get away with that too because it means we bypass the
> >>unknown NMI error even in genuine cases too)
> >>
> >>Here was the result for the my dbench test( 32 core  machine with 32
> >>vcpu guest HT off)
> >>
> >>                  ---------- % improvement --------------
> >>		pvspinlock      pvspin_ipi      pvpsin_nmi
> >>dbench_1x	0.9016    	0.7442    	0.7522
> >>dbench_2x	14.7513   	18.0164   	15.9421
> >>dbench_3x	14.7571   	17.0793   	13.3572
> >>dbench_4x	6.3625    	8.7897    	5.3800
> >>
> >>So I am seeing over 2-4% improvement with IPI method.
> >>
> >Yeah, this was expected.
> >
> >>Gleb,
> >>  do you think the current series looks good to you? [one patch I
> >>have resent with in_nmi() check] or do you think I have to respin the
> >>series with IPI method etc. or is there any concerns that I have to
> >>address. Please let me know..
> >>
> >The current code looks fine to me.
> 
> Gleb,
> 
> Shall I consider this as an ack for kvm part?
> 
For everything except 18/18. For that I still want to see numbers. But
18/18 is pretty independent from the reset of the series so it should
not stop the reset from going in.

--
			Gleb.
