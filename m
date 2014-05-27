Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaE0A1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:27:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:46056 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaE0A1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:27:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,915,1392192000"; 
   d="scan'208";a="518037891"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] KVM: lapic: sync highest ISR to hardware apic on EOI
Thread-Topic: [PATCH] KVM: lapic: sync highest ISR to hardware apic on EOI
Thread-Index: AQHPdpaiz0U4PEBytESNOv6ntY3j3ptSOodggAAZG4CAAUKkIA==
Date: Tue, 27 May 2014 00:26:30 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AAD4436@SHSMSX104.ccr.corp.intel.com>
References: <1400856713-18628-1-git-send-email-pbonzini@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AAD347A@SHSMSX104.ccr.corp.intel.com>
 <53833C97.3040305@redhat.com>
In-Reply-To: <53833C97.3040305@redhat.com>
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

Paolo Bonzini wrote on 2014-05-26:
> Il 26/05/2014 05:44, Zhang, Yang Z ha scritto:
>> Paolo Bonzini wrote on 2014-05-23:
>>> When Hyper-V enlightenments are in effect, Windows prefers to issue
>>> an Hyper-V MSR write to issue an EOI rather than an x2apic MSR write.
>>> The Hyper-V MSR write is not handled by the processor, and besides
>>> being slower, this also causes bugs with APIC virtualization.  The
>>> reason is that on EOI the processor will modify the highest
>>> in-service interrupt (SVI) field of the VMCS, as explained in
>>> section
>>> 29.1.4 of the SDM.
>>> 
>> 
>> Not only SVI update. It also includes ISR and PPR update. During PPR
>> update, a new pending interrupt may be recognized and inject to guest.
> 
> Right, but SVI update is the only part that is missing.  Writing VISR
> is done by apic_clear_isr and PPR virtualization is done by
> apic_update_ppr. PPR virtualization is also done anyway at any VM
> entry, together with evaluating and delivering pending virtual interrupts.
> 
> We'll do two PPR virtualizations (one in KVM, one in the processor),
> but that's ok because they're idempotent.
> 
> We also operate as if the EOI exit bitmap was all ones, but that's ok
> because a useless kvm_ioapic_send_eoi is not harmful.
> 
>>>  static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>>> {
>>> -	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
>>> +	struct kvm_vcpu *vcpu;
>>> +	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
>>> +		return;
>>> +
>>> +	vcpu = apic->vcpu;
>>> +
>>> +	/*
>>> +	 * We do get here for APIC virtualization enabled if the guest
>>> +	 * uses the Hyper-V APIC enlightenment.  In this case we may need
>>> +	 * to trigger a new interrupt delivery by writing the SVI field;
>>> +	 * on the other hand isr_count and highest_isr_cache are unused
>>> +	 * and must be left alone.
>>> +	 */
>>> +	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
>>> +		kvm_x86_ops->hwapic_isr_update(vcpu->kvm,
>>> +					       apic_find_highest_isr(apic));
>> 
>> If there is a pending interrupt, will it be recognized? I am not
>> looking into the Hyper-V enlightenments code, not sure whether it
>> already covers interrupt recognition. But if it doesn't do it, then
>> we need to do it.
> 
> Yes, on the next VM entry the processor will do RVI to the PPR.
> Before the VM entry KVM_REQ_EVENT will also be processed, which
> updates RVI in hwapic_irr_update .

Ok, thanks for explanation. 

Reviewed-by: Yang Zhang <yang.z.zhang@intel.com>

> 
> Paolo


Best regards,
Yang

