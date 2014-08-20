Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHTHSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:18:13 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:37597 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHTHSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:18:11 -0400
Message-ID: <53F44BAE.9040405@redhat.com>
Date: Wed, 20 Aug 2014 09:18:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 5/9] KVM: VMX: clamp PLE window
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com> <1408480536-8240-6-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-6-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2014 22:35, Radim Krčmář ha scritto:
> Modifications could get unwanted values of PLE window. (low or negative)
> Use ple_window and the maximal value that cannot overflow as bounds.
> 
> ple_window_max defaults to a very high value, but it would make sense to
> set it to some fraction of the scheduler tick.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  arch/x86/kvm/vmx.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 66259fd..e1192fb 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -144,6 +144,10 @@ module_param(ple_window_grow, int, S_IRUGO);
>  static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
>  module_param(ple_window_shrink, int, S_IRUGO);
>  
> +/* Default is to compute the maximum so we can never overflow. */
> +static int ple_window_max = INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
> +module_param(ple_window_max, int, S_IRUGO);
> +
>  extern const ulong vmx_return;
>  
>  #define NR_AUTOLOAD_MSRS 8
> @@ -5704,7 +5708,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
>  	else
>  		new = old + ple_window_grow;
>  
> -	vmx->ple_window = new;
> +	vmx->ple_window = min(new, ple_window_max);
>  }

Please introduce a dynamic overflow-avoiding ple_window_max (like what
you have in patch 9) already in patch 4...

>  static void shrink_ple_window(struct kvm_vcpu *vcpu)
> @@ -5720,7 +5724,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  	else
>  		new = old - ple_window_shrink;
>  
> -	vmx->ple_window = new;
> +	vmx->ple_window = max(new, ple_window);

... and also squash this in patch 4.

This patch can then introduce the ple_window_max module parameter (using
module_param_cb to avoid overflows).

Paolo

>  }
>  
>  /*
> 

