Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3GQJfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab3GQJfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:35:44 -0400
Date: Wed, 17 Jul 2013 12:34:20 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, agraf@suse.de,
        chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
Message-ID: <20130717093420.GU11772@redhat.com>
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com>
 <20130624124342.27508.44656.sendpatchset@codeblue.in.ibm.com>
 <20130714131241.GA11772@redhat.com>
 <51E3C5CE.7000009@linux.vnet.ibm.com>
 <20130715103648.GN11772@redhat.com>
 <51E4C011.4060803@linux.vnet.ibm.com>
 <20130716060215.GE11772@redhat.com>
 <51E5941B.3090300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E5941B.3090300@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 12:12:35AM +0530, Raghavendra K T wrote:
>> I do not think it is very rare to get interrupt between
>> local_irq_restore() and halt() under load since any interrupt that
>> occurs between local_irq_save() and local_irq_restore() will be
>> delivered
>> immediately after local_irq_restore(). Of course the chance of no
>> other
>> random interrupt waking lock waiter is very low, but waiter can sleep
>> for much longer then needed and this will be noticeable in
>> performance.
>
>Yes, I meant the entire thing. I did infact turned WARN on
>w->lock==null before halt() [ though we can potentially have irq right
>after that ], but did not hit so far.
Depends on your workload of course. To hit that you not only need to get
interrupt in there, but the interrupt handler needs to take contended
spinlock.

>
> >BTW can NMI handler take spinlocks? If it can what happens if NMI is
> >delivered in a section protected by local_irq_save()/local_irq_restore()?
> >
> 
> Had another idea if NMI, halts are causing problem until I saw
> PeterZ's reply similar to V2 of pvspinlock posted  here:
> 
>  https://lkml.org/lkml/2011/10/23/211
> 
> Instead of halt we started with a sleep hypercall in those
>  versions. Changed to halt() once Avi suggested to reuse existing sleep.
> 
> If we use older hypercall with few changes like below:
> 
> kvm_pv_wait_for_kick_op(flags, vcpu, w->lock )
> {
>  // a0 reserved for flags
> if (!w->lock)
> return;
> DEFINE_WAIT
> ...
> end_wait
> }
> 
How would this help if NMI takes lock in critical section. The thing
that may happen is that lock_waiting->want may have NMI lock value, but
lock_waiting->lock will point to non NMI lock. Setting of want and lock
have to be atomic.

kvm_pv_wait_for_kick_op() is incorrect in other ways. It will spuriously
return to a guest since not all events that wake up vcpu thread
correspond to work for guest to do.

> Only question is how to retry immediately with lock_spinning in
> w->lock=null cases.
> 
> /me need to experiment that again perhaps to see if we get some benefit.
> 
> >>
> >>So I am,
> >>1. trying to artificially reproduce this.
> >>
> >>2. I replaced the halt with below code,
> >>        if (arch_irqs_disabled())
> >>                 halt();
> >>
> >>and ran benchmarks.
> >>But this results in degradation because, it means we again go back
> >>and spin in irq enabled case.
> >>
> >Yes, this is not what I proposed.
> 
> True.
> 
> >
> >>3. Now I am analyzing the performance overhead of safe_halt in irq
> >>enabled case.
> >>       if (arch_irqs_disabled())
> >>                halt();
> >>       else
> >>                safe_halt();
> >Use of arch_irqs_disabled() is incorrect here.
> 
> Oops! sill me.
> 
> If you are doing it before
> >local_irq_restore() it will always be false since you disabled interrupt
> >yourself,
> 
> This was not the case. but latter is the one I missed.
> 
>  if you do it after then it is to late since interrupt can come
> >between local_irq_restore() and halt() so enabling interrupt and halt
> >are still not atomic.  You should drop local_irq_restore() and do
> >
> >   if (arch_irqs_disabled_flags(flags))
> >	halt();
> >   else
> >	safe_halt();
> >
> >instead.
> >
> 
> Yes, I tested with below as suggested:
> 
> //local_irq_restore(flags);
> 
>         /* halt until it's our turn and kicked. */
>         if (arch_irqs_disabled_flags(flags))
>                 halt();
>         else
>                 safe_halt();
> 
>  //local_irq_save(flags);
> I am seeing only a slight overhead, but want to give a full run to
> check the performance.
Without compiling and checking myself the different between previous
code and this one should be a couple asm instruction. I would be
surprised if you can measure it especially as vcpu is going to halt
(and do expensive vmexit in the process) anyway.

--
			Gleb.
