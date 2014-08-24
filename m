Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaHXJiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 05:38:08 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65245 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaHXJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 05:38:05 -0400
Date: Sun, 24 Aug 2014 12:38:00 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Dennis Chen <kernel.org.gnu@gmail.com>
Cc: linux-kernel@vger.kernel.org, avi@qumranet.com, yaniv@qumranet.com,
        wanpeng.li@linux.intel.com
Subject: Re: [PATCH] KVM-Use value reading from MSR when construct the eptp
 in VMX mode
Message-ID: <20140824093759.GG18167@minantech.com>
References: <CA+U0gVjxF+o3xHPULUQ26wJs4myW3gxUODnUJ3xaYVT6-mFYdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+U0gVjxF+o3xHPULUQ26wJs4myW3gxUODnUJ3xaYVT6-mFYdg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 11:54:32AM +0800, Dennis Chen wrote:
> This patch is used to construct the eptp in vmx mode with values
> readed from MSR according to the intel x86 software developer's
> manual.
> 
> Signed-off-by: Dennis Chen <kernel.org.gnu@gmail.com>
> ---
>  arch/x86/include/asm/vmx.h |    1 +
>  arch/x86/kvm/vmx.c         |   21 +++++++++++++++++----
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index bcbfade..bf82a77 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -417,6 +417,7 @@ enum vmcs_field {
>  #define VMX_EPT_GAW_EPTP_SHIFT            3
>  #define VMX_EPT_AD_ENABLE_BIT            (1ull << 6)
>  #define VMX_EPT_DEFAULT_MT            0x6ull
> +#define VMX_EPT_UC_MT                0x0ull
>  #define VMX_EPT_READABLE_MASK            0x1ull
>  #define VMX_EPT_WRITABLE_MASK            0x2ull
>  #define VMX_EPT_EXECUTABLE_MASK            0x4ull
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index bfe11cf..7add5ce 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -3477,11 +3477,24 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu,
> unsigned long cr0)
> 
>  static u64 construct_eptp(unsigned long root_hpa)
>  {
> -    u64 eptp;
> +    u64 eptp, pwl;
> +
> +    if (cpu_has_vmx_ept_4levels())
> +        pwl = VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT;
> +    else {
> +        WARN(1, "Unsupported page-walk length of 4.\n");
Page-walk length of 4 is the only one that is supported.

> +        BUG();
> +    }
> +
> +    if (cpu_has_vmx_eptp_writeback())
> +        eptp = VMX_EPT_DEFAULT_MT | pwl;
> +    else if (cpu_has_vmx_eptp_uncacheable())
> +        eptp = VMX_EPT_UC_MT | pwl;
> +    else {
> +        WARN(1, "Unsupported memory type config in vmx eptp.\n");
> +        BUG();
> +    }
> 
> -    /* TODO write the value reading from MSR */
> -    eptp = VMX_EPT_DEFAULT_MT |
> -        VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT;
>      if (enable_ept_ad_bits)
>          eptp |= VMX_EPT_AD_ENABLE_BIT;
>      eptp |= (root_hpa & PAGE_MASK);
> -- 
> 1.7.9.5

--
			Gleb.
