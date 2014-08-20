Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaHTG5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:57:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:63407 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaHTG5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:57:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,900,1400050800"; 
   d="scan'208";a="587311651"
Date: Wed, 20 Aug 2014 14:59:14 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: nVMX: nested TPR shadow/threshold emulation
Message-ID: <20140820065914.GA11546@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408437040-49181-1-git-send-email-wanpeng.li@linux.intel.com>
 <53F30C0C.9040601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F30C0C.9040601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Tue, Aug 19, 2014 at 10:34:20AM +0200, Paolo Bonzini wrote:
>Il 19/08/2014 10:30, Wanpeng Li ha scritto:
>> +		if (vmx->nested.virtual_apic_page)
>> +			nested_release_page(vmx->nested.virtual_apic_page);
>> +		vmx->nested.virtual_apic_page =
>> +		   nested_get_page(vcpu, vmcs12->virtual_apic_page_addr);
>> +		if (!vmx->nested.virtual_apic_page)
>> +			exec_control &=
>> +				~CPU_BASED_TPR_SHADOW;
>> +		else
>> +			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>> +				page_to_phys(vmx->nested.virtual_apic_page));
>> +
>> +		/*
>> +		 * If CR8 load exits are enabled, CR8 store exits are enabled,
>> +		 * and virtualize APIC access is disabled, the processor would
>> +		 * never notice. Doing it unconditionally is not correct, but
>> +		 * it is the simplest thing.
>> +		 */
>> +		if (!(exec_control & CPU_BASED_TPR_SHADOW) &&
>> +			!((exec_control & CPU_BASED_CR8_LOAD_EXITING) &&
>> +				(exec_control & CPU_BASED_CR8_STORE_EXITING)))
>> +			nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>> +
>
>You aren't checking "virtualize APIC access" here, but the comment
>mentions it.
>
>As the comment says, failing the entry unconditionally could be the
>simplest thing, which means moving the nested_vmx_failValid call inside
>the "if (!vmx->nested.virtual_apic_page)".
>
>If you want to check all of CR8_LOAD/CR8_STORE/VIRTUALIZE_APIC_ACCESS,
>please mention in the comment that failing the vm entry is _not_ what
>the processor does but it's basically the only possibility we have.  In
>that case, I would also place the "if" within the "if
>(!vmx->nested.virtual_apic_page)": it also simplifies the condition
>because you don't have to check CPU_BASED_TPR_SHADOW anymore.
>
>You can send v5 with these changes, and I'll apply it for 3.18.  Thanks!
>

Do you mean this? 

+	/*
+	 * Failing the vm entry is _not_ what the processor does
+	 * but it's basically the only possibility we have.
+	 */
+	if (!vmx->nested.virtual_apic_page)
+		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);

Regards,
Wanpeng Li 

>Paolo
