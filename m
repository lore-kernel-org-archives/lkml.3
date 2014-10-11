Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaJKSNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:13:22 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56219 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaJKSNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:13:20 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: rockchip: fix up rk3288 smp cpu hotplug
Date: Sat, 11 Oct 2014 20:12:58 +0200
Message-ID: <21744941.HYD27PaZsk@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412979915-19746-2-git-send-email-kever.yang@rock-chips.com>
References: <1412979915-19746-1-git-send-email-kever.yang@rock-chips.com> <1412979915-19746-2-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. Oktober 2014, 15:25:14 schrieb Kever Yang:
> This patch fix up the problem we met in rk3288 smp cpu hotplug.
> It is a known issue for the CA12/CA17 MPCore multiprocessor that the active
> processors might be stalled when the individual processor is powered down,
> we can avoid this prolbem by softreset the processor before power it down.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

without my Signed-off please

Also this should probably be folded into the core rk3288-smp patch (patch 
5/6).

I was able to verify the fault very easily and also that this patch fixed it, 
so the original smp patch should not introduce code known to produce breakage.

After this, also simply include the patch adding the resets in the dts to the 
general series as patch 7 or so.


Heiko

> ---
> 
>  arch/arm/mach-rockchip/platsmp.c | 38
> ++++++++++++++++++++++++++++++++++++++ 1 file changed, 38 insertions(+)
> 
> diff --git a/arch/arm/mach-rockchip/platsmp.c
> b/arch/arm/mach-rockchip/platsmp.c index d1f858e..5c08262 100644
> --- a/arch/arm/mach-rockchip/platsmp.c
> +++ b/arch/arm/mach-rockchip/platsmp.c
> @@ -22,6 +22,8 @@
>  #include <linux/regmap.h>
>  #include <linux/mfd/syscon.h>
> 
> +#include <linux/reset.h>
> +#include <linux/cpu.h>
>  #include <asm/cacheflush.h>
>  #include <asm/cp15.h>
>  #include <asm/smp_scu.h>
> @@ -53,11 +55,47 @@ static int pmu_power_domain_is_on(int pd)
>  	return !(val & BIT(pd));
>  }
> 
> +struct reset_control *rockchip_get_core_reset(int cpu)
> +{
> +	struct device *dev = get_cpu_device(cpu);
> +	struct device_node *np;
> +
> +	/* The cpu device is only available after the initial core bringup */
> +	if (dev)
> +		np = dev->of_node;
> +	else
> +		np = of_get_cpu_node(cpu, 0);
> +
> +	return of_reset_control_get(np, NULL);
> +}
> +
>  static int pmu_set_power_domain(int pd, bool on)
>  {
>  	u32 val = (on) ? 0 : BIT(pd);
>  	int ret;
> 
> +	/*
> +	 * We need to soft reset the cpu when we turn off the cpu power domain,
> +	 * or else the active processors might be stalled when the individual
> +	 * processor is powered down.
> +	 */
> +	if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {
> +		struct reset_control *rstc = rockchip_get_core_reset(pd);
> +
> +		if (IS_ERR(rstc)) {
> +			pr_err("%s: could not get reset control for core %d\n",
> +			       __func__, pd);
> +			return PTR_ERR(rstc);
> +		}
> +
> +		if (on)
> +			reset_control_deassert(rstc);
> +		else
> +			reset_control_assert(rstc);
> +
> +		reset_control_put(rstc);
> +	}
> +
>  	ret = regmap_update_bits(pmu, PMU_PWRDN_CON, BIT(pd), val);
>  	if (ret < 0) {
>  		pr_err("%s: could not update power domain\n", __func__);

