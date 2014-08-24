Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaHXET4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 00:19:56 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50919 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaHXETz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 00:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <CA+U0gVjxF+o3xHPULUQ26wJs4myW3gxUODnUJ3xaYVT6-mFYdg@mail.gmail.com>
References: <CA+U0gVjxF+o3xHPULUQ26wJs4myW3gxUODnUJ3xaYVT6-mFYdg@mail.gmail.com>
From: Dennis Chen <kernel.org.gnu@gmail.com>
Date: Sun, 24 Aug 2014 12:19:34 +0800
Message-ID: <CA+U0gVj=zD1MOJ9O5aA3LwkM_550x3pOkM8ek5mba_LqoMiScA@mail.gmail.com>
Subject: Re: [PATCH] KVM-Use value reading from MSR when construct the eptp in
 VMX mode
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, pbonzini@redhat.com, gleb@kernel.org,
        "wanpeng.li" <wanpeng.li@linux.intel.com>,
        Dennis Chen <kernel.org.gnu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing Avi  and Paolo...

Avi/Paolo, any comments?    --Den

On Sun, Aug 24, 2014 at 11:54 AM, Dennis Chen <kernel.org.gnu@gmail.com> wrote:
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
