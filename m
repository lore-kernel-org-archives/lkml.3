Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaHDMvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaHDMvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:51:37 -0400
Message-ID: <53DF81D1.1060701@redhat.com>
Date: Mon, 04 Aug 2014 14:51:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: nVMX: Fix nested vmexit ack intr before load
 vmcs01
References: <1406880727-60001-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1406880727-60001-1-git-send-email-wanpeng.li@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/08/2014 10:12, Wanpeng Li ha scritto:
> External interrupt will cause L1 vmexit w/ reason external interrupt when L2 is 
> running. Then L1 will pick up the interrupt through vmcs12 if L1 set the ack 
> interrupt bit. Commit 77b0f5d (KVM: nVMX: Ack and write vector info to intr_info
> if L1 asks us to) get intr that belongs to L1 before load vmcs01 which is wrong, 
> especially this lead to the obvious L1 ack APICv behavior weired since APICv 
> is for L1 instead of L2. This patch fix it by ack intr after load vmcs01.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/vmx.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index e618f34..b8122b3 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -8754,14 +8754,6 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  	prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
>  		       exit_qualification);
>  
> -	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> -	    && nested_exit_intr_ack_set(vcpu)) {
> -		int irq = kvm_cpu_get_interrupt(vcpu);
> -		WARN_ON(irq < 0);
> -		vmcs12->vm_exit_intr_info = irq |
> -			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
> -	}
> -
>  	trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
>  				       vmcs12->exit_qualification,
>  				       vmcs12->idt_vectoring_info_field,
> @@ -8771,6 +8763,14 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  
>  	vmx_load_vmcs01(vcpu);
>  
> +	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +	    && nested_exit_intr_ack_set(vcpu)) {
> +		int irq = kvm_cpu_get_interrupt(vcpu);
> +		WARN_ON(irq < 0);
> +		vmcs12->vm_exit_intr_info = irq |
> +			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
> +	}
> +
>  	vm_entry_controls_init(vmx, vmcs_read32(VM_ENTRY_CONTROLS));
>  	vm_exit_controls_init(vmx, vmcs_read32(VM_EXIT_CONTROLS));
>  	vmx_segment_cache_clear(vmx);
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

