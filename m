Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaKYEAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 23:00:21 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:37612 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaKYEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 23:00:20 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <eeb0a974308c83729e3bb3cb4acea9b4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5473FEBF.6090300@rock-chips.com>
Date: Tue, 25 Nov 2014 11:59:59 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Tony Xie <xxx@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/4] ARM: rockchip: add suspend and resume for RK3288
References: <1416051910-16730-1-git-send-email-zyw@rock-chips.com> <1416051910-16730-2-git-send-email-zyw@rock-chips.com> <708464816.ZORhtdDuUb@diego>
In-Reply-To: <708464816.ZORhtdDuUb@diego>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/25/2014 07:20 AM, Heiko Stübner wrote:
> Hi Chris,
>
> Am Samstag, 15. November 2014, 19:45:07 schrieb Chris Zhong:
>> It's a basic version of suspend and resume for rockchip,
>> it only support RK3288 now.
> please fold in both in the two patches from Doug
> https://chromium-review.googlesource.com/#/c/231181/
> https://chromium-review.googlesource.com/#/c/231182/
>
> as they make the code nicer to read :-)
>
>
> But overall, this looks quite nice now. I've found some small nits inside -
> some of them are already also addressed by Dougs patches.
OK, I will merge Doug's patch to v9.
>
>> Signed-off-by: Tony Xie<xxx@rock-chips.com>
>> Signed-off-by: Chris Zhong<zyw@rock-chips.com>
>> Tested-by: Doug Anderson<dianders@chromium.org>
>> Reviewed-by: Doug Anderson<dianders@chromium.org>
>>
>> ---
> [...]
>
>> diff --git a/arch/arm/mach-rockchip/pm.c b/arch/arm/mach-rockchip/pm.c
>> new file mode 100644
>> index 0000000..e059b84
>> --- /dev/null
>> +++ b/arch/arm/mach-rockchip/pm.c
>> @@ -0,0 +1,264 @@
>> +/*
>> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
>> + * Author: Tony Xie<tony.xie@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> for + * more details.
>> + *
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/regmap.h>
>> +#include <linux/suspend.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/regulator/machine.h>
>> +
>> +#include <asm/cacheflush.h>
>> +#include <asm/tlbflush.h>
>> +#include <asm/suspend.h>
>> +
>> +#include "pm.h"
>> +
>> +/* These enum are option of low power mode */
>> +enum {
>> +	ROCKCHIP_ARM_OFF_LOGIC_NORMAL = 0,
>> +	ROCKCHIP_ARM_OFF_LOGIC_DEEP = 1,
>> +};
>> +
>> +struct rockchip_pm_device_id {
>> +	const char *compatible;
>> +	const struct platform_suspend_ops *ops;
>> +	int (*init)(void);
>> +};
>> +
>> +static void __iomem *rk3288_bootram_base;
>> +static phys_addr_t rk3288_bootram_phy;
>> +
>> +static struct regmap *pmu_regmap;
>> +static struct regmap *sgrf_regmap;
>> +
>> +static u32 rk3288_pmu_pwr_mode_con;
>> +static u32 rk3288_sgrf_soc_con0;
>> +
>> +static inline u32 rk3288_l2_config(void)
>> +{
>> +	u32 l2ctlr;
>> +
>> +	asm("mrc p15, 1, %0, c9, c0, 2" : "=r" (l2ctlr));
>> +	return l2ctlr;
>> +}
>> +
>> +static void rk3288_config_bootdata(void)
>> +{
>> +	rkpm_bootdata_cpusp = rk3288_bootram_phy + (SZ_4K - 8);
>> +	rkpm_bootdata_cpu_code = virt_to_phys(cpu_resume);
>> +
>> +	rkpm_bootdata_l2ctlr_f  = 1;
>> +	rkpm_bootdata_l2ctlr = rk3288_l2_config();
>> +}
>> +
>> +static void rk3288_slp_mode_set(int level)
>> +{
>> +	u32 mode_set, mode_set1;
>> +
>> +	regmap_read(sgrf_regmap, RK3288_SGRF_SOC_CON0, &rk3288_sgrf_soc_con0);
>> +
>> +	regmap_read(pmu_regmap, RK3288_PMU_PWRMODE_CON,
>> +		    &rk3288_pmu_pwr_mode_con);
>> +
>> +	/* set bit 8 so that system will resume to FAST_BOOT_ADDR */
>> +	regmap_write(sgrf_regmap, RK3288_SGRF_SOC_CON0,
>> +		     SGRF_FAST_BOOT_EN | SGRF_FAST_BOOT_EN_WRITE);
>> +
>> +	/* booting address of resuming system is from this register value */
>> +	regmap_write(sgrf_regmap, RK3288_SGRF_FAST_BOOT_ADDR,
>> +		     rk3288_bootram_phy);
>> +
>> +	regmap_write(pmu_regmap, RK3288_PMU_WAKEUP_CFG1,
>> +		     PMU_ARMINT_WAKEUP_EN);
>> +
>> +	mode_set = BIT(PMU_GLOBAL_INT_DISABLE) | BIT(PMU_L2FLUSH_EN) |
>> +		   BIT(PMU_SREF0_ENTER_EN) | BIT(PMU_SREF1_ENTER_EN) |
>> +		   BIT(PMU_DDR0_GATING_EN) | BIT(PMU_DDR1_GATING_EN) |
>> +		   BIT(PMU_PWR_MODE_EN) | BIT(PMU_CHIP_PD_EN) |
>> +		   BIT(PMU_SCU_EN);
>> +
>> +	mode_set1 = BIT(PMU_CLR_CORE) | BIT(PMU_CLR_CPUP);
>> +
>> +	if (level == ROCKCHIP_ARM_OFF_LOGIC_DEEP) {
>> +		/* arm off, logic deep sleep */
>> +		mode_set |= BIT(PMU_BUS_PD_EN) |
>> +			    BIT(PMU_DDR1IO_RET_EN) | BIT(PMU_DDR0IO_RET_EN) |
>> +			    BIT(PMU_OSC_24M_DIS) | BIT(PMU_PMU_USE_LF) |
>> +			    BIT(PMU_ALIVE_USE_LF) | BIT(PMU_PLL_PD_EN);
>> +
>> +		mode_set1 |= BIT(PMU_CLR_ALIVE) | BIT(PMU_CLR_BUS) |
>> +			     BIT(PMU_CLR_PERI) | BIT(PMU_CLR_DMA);
>> +	} else {
>> +		/*
>> +		 * arm off, logic normal
>> +		 * if pmu_clk_core_src_gate_en is not set,
>> +		 * wakeup will be error
>> +		 */
>> +		mode_set |= BIT(PMU_CLK_CORE_SRC_GATE_EN);
>> +	}
>> +
>> +	regmap_write(pmu_regmap, RK3288_PMU_PWRMODE_CON, mode_set);
>> +	regmap_write(pmu_regmap, RK3288_PMU_PWRMODE_CON1, mode_set1);
>> +}
>> +
>> +static void rk3288_slp_mode_set_resume(void)
>> +{
>> +	regmap_write(pmu_regmap, RK3288_PMU_PWRMODE_CON,
>> +		     rk3288_pmu_pwr_mode_con);
>> +
>> +	regmap_write(sgrf_regmap, RK3288_SGRF_SOC_CON0,
>> +		     rk3288_sgrf_soc_con0 | SGRF_FAST_BOOT_EN_WRITE);
>> +}
>> +
>> +static int rockchip_lpmode_enter(unsigned long arg)
>> +{
>> +	flush_cache_all();
>> +
>> +	cpu_do_idle();
>> +
>> +	pr_info("Failed to suspend the system\n");
> I guess this should be a pr_err. Also could you try for a format like
> 	pr_err("%s: Failed to suspend\n", __func__);
>
> This way it at least gives an indication where is failed ... often this
> shortens the time spent searching for the place of origin :-)
Done
>
>> +
>> +	return 1;
>> +}
>> +
>> +static int rk3288_suspend_enter(suspend_state_t state)
>> +{
>> +	local_fiq_disable();
>> +
>> +	rk3288_slp_mode_set(ROCKCHIP_ARM_OFF_LOGIC_NORMAL);
>> +
>> +	cpu_suspend(0, rockchip_lpmode_enter);
>> +
>> +	rk3288_slp_mode_set_resume();
>> +
>> +	local_fiq_enable();
>> +
>> +	return 0;
>> +}
>> +
>> +static int rk3288_suspend_prepare(void)
>> +{
>> +	return regulator_suspend_prepare(PM_SUSPEND_MEM);
>> +}
>> +
>> +static void rk3288_suspend_finish(void)
>> +{
>> +	if (regulator_suspend_finish())
>> +		pr_warn("suspend finish failed\n");
> pr_err and the format containing the function name
Done
>> +}
>> +
>> +static int rk3288_suspend_iomap(void)
>> +{
>> +	struct device_node *node;
>> +	struct resource res;
>> +
>> +	node = of_find_compatible_node(NULL, NULL, "rockchip,rk3288-pmu-sram");
>> +	if (!node) {
>> +		pr_err("%s: could not find bootram dt node\n", __func__);
>> +		return -1;
> 	return -ENODEV;
Done
>
>> +	}
>> +
>> +	rk3288_bootram_base = of_iomap(node, 0);
>> +	if (!rk3288_bootram_base) {
>> +		pr_err("%s: could not map bootram base\n", __func__);
>> +		return -1;
> 	return -ENOMEM;
Done
>
>> +	}
>> +
>> +	if (of_address_to_resource(node, 0, &res)) {
>> +		pr_err("%s: could not get bootram phy addr\n", __func__);
>> +		return -1;
>> +	}
> ret = of_address_to_resource(node, 0, &res)
> if (ret) {
> 	pr_err("%s: could not get bootram phy addr\n", __func__);
> 	return ret;
> }
>
Done
>> +
>> +	rk3288_bootram_phy = res.start;
>> +
>> +	rk3288_config_bootdata();
>> +
>> +	/* copy resume code and data to bootsram */
>> +	memcpy(rk3288_bootram_base, rockchip_slp_cpu_resume,
>> +	       rk3288_bootram_sz);
>> +
>> +	return 0;
>> +}
>> +
>> +static int rk3288_suspend_init(void)
>> +{
>> +	int ret;
>> +
>> +	pmu_regmap = syscon_regmap_lookup_by_compatible(
>> +				"rockchip,rk3288-pmu");
>> +
>> +	if (IS_ERR(pmu_regmap)) {
>> +		pr_err("%s: could not find pmu regmap\n", __func__);
>> +		return -1;
> 	return PTR_ERR(pmu_regmap);
Done
>
>> +	}
>> +
>> +	sgrf_regmap = syscon_regmap_lookup_by_compatible(
>> +				"rockchip,rk3288-sgrf");
>> +
>> +	if (IS_ERR(sgrf_regmap)) {
>> +		pr_err("%s: could not find sgrf regmap\n", __func__);
>> +		return -1;
> 	return PTR_ERR(sgrf_regmap);
>
>
Done


