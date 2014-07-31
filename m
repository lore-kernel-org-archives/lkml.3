Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbaGaIDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:03:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:32694 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974AbaGaIDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:03:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="581592598"
Date: Thu, 31 Jul 2014 16:03:54 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: nested TPR shadow/threshold emulation
Message-ID: <20140731080353.GA3033@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1406721880-5490-1-git-send-email-wanpeng.li@linux.intel.com>
 <53D90D5A.3060404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D90D5A.3060404@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Wed, Jul 30, 2014 at 05:20:58PM +0200, Paolo Bonzini wrote:
>Il 30/07/2014 14:04, Wanpeng Li ha scritto:
>> @@ -7962,14 +7965,14 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>>  		if (!vmx->rdtscp_enabled)
>>  			exec_control &= ~SECONDARY_EXEC_RDTSCP;
>>  		/* Take the following fields only from vmcs12 */
>> -		exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
>> -				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>> +		exec_control &= ~(SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>>                                    SECONDARY_EXEC_APIC_REGISTER_VIRT);
>
>This change is wrong.  You don't have to take L0's "virtualize APIC
>accesses" setting into account, because while running L2 you cannot
>modify L1's CR8 (only the virtual nested one).
>

Agreed.

>> +
>> +			virtual_apic_page = nested_get_page(vcpu,
>> +						vmcs12->virtual_apic_page_addr);
>> +			if (vmcs_read64(VIRTUAL_APIC_PAGE_ADDR) !=
>> +					page_to_phys(virtual_apic_page))
>> +				vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>> +					page_to_phys(virtual_apic_page));
>> +			nested_release_page(virtual_apic_page);
>> +
>
>You cannot release this page here.  You need to the exactly the same
>thing that is done for apic_access_page.
>

Agreed.

>One thing:
>
>> +	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
>> +		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
>
>I think you can just do this write unconditionally, since most
>hypervisors will enable this.  Also, you probably can add the tpr

What will happen if a hypervisor doesn't enable it? I make it more 
cleaner in version two.

>threshold field to the read-write fields for shadow VMCS.
>

Agreed.

Regards,
Wanpeng Li 

>Paolo
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
