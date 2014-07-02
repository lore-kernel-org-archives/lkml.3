Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaGBJB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:01:58 -0400
Received: from goliath.siemens.de ([192.35.17.28]:56813 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaGBJB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:01:56 -0400
Message-ID: <53B3CA6A.4050902@siemens.com>
Date: Wed, 02 Jul 2014 11:01:30 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
CC: Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-02 08:54, Wanpeng Li wrote:
> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=72381 
> 
> If we didn't inject a still-pending event to L1 since nested_run_pending,
> KVM_REQ_EVENT should be requested after the vmexit in order to inject the 
> event to L1. However, current log blindly request a KVM_REQ_EVENT even if 
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

There are more, unrelated reasons why KVM_REQ_EVENT could be set. Why
aren't those able to trigger this scenario?

In any case, unconditionally setting KVM_REQ_EVENT seems strange and
should be changed.

Jan

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
>  
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
