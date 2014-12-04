Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaLDN4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:56:04 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54158 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaLDN4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:56:03 -0500
Message-ID: <548067ED.2020309@redhat.com>
Date: Thu, 04 Dec 2014 14:55:57 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] kvm: cpuid: fix the size of xsaves area
References: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com> <1417681468-7165-2-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1417681468-7165-2-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/12/2014 09:24, Wanpeng Li wrote:
> The section of CPUID(EAX=0xd, ECX=1) in the spec which commit 
> f5c2290cd01e (KVM: cpuid: mask more bits in leaf 0xd and subleaves)
> mentioned is older than SDM. 
> 
> EBX: Bits 31-00: The size in bytes of the XSAVE area containing all 
> states enabled by XCR0|IA32_XSS.
> 
> The the value of EBX should represent the size of XCR0 related XSAVE 
> area since IA32_XSS is not used currently.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 646e6e8..70f0fa1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -477,7 +477,10 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			do_cpuid_1_ent(&entry[i], function, idx);
>  			if (idx == 1) {
>  				entry[i].eax &= kvm_supported_word10_x86_features;
> -				entry[i].ebx = 0;
> +				if (entry[i].eax & F(XSAVES))
> +					entry[i].ebx = xstate_required_size(supported, true);
> +				else
> +					entry[i].ebx = xstate_required_size(supported, false);

On machines without XSAVES, this value is zero though.

Paolo

>  			} else {
>  				if (entry[i].eax == 0 || !(supported & mask))
>  					continue;
> 
