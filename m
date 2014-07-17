Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbaGQL3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:29:07 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:45383 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbaGQL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:29:04 -0400
Message-ID: <53C7B378.2030509@redhat.com>
Date: Thu, 17 Jul 2014 13:28:56 +0200
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
References: <1405594981-31384-1-git-send-email-wanpeng.li@linux.intel.com> <1405594981-31384-2-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1405594981-31384-2-git-send-email-wanpeng.li@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2014 13:03, Wanpeng Li ha scritto:
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 4ae5ad8..a704f71 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -8697,6 +8697,9 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
>  	    && nested_exit_intr_ack_set(vcpu)) {
>  		int irq = kvm_cpu_get_interrupt(vcpu);
> +
> +		if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
> +			irq = kvm_lapic_find_highest_irr(vcpu);
>  		WARN_ON(irq < 0);
>  		vmcs12->vm_exit_intr_info = irq |
>  			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;

I wonder if this should be kvm_apic_has_interrupt, so that the PPR
register is taken into consideration?

If so, the same change can also be written like this:

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
index 3855103..92a0a58 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1627,10 +1627,13 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	int vector = kvm_apic_has_interrupt(vcpu);
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	/* Note that we never get here with APIC virtualization enabled.  */
+	/*
+	 * With APIC virtualization enabled, just pass back the
+	 * vector, the processor will take care of delivery.
+	 */
 
-	if (vector == -1)
-		return -1;
+	if (vector == -1 || kvm_apic_vid_enabled(vcpu->kvm))
+		return vector;
 
 	apic_set_isr(vector, apic);
 	apic_update_ppr(apic);

The idea is that kvm_cpu_get_interrupt always return the interrupt.  If
you are injecting an interrupt you will test kvm_cpu_has_injectable_intr
outside the call to kvm_cpu_get_interrupt, and kvm_get_apic_interrupt
will never be reached anyway.  Instead, if you are reporting the interrupt,
any interrupt will be okay.

Yang, Wanpeng, what do you think?  Can you test both variants,
that is:

- you patch with kvm_apic_has_interrupt instead of
kvm_lapic_find_highest_irr

- the above untested patch of mine?

Thanks,

Paolo
