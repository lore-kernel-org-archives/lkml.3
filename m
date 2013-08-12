Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3HLNcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:32:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45136 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3HLNbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:31:46 -0400
Message-ID: <5208E3E2.4010505@arm.com>
Date: Mon, 12 Aug 2013 14:32:18 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 1/3] drivers: clocksource: configure event stream for
 ARM arch timer
References: <1374492082-13686-2-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374745537-30389-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1374745537-30389-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 12 Aug 2013 13:31:43.0919 (UTC) FILETIME=[491683F0:01CE9760]
X-MC-Unique: 113081214314405901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/13 10:45, Sudeep KarkadaNagesha wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> The ARM architected timer can generate events (used for waking up
> CPUs executing the wfe instruction) at a frequency represented as a
> power-of-2 divisor of the clock rate.
> 
> This patch configures the event stream, aiming for a period of 100us
> between events. This can be used to implement wfe-based timeouts for
> userspace locking implementations.
> 
> This patch also adds the hwcaps for the same, so that userspace can
> detect this feature.
> 
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/include/asm/arch_timer.h    | 6 ++++--
>  arch/arm/include/uapi/asm/hwcap.h    | 1 +
>  arch/arm/kernel/setup.c              | 1 +
>  arch/arm64/include/asm/arch_timer.h  | 6 +++---
>  drivers/clocksource/arm_arch_timer.c | 9 ++++++++-
>  include/clocksource/arm_arch_timer.h | 2 ++
>  6 files changed, 19 insertions(+), 6 deletions(-)
> 
> ------------>8---------------------
> 
> Hi,
> 
> This version adds the hwcaps for publishing the event stream feature to the
> userspace.
> 
Hi Catalin,

If you are OK with this patch, can I have your ACK ?

Regards,
Sudeep

> This patch is now rebased on rmk's fixes branch as it conflicts with ab8d46c0 
> "ARM: 7788/1: elf: fix lpae hwcap feature reporting in proc/cpuinfo"
> 
> Regards,
> Sudeep
> 
> diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
> index e406d57..8963877 100644
> --- a/arch/arm/include/asm/arch_timer.h
> +++ b/arch/arm/include/asm/arch_timer.h
> @@ -89,16 +89,18 @@ static inline u64 arch_counter_get_cntvct(void)
>  	return cval;
>  }
>  
> -static inline void arch_counter_set_user_access(void)
> +static inline void arch_counter_set_user_access(int divider)
>  {
>  	u32 cntkctl;
>  
>  	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
>  
>  	/* disable user access to everything */
> -	cntkctl &= ~((3 << 8) | (7 << 0));
> +	cntkctl &= ~((3 << 8) | (0xf << 4) | (3 << 0));
> +	cntkctl |= (divider << 4) | (1 << 2);
>  
>  	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
> +	elf_hwcap |= HWCAP_EVTSTRM;
>  }
>  #endif
>  
> diff --git a/arch/arm/include/uapi/asm/hwcap.h b/arch/arm/include/uapi/asm/hwcap.h
> index 6d34d08..7dcc10d 100644
> --- a/arch/arm/include/uapi/asm/hwcap.h
> +++ b/arch/arm/include/uapi/asm/hwcap.h
> @@ -26,5 +26,6 @@
>  #define HWCAP_VFPD32	(1 << 19)	/* set if VFP has 32 regs (not 16) */
>  #define HWCAP_IDIV	(HWCAP_IDIVA | HWCAP_IDIVT)
>  #define HWCAP_LPAE	(1 << 20)
> +#define HWCAP_EVTSTRM	(1 << 21)
>  
>  #endif /* _UAPI__ASMARM_HWCAP_H */
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 96286cb..5191956 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -973,6 +973,7 @@ static const char *hwcap_str[] = {
>  	"idivt",
>  	"vfpd32",
>  	"lpae",
> +	"evtstrm",
>  	NULL
>  };
>  
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index 98abd47..8c1e42f 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -97,16 +97,16 @@ static inline u32 arch_timer_get_cntfrq(void)
>  	return val;
>  }
>  
> -static inline void arch_counter_set_user_access(void)
> +static inline void arch_counter_set_user_access(int divider)
>  {
>  	u32 cntkctl;
>  
>  	/* Disable user access to the timers and the physical counter. */
>  	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
> -	cntkctl &= ~((3 << 8) | (1 << 0));
> +	cntkctl &= ~((3 << 8) | (0xf << 4) | (1 << 0));
>  
>  	/* Enable user access to the virtual counter and frequency. */
> -	cntkctl |= (1 << 1);
> +	cntkctl |= (divider << 4) | (1 << 2) | (1 << 1);
>  	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
>  }
>  
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index ffadd83..6301ee5 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -125,6 +125,8 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
>  
>  static int arch_timer_setup(struct clock_event_device *clk)
>  {
> +	int evt_stream_div, pos;
> +
>  	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
>  	clk->name = "arch_sys_timer";
>  	clk->rating = 450;
> @@ -153,7 +155,12 @@ static int arch_timer_setup(struct clock_event_device *clk)
>  			enable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI], 0);
>  	}
>  
> -	arch_counter_set_user_access();
> +	/* Find the closest power of two to the divisor */
> +	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
> +	pos = fls(evt_stream_div);
> +	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
> +		pos--;
> +	arch_counter_set_user_access(min(pos, 15));
>  
>  	return 0;
>  }
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index c463ce9..24dc140 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -29,6 +29,8 @@
>  #define ARCH_TIMER_PHYS_ACCESS		0
>  #define ARCH_TIMER_VIRT_ACCESS		1
>  
> +#define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
> +
>  #ifdef CONFIG_ARM_ARCH_TIMER
>  
>  extern u32 arch_timer_get_rate(void);
> 


