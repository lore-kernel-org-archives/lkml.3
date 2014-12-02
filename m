Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaLBIzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:55:18 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54556 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLBIzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:55:15 -0500
Message-ID: <547D7E6D.6090000@redhat.com>
Date: Tue, 02 Dec 2014 09:55:09 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kvm: x86: revert mask out xsaves
References: <1417500894-7604-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1417500894-7604-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/12/2014 07:14, Wanpeng Li wrote:
> xsaves will be exported to guest in the next patch, so revert the
> mask out xsaves patch.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a4f5ac4..7af07571 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -320,10 +320,6 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  		F(ADX) | F(SMAP) | F(AVX512F) | F(AVX512PF) | F(AVX512ER) |
>  		F(AVX512CD);
>  
> -	/* cpuid 0xD.1.eax */
> -	const u32 kvm_supported_word10_x86_features =
> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);

Every single bit needs to be whitelisted independently of the others, so
a full revert is not possible.  We need to be careful about post-Skylake
processors introducing new bits in this cpuid leaf.

Also, you cannot just add F(XSAVES) here; you must only do it if XSAVES
is actually supported.  This makes sure that nested virtualization will
_not_ present XSAVES to the guests until specific support is introduced
for XSAVES and XRSTORS exits (including the XSS exit bitmap).

In order to do this, you have to introduce a new member in kvm_x86_ops,
modeling what was done for MPX.  The second patch can then implement
this new member.

Thanks,

Paolo

>  	/* all calls to cpuid_count() should be made on the same cpu */
>  	get_cpu();
>  
> @@ -460,8 +456,6 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  		entry->eax &= supported;
>  		entry->edx &= supported >> 32;
>  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> -		if (!supported)
> -			break;
>  
>  		for (idx = 1, i = 1; idx < 64; ++idx) {
>  			u64 mask = ((u64)1 << idx);
> @@ -469,9 +463,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  				goto out;
>  
>  			do_cpuid_1_ent(&entry[i], function, idx);
> -			if (idx == 1)
> -				entry[i].eax &= kvm_supported_word10_x86_features;
> -			else if (entry[i].eax == 0 || !(supported & mask))
> +			if (entry[i].eax == 0 || !(supported & mask))
>  				continue;
>  			entry[i].flags |=
>  			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> 
