Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaHUI0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:26:05 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39657 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbaHUI0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:26:01 -0400
Message-ID: <53F5AD14.9050405@redhat.com>
Date: Thu, 21 Aug 2014 10:25:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 3/6] KVM: VMX: make PLE window per-VCPU
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com> <1408567997-21222-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408567997-21222-4-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> Change PLE window into per-VCPU variable, seeded from module parameter,
> to allow greater flexibility.
> 
> Brings in a small overhead on every vmentry.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  arch/x86/kvm/vmx.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 2b306f9..18e0e52 100644
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
> @@ -4402,7 +4405,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
>  
>  	if (ple_gap) {
>  		vmcs_write32(PLE_GAP, ple_gap);
> -		vmcs_write32(PLE_WINDOW, ple_window);
> +		vmx->ple_window = ple_window;
>  	}
>  
>  	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
> @@ -7387,6 +7390,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vmx->emulation_required)
>  		return;
>  
> +	if (ple_gap)
> +		vmcs_write32(PLE_WINDOW, vmx->ple_window);

Maybe we can add a ple_window_dirty field?  It can be tested instead of
ple_gap to avoid the vmwrite in the common case?

Paolo

>  	if (vmx->nested.sync_shadow_vmcs) {
>  		copy_vmcs12_to_shadow(vmx);
>  		vmx->nested.sync_shadow_vmcs = false;
> 

