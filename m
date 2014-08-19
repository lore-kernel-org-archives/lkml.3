Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaHSIeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaHSIed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:34:33 -0400
Message-ID: <53F30C0C.9040601@redhat.com>
Date: Tue, 19 Aug 2014 10:34:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: nVMX: nested TPR shadow/threshold emulation
References: <1408437040-49181-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1408437040-49181-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2014 10:30, Wanpeng Li ha scritto:
> +		if (vmx->nested.virtual_apic_page)
> +			nested_release_page(vmx->nested.virtual_apic_page);
> +		vmx->nested.virtual_apic_page =
> +		   nested_get_page(vcpu, vmcs12->virtual_apic_page_addr);
> +		if (!vmx->nested.virtual_apic_page)
> +			exec_control &=
> +				~CPU_BASED_TPR_SHADOW;
> +		else
> +			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
> +				page_to_phys(vmx->nested.virtual_apic_page));
> +
> +		/*
> +		 * If CR8 load exits are enabled, CR8 store exits are enabled,
> +		 * and virtualize APIC access is disabled, the processor would
> +		 * never notice. Doing it unconditionally is not correct, but
> +		 * it is the simplest thing.
> +		 */
> +		if (!(exec_control & CPU_BASED_TPR_SHADOW) &&
> +			!((exec_control & CPU_BASED_CR8_LOAD_EXITING) &&
> +				(exec_control & CPU_BASED_CR8_STORE_EXITING)))
> +			nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> +

You aren't checking "virtualize APIC access" here, but the comment
mentions it.

As the comment says, failing the entry unconditionally could be the
simplest thing, which means moving the nested_vmx_failValid call inside
the "if (!vmx->nested.virtual_apic_page)".

If you want to check all of CR8_LOAD/CR8_STORE/VIRTUALIZE_APIC_ACCESS,
please mention in the comment that failing the vm entry is _not_ what
the processor does but it's basically the only possibility we have.  In
that case, I would also place the "if" within the "if
(!vmx->nested.virtual_apic_page)": it also simplifies the condition
because you don't have to check CPU_BASED_TPR_SHADOW anymore.

You can send v5 with these changes, and I'll apply it for 3.18.  Thanks!

Paolo
