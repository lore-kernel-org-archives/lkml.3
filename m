Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaGQJqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:46:37 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63923 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaGQJqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:46:34 -0400
Message-ID: <53C78E37.5090807@redhat.com>
Date: Thu, 17 Jul 2014 10:49:59 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: nVMX: Fix fail to get nested ack intr's vector
 during nested vmexit
References: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com> <1405573011-41330-2-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1405573011-41330-2-git-send-email-wanpeng.li@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2014 06:56, Wanpeng Li ha scritto:
>  	    && nested_exit_intr_ack_set(vcpu)) {
>  		int irq = kvm_cpu_get_interrupt(vcpu);
> +
> +		if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
> +			irq = kvm_get_apic_interrupt(vcpu);

There's something weird in this patch.  If you "inline" 
kvm_cpu_get_interrupt, what you get is this:

         int irq;

	/* Beginning of kvm_cpu_get_interrupt... */
         if (!irqchip_in_kernel(v->kvm))
                 irq = v->arch.interrupt.nr;
	else {
	        irq = kvm_cpu_get_extint(v); /* PIC */
	        if (!kvm_apic_vid_enabled(v->kvm) && irq == -1)
			irq = kvm_get_apic_interrupt(v); /* APIC */
	}

	/* kvm_cpu_get_interrupt done. */
	if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
		irq = kvm_get_apic_interrupt(vcpu);

There are just two callers of kvm_cpu_get_interrupt, and the other is 
protected by kvm_cpu_has_injectable_intr so it won't be executed if 
virtual interrupt delivery is enabled.  So you patch is effectively the 
same as this:

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

But in kvm_get_apic_interrupt I have just added this comment:

         /* Note that we never get here with APIC virtualization
	 * enabled.  */

because kvm_get_apic_interrupt calls apic_set_isr, and apic_set_isr must 
never be called with APIC virtualization enabled either.  With APIC 
virtualization enabled, isr_count is always 1, and highest_isr_cache is 
always -1, and apic_set_isr breaks both of these invariants.

Paolo
