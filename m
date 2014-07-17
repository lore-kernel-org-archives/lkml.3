Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaGQJOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:14:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:40733 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbaGQJOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:14:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,676,1400050800"; 
   d="scan'208";a="563115092"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, "Hu, Robert" <robert.hu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] KVM: nVMX: Fix fail to get nested ack intr's vector
 during nested vmexit
Thread-Topic: [PATCH 2/3] KVM: nVMX: Fix fail to get nested ack intr's
 vector during nested vmexit
Thread-Index: AQHPoZw7RcQZK/akI06lbOFGhVZ6iZuj+mTA
Date: Thu, 17 Jul 2014 09:13:56 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AB31D9E@SHSMSX104.ccr.corp.intel.com>
References: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com>
 <1405573011-41330-2-git-send-email-wanpeng.li@linux.intel.com>
 <53C78E37.5090807@redhat.com>
In-Reply-To: <53C78E37.5090807@redhat.com>
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

Paolo Bonzini wrote on 2014-07-17:
> Il 17/07/2014 06:56, Wanpeng Li ha scritto:
>>  	    && nested_exit_intr_ack_set(vcpu)) {
>>  		int irq = kvm_cpu_get_interrupt(vcpu);
>> +
>> +		if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
>> +			irq = kvm_get_apic_interrupt(vcpu);
> 
> There's something weird in this patch.  If you "inline"
> kvm_cpu_get_interrupt, what you get is this:
> 
>          int irq;
> 	/* Beginning of kvm_cpu_get_interrupt... */
>          if (!irqchip_in_kernel(v->kvm))
>                  irq = v->arch.interrupt.nr;
> 	else {
> 	        irq = kvm_cpu_get_extint(v); /* PIC */
> 	        if (!kvm_apic_vid_enabled(v->kvm) && irq == -1)
> 			irq = kvm_get_apic_interrupt(v); /* APIC */
> 	}
> 
> 	/* kvm_cpu_get_interrupt done. */
> 	if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
> 		irq = kvm_get_apic_interrupt(vcpu);
> 
> There are just two callers of kvm_cpu_get_interrupt, and the other is
> protected by kvm_cpu_has_injectable_intr so it won't be executed if
> virtual interrupt delivery is enabled.  So you patch is effectively the same as this:
> 
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c index
> bd0da43..a1ec6a5 100644 --- a/arch/x86/kvm/irq.c +++
> b/arch/x86/kvm/irq.c @@ -108,7 +108,7 @@ int
> kvm_cpu_get_interrupt(struct kvm_vcpu *v)
> 
>   	vector = kvm_cpu_get_extint(v);
> -	if (kvm_apic_vid_enabled(v->kvm) || vector != -1)
> +	if (vector != -1)
>   		return vector;			/* PIC */
>   
>   	return kvm_get_apic_interrupt(v);	/* APIC */
> But in kvm_get_apic_interrupt I have just added this comment:
> 
>          /* Note that we never get here with APIC virtualization
> 	 * enabled.  */
> 
> because kvm_get_apic_interrupt calls apic_set_isr, and apic_set_isr
> must never be called with APIC virtualization enabled either.  With
> APIC virtualization enabled, isr_count is always 1, and
> highest_isr_cache is always -1, and apic_set_isr breaks both of these invariants.
> 

You are right. kvm_lapic_find_highest_irr should be the right one.

> Paolo


Best regards,
Yang


