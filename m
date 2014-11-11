Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaKKHdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:33:15 -0500
Received: from regular1.263xmail.com ([211.150.99.133]:49918 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaKKHdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:33:12 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <0723e6d09f073a589ec9fec376dbf867>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5461BBB1.9070002@rock-chips.com>
Date: Tue, 11 Nov 2014 15:33:05 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>, Russell King <linux@arm.linux.org.uk>,
        heiko@sntech.de, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, dianders@chromium.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, mturquette@linaro.org,
        Tony Xie <xxx@rock-chips.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 4/7] ARM: rockchip: add suspend and resume for RK3288
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com> <1414583525-17395-5-git-send-email-zyw@rock-chips.com> <7h38a68zu9.fsf@deeprootsystems.com>
In-Reply-To: <7h38a68zu9.fsf@deeprootsystems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/30/2014 03:01 AM, Kevin Hilman wrote:
> Chris Zhong <zyw@rock-chips.com> writes:
>
>> It's a basic version of suspend and resume for rockchip,
>> it only support RK3288 now.
>>
>> Signed-off-by: Tony Xie <xxx@rock-chips.com>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>> Tested-by: Doug Anderson <dianders@chromium.org>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>>
>> ---
>> +static void rk3288_fill_in_bootram(u32 level)
> This function name no longer reflects what it does...
have removed in v7.
>
>> +{
>> +	rkpm_bootdata_cpusp = rk3288_bootram_phy + (SZ_4K - 8);
>> +	rkpm_bootdata_cpu_code = virt_to_phys(cpu_resume);
>> +
>> +	rkpm_bootdata_l2ctlr_f  = 1;
>> +	rkpm_bootdata_l2ctlr = rk3288_l2_config();
>> +
>> +	rkpm_bootdata_ddr_code = 0;
> Already initialized to 0 in the resume code.
have removed in v7
>
>> +}
> In addition, you're no longer copying the resume code to SRAM, but this
> function writes values into the version of resume code that's in memory.
> IOW, this function is being called for every suspend cycle, but has no
> effect since the resume code has already been copied to SRAM.
>
> Seems to me like this whole 'fill_in_bootram()' needs to go away, and be
> replaced by a single setup at init time.
Done in v7
>
>> +static u32 rk3288_pmu_pwr_mode_con;
>> +static u32 rk3288_sgrf_soc_con0;
> Minor nit, and it's up to Heiko's preference here, but it's generally
> preferred to have global variables like  this at the top of the file,
> not interspersed with the code.
>
> Also, I'm not sure if you expect the number of registers that need
> saving to grow here, but regmap provides a regcache facility for keeping
> copies of things that may be useful.  Probably not worth the over head
> for a single register in each of these regmaps, but worth exploring if
> this is going to grow.
have moved them to the top of file in v7
>
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
>> +		     BIT(SGRF_FAST_BOOT_EN) | BIT(SGRF_FAST_BOOT_EN + 16));
> Comment says "bit 8", but code says bit 8 and bit 24, and if bit 24 is
> needed, it should probably get its own #define in the header.
Done in v7
>
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
>> +
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
>> +
> extra blank line not needed
Done in v7
>
>> +	regmap_write(pmu_regmap, RK3288_PMU_PWRMODE_CON1, mode_set1);
>> +}
>> +
>> +static void rk3288_slp_mode_set_resume(void)
>> +{
>> +	regmap_write(pmu_regmap, RK3288_PMU_PWRMODE_CON,
>> +		     rk3288_pmu_pwr_mode_con);
> extra blank line
Done in v7
>
>> +	regmap_write(sgrf_regmap, RK3288_SGRF_SOC_CON0,
>> +		     rk3288_sgrf_soc_con0 | BIT(SGRF_FAST_BOOT_EN + 16));
> here is magic bit 24 again.
Done in v7
>
>> +}
>> +
>> +/*
>> + * level: used to control the level of sleep mode.
>> + * ROCKCHIP_ARM_OFF_LOGIC_NORMAL : arm is off and logic is in normal
>> + * sleep mode.
>> + * ROCKCHIP_ARM_OFF_LOGIC_DEEP : arm is off and logic is in deep sleep mode
> IMO, these descriptions don't add any value over the already descriptive
> names of the #defines
have removed it in v7
>
>> + */
>> +static void rk3288_save_settings(u32 level)
>> +{
>> +	rk3288_fill_in_bootram(level);
>> +
>> +	rk3288_slp_mode_set(level);
>> +}
>> +
>> +static void rk3288_restore_settings(void)
>> +{
>> +	rk3288_slp_mode_set_resume();
>> +}
> These 'save' and 'restore' functions seem like unnecessary levels of
> redirection, especially if 'fill_in_bootram' goes away.
>
> IMO, probably best to just move the calls into _suspend_enter().
Done in v7
.
.
.
>> diff --git a/arch/arm/mach-rockchip/pm.h b/arch/arm/mach-rockchip/pm.h
>> new file mode 100644
>> index 0000000..781ea9d
>> --- /dev/null
>> +++ b/arch/arm/mach-rockchip/pm.h
>> @@ -0,0 +1,103 @@
>> +/*
>> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
>> + * Author: Tony Xie <tony.xie@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + */
>> +
>> +#ifndef __MACH_ROCKCHIP_PM_H
>> +#define __MACH_ROCKCHIP_PM_H
>> +
>> +extern unsigned long rkpm_bootdata_cpusp;
>> +extern unsigned long rkpm_bootdata_cpu_code;
>> +extern unsigned long rkpm_bootdata_l2ctlr_f;
>> +extern unsigned long rkpm_bootdata_l2ctlr;
>> +extern unsigned long rkpm_bootdata_ddr_code;
>> +extern unsigned long rkpm_bootdata_ddr_data;
>> +extern unsigned long rk3288_bootram_sz;
>> +/* The function selction of low power mode */
>> +/* arm is off and logic is in normal sleep mode */
>> +#define ROCKCHIP_ARM_OFF_LOGIC_NORMAL (0)
>> +/* arm is off and logic is in deep sleep mode */
>> +#define ROCKCHIP_ARM_OFF_LOGIC_DEEP (1)
> These defines only seem to be used inside pm.c, so should be moved there
> (and maybe turned into an enum?)
have removed them to pm.c, but still Macros, I will use enum in v8.

