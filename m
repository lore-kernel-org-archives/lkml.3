Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3HMUA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:00:27 -0400
Received: from claw.goop.org ([74.207.240.146]:40463 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796Ab3HMUAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:00:24 -0400
Message-ID: <520A9056.3080707@goop.org>
Date: Tue, 13 Aug 2013 13:00:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, konrad.wilk@oracle.com,
        gleb@redhat.com, pbonzini@redhat.com, gregkh@suse.de,
        peterz@infradead.org, tglx@linutronix.de, agraf@suse.de,
        riel@redhat.com, avi.kivity@gmail.com, habanero@linux.vnet.ibm.com,
        chegu_vinod@hp.com, ouyang@cs.pitt.edu, drjones@redhat.com,
        attilio.rao@citrix.com, linux-doc@vger.kernel.org,
        torvalds@linux-foundation.org, kvm@vger.kernel.org,
        andi@firstfloor.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        stefano.stabellini@eu.citrix.com, mtosatti@redhat.com,
        srivatsa.vaddagiri@gmail.com,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: [PATCH delta V13 14/14] kvm : Paravirtual ticketlocks support
 for linux guests running on KVM hypervisor
References: <y> <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <1376058122-8248-15-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20130810193849.GA25260@linux.vnet.ibm.com> <520A620B.6070702@zytor.com> <20130813165552.GA6795@gmail.com> <20130813200211.GA27811@linux.vnet.ibm.com>
In-Reply-To: <20130813200211.GA27811@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 01:02 PM, Raghavendra K T wrote:
> * Ingo Molnar <mingo@kernel.org> [2013-08-13 18:55:52]:
>
>> Would be nice to have a delta fix patch against tip:x86/spinlocks, which 
>> I'll then backmerge into that series via rebasing it.
>>
> There was a namespace collision of PER_CPU lock_waiting variable when
> we have both Xen and KVM enabled. 
>
> Perhaps this week wasn't for me. Had run 100 times randconfig in a loop
> for the fix sent earlier :(. 
>
> Ingo, below delta patch should fix it, IIRC, I hope you will be folding this
> back to patch 14/14 itself. Else please let me.
> I have already run allnoconfig, allyesconfig, randconfig with below patch. But will
> test again. This should apply on top of tip:x86/spinlocks.
>
> ---8<---
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>
> Fix Namespace collision for lock_waiting
>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d442471..b8ef630 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -673,7 +673,7 @@ struct kvm_lock_waiting {
>  static cpumask_t waiting_cpus;
>  
>  /* Track spinlock on which a cpu is waiting */
> -static DEFINE_PER_CPU(struct kvm_lock_waiting, lock_waiting);
> +static DEFINE_PER_CPU(struct kvm_lock_waiting, klock_waiting);

Has static stopped meaning static?

    J

>  
>  static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
>  {
> @@ -685,7 +685,7 @@ static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
>  	if (in_nmi())
>  		return;
>  
> -	w = &__get_cpu_var(lock_waiting);
> +	w = &__get_cpu_var(klock_waiting);
>  	cpu = smp_processor_id();
>  	start = spin_time_start();
>  
> @@ -756,7 +756,7 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
>  
>  	add_stats(RELEASED_SLOW, 1);
>  	for_each_cpu(cpu, &waiting_cpus) {
> -		const struct kvm_lock_waiting *w = &per_cpu(lock_waiting, cpu);
> +		const struct kvm_lock_waiting *w = &per_cpu(klock_waiting, cpu);
>  		if (ACCESS_ONCE(w->lock) == lock &&
>  		    ACCESS_ONCE(w->want) == ticket) {
>  			add_stats(RELEASED_SLOW_KICKED, 1);
>
>

