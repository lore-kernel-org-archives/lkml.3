Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaHDCCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 22:02:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:29959 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaHDCB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 22:01:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,794,1400050800"; 
   d="scan'208";a="579535277"
From: "Liu, RongrongX" <rongrongx.liu@intel.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] KVM: nVMX: Fix nested vmexit ack intr before load
 vmcs01
Thread-Topic: [PATCH 1/2] KVM: nVMX: Fix nested vmexit ack intr before load
 vmcs01
Thread-Index: AQHPrWB73+AVISl9r0ClB7NgEd4rFpu/tSkw
Date: Mon, 4 Aug 2014 02:01:54 +0000
Message-ID: <8F9B1D95D29E8A42905D3F4AAB23ED140A70103E@SHSMSX103.ccr.corp.intel.com>
References: <1406880727-60001-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1406880727-60001-1-git-send-email-wanpeng.li@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]
> On Behalf Of Wanpeng Li
> Sent: Friday, August 01, 2014 4:12 PM
> To: Paolo Bonzini; Jan Kiszka
> Cc: Marcelo Tosatti; Gleb Natapov; Bandan Das; Zhang, Yang Z;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Wanpeng Li
> Subject: [PATCH 1/2] KVM: nVMX: Fix nested vmexit ack intr before load
> vmcs01
> 
> External interrupt will cause L1 vmexit w/ reason external interrupt when L2
> is running. Then L1 will pick up the interrupt through vmcs12 if L1 set the ack
> interrupt bit. Commit 77b0f5d (KVM: nVMX: Ack and write vector info to
> intr_info if L1 asks us to) get intr that belongs to L1 before load vmcs01 which
> is wrong, especially this lead to the obvious L1 ack APICv behavior weired
> since APICv is for L1 instead of L2. This patch fix it by ack intr after load
> vmcs01.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>

Tested-by:  Liu, RongrongX <rongrongx.liu@intel.com>

> ---
>  arch/x86/kvm/vmx.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c index
> e618f34..b8122b3 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -8754,14 +8754,6 @@ static void nested_vmx_vmexit(struct kvm_vcpu
> *vcpu, u32 exit_reason,
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
>  				       vmcs12->idt_vectoring_info_field, @@ -
> 8771,6 +8763,14 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu,
> u32 exit_reason,
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
> --
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in the body of
> a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
