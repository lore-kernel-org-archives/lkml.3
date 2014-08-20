Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaHTHmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:42:54 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58609 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHTHmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:42:53 -0400
Message-ID: <53F45177.9000706@redhat.com>
Date: Wed, 20 Aug 2014 09:42:47 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: nVMX: nested TPR shadow/threshold emulation
References: <1408437040-49181-1-git-send-email-wanpeng.li@linux.intel.com> <53F30C0C.9040601@redhat.com> <20140820065914.GA11546@kernel>
In-Reply-To: <20140820065914.GA11546@kernel>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 08:59, Wanpeng Li ha scritto:
> 
> +	/*
> +	 * Failing the vm entry is _not_ what the processor does
> +	 * but it's basically the only possibility we have.

	 * We could still enter the guest if CR8 load exits are 
	 * enabled, CR8 store exits are enabled, and virtualize APIC
	 * access is disabled; in this case the processor would never
	 * use the TPR shadow and we could simply clear the bit from
	 * the execution control.  But such a configuration is useless,
	 * so let's keep the code simple.

> +	 */
> +	if (!vmx->nested.virtual_apic_page)
> +		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);

I thought so, but I'm afraid it's too late to do nested_vmx_failValid 
here.

Without a test case, I'd be more confident if you moved the 
nested_release_page/nested_get_page to a separate function, that 
nested_vmx_run calls before enter_guest_mode.  The same function can 
map apic_access_page too, for cleanliness.  Something like this:

         if (cpu_has_secondary_exec_ctrls() &&
             nested_cpu_has(vmcs12,
                            CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
             (vmcs12->secondary_vm_exec_control &
              SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
                        if (vmx->nested.apic_access_page) /* shouldn't happen */
                                nested_release_page(vmx->nested.apic_access_page);
                        vmx->nested.apic_access_page =
                                nested_get_page(vcpu, vmcs12->apic_access_addr);
         }
        if (...) {
	         /* do the same for virtual_apic_page if CPU_BASED_TPR_SHADOW
	            is set... */

		/*
		 * Failing the vm entry is _not_ what the processor does
		 * but it's basically the only possibility we have.
		 * We could still enter the guest if CR8 load exits are 
		 * enabled, CR8 store exits are enabled, and virtualize APIC
		 * access is disabled; in this case the processor would never
		 * use the TPR shadow and we could simply clear the bit from
		 * the execution control.  But such a configuration is useless,
		 * so let's keep the code simple.
		 */
		if (!vmx->nested.virtual_apic_page)
			return -EFAULT;
	}

	return 0;

...

Then nested_vmx_run can do the nested_vmx_failValid if the function returns
an error.

Paolo