.
.
> + * ddr to sram for system resumeing.
> + * so it is ".data section".
> + */
> +.align
> +
> +ENTRY(rockchip_slp_cpu_resume)
> +	setmode	PSR_I_BIT | PSR_F_BIT | SVC_MODE, r1  @ set svc, irqs off
> +	mrc	p15, 0, r1, c0, c0, 5
> +	and	r1, r1, #0xf
> +	cmp	r1, #0
> +	/* olny cpu0 can continue to run, the others is halt here */
> +	beq	cpu0run
> +secondary_loop:
> +	wfe
> +	b	secondary_loop
> +cpu0run:
> +	ldr	r3, rkpm_bootdata_l2ctlr_f
> +	cmp	r3, #0
> +	beq	sp_set
> +	ldr	r3, rkpm_bootdata_l2ctlr
> +	mcr	p15, 1, r3, c9, c0, 2
> +sp_set:
> +	ldr	sp, rkpm_bootdata_cpusp
> +
> +	ldr	r1, rkpm_bootdata_ddr_code
> +	cmp	r1, #0
> +	beq	res
> In this series, 'ddr_code' is always zero, and othrewise unused.  I'd
> suggest leaving it out of this series entirely for simplicity (and
> readability) and add it back in a patch/series where it's actually used.
>
>> +	ldr	r0, rkpm_bootdata_ddr_data
>> +	blx	r1
> And 'ddr_data' is entirely unused.
Yes, the ddr_ have been removed in v7
>
>> +res:
>> +	ldr	r1, rkpm_bootdata_cpu_code
>> +	bx	r1
>> +ENDPROC(rockchip_slp_cpu_resume)
>> +
>> +/* Parameters filled in by the kernel */
>> +
>> +/* Code to jump to for DDR resume code, or NULL */
>> +	.global rkpm_bootdata_ddr_code
>> +rkpm_bootdata_ddr_code:
>> +	.long 0
>> +
>> +/* Data to pass to DDR resume data */
>> +	.global rkpm_bootdata_ddr_data
>> +rkpm_bootdata_ddr_data:
>> +	.long 0
>> +
>> +/* Flag for whether to restore L2CTLR on resume */
>> +	.global rkpm_bootdata_l2ctlr_f
>> +rkpm_bootdata_l2ctlr_f:
>> +	.long 0
>> +
>> +/* Saved L2CTLR to restore on resume */
>> +	.global rkpm_bootdata_l2ctlr
>> +rkpm_bootdata_l2ctlr:
>> +	.long 0
>> +
>> +/* CPU resume SP addr */
>> +	.globl rkpm_bootdata_cpusp
>> +rkpm_bootdata_cpusp:
>> +	.long 0
>> +
>> +/* CPU resume function (physical address) */
>> +	.globl rkpm_bootdata_cpu_code
>> +rkpm_bootdata_cpu_code:
>> +	.long 0
>> +
>> +ENTRY(rk3288_bootram_sz)
>> +        .word   . - rockchip_slp_cpu_resume
> Kevin
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>


