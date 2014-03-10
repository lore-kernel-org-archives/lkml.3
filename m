Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaCJIyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:54:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaCJIyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:54:03 -0400
Message-ID: <531D7DA5.4020002@redhat.com>
Date: Mon, 10 Mar 2014 09:53:57 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] KVM: x86: Work around buggy MPX platform
References: <DE8DF0795D48FD4CA783C40EC82923350155757D@SHSMSX152.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350155757D@SHSMSX152.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/03/2014 09:48, Liu, Jinsong ha scritto:
> From 5854070994c5002b3a37577165ed3e82f36f712d Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Sat, 8 Mar 2014 04:40:02 +0800
> Subject: [PATCH] KVM: x86: Work around buggy MPX platform
>
> Work around buggy MPX platform which support MSR_IA32_BNDCFGS
> but has issue at, say, VMX ucode.
>
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/kvm/x86.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1e91a24..1fc184d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3936,6 +3936,16 @@ static void kvm_init_msr_list(void)
>  	for (i = j = KVM_SAVE_MSRS_BEGIN; i < ARRAY_SIZE(msrs_to_save); i++) {
>  		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
>  			continue;
> +
> +		/*
> +		 * Work around some buggy MPX platform which support
> +		 * MSR_IA32_BNDCFGS but has issue at, say, VMX ucode.
> +		 */
> +		if ((msrs_to_save[i] == MSR_IA32_BNDCFGS) &&

Too many parentheses in this "if".


> +			(kvm_x86_ops->mpx_supported   ?
> +			!kvm_x86_ops->mpx_supported() : 1))

Better: "!kvm_x86_ops->mpx_supported || !kvm_x86_ops->mpx_supported()" 
but I'm leaning towards adding an implementation of mpx_supported to SVM 
too (it will always return false).

> +				continue;
> +
>  		if (j < i)
>  			msrs_to_save[j] = msrs_to_save[i];
>  		j++;
> @@ -5576,9 +5586,11 @@ int kvm_arch_init(void *opaque)
>  		goto out_free_percpu;
>
>  	kvm_set_mmio_spte_mask();
> -	kvm_init_msr_list();
>
>  	kvm_x86_ops = ops;
> +
> +	kvm_init_msr_list();
> +
>  	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
>  			PT_DIRTY_MASK, PT64_NX_MASK, 0);
>
>

Thanks Liu.  Indeed I could not reproduce Robert's issue, though it 
might be possible to get it with nested virtualization.  I'll send a 
similar patch that I was testing.

Paolo
