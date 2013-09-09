Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3IIOJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:09:47 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:62980 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3IIOJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:09:45 -0400
Message-ID: <522DD6AB.1030303@redhat.com>
Date: Mon, 09 Sep 2013 16:09:47 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: prevent setting unsupported XSAVE states
References: <1378383714-9723-2-git-send-email-pbonzini@redhat.com> <20130908095446.GE17294@redhat.com>
In-Reply-To: <20130908095446.GE17294@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/09/2013 11:54, Gleb Natapov ha scritto:
> On Thu, Sep 05, 2013 at 02:21:54PM +0200, Paolo Bonzini wrote:
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
>> Cc: kvm@vger.kernel.org
>> Cc: Gleb Natapov <gleb@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/cpuid.c |  2 +-
>>  arch/x86/kvm/x86.c   | 10 ++++++++--
>>  arch/x86/kvm/x86.h   |  1 +
>>  3 files changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index a20ecb5..d7c465d 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -182,7 +182,7 @@ static bool supported_xcr0_bit(unsigned bit)
>>  {
>>  	u64 mask = ((u64)1 << bit);
>>  
>> -	return mask & (XSTATE_FP | XSTATE_SSE | XSTATE_YMM) & host_xcr0;
>> +	return mask & KVM_SUPPORTED_XCR0 & host_xcr0;
>>  }
>>  
>>  #define F(x) bit(X86_FEATURE_##x)
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3625798..801a882 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -586,6 +586,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>>  		return 1;
>>  	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
>>  		return 1;
>> +	if (xcr0 & ~KVM_SUPPORTED_XCR0)
>> +		return 1;
> Shouldn't we check guest's cpuid here?

Yes.

>>  	if (xcr0 & ~host_xcr0)
>>  		return 1;
>>  	kvm_put_guest_xcr0(vcpu);
>> @@ -2980,10 +2982,14 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>>  	u64 xstate_bv =
>>  		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
>>  
>> -	if (cpu_has_xsave)
>> +	if (cpu_has_xsave) {
>> +		if (xstate_bv & ~KVM_SUPPORTED_XCR0)
>> +			return -EINVAL;
>> +		if (xstate_bv & ~host_xcr0)
>> +			return -EINVAL;
> And here?

Here it'd be nice, but we cannot due to backwards compatibility.  We
agreed to change KVM_GET_XSAVE and make it only report states that are
included in CPUID, but we still need to do migration from old kernels
that report all states.

If we change KVM_SET_XSAVE to look at CPUID, and the CPUID does not
include AVX, migration will fail from old kernel (KVM_GET_XSAVE reports
all states) to new kernel (KVM_SET_XSAVES checks against CPUID).

Paolo

>>  		memcpy(&vcpu->arch.guest_fpu.state->xsave,
>>  			guest_xsave->region, xstate_size);
>> -	else {
>> +	} else {
>>  		if (xstate_bv & ~XSTATE_FPSSE)
>>  			return -EINVAL;
>>  		memcpy(&vcpu->arch.guest_fpu.state->fxsave,
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index e224f7a..587fb9e 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -122,6 +122,7 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
>>  	gva_t addr, void *val, unsigned int bytes,
>>  	struct x86_exception *exception);
>>  
>> +#define KVM_SUPPORTED_XCR0	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
>>  extern u64 host_xcr0;
>>  
>>  extern struct static_key kvm_no_apic_vcpu;
>> -- 
>> 1.8.3.1
> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

