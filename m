Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbaLBXFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:05:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaLBXFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:05:45 -0500
Date: Wed, 3 Dec 2014 00:05:37 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH] KVM: cpuid: mask more bits in leaf 0xd and subleaves
Message-ID: <20141202230536.GA12980@potion.redhat.com>
References: <1417525770-16485-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417525770-16485-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-02 14:09+0100, Paolo Bonzini:
> - EAX=0Dh, ECX=1: output registers EBX/ECX/EDX are reserved.

(As good as reserved without XSAVES/IA32_XSS.)

> - EAX=0Dh, ECX>1: output register ECX is zero for all the CPUID leaves
> we support, because variable "supported" comes from XCR0 and not XSS.
> However, only bits above 0 are reserved.  Output register EDX is reserved.

(Yes.  Well, EDX is 0 when the sub-leaf is invalid.)

> Source: Intel Architecture Instruction Set Extensions Programming
> Reference, ref. number 319433-022
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> --
>  arch/x86/kvm/cpuid.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0d919bc33b02..b1366743a728 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -470,10 +470,17 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  				goto out;
>  
>  			do_cpuid_1_ent(&entry[i], function, idx);
> -			if (idx == 1)
> +			if (idx == 1) {
>  				entry[i].eax &= kvm_supported_word10_x86_features;
> -			else if (entry[i].eax == 0 || !(supported & mask))
> -				continue;
> +				entry[i].ebx = 0;
> +				entry[i].ecx = 0;
> +			} else {
> +				if (entry[i].eax == 0 || !(supported & mask))
> +					continue;
> +				WARN_ON_ONCE(entry[i].ecx & 1);
> +				entry[i].ecx &= 1;

 ECX  Bit 0 is set if the sub-leaf index, n, maps to a valid bit in the
      IA32_XSS MSR and bit 0 is clear if n maps to a valid bit in XCR0.

ECX should be set to 0 instead, we definitely don't map to a valid bit
in IA32_XSS now.
(Having only one part of cpuid ready for it is weird ...)

> +			}
> +			entry[i].edx = 0;
>  			entry[i].flags |=
>  			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;

(Unrelated, I have yet to understand how this flag translates
 * If ECX contains an invalid sub-leaf index, EAX/EBX/ECX/EDX return 0.)

>  			++*nent;

Forcing a change of the XSAVES implementation is a likely purpose of
this patch and it is correct after changing the ecx handling, so then,

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
