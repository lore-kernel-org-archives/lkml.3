Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3GNNtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 09:49:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab3GNNtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 09:49:36 -0400
Date: Sun, 14 Jul 2013 16:48:20 +0300
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
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 12/18] kvm hypervisor : Add a hypercall to KVM
 hypervisor to support pv-ticketlocks
Message-ID: <20130714134820.GC11772@redhat.com>
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com>
 <20130624124304.27508.5414.sendpatchset@codeblue.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624124304.27508.5414.sendpatchset@codeblue.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 06:13:04PM +0530, Raghavendra K T wrote:
> kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks
> 
> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> kvm_hc_kick_cpu allows the calling vcpu to kick another vcpu out of halt state.
> the presence of these hypercalls is indicated to guest via
> kvm_feature_pv_unhalt.
> 
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> [Raghu: Apic related changes, folding pvunhalted into vcpu_runnable]
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h      |    5 +++++
>  arch/x86/include/uapi/asm/kvm_para.h |    1 +
>  arch/x86/kvm/cpuid.c                 |    3 ++-
>  arch/x86/kvm/x86.c                   |   37 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm_para.h        |    1 +
>  5 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3741c65..95702de 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -503,6 +503,11 @@ struct kvm_vcpu_arch {
>  	 * instruction.
>  	 */
>  	bool write_fault_to_shadow_pgtable;
> +
> +	/* pv related host specific info */
> +	struct {
> +		bool pv_unhalted;
> +	} pv;
>  };
>  
>  struct kvm_lpage_info {
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 06fdbd9..94dc8ca 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -23,6 +23,7 @@
>  #define KVM_FEATURE_ASYNC_PF		4
>  #define KVM_FEATURE_STEAL_TIME		5
>  #define KVM_FEATURE_PV_EOI		6
> +#define KVM_FEATURE_PV_UNHALT		7
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a20ecb5..b110fe6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -413,7 +413,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
>  			     (1 << KVM_FEATURE_ASYNC_PF) |
>  			     (1 << KVM_FEATURE_PV_EOI) |
> -			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
> +			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
> +			     (1 << KVM_FEATURE_PV_UNHALT);
>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 094b5d9..f8bea30 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5449,6 +5449,36 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +/*
> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> + *
> + * @apicid - apicid of vcpu to be kicked.
> + */
> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
> +{
> +	struct kvm_vcpu *vcpu = NULL;
> +	int i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!kvm_apic_present(vcpu))
> +			continue;
> +
> +		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
> +			break;
> +	}
> +	if (vcpu) {
> +		/*
> +		 * Setting unhalt flag here can result in spurious runnable
> +		 * state when unhalt reset does not happen in vcpu_block.
> +		 * But that is harmless since that should soon result in halt.
> +		 */
> +		vcpu->arch.pv.pv_unhalted = true;
> +		/* We need everybody see unhalt before vcpu unblocks */
> +		smp_wmb();
> +		kvm_vcpu_kick(vcpu);
> +	}
> +}
> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long nr, a0, a1, a2, a3, ret;
> @@ -5482,6 +5512,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  	case KVM_HC_VAPIC_POLL_IRQ:
>  		ret = 0;
>  		break;
> +	case KVM_HC_KICK_CPU:
> +		kvm_pv_kick_cpu_op(vcpu->kvm, a0);
Lets make it hypercall with two parameters: 
a0 - flags
a1 - apic id of a cpu to kick

A0 have to be zero. This will make it more extensible.

> +		ret = 0;
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> @@ -5909,6 +5943,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  				kvm_apic_accept_events(vcpu);
>  				switch(vcpu->arch.mp_state) {
>  				case KVM_MP_STATE_HALTED:
> +					vcpu->arch.pv.pv_unhalted = false;
>  					vcpu->arch.mp_state =
>  						KVM_MP_STATE_RUNNABLE;
>  				case KVM_MP_STATE_RUNNABLE:
> @@ -6729,6 +6764,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	BUG_ON(vcpu->kvm == NULL);
>  	kvm = vcpu->kvm;
>  
> +	vcpu->arch.pv.pv_unhalted = false;
>  	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
>  	if (!irqchip_in_kernel(kvm) || kvm_vcpu_is_bsp(vcpu))
>  		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> @@ -7065,6 +7101,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  		!vcpu->arch.apf.halted)
>  		|| !list_empty_careful(&vcpu->async_pf.done)
>  		|| kvm_apic_has_events(vcpu)
> +		|| vcpu->arch.pv.pv_unhalted
>  		|| atomic_read(&vcpu->arch.nmi_queued) ||
>  		(kvm_arch_interrupt_allowed(vcpu) &&
>  		 kvm_cpu_has_interrupt(vcpu));
> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> index cea2c5c..2841f86 100644
> --- a/include/uapi/linux/kvm_para.h
> +++ b/include/uapi/linux/kvm_para.h
> @@ -19,6 +19,7 @@
>  #define KVM_HC_MMU_OP			2
>  #define KVM_HC_FEATURES			3
>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
> +#define KVM_HC_KICK_CPU			5
I wounder why hypercalls are not defined in architecture headers.

--
			Gleb.
