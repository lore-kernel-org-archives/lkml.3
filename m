Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaGBROb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:14:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaGBRO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:14:29 -0400
From: Bandan Das <bsd@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
Date: Wed, 02 Jul 2014 12:27:59 -0400
In-Reply-To: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
	(Wanpeng Li's message of "Wed, 2 Jul 2014 14:54:14 +0800")
Message-ID: <jpg7g3v7mk0.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <wanpeng.li@linux.intel.com> writes:

> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=72381 
I can also reproduce this easily with Linux as L1 by "slowing it down"
eg. running with ept = 0

I suggest changing the subject to -
KVM: nVMX: Fix race that incorrectly injects L1's irq to L2

> If we didn't inject a still-pending event to L1 since nested_run_pending,
> KVM_REQ_EVENT should be requested after the vmexit in order to inject the 
> event to L1. However, current log blindly request a KVM_REQ_EVENT even if 

What's current "log" ? Do you mean current "code" ?

> there is no still-pending event to L1 which blocked by nested_run_pending. 
> There is a race which lead to an interrupt will be injected to L2 which 
> belong to L1 if L0 send an interrupt to L1 during this window. 
>
>                VCPU0                               another thread 
>
> L1 intr not blocked on L2 first entry
> vmx_vcpu_run req event 
> kvm check request req event 
> check_nested_events don't have any intr 
> not nested exit 
>                                             intr occur (8254, lapic timer etc)
> inject_pending_event now have intr 
> inject interrupt 
>
> This patch fix this race by introduced a l1_events_blocked field in nested_vmx 
> which indicates there is still-pending event which blocked by nested_run_pending, 
> and smart request a KVM_REQ_EVENT if there is a still-pending event which blocked 
> by nested_run_pending.
>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/vmx.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index f4e5aed..fe69c49 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -372,6 +372,7 @@ struct nested_vmx {
>  	u64 vmcs01_tsc_offset;
>  	/* L2 must run next, and mustn't decide to exit to L1. */
>  	bool nested_run_pending;
> +	bool l1_events_blocked;
>  	/*
>  	 * Guest pages referred to in vmcs02 with host-physical pointers, so
>  	 * we must keep them pinned while L2 runs.
> @@ -7380,8 +7381,10 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * we did not inject a still-pending event to L1 now because of
>  	 * nested_run_pending, we need to re-enable this bit.
>  	 */
> -	if (vmx->nested.nested_run_pending)
> +	if (to_vmx(vcpu)->nested.l1_events_blocked) {
Is to_vmx() necessary since we alredy have the vmx pointer ?

> +		to_vmx(vcpu)->nested.l1_events_blocked = false;
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
> +	}
>  
>  	vmx->nested.nested_run_pending = 0;
>  
> @@ -8197,15 +8200,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
>  
>  	if (nested_cpu_has_preemption_timer(get_vmcs12(vcpu)) &&
>  	    vmx->nested.preemption_timer_expired) {
> -		if (vmx->nested.nested_run_pending)
> +		if (vmx->nested.nested_run_pending) {
> +			vmx->nested.l1_events_blocked = true;
>  			return -EBUSY;
> +		}
>  		nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER, 0, 0);
>  		return 0;
>  	}
>  
>  	if (vcpu->arch.nmi_pending && nested_exit_on_nmi(vcpu)) {
> -		if (vmx->nested.nested_run_pending ||
> -		    vcpu->arch.interrupt.pending)
> +		if (vmx->nested.nested_run_pending) {
> +			vmx->nested.l1_events_blocked = true;
> +			return -EBUSY;
> +		}
> +		if (vcpu->arch.interrupt.pending)
>  			return -EBUSY;
>  		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
>  				  NMI_VECTOR | INTR_TYPE_NMI_INTR |
> @@ -8221,8 +8229,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
>  
>  	if ((kvm_cpu_has_interrupt(vcpu) || external_intr) &&
>  	    nested_exit_on_intr(vcpu)) {
> -		if (vmx->nested.nested_run_pending)
> +		if (vmx->nested.nested_run_pending) {
> +			vmx->nested.l1_events_blocked = true;
>  			return -EBUSY;
> +		}
>  		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
>  	}
Also, I am wondering isn't it enough to just do this to avoid this race ?

 static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
-       return (!to_vmx(vcpu)->nested.nested_run_pending &&
+       return (!is_guest_mode(vcpu) &&
+               !to_vmx(vcpu)->nested.nested_run_pending &&
                vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
                !(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &

Thanks,
Bandan
