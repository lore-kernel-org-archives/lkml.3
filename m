Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3JQN5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:57:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40789 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab3JQN5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:57:38 -0400
Message-ID: <525FECB8.20600@ti.com>
Date: Thu, 17 Oct 2013 09:57:12 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: OMAP4460: cpuidle: WA for ROM bug because of
 CA9 r2pX gic control register change
References: <1382000776-15897-3-git-send-email-grygorii.strashko@ti.com> <525FACB1.3030101@ti.com>
In-Reply-To: <525FACB1.3030101@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 October 2013 05:24 AM, Grygorii Strashko wrote:
> On OMAP4+ devices, GIC register context is lost when MPUSS hits the
> OSWR. On the CPU wakeup path, ROM code gets executed and one of the
> steps in it is to restore the saved context of the GIC.
> 
> The ROM code uses GICD != 1 condition to decide how the GIC registers
> are handled in wakeup path from OSWR. But, GICD  register has changed
> between CortexA9 r1pX and r2pX and it contains 2 bits now. Secure view
> which ROM code sees:
>       bit 1 == Enable Non-secure
>       bit 0 == Enable secure
> Non-secure view which HLOS sees:
>       bit 0 == Enable Non-secure
> 
> As result, on OMAP4460(r2pX) devices, when the ROM code is executed
> during CPU1 wakeup, GICD == 3 and it fails to understand the real wakeup
> power state and reconfigures GIC distributor to boot values and, as
> result, the entire interrupt controller context will loose in a live
> system.
> 
> Hence, implement a workaround on OMAP4460 devices in case if MPUSS has
> hit OSWR - as long as CPU1 sees GICD == 1 in it's wakeup path from OSWR,
> the issue won't happen:
>      1.1) CPU0 must disable the GIC distributor, before doing the CPU1
> wakeup,
>      1.2) CPU0 should wait until CPU1 will re-enable the GIC distributor
>        2) CPU1 must re-enable the GIC distributor on it's wakeup path.
> 
> The workaround for CPUIdle has been implemented in the same way as
> for boot-up & hot-plug path in:
>  - http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;
> a=commitdiff;h=ff999b8a0983ee15668394ed49e38d3568fc6859
> 
> For more information see:
> - https://patchwork.kernel.org/patch/1609011/
> - http://www.spinics.net/lists/arm-kernel/msg201402.html
> 
> The ROM code bug is applicable to only OMAP4460(r2pX) devices.
> OMAP4470 (also r2pX) is not affected by this bug because ROM code has been
> fixed.
> 
Just give reference to the commit which has best description about
the bug and just say applying the fix for idle case.

ff999b8a {ARM: OMAP4460: Workaround for ROM...}

> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Reported-and-Tested-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  arch/arm/mach-omap2/common.h       |    1 +
>  arch/arm/mach-omap2/cpuidle44xx.c  |   34 +++++++++++++++++++++++++++++++++-
>  arch/arm/mach-omap2/omap4-common.c |    6 ++++++
>  3 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
> index b875a4a..7957110 100644
> --- a/arch/arm/mach-omap2/common.h
> +++ b/arch/arm/mach-omap2/common.h
> @@ -232,6 +232,7 @@ static inline void __iomem *omap4_get_scu_base(void)
> 
>  extern void __init gic_init_irq(void);
>  extern void gic_dist_disable(void);
> +extern void gic_dist_enable(void);
>  extern bool gic_dist_disabled(void);
>  extern void gic_timer_retrigger(void);
>  extern void omap_smc1(u32 fn, u32 arg);
> diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
> index 384aa1c..528638b 100644
> --- a/arch/arm/mach-omap2/cpuidle44xx.c
> +++ b/arch/arm/mach-omap2/cpuidle44xx.c
> @@ -80,6 +80,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
>              int index)
>  {
>      struct idle_statedata *cx = state_ptr + index;
> +    u32 mpuss_context_lost = 0;
> 
>      /*
>       * CPU0 has to wait and stay ON until CPU1 is OFF state.
> @@ -126,13 +127,44 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
>      omap4_enter_lowpower(dev->cpu, cx->cpu_state);
>      cpu_done[dev->cpu] = true;
> 
> +    mpuss_context_lost = omap4_mpuss_read_prev_context_state();
> +
Just use the targeted state since couple idle almost grantees
the low power entry. Even in failed case, applying errata sequence
is harmless.

>      /* Wakeup CPU1 only if it is not offlined */
>      if (dev->cpu == 0 && cpumask_test_cpu(1, cpu_online_mask)) {
> +        /*
> +         * GIC distributor control register has changed between
> +         * CortexA9 r1pX and r2pX. The Control Register secure
> +         * banked version is now composed of 2 bits:
> +         * bit 0 == Secure Enable
> +         * bit 1 == Non-Secure Enable
> +         * The Non-Secure banked register has not changed
> +         * Because the ROM Code is based on the r1pX GIC, the CPU1
> +         * GIC restoration will cause a problem to CPU0 Non-Secure SW.
> +         * The workaround must be:
> +         * 1) Before doing the CPU1 wakeup, CPU0 must disable
> +         * the GIC distributor and wait until it will be enabled by CPU1
> +         * 2) CPU1 must re-enable the GIC distributor on
> +         * it's wakeup path.
> +         */
> +        if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) &&
> +            mpuss_context_lost)
Use target state here..

> +            gic_dist_disable();
> +
>          clkdm_wakeup(cpu_clkdm[1]);
>          omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON);
>          clkdm_allow_idle(cpu_clkdm[1]);
> +
> +        if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) &&
> +            mpuss_context_lost)
> +            while (gic_dist_disabled()) {
> +                udelay(1);
> +                cpu_relax();
> +            }
Am surprised you didn't live lock here. CPUs can wait here infinitely
because the distributor isn't turned on in idle case. Suspend case,
CPU1 on its boot-up will enable distributor and hence everything works
with above check. 

>      }
> 
> +    if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) && dev->cpu)
> +        gic_dist_enable();
> +
Just move this code under omap-mpuss-lowpower.c and then things should work
properly. It won't affect suspend code since suspend path is different.

Thanks for the fix though...

Regards,
Santosh
