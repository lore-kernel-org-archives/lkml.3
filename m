Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaHTHN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:13:56 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37997 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHTHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:13:54 -0400
Message-ID: <53F44AAD.5020203@redhat.com>
Date: Wed, 20 Aug 2014 09:13:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 3/9] KVM: VMX: make PLE window per-vcpu
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com> <1408480536-8240-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-4-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2014 22:35, Radim Krčmář ha scritto:
> Change PLE window into per-vcpu variable, seeded from module parameter,
> to allow greater flexibility.
> 
> Brings in a small overhead on every vmentry.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  I've been thinking about a general hierarchical per-vcpu variable model,
>  but it's hard to have current performance and sane code.
> 
>  arch/x86/kvm/vmx.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 2b306f9..eaa5574 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -484,6 +484,9 @@ struct vcpu_vmx {
>  
>  	/* Support for a guest hypervisor (nested VMX) */
>  	struct nested_vmx nested;
> +
> +	/* Dynamic PLE window. */
> +	int ple_window;
>  };
>  
>  enum segment_cache_field {
> @@ -4403,6 +4406,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
>  	if (ple_gap) {
>  		vmcs_write32(PLE_GAP, ple_gap);
>  		vmcs_write32(PLE_WINDOW, ple_window);

Is this necessary?

> +		vmx->ple_window = ple_window;
>  	}
>  
>  	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
> @@ -7387,6 +7391,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vmx->emulation_required)
>  		return;
>  
> +	if (ple_gap)
> +		vmcs_write32(PLE_WINDOW, vmx->ple_window);
> +
>  	if (vmx->nested.sync_shadow_vmcs) {
>  		copy_vmcs12_to_shadow(vmx);
>  		vmx->nested.sync_shadow_vmcs = false;
> 

