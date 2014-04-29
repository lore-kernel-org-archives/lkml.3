Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbaD2QzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181AbaD2Qy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:54:59 -0400
From: Bandan Das <bsd@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: nVMX: additional checks on vmxon region
References: <1398661204-4822-1-git-send-email-bsd@redhat.com>
	<1398661204-4822-3-git-send-email-bsd@redhat.com>
	<535E3BDA.1000008@siemens.com>
Date: Tue, 29 Apr 2014 12:54:50 -0400
In-Reply-To: <535E3BDA.1000008@siemens.com> (Jan Kiszka's message of "Mon, 28
	Apr 2014 13:30:34 +0200")
Message-ID: <jpgha5cxehx.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka <jan.kiszka@siemens.com> writes:

> On 2014-04-28 07:00, Bandan Das wrote:
>> Currently, the vmxon region isn't used in the nested case.
>> However, according to the spec, the vmxon instruction performs
>> additional sanity checks on this region and the associated
>> pointer. Modify emulated vmxon to better adhere to the spec
>> requirements
>> 
>> Signed-off-by: Bandan Das <bsd@redhat.com>
>> ---
>>  arch/x86/kvm/vmx.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 53 insertions(+)
>> 
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index c18fe9a4..d5342c7 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -354,6 +354,7 @@ struct vmcs02_list {
>>  struct nested_vmx {
>>  	/* Has the level1 guest done vmxon? */
>>  	bool vmxon;
>> +	gpa_t vmxon_ptr;
>>  
>>  	/* The guest-physical address of the current VMCS L1 keeps for L2 */
>>  	gpa_t current_vmptr;
>> @@ -5840,9 +5841,19 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
>>  	struct kvm_segment cs;
>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>  	struct vmcs *shadow_vmcs;
>> +	gva_t gva;
>> +	gpa_t vmptr;
>> +	struct x86_exception e;
>> +	struct page *page;
>> +
>>  	const u64 VMXON_NEEDED_FEATURES = FEATURE_CONTROL_LOCKED
>>  		| FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
>>  
>> +	/* Guest physical Address Width */
>> +	struct kvm_cpuid_entry2 *best =
>> +		kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
>
> We have cpuid_maxphyaddr().
>
>> +
>> +
>>  	/* The Intel VMX Instruction Reference lists a bunch of bits that
>>  	 * are prerequisite to running VMXON, most notably cr4.VMXE must be
>>  	 * set to 1 (see vmx_set_cr4() for when we allow the guest to set this).
>> @@ -5865,6 +5876,46 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
>>  		kvm_inject_gp(vcpu, 0);
>>  		return 1;
>>  	}
>> +
>> +	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
>> +				vmcs_read32(VMX_INSTRUCTION_INFO), &gva))
>> +		return 1;
>> +
>> +	if (kvm_read_guest_virt(&vcpu->arch.emulate_ctxt, gva, &vmptr,
>> +				sizeof(vmptr), &e)) {
>> +		kvm_inject_page_fault(vcpu, &e);
>> +		return 1;
>> +	}
>> +
>> +	/* Don't bailout if best is NULL */
>> +	WARN_ON(!best);
>> +
>> +	/*
>> +	 * SDM 3: 24.11.5
>> +	 * VMXON pointer must be 4KB aligned
>> +	 * VMXON pointer must not set any bits beyond processor's
>> +	 * physical address width
>> +	 * The first 4 bytes of VMXON region contain the supported
>> +	 * VMCS revision identifier
>> +	 *
>> +	 * Note - IA32_VMX_BASIC[48] will never be 1 for the nested case;
>> +	 * which replaces physical address width with 32
>> +	 */
>> +	if (!IS_ALIGNED(vmptr, PAGE_SIZE) || (best &&
>> +					      (vmptr >> (best->eax & 0xff)))) {
>> +		nested_vmx_failInvalid(vcpu);
>> +		skip_emulated_instruction(vcpu);
>> +		return 1;
>> +	}
>> +
>> +	page = nested_get_page(vcpu, vmptr);
>> +	if ((page == NULL) || ((*(u32 *)kmap(page) != VMCS12_REVISION))) {
>
> Style: you don't need braces around the comparisons.
>
>> +		nested_vmx_failInvalid(vcpu);
>> +		kunmap(page);
>> +		skip_emulated_instruction(vcpu);
>> +		return 1;
>> +	}
>> +
>>  	if (vmx->nested.vmxon) {
>>  		nested_vmx_failValid(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
>>  		skip_emulated_instruction(vcpu);
>> @@ -5896,9 +5947,11 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
>>  	vmx->nested.preemption_timer.function = vmx_preemption_timer_fn;
>>  
>>  	vmx->nested.vmxon = true;
>> +	vmx->nested.vmxon_ptr = vmptr;
>>  
>>  	skip_emulated_instruction(vcpu);
>>  	nested_vmx_succeed(vcpu);
>> +	kunmap(page);
>
> This late unmapping leaks the page in other error cases.

Oops, sorry!

> Jan
>
>>  	return 1;
>>  }
>>  
>> 
