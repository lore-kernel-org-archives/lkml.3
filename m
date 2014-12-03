Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaLCMdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:33:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaLCMdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:33:37 -0500
Date: Wed, 3 Dec 2014 13:33:32 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] kvm: x86: Enable Intel XSAVES for guest
Message-ID: <20141203123331.GA26699@potion.brq.redhat.com>
References: <1417519290-44063-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417519290-44063-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-02 19:21+0800, Wanpeng Li:
> Exporse intel xsaves feature to guest.

0xD.1:ebx ought to be non-zero with XSAVES, even if IA32_XSS is known to
be 0, so we'll need to set it after Paolo's patch.

> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a4f5ac4..0d919bc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -267,6 +267,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
>  	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
>  	unsigned f_mpx = kvm_x86_ops->mpx_supported() ? F(MPX) : 0;
> +	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
>  
>  	/* cpuid 1.edx */
>  	const u32 kvm_supported_word0_x86_features =
> @@ -322,7 +323,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  
>  	/* cpuid 0xD.1.eax */
>  	const u32 kvm_supported_word10_x86_features =
> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
> +		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
>  
>  	/* all calls to cpuid_count() should be made on the same cpu */
>  	get_cpu();
> -- 
> 1.9.1

--- rant ---
The documentation isn't clearly backward-compatible, it took me a while
to understand why

  EBX  Bits 31-00: The size in bytes of the XSAVE area containing all
       states enabled by XCRO | IA32_XSS.

Is 0 on my old machine.

Different section gives a better hint by mentioning XSAVES directly
 * EBX enumerates the size (in bytes) required by the XSAVES
   instruction for an XSAVE area containing all the state components
   corresponding to bits currently set in XCR0 | IA32_XSS.
