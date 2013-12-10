Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3LJPXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:23:52 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61871 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3LJPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:23:51 -0500
Date: Tue, 10 Dec 2013 16:23:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: suravee.suthikulpanit@amd.com
Cc: mingo@kernel.org, mingo@redhat.com, jacob.w.shin@gmail.com,
        oleg@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        hpa@zytor.com, tgl@domain.invalid, linux-kernel@vger.kernel.org,
        sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131210152342.GE10633@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:11:06AM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Jacob Shin <jacob.w.shin@gmail.com>
> 
> Implement hardware breakpoint address mask for AMD Family 16h and
> above processors. CPUID feature bit indicates hardware support for
> DRn_ADDR_MASK MSRs. These masks further qualify DRn/DR7 hardware
> breakpoint addresses to allow matching of larger addresses ranges.
> 
> Valuable advice and pseudo code from Oleg Nesterov <oleg@redhat.com>
> 
> Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thinking further about this, Oleg convinced me that we can keep the mask eventually.
It actually makes sense internally just for the use of bpext.

But I still have a few comments on this patchset:

> ---
>  arch/x86/include/asm/cpufeature.h     |  2 ++
>  arch/x86/include/asm/debugreg.h       |  5 ++++
>  arch/x86/include/asm/hw_breakpoint.h  |  1 +
>  arch/x86/include/uapi/asm/msr-index.h |  4 +++
>  arch/x86/kernel/cpu/amd.c             | 19 ++++++++++++++
>  arch/x86/kernel/hw_breakpoint.c       | 47 ++++++++++++++---------------------
>  6 files changed, 49 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index d3f5c63..26609bb 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -170,6 +170,7 @@
>  #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
>  #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
>  #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
> +#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */

Please comment that it's AMD specific.

