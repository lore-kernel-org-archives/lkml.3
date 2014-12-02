Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbaLBNAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:00:32 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:52374 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105AbaLBNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:00:29 -0500
Message-ID: <547DB7E8.8030601@redhat.com>
Date: Tue, 02 Dec 2014 14:00:24 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] kvm: vmx: enable xsaves for kvm
References: <1417518900-42446-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1417518900-42446-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/12/2014 12:14, Wanpeng Li wrote:
> This patchset is to enable xsaves for kvm part, the patch for 
> qemu part will be sent out later. 
> 
> The patchset is tested on skylake-client.
> 
> v2 -> v3:
>  * add kvm_get/set for ia32_xss
>  * fix the type XSS_EXIT_BITMAP
>  * load host_xss just once in setup_vmcs_config
>  * add/clear atuo switch ia32_xss msr in kvm_get/clear
>  * add VMX_XSS_EXIT_BITMAP macro
>  * add WARN() in handle_xsaves/xrstors
>  * export xsaves if related vmcs field is set 
> 
> v1 -> v2: 
>  * auto switch ia32_xss msr just if this msr is present 
> 
> Wanpeng Li (3):
>   kvm: x86: Intel XSAVES vmx and msr handle
>   kvm: vmx: add kvm_get/set logic to xsaves
>   kvm: x86: Enable Intel XSAVES for guest
> 
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/include/asm/vmx.h      |  3 +++
>  arch/x86/include/uapi/asm/vmx.h |  6 ++++-
>  arch/x86/kvm/cpuid.c            |  3 ++-
>  arch/x86/kvm/vmx.c              | 51 ++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 62 insertions(+), 3 deletions(-)
> 

We need to return false from an svm_xsaves_supported function too, and 
we need to prevent setting MSR_IA32_XSS to any non-zero value because 
we do not support getting/setting a guest's Trace Packet Configuration 
State.

I will squash this hunk in, and send a new patch to return zero for
CPUID(0xd,i).ECX and CPUID(0xd,i).EDX.

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 66d1e3d0195e..6e3a4486749c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2671,6 +2671,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_XSS:
 		if (!vmx_xsaves_supported())
 			return 1;
+		/* The only supported bit as of Skylake is bit 8, but
+		 * it is not supported on KVM.
+		 */
+		if (data != 0)
+			return 1;
 		vcpu->arch.ia32_xss = data;
 		if (vcpu->arch.ia32_xss != host_xss)
 			add_atomic_switch_msr(vmx, MSR_IA32_XSS,

Paolo
