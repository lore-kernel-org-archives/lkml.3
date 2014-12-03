Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658AbaLCAaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:30:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:61807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933438AbaLCAaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:30:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,504,1413270000"; 
   d="scan'208";a="631705007"
Date: Wed, 3 Dec 2014 08:09:55 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] kvm: vmx: enable xsaves for kvm
Message-ID: <20141203000955.GA4266@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1417518900-42446-1-git-send-email-wanpeng.li@linux.intel.com>
 <547DB7E8.8030601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547DB7E8.8030601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 02:00:24PM +0100, Paolo Bonzini wrote:
>
>
>On 02/12/2014 12:14, Wanpeng Li wrote:
>> This patchset is to enable xsaves for kvm part, the patch for 
>> qemu part will be sent out later. 
>> 
>> The patchset is tested on skylake-client.
>> 
>> v2 -> v3:
>>  * add kvm_get/set for ia32_xss
>>  * fix the type XSS_EXIT_BITMAP
>>  * load host_xss just once in setup_vmcs_config
>>  * add/clear atuo switch ia32_xss msr in kvm_get/clear
>>  * add VMX_XSS_EXIT_BITMAP macro
>>  * add WARN() in handle_xsaves/xrstors
>>  * export xsaves if related vmcs field is set 
>> 
>> v1 -> v2: 
>>  * auto switch ia32_xss msr just if this msr is present 
>> 
>> Wanpeng Li (3):
>>   kvm: x86: Intel XSAVES vmx and msr handle
>>   kvm: vmx: add kvm_get/set logic to xsaves
>>   kvm: x86: Enable Intel XSAVES for guest
>> 
>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>  arch/x86/include/asm/vmx.h      |  3 +++
>>  arch/x86/include/uapi/asm/vmx.h |  6 ++++-
>>  arch/x86/kvm/cpuid.c            |  3 ++-
>>  arch/x86/kvm/vmx.c              | 51 ++++++++++++++++++++++++++++++++++++++++-
>>  5 files changed, 62 insertions(+), 3 deletions(-)
>> 
>
>We need to return false from an svm_xsaves_supported function too, and 
>we need to prevent setting MSR_IA32_XSS to any non-zero value because 
>we do not support getting/setting a guest's Trace Packet Configuration 
>State.
>

Agreed, I will fix them in next version.

>I will squash this hunk in, and send a new patch to return zero for
>CPUID(0xd,i).ECX and CPUID(0xd,i).EDX.

Cool, I will test it.

Regards,
Wanpeng Li 

>
>diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>index 66d1e3d0195e..6e3a4486749c 100644
>--- a/arch/x86/kvm/vmx.c
>+++ b/arch/x86/kvm/vmx.c
>@@ -2671,6 +2671,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 	case MSR_IA32_XSS:
> 		if (!vmx_xsaves_supported())
> 			return 1;
>+		/* The only supported bit as of Skylake is bit 8, but
>+		 * it is not supported on KVM.
>+		 */
>+		if (data != 0)
>+			return 1;
> 		vcpu->arch.ia32_xss = data;
> 		if (vcpu->arch.ia32_xss != host_xss)
> 			add_atomic_switch_msr(vmx, MSR_IA32_XSS,
>
>Paolo
