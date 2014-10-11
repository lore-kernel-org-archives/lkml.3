Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaJKRzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 13:55:37 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56080 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaJKRzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 13:55:36 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/6] ARM: rockchip: add basic smp support for rk3288
Date: Sat, 11 Oct 2014 19:55:23 +0200
Message-ID: <4844905.4JJtDpVWt2@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412976370-14468-6-git-send-email-kever.yang@rock-chips.com>
References: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com> <1412976370-14468-6-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. Oktober 2014, 14:26:09 schrieb Kever Yang:
> This patch add basic rk3288 smp support.
> 
> Only cortex-A9 need invalid L1, A7/A12/A15/A17 should not invalid L1, since
> for A7/A12/A15, the invalidation would be taken as clean and invalidate.
> 
> If you use the software manual invalidation instead of hardware invalidation
> (assert l1/l2rstdisable during reset) after reset, there is tiny change
> that some cachelines would be in dirty and valid state after reset(since
> the ram content would be random value after reset), then the unexpected
> clean might lead to system crash.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
> 
> Changes in v3:
> - use one ops and secondary_starup for all rockchip SOCs
> - pick back the power domain operation for cpu hotplug
> 
> Changes in v2:
> - use rk3288_boot_secondary instead ofsmp_boot_secondary
> - discards the power domain operation
> - handle the per cpu starup when actived by 'sev'
> 
>  arch/arm/mach-rockchip/headsmp.S |  5 ++-
>  arch/arm/mach-rockchip/platsmp.c | 81
> ++++++++++++++++++++++++++++------------ 2 files changed, 61 insertions(+),
> 25 deletions(-)
> 
> diff --git a/arch/arm/mach-rockchip/headsmp.S
> b/arch/arm/mach-rockchip/headsmp.S index 73206e3..46c22de 100644
> --- a/arch/arm/mach-rockchip/headsmp.S
> +++ b/arch/arm/mach-rockchip/headsmp.S
> @@ -16,7 +16,10 @@
>  #include <linux/init.h>
> 
>  ENTRY(rockchip_secondary_startup)
> -	bl	v7_invalidate_l1
> +	mrc	p15, 0, r0, c0, c0, 0	@ read main ID register
> +	ldr	r1, =0x00000c09		@ Cortex-A9 primary part number
> +	teq	r0, r1
> +	beq	v7_invalidate_l1
>  	b	secondary_startup
>  ENDPROC(rockchip_secondary_startup)
> 
> diff --git a/arch/arm/mach-rockchip/platsmp.c
> b/arch/arm/mach-rockchip/platsmp.c index 57b53b3..d1f858e 100644
> --- a/arch/arm/mach-rockchip/platsmp.c
> +++ b/arch/arm/mach-rockchip/platsmp.c
> @@ -84,6 +84,8 @@ static int pmu_set_power_domain(int pd, bool on)
>  static int __cpuinit rockchip_boot_secondary(unsigned int cpu,
>  					     struct task_struct *idle)
>  {
> +	int ret;
> +
>  	if (!sram_base_addr || !pmu) {
>  		pr_err("%s: sram or pmu missing for cpu boot\n", __func__);
>  		return -ENXIO;
> @@ -96,7 +98,26 @@ static int __cpuinit rockchip_boot_secondary(unsigned int
> cpu, }
> 
>  	/* start the core */
> -	return pmu_set_power_domain(0 + cpu, true);
> +	ret = pmu_set_power_domain(0 + cpu, true);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (read_cpuid_part() != ARM_CPU_PART_CORTEX_A9) {
> +		/* We communicate with the bootrom to active the cpus other
> +		 * than cpu0, after a blob of initialize code, they will
> +		 * stay at wfe state, once they are actived, they will check
> +		 * the mailbox:
> +		 * sram_base_addr + 4: 0xdeadbeaf
> +		 * sram_base_addr + 8: start address for pc
> +		 * */
> +		udelay(10);
> +		writel(virt_to_phys(rockchip_secondary_startup),
> +			sram_base_addr + 8);
> +		writel(0xDEADBEAF, sram_base_addr + 4);
> +		dsb_sev();
> +	}
> +
> +	return 0;
>  }
> 
>  /**
> @@ -129,8 +150,6 @@ static int __init rockchip_smp_prepare_sram(struct
> device_node *node) return -EINVAL;
>  	}
> 
> -	sram_base_addr = of_iomap(node, 0);
> -
>  	/* set the boot function for the sram code */
>  	rockchip_boot_fn = virt_to_phys(rockchip_secondary_startup);
> 
> @@ -203,18 +222,7 @@ static void __init rockchip_smp_prepare_cpus(unsigned
> int max_cpus) {
>  	struct device_node *node;
>  	unsigned int i;
> -
> -	node = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
> -	if (!node) {
> -		pr_err("%s: missing scu\n", __func__);
> -		return;
> -	}
> -
> -	scu_base_addr = of_iomap(node, 0);
> -	if (!scu_base_addr) {
> -		pr_err("%s: could not map scu registers\n", __func__);
> -		return;
> -	}
> +	unsigned int l2ctlr;

please move this l2ctlr below inside the else branch - as it's only used 
there.


> 
>  	node = of_find_compatible_node(NULL, NULL, "rockchip,rk3066-smp-sram");
>  	if (!node) {
> @@ -222,22 +230,47 @@ static void __init rockchip_smp_prepare_cpus(unsigned
> int max_cpus) return;
>  	}
> 
> -	if (rockchip_smp_prepare_sram(node))
> +	sram_base_addr = of_iomap(node, 0);
> +	if (!sram_base_addr) {
> +		pr_err("%s: could not map sram registers\n", __func__);
>  		return;
> +	}
> 
>  	if (rockchip_smp_prepare_pmu())
>  		return;
> 
> -	/* enable the SCU power domain */
> -	pmu_set_power_domain(PMU_PWRDN_SCU, true);
> +	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
> +		if (rockchip_smp_prepare_sram(node))
> +			return;
> 
> -	/*
> -	 * While the number of cpus is gathered from dt, also get the number
> -	 * of cores from the scu to verify this value when booting the cores.
> -	 */
> -	ncores = scu_get_core_count(scu_base_addr);
> +		/* enable the SCU power domain */
> +		pmu_set_power_domain(PMU_PWRDN_SCU, true);
> +
> +		node = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
> +		if (!node) {
> +			pr_err("%s: missing scu\n", __func__);
> +			return;
> +		}
> 
> -	scu_enable(scu_base_addr);
> +		scu_base_addr = of_iomap(node, 0);
> +		if (!scu_base_addr) {
> +			pr_err("%s: could not map scu registers\n", __func__);
> +			return;
> +		}
> +
> +		/*
> +		 * While the number of cpus is gathered from dt, also get the
> +		 * number of cores from the scu to verify this value when
> +		 * booting the cores.
> +		 */
> +		ncores = scu_get_core_count(scu_base_addr);
> +		pr_err("%s: ncores %d\n", __func__, ncores);
> +
> +		scu_enable(scu_base_addr);
> +	} else {

-> here

> +		asm ("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
> +		ncores = ((l2ctlr >> 24) & 0x3) + 1;
> +	}
> 
>  	/* Make sure that all cores except the first are really off */
>  	for (i = 1; i < ncores; i++)

