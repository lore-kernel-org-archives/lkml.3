Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaHGGZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:25:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:26062 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaHGGZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:25:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="369071315"
Date: Thu, 7 Aug 2014 14:26:28 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: nVMX: nested TPR shadow/threshold emulation
Message-ID: <20140807062628.GA32500@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1407149907-13483-1-git-send-email-wanpeng.li@linux.intel.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB505AB@SHSMSX104.ccr.corp.intel.com>
 <53E0B931.7010309@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB516FF@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AB516FF@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Wed, Aug 06, 2014 at 06:38:06AM +0000, Zhang, Yang Z wrote:
[...]
>>>> +
>>>> +	if (exec_control & CPU_BASED_TPR_SHADOW) {
>>>> +		if (vmx->nested.virtual_apic_page)
>>>> +			nested_release_page(vmx->nested.virtual_apic_page);
>>>> +		vmx->nested.virtual_apic_page =
>>>> +		   nested_get_page(vcpu, vmcs12->virtual_apic_page_addr);
>>>> +		if (!vmx->nested.virtual_apic_page)
>>>> +			exec_control &=
>>>> +				~CPU_BASED_TPR_SHADOW;
>>>> +		else
>>>> +			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>>>> +				page_to_phys(vmx->nested.virtual_apic_page));
>>>> +
>>>> +		if (!(exec_control & CPU_BASED_TPR_SHADOW) &&
>>>> +			!((exec_control & CPU_BASED_CR8_LOAD_EXITING) &&
>>>> +				(exec_control & CPU_BASED_CR8_STORE_EXITING)))
>>>> +			nested_vmx_failValid(vcpu,
>>>> VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>>> 
>>> I think this is not correct. The vmx->nested.virtual_apic_page may not
>>> valid due to two reasons: 1. The virtual_apic_page_addr is not a valid
>>> gfn. In this case, the vmx failure
>> must be injected to L1 unconditionally regardless of the setting of
>> CR8 load/store exiting.
>> 
>> You're right that accesses to the APIC-access page may also end up
>> writing to the virtual-APIC page.  Hence, if the "virtualize APIC
>> accesses" setting is 1 in the secondary exec controls, you also have to fail the vmentry.
>> 
>> Doing it unconditionally is not correct, but it is the simplest thing
>
>Why not correct?

What's your opinion?

>
>> to do and it would be okay with a comment, I think.
>> 
>>> 2. The virtual_apic_page is swapped by L0. In this case, we should
>>> not inject
>> failure to L1.
>> 
>> This cannot happen, nested_get_page ends up calling hva_to_pfn with
>> atomic==false, so the page would be swapped in and pinned.
>> 
>>>> +
>>>> +		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
>>>> +	}
>>> 
>>> Miss else here:
>>> If L2 owns the APIC and doesn't use TPR_SHADOW, we need to setup the
>>> vmcs02 based on vmcs01. For example, if vmcs01 is using TPR_SHADOW,
>>> then
>>> vmcs02 must set it. Also, we need to use vmcs01's virtual_apic_page
>>> and TPR_THRESHOLD for vmcs02.
>> 
>> What do you mean by "owns the APIC"?
>
>Means if L2 touch L1's APIC directly, for example, if L2 not using TPR_SHADOW, then move to/from CR8 will touch L1's TPR directly. And in this case, L0 should aware of L1's TRP change.
>

Ditto.

Regards,
Wanpeng Li 

>> 
>> Paolo
>
>
>Best regards,
>Yang
>
