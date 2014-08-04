Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaHDMv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaHDMvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:51:24 -0400
Message-ID: <53DF81C3.7050302@redhat.com>
Date: Mon, 04 Aug 2014 14:51:15 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: nVMX: fix acknowledge interrupt on exit when
 APICv is in use
References: <1406880727-60001-1-git-send-email-wanpeng.li@linux.intel.com> <1406880727-60001-2-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1406880727-60001-2-git-send-email-wanpeng.li@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/08/2014 10:12, Wanpeng Li ha scritto:
> +int kvm_lapic_ack_apicv(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	int vec;
> +
> +	vec = kvm_apic_has_interrupt(vcpu);
> +
> +	if (vec == -1)
> +		return vec;
> +
> +	apic_set_vector(vec, apic->regs + APIC_ISR);
> +	apic_update_ppr(apic);
> +	apic_clear_vector(vec, apic->regs + APIC_IRR);
> +
> +	return vec;
> +}
> +EXPORT_SYMBOL_GPL(kvm_lapic_ack_apicv);

I would prefer reusing kvm_get_apic_interrupt here (by modifying
kvm_cpu_get_interrupt, apic_set_isr and apic_clear_irr) as I had
sketched in the previous version of the patches.

There is no reason for kvm_cpu_get_interrupt to return -1 if virtual
interrupt delivery is enabled.

Paolo
