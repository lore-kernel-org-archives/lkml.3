Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKKUGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:06:46 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53038 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKUGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:06:45 -0500
Message-ID: <54626C51.6080401@amacapital.net>
Date: Tue, 11 Nov 2014 12:06:41 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/8] x86: Make old K8 swapgs workaround conditional
References: <1415663739-25525-1-git-send-email-andi@firstfloor.org> <1415663739-25525-5-git-send-email-andi@firstfloor.org>
In-Reply-To: <1415663739-25525-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 03:55 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Every gs selector/index reload always paid an extra MFENCE
> between the two SWAPGS. This was to work around an old
> bug in early K8 steppings.  All other CPUs don't need the extra
> mfence. Patch the extra MFENCE only in for K8.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h |  1 +
>  arch/x86/kernel/cpu/amd.c         |  3 +++
>  arch/x86/kernel/entry_64.S        | 10 +++++++++-
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 0bb1335..85b3f1f 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -106,6 +106,7 @@
>  #define X86_FEATURE_APERFMPERF	( 3*32+28) /* APERFMPERF */
>  #define X86_FEATURE_EAGER_FPU	( 3*32+29) /* "eagerfpu" Non lazy FPU restore */
>  #define X86_FEATURE_NONSTOP_TSC_S3 ( 3*32+30) /* TSC doesn't stop in S3 state */
> +#define X86_FEATURE_SWAPGS_MFENCE (3*32+31) /* SWAPGS may need MFENCE */
> 

Can this use the new X86_BUG thing?

--Andy


>  /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
>  #define X86_FEATURE_XMM3	( 4*32+ 0) /* "pni" SSE-3 */
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 813d29d..1553184 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -551,6 +551,9 @@ static void init_amd_k8(struct cpuinfo_x86 *c)
>  	if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>  		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
>  
> +	/* Early steppings needed a mfence on swapgs. */
> +	set_cpu_cap(c, X86_FEATURE_SWAPGS_MFENCE);
> +
>  	/*
>  	 * Some BIOSes incorrectly force this feature, but only K8 revision D
>  	 * (model = 0x14) and later actually support it.
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 9f7fde5..a8c5584 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1203,13 +1203,21 @@ ENTRY(native_load_gs_index)
>  	SWAPGS
>  gs_change:
>  	movl %edi,%gs
> -2:	mfence		/* workaround */
> +2:	ASM_NOP3	/* may be replaced with mfence */
>  	SWAPGS
>  	popfq_cfi
>  	ret
>  	CFI_ENDPROC
>  END(native_load_gs_index)
>  
> +	/* Early K8 systems needed an mfence after swapgs to workaround a bug */
> +	.section .altinstr_replacement,"ax"
> +3:	mfence
> +	.previous
> +	.section .altinstructions,"a"
> +	altinstruction_entry 2b,3b,X86_FEATURE_SWAPGS_MFENCE,3,3
> +	.previous
> +
>  	_ASM_EXTABLE(gs_change,bad_gs)
>  	.section .fixup,"ax"
>  	/* running with kernelgs */
> 

