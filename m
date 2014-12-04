Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaLDNPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:15:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbaLDNPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:15:01 -0500
Date: Thu, 4 Dec 2014 14:14:55 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] kvm: cpuid: fix the size of xsaves area
Message-ID: <20141204131454.GA17050@potion.brq.redhat.com>
References: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
 <1417691470-5221-2-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417691470-5221-2-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 19:11+0800, Wanpeng Li:
> The section of CPUID(EAX=0xd, ECX=1) in the spec which commit
> f5c2290cd01e (KVM: cpuid: mask more bits in leaf 0xd and subleaves)
> mentioned is older than SDM.
> 
> EBX: Bits 31-00: The size in bytes of the XSAVE area containing all
> states enabled by XCR0|IA32_XSS.

Well, CPUs without XSAVES return 0 there, so we would emulate them
incorrectly ... (I don't mind much, it is reserved.)

> The the value of EBX should represent the size of XCR0 related XSAVE
> area since IA32_XSS is not used currently.

True, but 'supported' is not the state of XCR0, just its supremum.
EBX should be set in kvm_update_cpuid(), like [3/4] does.
(We can safely drop [2/4].)

> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
> v1 -> v2:
>  * add F(XSAVEC) check
> 
>  arch/x86/kvm/cpuid.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 646e6e8..5b78e9b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -477,7 +477,10 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			do_cpuid_1_ent(&entry[i], function, idx);
>  			if (idx == 1) {
>  				entry[i].eax &= kvm_supported_word10_x86_features;
> -				entry[i].ebx = 0;
> +				if (entry[i].eax & (F(XSAVES) | F(XSAVEC)))
> +					entry[i].ebx = xstate_required_size(supported, true);
> +				else
> +					entry[i].ebx = xstate_required_size(supported, false);
>  			} else {
>  				if (entry[i].eax == 0 || !(supported & mask))
>  					continue;
> -- 
> 1.9.1
> 
