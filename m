Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaHTHCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:02:52 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:49569 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaHTHCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:02:50 -0400
Message-ID: <53F44815.9020309@redhat.com>
Date: Wed, 20 Aug 2014 09:02:45 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 7/9] KVM: VMX: abstract ple_window modifiers
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com> <1408480536-8240-8-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-8-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2014 22:35, Radim Krčmář ha scritto:
> They were almost identical and thus merged with a loathable macro.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  This solution is hopefully more acceptable than function pointers.

I think a little amount of duplication is not a problem.

Paolo

>  arch/x86/kvm/vmx.c | 53 +++++++++++++++++++----------------------------------
>  1 file changed, 19 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index a236a9f..c6cfb71 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5694,42 +5694,27 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  out:
>  	return ret;
>  }
> -
> -static void grow_ple_window(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	int old = vmx->ple_window;
> -	int new;
> -
> -	if (ple_window_grow < 1)
> -		new = ple_window;
> -	else if (ple_window_grow < ple_window)
> -		new = old * ple_window_grow;
> -	else
> -		new = old + ple_window_grow;
> -
> -	vmx->ple_window = min(new, ple_window_max);
> -
> -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> +#define make_ple_window_modifier(type, oplt, opge, cmp, bound) \
> +static void type##_ple_window(struct kvm_vcpu *vcpu) \
> +{ \
> +	struct vcpu_vmx *vmx = to_vmx(vcpu); \
> +	int old = vmx->ple_window; \
> +	int new; \
> +\
> +	if (ple_window_##type < 1) \
> +		new = ple_window; \
> +	else if (ple_window_##type < ple_window) \
> +		new = old oplt ple_window_##type; \
> +	else \
> +		new = old opge ple_window_##type; \
> +\
> +	vmx->ple_window = cmp(new, bound); \
> +\
> +	trace_kvm_ple_window_##type(vcpu->vcpu_id, vmx->ple_window, old); \
>  }
>  
> -static void shrink_ple_window(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	int old = vmx->ple_window;
> -	int new;
> -
> -	if (ple_window_shrink < 1)
> -		new = ple_window;
> -	else if (ple_window_shrink < ple_window)
> -		new = old / ple_window_shrink;
> -	else
> -		new = old - ple_window_shrink;
> -
> -	vmx->ple_window = max(new, ple_window);
> -
> -	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
> -}
> +make_ple_window_modifier(grow,   *, +, min, ple_window_max)
> +make_ple_window_modifier(shrink, /, -, max, ple_window)
>  
>  /*
>   * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
> 

