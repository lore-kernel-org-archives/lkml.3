Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3IWKWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab3IWKWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:22:21 -0400
Message-ID: <5240166D.5020401@redhat.com>
Date: Mon, 23 Sep 2013 12:22:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: x86: prevent setting unsupported XSAVE states
References: <1379341591-6538-1-git-send-email-pbonzini@redhat.com> <1379341591-6538-3-git-send-email-pbonzini@redhat.com> <20130922093353.GI25202@redhat.com>
In-Reply-To: <20130922093353.GI25202@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2013 11:33, Gleb Natapov ha scritto:
> On Mon, Sep 16, 2013 at 04:26:30PM +0200, Paolo Bonzini wrote:
>> A guest can still attempt to save and restore XSAVE states even if they
>> have been masked in CPUID leaf 0Dh.  This usually is not visible to
>> the guest, but is still wrong: "Any attempt to set a reserved bit (as
>> determined by the contents of EAX and EDX after executing CPUID with
>> EAX=0DH, ECX= 0H) in XCR0 for a given processor will result in a #GP
>> exception".
>>
>> The patch also performs the same checks as __kvm_set_xcr in KVM_SET_XSAVE.
>> This catches migration from newer to older kernel/processor before the
>> guest starts running.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/cpuid.c            |  7 +++++++
>>  arch/x86/kvm/x86.c              | 17 ++++++++++++++---
>>  3 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index c76ff74..1553542 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -389,6 +389,7 @@ struct kvm_vcpu_arch {
>>  
>>  	struct fpu guest_fpu;
>>  	u64 xcr0;
>> +	u64 supported_xcr0;
>>  
> Lets prefix it with guest_.

Ok.

>>  	struct kvm_pio_request pio;
>>  	void *pio_data;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index a03a9fa..fa754a8 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -46,6 +46,13 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
>>  			apic->lapic_timer.timer_mode_mask = 1 << 17;
>>  	}
>>  
>> +	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
>> +	if (!best)
>> +		return;
> If QMEU will set AVX in 0xD and then remove cpuid leaf at all
> supported_xcr0  will still have it.

Right.  Will fix.

>> +	vcpu->arch.supported_xcr0 =
>> +		(best->eax | ((u64)best->edx << 32)) &
>> +		host_xcr0 & KVM_SUPPORTED_XCR0;
>> +
>>  	kvm_pmu_cpuid_update(vcpu);
>>  }
>>  
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index e5ca72a..cc8c403 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -586,7 +586,7 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>>  		return 1;
>>  	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
>>  		return 1;
>> -	if (xcr0 & ~host_xcr0)
>> +	if (xcr0 & ~vcpu->arch.supported_xcr0)
>>  		return 1;
>>  	kvm_put_guest_xcr0(vcpu);
>>  	vcpu->arch.xcr0 = xcr0;
>> @@ -3003,10 +3003,19 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>>  	u64 xstate_bv =
>>  		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
>>  
>> -	if (cpu_has_xsave)
>> +	if (cpu_has_xsave) {
>> +		/*
>> +		 * Here we allow setting states that are not present in
>> +		 * CPUID leaf 0xD, index 0, EDX:EAX.  This is for compatibility
>> +		 * with old userspace.
>> +		 */
>> +		if (xstate_bv & ~KVM_SUPPORTED_XCR0)
>> +			return -EINVAL;
>> +		if (xstate_bv & ~host_xcr0)
>> +			return -EINVAL;
>>  		memcpy(&vcpu->arch.guest_fpu.state->xsave,
>>  			guest_xsave->region, xstate_size);
>> -	else {
>> +	} else {
>>  		if (xstate_bv & ~XSTATE_FPSSE)
>>  			return -EINVAL;
>>  		memcpy(&vcpu->arch.guest_fpu.state->fxsave,
>> @@ -6940,6 +6948,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>  
>>  	vcpu->arch.ia32_tsc_adjust_msr = 0x0;
>>  	vcpu->arch.pv_time_enabled = false;
>> +
>> +	vcpu->arch.supported_xcr0 = XSTATE_FPSSE;
>> +
> Why is this needed? It will make make __kvm_set_xcr() succeed if attempt
> is made to set SSE bit when it is not supported in cpuid. This may not
> be an issue in practice, but for clarity it is better for supported_xcr0
> to contain only what is supported in guest's cpuid bits and handle the
> fact that FP/SSE state should always be copied to/from userspace in
> kvm_vcpu_ioctl_x86_(set|get)_xsave functions.

I don't think it makes sense to disable SSE but not XSAVE.  Linux even
has this:

        if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
                pr_err("FP/SSE not shown under xsave features 0x%llx\n",
                       pcntxt_mask);
                BUG();
        }

I preferred this to adding dubiously-testable code that probed CPUID for
SSE support (or should I check FXSR instead?)

Paolo

>>  	kvm_async_pf_hash_reset(vcpu);
>>  	kvm_pmu_init(vcpu);
>>  
>> -- 
>> 1.8.3.1
>>
> 
> --
> 			Gleb.
> 

