Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaEZNHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbaEZNHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:07:40 -0400
Message-ID: <53833C97.3040305@redhat.com>
Date: Mon, 26 May 2014 15:07:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] KVM: lapic: sync highest ISR to hardware apic on EOI
References: <1400856713-18628-1-git-send-email-pbonzini@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AAD347A@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AAD347A@SHSMSX104.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/05/2014 05:44, Zhang, Yang Z ha scritto:
> Paolo Bonzini wrote on 2014-05-23:
>> When Hyper-V enlightenments are in effect, Windows prefers to issue an
>> Hyper-V MSR write to issue an EOI rather than an x2apic MSR write.
>> The Hyper-V MSR write is not handled by the processor, and besides
>> being slower, this also causes bugs with APIC virtualization.  The
>> reason is that on EOI the processor will modify the highest in-service
>> interrupt (SVI) field of the VMCS, as explained in section 29.1.4 of
>> the SDM.
>>
>
> Not only SVI update. It also includes ISR and PPR update. During PPR
> update, a new pending interrupt may be recognized and inject to guest.

Right, but SVI update is the only part that is missing.  Writing VISR is 
done by apic_clear_isr and PPR virtualization is done by 
apic_update_ppr. PPR virtualization is also done anyway at any VM entry, 
together with evaluating and delivering pending virtual interrupts.

We'll do two PPR virtualizations (one in KVM, one in the processor), but 
that's ok because they're idempotent.

We also operate as if the EOI exit bitmap was all ones, but that's ok 
because a useless kvm_ioapic_send_eoi is not harmful.

>>  static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>>  {
>> -	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
>> +	struct kvm_vcpu *vcpu;
>> +	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
>> +		return;
>> +
>> +	vcpu = apic->vcpu;
>> +
>> +	/*
>> +	 * We do get here for APIC virtualization enabled if the guest
>> +	 * uses the Hyper-V APIC enlightenment.  In this case we may need
>> +	 * to trigger a new interrupt delivery by writing the SVI field;
>> +	 * on the other hand isr_count and highest_isr_cache are unused
>> +	 * and must be left alone.
>> +	 */
>> +	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
>> +		kvm_x86_ops->hwapic_isr_update(vcpu->kvm,
>> +					       apic_find_highest_isr(apic));
>
> If there is a pending interrupt, will it be recognized? I am not
> looking into the Hyper-V enlightenments code, not sure whether it
> already covers interrupt recognition. But if it doesn't do it, then we
> need to do it.

Yes, on the next VM entry the processor will do RVI to the PPR.  Before 
the VM entry KVM_REQ_EVENT will also be processed, which updates RVI in 
hwapic_irr_update
.

Paolo
