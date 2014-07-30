Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaG3PVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:21:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaG3PVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:21:10 -0400
Message-ID: <53D90D5A.3060404@redhat.com>
Date: Wed, 30 Jul 2014 17:20:58 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: nested TPR shadow/threshold emulation
References: <1406721880-5490-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1406721880-5490-1-git-send-email-wanpeng.li@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/07/2014 14:04, Wanpeng Li ha scritto:
> @@ -7962,14 +7965,14 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  		if (!vmx->rdtscp_enabled)
>  			exec_control &= ~SECONDARY_EXEC_RDTSCP;
>  		/* Take the following fields only from vmcs12 */
> -		exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
> -				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
> +		exec_control &= ~(SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>                                    SECONDARY_EXEC_APIC_REGISTER_VIRT);

This change is wrong.  You don't have to take L0's "virtualize APIC
accesses" setting into account, because while running L2 you cannot
modify L1's CR8 (only the virtual nested one).

> +
> +			virtual_apic_page = nested_get_page(vcpu,
> +						vmcs12->virtual_apic_page_addr);
> +			if (vmcs_read64(VIRTUAL_APIC_PAGE_ADDR) !=
> +					page_to_phys(virtual_apic_page))
> +				vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
> +					page_to_phys(virtual_apic_page));
> +			nested_release_page(virtual_apic_page);
> +

You cannot release this page here.  You need to the exactly the same
thing that is done for apic_access_page.

One thing:

> +	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
> +		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);

I think you can just do this write unconditionally, since most
hypervisors will enable this.  Also, you probably can add the tpr
threshold field to the read-write fields for shadow VMCS.

Paolo
