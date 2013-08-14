Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab3HNIu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:50:29 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:47031 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455Ab3HNIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:50:26 -0400
Message-ID: <520B44CF.6040403@linaro.org>
Date: Wed, 14 Aug 2013 10:50:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 1/6] ARM/ARM64: arch_timer: add macros for bits in
 control register
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1376414984-14182-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 07:29 PM, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Add macros to describe the bitfields in the ARM architected timer
> control register to make code easy to understand.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  arch/arm/include/asm/arch_timer.h    |  9 +++++++--
>  arch/arm64/include/asm/arch_timer.h  | 12 ++++++++----
>  include/clocksource/arm_arch_timer.h |  8 ++++++++
>  3 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
> index e406d57..9ef74da 100644
> --- a/arch/arm/include/asm/arch_timer.h
> +++ b/arch/arm/include/asm/arch_timer.h
> @@ -95,8 +95,13 @@ static inline void arch_counter_set_user_access(void)
>  
>  	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
>  
> -	/* disable user access to everything */
> -	cntkctl &= ~((3 << 8) | (7 << 0));
> +	/* Disable user access to both physical/virtual counters/timers. */
> +	/* Also disable virtual event stream */
> +	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
> +			| ARCH_TIMER_USR_VT_ACCESS_EN
> +			| ARCH_TIMER_VIRT_EVT_EN
> +			| ARCH_TIMER_USR_VCT_ACCESS_EN
> +			| ARCH_TIMER_USR_PCT_ACCESS_EN);
>  
>  	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
>  }
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index 98abd47..00b09d0 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -101,12 +101,16 @@ static inline void arch_counter_set_user_access(void)
>  {
>  	u32 cntkctl;
>  
> -	/* Disable user access to the timers and the physical counter. */
>  	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
> -	cntkctl &= ~((3 << 8) | (1 << 0));
>  
> -	/* Enable user access to the virtual counter and frequency. */
> -	cntkctl |= (1 << 1);
> +	/* Disable user access to the timers and the physical counter. */
> +	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
> +			| ARCH_TIMER_USR_VT_ACCESS_EN
> +			| ARCH_TIMER_USR_PCT_ACCESS_EN);
> +
> +	/* Enable user access to the virtual counter. */
> +	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
> +
>  	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
>  }

Before doing those changes, I suggest you kill include/asm/arch_timer.h
header file and move the functions directly in the arm_arch_timer.c as
they are only used by it.

> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index c463ce9..551f7e9 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -29,6 +29,14 @@
>  #define ARCH_TIMER_PHYS_ACCESS		0
>  #define ARCH_TIMER_VIRT_ACCESS		1
>  
> +#define ARCH_TIMER_USR_PCT_ACCESS_EN	(1 << 0) /* physical counter */
> +#define ARCH_TIMER_USR_VCT_ACCESS_EN	(1 << 1) /* virtual counter */
> +#define ARCH_TIMER_VIRT_EVT_EN		(1 << 2)
> +#define ARCH_TIMER_EVT_TRIGGER_SHIFT	(4)
> +#define ARCH_TIMER_EVT_TRIGGER_MASK	(0xF << ARCH_TIMER_EVT_TRIGGER_SHIFT)
> +#define ARCH_TIMER_USR_VT_ACCESS_EN	(1 << 8) /* virtual timer registers */
> +#define ARCH_TIMER_USR_PT_ACCESS_EN	(1 << 9) /* physical timer registers */
> +
>  #ifdef CONFIG_ARM_ARCH_TIMER
>  
>  extern u32 arch_timer_get_rate(void);
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

