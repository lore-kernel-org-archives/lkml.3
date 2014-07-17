Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaGQMEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:04:24 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:41487 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGQMEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:04:20 -0400
Message-ID: <53C7BBBB.3000009@redhat.com>
Date: Thu, 17 Jul 2014 14:04:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Fix fail to get nested ack intr's vector
 during nested vmexit
References: <1405594981-31384-1-git-send-email-wanpeng.li@linux.intel.com> <1405594981-31384-2-git-send-email-wanpeng.li@linux.intel.com> <53C7B378.2030509@redhat.com>
In-Reply-To: <53C7B378.2030509@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2014 13:28, Paolo Bonzini ha scritto:
> Il 17/07/2014 13:03, Wanpeng Li ha scritto:
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 4ae5ad8..a704f71 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -8697,6 +8697,9 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>>  	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
>>  	    && nested_exit_intr_ack_set(vcpu)) {
>>  		int irq = kvm_cpu_get_interrupt(vcpu);
>> +
>> +		if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
>> +			irq = kvm_lapic_find_highest_irr(vcpu);
>>  		WARN_ON(irq < 0);
>>  		vmcs12->vm_exit_intr_info = irq |
>>  			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
> 
> I wonder if this should be kvm_apic_has_interrupt, so that the PPR
> register is taken into consideration?


And actually, I think the acknowledging should include the three steps to
set-ISR/update-PPR/clear-IRR.  (With APICv update PPR is not strictly
necessary, but it doesn't hurt either).

You cannot let the processor do these because it would deliver the interrupt
through the IDT,  but you still must do it in the hypervisor.

This gives this patch:

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index bd0da43..a1ec6a5 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -108,7 +108,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 
 	vector = kvm_cpu_get_extint(v);
 
-	if (kvm_apic_vid_enabled(v->kvm) || vector != -1)
+	if (vector != -1)
 		return vector;			/* PIC */
 
 	return kvm_get_apic_interrupt(v);	/* APIC */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3855103..6cbc7af 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -360,10 +360,20 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
-	/* Note that we never get here with APIC virtualization enabled.  */
+	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR)) {
+		/*
+		 * With APIC virtualization enabled, all caching is disabled
+		 * because the processor can modify ISR under the hood.  Instead
+		 * just set SVI.
+		 */
+		if (kvm_apic_vid_enabled(vcpu->kvm)) {
+			kvm_x86_ops->hwapic_isr_update(vcpu->kvm, vec);
+			return;
+		}
 
-	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
 		++apic->isr_count;
+	}
+
 	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
 	/*
 	 * ISR (in service register) bit is set when injecting an interrupt.
@@ -1627,11 +1637,16 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	int vector = kvm_apic_has_interrupt(vcpu);
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	/* Note that we never get here with APIC virtualization enabled.  */
-
 	if (vector == -1)
 		return -1;
 
+	/*
+	 * We get here even with APIC virtualization enabled, if doing
+	 * nested virtualization and L1 runs with the "acknowledge interrupt 
+	 * on exit" mode.  Then we cannot inject the interrupt via RVI,
+	 * because the process would deliver it through the IDT.
+	 */
+
 	apic_set_isr(vector, apic);
 	apic_update_ppr(apic);
 	apic_clear_irr(vector, apic);


I think the right way to do it must be something like this; you cannot
do it just in nested_vmx_vmexit.  Testing is welcome since I don't have
easy access to APICv-capable hardware (it would take a few days).

Paolo
