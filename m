Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3BVLQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 06:16:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62197 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756Ab3BVLQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 06:16:08 -0500
Date: Fri, 22 Feb 2013 11:15:45 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] ARM: smp: Remove local timer API
Message-ID: <20130222111545.GA15020@e106331-lin.cambridge.arm.com>
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
 <1361518039-16663-9-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361518039-16663-9-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

One thing that struck me when I was fiddling with the broadcast mechanism was
that it should be possible to have a generic dummy timer implementation. As
long as the architecture calls notifiers at the appropriate times, it should
look like any other timer driver (apart from not touching any hardware). It just
needs to depend on ARCH_HAS_TICK_BROADCAST.

I believe it shouldn't be too difficult to implement, though I may be blind to
some problems.

Otherwise, I have a few comments on the patch below.

On Fri, Feb 22, 2013 at 07:27:19AM +0000, Stephen Boyd wrote:
> There are no more users of this API, remove it.

As we're leaving the dummy timers, it'd be worth explaining why in the commit
message.

> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/Kconfig                  | 12 +------
>  arch/arm/include/asm/localtimer.h | 34 --------------------
>  arch/arm/kernel/smp.c             | 67 ++++++---------------------------------
>  arch/arm/mach-omap2/Kconfig       |  1 -
>  arch/arm/mach-omap2/timer.c       |  7 ----
>  5 files changed, 11 insertions(+), 110 deletions(-)
>  delete mode 100644 arch/arm/include/asm/localtimer.h
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index dedf02b..7d4338d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1527,6 +1527,7 @@ config SMP
>  	depends on HAVE_SMP
>  	depends on MMU
>  	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
> +	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
>  	select USE_GENERIC_SMP_HELPERS
>  	help
>  	  This enables support for systems with more than one CPU. If you have

Should this have been in an earlier patch?

Why is it necessary?

[...]

> -static void percpu_timer_setup(void);
> +static void broadcast_timer_setup(void);
>  
>  /*
>   * This is the secondary CPU boot entry.  We're using this CPUs
> @@ -325,9 +317,9 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
>  	complete(&cpu_running);
>  
>  	/*
> -	 * Setup the percpu timer for this CPU.
> +	 * Setup the dummy broadcast timer for this CPU.

To me, calling something a broadcast timer makes it sound like it performs the
broadcast. We use the term "broadcast timer" elsewhere here (e.g.
broadcast_timer_setup), and I think it's any unnecessarily confusing term.

Might it be better to say "dummy timer" consistently?

[...]

> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 49ac3df..6e1f871 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -88,7 +88,6 @@ config ARCH_OMAP4
>  	select CACHE_L2X0
>  	select CPU_V7
>  	select HAVE_SMP
> -	select LOCAL_TIMERS if SMP
>  	select OMAP_INTERCONNECT
>  	select PL310_ERRATA_588369
>  	select PL310_ERRATA_727915
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 2bdd4cf..c00a8f8 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -587,7 +587,6 @@ OMAP_SYS_GP_TIMER_INIT(3_am33xx, 1, OMAP4_MPU_SOURCE, "ti,timer-alwon",
>  #ifdef CONFIG_ARCH_OMAP4
>  OMAP_SYS_32K_TIMER_INIT(4, 1, OMAP4_32K_SOURCE, "ti,timer-alwon",
>  			2, OMAP4_MPU_SOURCE);
> -#ifdef CONFIG_LOCAL_TIMERS
>  static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, OMAP44XX_LOCAL_TWD_BASE, 29);
>  void __init omap4_local_timer_init(void)
>  {
> @@ -606,12 +605,6 @@ void __init omap4_local_timer_init(void)
>  			pr_err("twd_local_timer_register failed %d\n", err);
>  	}
>  }
> -#else /* CONFIG_LOCAL_TIMERS */
> -void __init omap4_local_timer_init(void)
> -{
> -	omap4_sync32k_timer_init();
> -}
> -#endif /* CONFIG_LOCAL_TIMERS */
>  #endif /* CONFIG_ARCH_OMAP4 */
>  
>  #ifdef CONFIG_SOC_OMAP5

I believe the above OMAP changes should have been in an earlier patch?

Thanks,
Mark.