>  #define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensions */
>  
>  /*
> @@ -332,6 +333,7 @@ extern const char * const x86_power_flags[32];
>  #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
>  #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
>  #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
> +#define cpu_has_bpext		boot_cpu_has(X86_FEATURE_BPEXT)
>  
>  #ifdef CONFIG_X86_64
>  
> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
> index 4b528a9..145b009 100644
> --- a/arch/x86/include/asm/debugreg.h
> +++ b/arch/x86/include/asm/debugreg.h
> @@ -114,5 +114,10 @@ static inline void debug_stack_usage_inc(void) { }
>  static inline void debug_stack_usage_dec(void) { }
>  #endif /* X86_64 */
>  
> +#ifdef CONFIG_CPU_SUP_AMD
> +extern void set_dr_addr_mask(unsigned long mask, int dr);
> +#else
> +static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
> +#endif
>  
>  #endif /* _ASM_X86_DEBUGREG_H */
> diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
> index ef1c4d2..6c98be8 100644
> --- a/arch/x86/include/asm/hw_breakpoint.h
> +++ b/arch/x86/include/asm/hw_breakpoint.h
> @@ -12,6 +12,7 @@
>   */
>  struct arch_hw_breakpoint {
>  	unsigned long	address;
> +	unsigned long	mask;
>  	u8		len;
>  	u8		type;
>  };
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index bb04650..1f04f6c 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -205,6 +205,10 @@
>  /* Fam 16h MSRs */
>  #define MSR_F16H_L2I_PERF_CTL		0xc0010230
>  #define MSR_F16H_L2I_PERF_CTR		0xc0010231
> +#define MSR_F16H_DR1_ADDR_MASK		0xc0011019
> +#define MSR_F16H_DR2_ADDR_MASK		0xc001101a
> +#define MSR_F16H_DR3_ADDR_MASK		0xc001101b
> +#define MSR_F16H_DR0_ADDR_MASK		0xc0011027
>  
>  /* Fam 15h MSRs */
>  #define MSR_F15H_PERF_CTL		0xc0010200
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 903a264..fffc9cb 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -909,3 +909,22 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
>  
>  	return false;
>  }
> +
> +void set_dr_addr_mask(unsigned long mask, int dr)
> +{
> +	if (!cpu_has_bpext)
> +		return;
> +
> +	switch (dr) {
> +	case 0:
> +		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
> +		break;
> +	case 1:
> +	case 2:
> +	case 3:
> +		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
> +		break;
> +	default:

How about just:

if (dr <= 4 && dr >= 0)
   wrmsr(MSR_F16H_DR1_ADDR_MASK + dr - 1, mask, 0)

> +		break;
> +	}
> +}
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index f66ff16..3cb1951 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -128,6 +128,8 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>  	*dr7 |= encode_dr7(i, info->len, info->type);
>  
>  	set_debugreg(*dr7, 7);
> +	if (info->mask)
> +		set_dr_addr_mask(info->mask, i);
>  
>  	return 0;
>  }
> @@ -163,29 +165,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
>  	*dr7 &= ~__encode_dr7(i, info->len, info->type);
>  
>  	set_debugreg(*dr7, 7);
> -}
> -
> -static int get_hbp_len(u8 hbp_len)
> -{
> -	unsigned int len_in_bytes = 0;
> -
> -	switch (hbp_len) {
> -	case X86_BREAKPOINT_LEN_1:
> -		len_in_bytes = 1;
> -		break;
> -	case X86_BREAKPOINT_LEN_2:
> -		len_in_bytes = 2;
> -		break;
> -	case X86_BREAKPOINT_LEN_4:
> -		len_in_bytes = 4;
> -		break;
> -#ifdef CONFIG_X86_64
> -	case X86_BREAKPOINT_LEN_8:
> -		len_in_bytes = 8;
> -		break;
> -#endif
> -	}
> -	return len_in_bytes;
> +	if (info->mask)
> +		set_dr_addr_mask(0, i);
>  }
>  
>  /*
> @@ -198,7 +179,7 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
>  	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
>  
>  	va = info->address;
> -	len = get_hbp_len(info->len);
> +	len = bp->attr.bp_len;

So we can access the attr directly instead of get_hbp_len(). Good, that's a welcome
simplification but it's a change that is meaningful and tricky enough to deserve a seperate patch.

Could you send a seperate one for that?

>  
>  	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
>  }
> @@ -279,7 +260,16 @@ static int arch_build_bp_info(struct perf_event *bp)
>  	}
>  
>  	/* Len */
> +	info->mask = 0;
> +
>  	switch (bp->attr.bp_len) {
> +	default:
> +		if (!is_power_of_2(bp->attr.bp_len))
> +			return -EINVAL;
> +		if (!cpu_has_bpext)
> +			return -EOPNOTSUPP;
> +		info->mask = bp->attr.bp_len - 1;
> +		/* fall through */

So, that's perhaps just personal preference but having the default on
top of the switch makes things very confusing. Can't we put the above
in the end of the switch instead?

>  	case HW_BREAKPOINT_LEN_1:
>  		info->len = X86_BREAKPOINT_LEN_1;
>  		break;
> @@ -294,12 +284,11 @@ static int arch_build_bp_info(struct perf_event *bp)
>  		info->len = X86_BREAKPOINT_LEN_8;
>  		break;
>  #endif
> -	default:
> -		return -EINVAL;
>  	}
>  
>  	return 0;
>  }
> +
>  /*
>   * Validate the arch-specific HW Breakpoint register settings
>   */
> @@ -314,11 +303,11 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
>  	if (ret)
>  		return ret;
>  
> -	ret = -EINVAL;
> -
>  	switch (info->len) {
>  	case X86_BREAKPOINT_LEN_1:
>  		align = 0;
> +		if (info->mask)
> +			align = info->mask;

Confused, I thought mask is set only when length is above 8?

>  		break;
>  	case X86_BREAKPOINT_LEN_2:
>  		align = 1;
> @@ -332,7 +321,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
>  		break;
>  #endif
>  	default:
> -		return ret;
> +		BUG();

Please use WARN_ON_ONCE() instead.

Thanks.

>  	}
>  
>  	/*
> -- 
> 1.8.1.2
> 
> 
