Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbaCLBK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:10:56 -0400
Received: from [207.46.163.143] ([207.46.163.143]:53767 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755989AbaCLBKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:10:54 -0400
Message-ID: <1394586624.13761.132.camel@snotra.buserror.net>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Tue, 11 Mar 2014 20:10:24 -0500
In-Reply-To: <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: CO1PR04CA005.namprd04.prod.outlook.com (10.141.49.15) To
 DM2PR03MB400.namprd03.prod.outlook.com (10.141.84.153)
X-Forefront-PRVS: 01480965DA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(51704005)(24454002)(199002)(189002)(74366001)(47776003)(20776003)(85852003)(79102001)(19580395003)(83322001)(31966008)(69226001)(92566001)(88136002)(51856001)(95416001)(59766001)(56816005)(81686001)(90146001)(63696002)(77096001)(74876001)(77982001)(83072002)(87976001)(46102001)(93516002)(19580405001)(85306002)(95666003)(97336001)(33646001)(81342001)(81542001)(93136001)(87266001)(97186001)(87286001)(77156001)(42186004)(74662001)(53806001)(89996001)(50466002)(80976001)(23676002)(47736001)(74502001)(47446002)(94316002)(50226001)(49866001)(62966002)(65816001)(50986001)(76796001)(76482001)(80022001)(92726001)(93916002)(94946001)(86362001)(76786001)(56776001)(47976001)(54316002)(4396001)(81816001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB400;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:8E11F2F5.A7E2DEC1.F5FC7287.D9D8E229.20B3F;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> From: Zhao Chenhui <chenhui.zhao@freescale.com>
> 
> T1040 supports deep sleep feature, which can switch off most parts of
> the SoC when it is in deep sleep mode. This way, it becomes more
> energy-efficient.
> 
> The DDR controller will also be powered off in deep sleep. Therefore,
> the last stage (the latter part of fsl_dp_enter_low) will run without DDR
> access. This piece of code and related TLBs will be prefetched.
> 
> Due to the different initialization code between 32-bit and 64-bit, they
> have seperate resume entry and precedure.
> 
> The feature supports 32-bit and 64-bit kernel mode.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
>  arch/powerpc/include/asm/booke_save_regs.h |    3 +
>  arch/powerpc/kernel/cpu_setup_fsl_booke.S  |   17 ++
>  arch/powerpc/kernel/head_fsl_booke.S       |   30 +++
>  arch/powerpc/platforms/85xx/Makefile       |    2 +-
>  arch/powerpc/platforms/85xx/deepsleep.c    |  201 +++++++++++++++++++
>  arch/powerpc/platforms/85xx/qoriq_pm.c     |   38 ++++
>  arch/powerpc/platforms/85xx/sleep.S        |  295 ++++++++++++++++++++++++++++
>  arch/powerpc/sysdev/fsl_soc.h              |    7 +
>  8 files changed, 592 insertions(+), 1 deletions(-)
>  create mode 100644 arch/powerpc/platforms/85xx/deepsleep.c
>  create mode 100644 arch/powerpc/platforms/85xx/sleep.S
> 
> diff --git a/arch/powerpc/include/asm/booke_save_regs.h b/arch/powerpc/include/asm/booke_save_regs.h
> index 87c357a..37c1f6c 100644
> --- a/arch/powerpc/include/asm/booke_save_regs.h
> +++ b/arch/powerpc/include/asm/booke_save_regs.h
> @@ -88,6 +88,9 @@
>  #define HIBERNATION_FLAG	1
>  #define DEEPSLEEP_FLAG		2
>  
> +#define CPLD_FLAG	1
> +#define FPGA_FLAG	2

What is this?

>  #ifndef __ASSEMBLY__
>  extern void booke_cpu_state_save(void *buf, int type);
>  extern void *booke_cpu_state_restore(void *buf, int type);
> diff --git a/arch/powerpc/kernel/cpu_setup_fsl_booke.S b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
> index e59d6de..ea9bc28 100644
> --- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
> +++ b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
> @@ -318,6 +318,23 @@ flush_backside_L2_cache:
>  2:
>  	blr
>  
> +#define CPC_CPCCSR0		0x0
> +#define CPC_CPCCSR0_CPCFL	0x800

This is supposed to be CPU setup, not platform setup.

> +/* r3 : the base address of CPC  */
> +_GLOBAL(fsl_flush_cpc_cache)
> +	lwz	r6, CPC_CPCCSR0(r3)
> +	ori	r6, r6, CPC_CPCCSR0_CPCFL
> +	stw	r6, CPC_CPCCSR0(r3)
> +	sync
> +
> +	/* Wait until completing the flush */
> +1:	lwz	r6, CPC_CPCCSR0(r3)
> +	andi.	r6, r6, CPC_CPCCSR0_CPCFL
> +	bne	1b
> +
> +	blr
> +
>  _GLOBAL(__flush_caches_e500v2)

I'm not sure that this belongs here either.

>  	mflr r0
>  	bl	flush_dcache_L1
> diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
> index 20204fe..3285752 100644
> --- a/arch/powerpc/kernel/head_fsl_booke.S
> +++ b/arch/powerpc/kernel/head_fsl_booke.S
> @@ -162,6 +162,19 @@ _ENTRY(__early_start)
>  #include "fsl_booke_entry_mapping.S"
>  #undef ENTRY_MAPPING_BOOT_SETUP
>  
> +#if defined(CONFIG_SUSPEND) && defined(CONFIG_FSL_CORENET_RCPM)
> +	/* if deep_sleep_flag != 0, jump to the deep sleep resume entry */
> +	LOAD_REG_ADDR(r4, deep_sleep_flag)
> +	lwz	r3, 0(r4)
> +	cmpwi	r3, 0
> +	beq	11f
> +	/* clear deep_sleep_flag */
> +	li	r3, 0
> +	stw	r3, 0(r4)
> +	b	fsl_deepsleep_resume
> +11:
> +#endif

Why do you come in via the normal kernel entry, versus specifying a
direct entry point for deep sleep resume?  How does U-Boot even know
what the normal entry is when resuming?

Be careful of the "beq set_ivor" in the CONFIG_RELOCATABLE section
above.  Also you probably don't want the relocation code to run again
when resuming.

> +#if defined(CONFIG_SUSPEND) && defined(CONFIG_FSL_CORENET_RCPM)
> +_ENTRY(__entry_deep_sleep)
> +/*
> + * Bootloader will jump to here when resuming from deep sleep.
> + * After executing the init code in fsl_booke_entry_mapping.S,
> + * will jump to the real resume entry.
> + */
> +	li	r8, 1
> +	bl	12f
> +12:	mflr	r9
> +	addi	r9, r9, (deep_sleep_flag - 12b)
> +	stw	r8, 0(r9)
> +	b __early_start
> +deep_sleep_flag:
> +	.long	0
> +#endif

It's a bit ambiguous to say "entry_deep_sleep" when it's resuming rather
than entering...

So you do have a special entry point.  Why do you go to __early_start
only to quickly test a flag and branch away?

> diff --git a/arch/powerpc/platforms/85xx/Makefile b/arch/powerpc/platforms/85xx/Makefile
> index 7fae817..9a4ea86 100644
> --- a/arch/powerpc/platforms/85xx/Makefile
> +++ b/arch/powerpc/platforms/85xx/Makefile
> @@ -3,7 +3,7 @@
>  #
>  obj-$(CONFIG_SMP) += smp.o
>  ifeq ($(CONFIG_FSL_CORENET_RCPM), y)
> -obj-$(CONFIG_SUSPEND)	+= qoriq_pm.o
> +obj-$(CONFIG_SUSPEND)	+= qoriq_pm.o deepsleep.o sleep.o
>  endif
>  
>  obj-y += common.o
> diff --git a/arch/powerpc/platforms/85xx/deepsleep.c b/arch/powerpc/platforms/85xx/deepsleep.c
> new file mode 100644
> index 0000000..ddd7185
> --- /dev/null
> +++ b/arch/powerpc/platforms/85xx/deepsleep.c
> @@ -0,0 +1,201 @@
> +/*
> + * Support deep sleep feature

AFAICT this supports deep sleep on T1040, not on all 85xx that has it.

> + *
> + * Copyright 2014 Freescale Semiconductor Inc.
> + *
> + * Author: Chenhui Zhao <chenhui.zhao@freescale.com>
> + *
> + * This program is free software; you can redistribute	it and/or modify it
> + * under  the terms of	the GNU General	 Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_address.h>
> +#include <asm/machdep.h>
> +#include <sysdev/fsl_soc.h>
> +#include <asm/booke_save_regs.h>
> +
> +#define SIZE_1MB	0x100000
> +#define SIZE_2MB	0x200000
> +
> +#define CCSR_SCFG_DPSLPCR	0xfc000
> +#define CCSR_SCFG_DPSLPCR_WDRR_EN	0x1
> +#define CCSR_SCFG_SPARECR2	0xfc504
> +#define CCSR_SCFG_SPARECR3	0xfc508
> +
> +#define CCSR_GPIO1_GPDIR	0x130000
> +#define CCSR_GPIO1_GPODR	0x130004
> +#define CCSR_GPIO1_GPDAT	0x130008
> +#define CCSR_GPIO1_GPDIR_29		0x4
> +
> +/* 128 bytes buffer for restoring data broke by DDR training initialization */
> +#define DDR_BUF_SIZE	128
> +static u8 ddr_buff[DDR_BUF_SIZE] __aligned(64);
> +
> +static void *dcsr_base, *ccsr_base, *pld_base;
> +static int pld_flag;
> +
> +int fsl_dp_iomap(void)
> +{
> +	struct device_node *np;
> +	const u32 *prop;
> +	int ret = 0;
> +	u64 ccsr_phy_addr, dcsr_phy_addr;
> +
> +	np = of_find_node_by_type(NULL, "soc");
> +	if (!np) {
> +		pr_err("%s: Can't find the node of \"soc\"\n", __func__);
> +		ret = -EINVAL;
> +		goto ccsr_err;
> +	}
> +	prop = of_get_property(np, "ranges", NULL);
> +	if (!prop) {
> +		pr_err("%s: Can't find the property of \"ranges\"\n", __func__);
> +		of_node_put(np);
> +		ret = -EINVAL;
> +		goto ccsr_err;
> +	}

Use get_immrbase(), or better use specific nodes in the device tree.

> +	ccsr_phy_addr = of_translate_address(np, prop + 1);
> +	ccsr_base = ioremap((phys_addr_t)ccsr_phy_addr, SIZE_2MB);
> +	of_node_put(np);
> +	if (!ccsr_base) {
> +		ret = -ENOMEM;
> +		goto ccsr_err;
> +	}

Unnecessary cast.

Why 2 MiB?

> +	np = of_find_compatible_node(NULL, NULL, "fsl,dcsr");
> +	if (!np) {
> +		pr_err("%s: Can't find the node of \"fsl,dcsr\"\n", __func__);
> +		ret = -EINVAL;
> +		goto dcsr_err;
> +	}
> +	prop = of_get_property(np, "ranges", NULL);
> +	if (!prop) {
> +		pr_err("%s: Can't find the property of \"ranges\"\n", __func__);
> +		of_node_put(np);
> +		ret = -EINVAL;
> +		goto dcsr_err;
> +	}
> +	dcsr_phy_addr = of_translate_address(np, prop + 1);
> +	dcsr_base = ioremap((phys_addr_t)dcsr_phy_addr, SIZE_1MB);
> +	of_node_put(np);
> +	if (!dcsr_base) {
> +		ret = -ENOMEM;
> +		goto dcsr_err;
> +	}

If you must do this, add a helper to get the dcsr base -- but do we not
already have dcsr subnodes for what you are using?

> +
> +	np = of_find_compatible_node(NULL, NULL, "fsl,fpga-qixis");
> +	if (np) {
> +		pld_flag = FPGA_FLAG;
> +	} else {
> +		np = of_find_compatible_node(NULL, NULL, "fsl,p104xrdb-cpld");
> +		if (np) {
> +			pld_flag = CPLD_FLAG;
> +		} else {
> +			pr_err("%s: Can't find the FPGA/CPLD node\n",
> +					__func__);
> +			ret = -EINVAL;
> +			goto pld_err;
> +		}
> +	}

OK, so this file isn't even specific to T1040 -- it's specific to our
reference boards?

> +static void fsl_dp_ddr_save(void *ccsr_base)
> +{
> +	u32 ddr_buff_addr;
> +
> +	/*
> +	 * DDR training initialization will break 128 bytes at the beginning
> +	 * of DDR, therefore, save them so that the bootloader will restore
> +	 * them. Assume that DDR is mapped to the address space started with
> +	 * CONFIG_PAGE_OFFSET.
> +	 */
> +	memcpy(ddr_buff, (void *)CONFIG_PAGE_OFFSET, DDR_BUF_SIZE);
> +
> +	/* assume ddr_buff is in the physical address space of 4GB */
> +	ddr_buff_addr = (u32)(__pa(ddr_buff) & 0xffffffff);

That assumption may break with a relocatable kernel.

> +
> +}
> +
> +int fsl_enter_epu_deepsleep(void)
> +{
> +
> +

No blank lines at begin/end of function.

> diff --git a/arch/powerpc/platforms/85xx/qoriq_pm.c b/arch/powerpc/platforms/85xx/qoriq_pm.c
> index 915b13b..5f2c016 100644
> --- a/arch/powerpc/platforms/85xx/qoriq_pm.c
> +++ b/arch/powerpc/platforms/85xx/qoriq_pm.c
> @@ -20,6 +20,8 @@
>  #define FSL_SLEEP		0x1
>  #define FSL_DEEP_SLEEP		0x2
>  
> +int (*fsl_enter_deepsleep)(void);
> +
>  /* specify the sleep state of the present platform */
>  int sleep_pm_state;
>  /* supported sleep modes by the present platform */
> @@ -28,6 +30,7 @@ static unsigned int sleep_modes;
>  static int qoriq_suspend_enter(suspend_state_t state)
>  {
>  	int ret = 0;
> +	int cpu;
>  
>  	switch (state) {
>  	case PM_SUSPEND_STANDBY:
> @@ -39,6 +42,17 @@ static int qoriq_suspend_enter(suspend_state_t state)
>  
>  		break;
>  
> +	case PM_SUSPEND_MEM:
> +
> +		cpu = smp_processor_id();
> +		qoriq_pm_ops->irq_mask(cpu);
> +
> +		ret = fsl_enter_deepsleep();
> +
> +		qoriq_pm_ops->irq_unmask(cpu);
> +
> +		break;
> +
>  	default:
>  		ret = -EINVAL;
>  
> @@ -52,12 +66,30 @@ static int qoriq_suspend_valid(suspend_state_t state)
>  	if (state == PM_SUSPEND_STANDBY && (sleep_modes & FSL_SLEEP))
>  		return 1;
>  
> +	if (state == PM_SUSPEND_MEM && (sleep_modes & FSL_DEEP_SLEEP))
> +		return 1;
> +
>  	return 0;
>  }
>  
> +static int qoriq_suspend_begin(suspend_state_t state)
> +{
> +	if (state == PM_SUSPEND_MEM)
> +		return fsl_dp_iomap();
> +
> +	return 0;
> +}
> +
> +static void qoriq_suspend_end(void)
> +{
> +	fsl_dp_iounmap();
> +}
> +
>  static const struct platform_suspend_ops qoriq_suspend_ops = {
>  	.valid = qoriq_suspend_valid,
>  	.enter = qoriq_suspend_enter,
> +	.begin = qoriq_suspend_begin,
> +	.end = qoriq_suspend_end,
>  };
>  
>  static int __init qoriq_suspend_init(void)
> @@ -71,6 +103,12 @@ static int __init qoriq_suspend_init(void)
>  	if (np)
>  		sleep_pm_state = PLAT_PM_LPM20;
>  
> +	np = of_find_compatible_node(NULL, NULL, "fsl,t1040-rcpm");
> +	if (np) {
> +		fsl_enter_deepsleep = fsl_enter_epu_deepsleep;
> +		sleep_modes |= FSL_DEEP_SLEEP;
> +	}
> +
>  	suspend_set_ops(&qoriq_suspend_ops);
>  
>  	return 0;
> diff --git a/arch/powerpc/platforms/85xx/sleep.S b/arch/powerpc/platforms/85xx/sleep.S
> new file mode 100644
> index 0000000..95a5746
> --- /dev/null
> +++ b/arch/powerpc/platforms/85xx/sleep.S
> @@ -0,0 +1,295 @@
> +/*
> + * Implement the low level part of deep sleep
> + *
> + * Copyright 2014 Freescale Semiconductor Inc.
> + *
> + * This program is free software; you can redistribute	it and/or modify it
> + * under  the terms of	the GNU General	 Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <asm/page.h>
> +#include <asm/ppc_asm.h>
> +#include <asm/reg.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/booke_save_regs.h>
> +#include <asm/mmu.h>
> +
> +#define FSLDELAY(count)		\
> +	li	r3, (count)@l;	\
> +	slwi	r3, r3, 10;	\
> +	mtctr	r3;		\
> +101:	nop;			\
> +	bdnz	101b;

You don't need a namespace prefix on local macros in a non-header file.

Is the timebase stopped where you're calling this from?

> +#define FSL_DIS_ALL_IRQ		\
> +	mfmsr	r8;			\
> +	rlwinm	r8, r8, 0, ~MSR_CE;	\
> +	rlwinm	r8, r8, 0, ~MSR_ME;	\
> +	rlwinm	r8, r8, 0, ~MSR_EE;	\
> +	rlwinm	r8, r8, 0, ~MSR_DE;	\
> +	mtmsr	r8;			\
> +	isync
> +
> +
> +	.section .data
> +	.align	6
> +booke_regs_buffer:
> +	.space REGS_BUFFER_SIZE
> +
> +	.section .txt
> +	.align 6
> +
> +_GLOBAL(fsl_dp_enter_low)
> +deepsleep_start:
> +	LOAD_REG_ADDR(r9, buf_tmp)
> +	PPC_STL	r3, 0(r9)
> +	PPC_STL	r4, 8(r9)
> +	PPC_STL	r5, 16(r9)
> +	PPC_STL	r6, 24(r9)
> +
> +	LOAD_REG_ADDR(r3, booke_regs_buffer)
> +	/* save the return address */
> +	mflr	r5
> +	PPC_STL r5, SR_LR(r3)
> +	mfmsr	r5
> +	PPC_STL r5, SR_MSR(r3)
> +	li	r4, DEEPSLEEP_FLAG
> +	bl	booke_cpu_state_save
> +
> +	LOAD_REG_ADDR(r9, buf_tmp)
> +	PPC_LL	r31, 0(r9)
> +	PPC_LL	r30, 8(r9)
> +	PPC_LL	r29, 16(r9)
> +	PPC_LL	r28, 24(r9)
> +
> +	/* flush caches */
> +	LOAD_REG_ADDR(r3, cur_cpu_spec)
> +	PPC_LL	r3, 0(r3)
> +	PPC_LL	r3, CPU_FLUSH_CACHES(r3)
> +	PPC_LCMPI  0, r3, 0
> +	beq	6f
> +#ifdef CONFIG_PPC64
> +	PPC_LL	r3, 0(r3)
> +#endif
> +	mtctr	r3
> +	bctrl
> +6:
> +#define CPC_OFFSET	0x10000
> +	mr	r3, r31
> +	addis	r3, r3, CPC_OFFSET@h
> +	bl	fsl_flush_cpc_cache
> +
> +	LOAD_REG_ADDR(r8, deepsleep_start)
> +	LOAD_REG_ADDR(r9, deepsleep_end)
> +
> +	/* prefecth TLB */
> +#define CCSR_GPIO1_GPDAT	0x130008
> +#define CCSR_GPIO1_GPDAT_29	0x4
> +	LOAD_REG_IMMEDIATE(r11, CCSR_GPIO1_GPDAT)
> +	add	r11, r31, r11
> +	lwz	r10, 0(r11)
> +
> +#define CCSR_RCPM_PCPH15SETR	0xe20b4
> +#define CCSR_RCPM_PCPH15SETR_CORE0	0x1
> +	LOAD_REG_IMMEDIATE(r12, CCSR_RCPM_PCPH15SETR)
> +	add	r12, r31, r12
> +	lwz	r10, 0(r12)
> +
> +#define CCSR_DDR_SDRAM_CFG_2	0x8114
> +#define CCSR_DDR_SDRAM_CFG_2_FRC_SR	0x80000000
> +	LOAD_REG_IMMEDIATE(r13, CCSR_DDR_SDRAM_CFG_2)
> +	add	r13, r31, r13
> +	lwz	r10, 0(r13)
> +
> +#define	DCSR_EPU_EPGCR		0x000
> +#define DCSR_EPU_EPGCR_GCE	0x80000000
> +	li	r14, DCSR_EPU_EPGCR
> +	add	r14, r30, r14
> +	lwz	r10, 0(r14)
> +
> +#define	DCSR_EPU_EPECR15	0x33C
> +#define DCSR_EPU_EPECR15_IC0	0x80000000
> +	li	r15, DCSR_EPU_EPECR15
> +	add	r15, r30, r15
> +	lwz	r10, 0(r15)
> +
> +#define CCSR_SCFG_QMCRDTRSTCR		0xfc40c
> +#define CCSR_SCFG_QMCRDTRSTCR_CRDTRST	0x80000000
> +	LOAD_REG_IMMEDIATE(r16, CCSR_SCFG_QMCRDTRSTCR)
> +	add	r16, r31, r16
> +	lwz	r10, 0(r16)
> +
> +/*
> + * There are two kind of register maps, one for CPLD and the other for FPGA
> + */
> +#define CPLD_MISCCSR		0x17
> +#define CPLD_MISCCSR_SLEEPEN	0x40
> +#define QIXIS_PWR_CTL2		0x21
> +#define QIXIS_PWR_CTL2_PCTL	0x2
> +	PPC_LCMPI  0, r28, FPGA_FLAG
> +	beq	20f
> +	addi	r29, r29, CPLD_MISCCSR
> +20:
> +	addi	r29, r29, QIXIS_PWR_CTL2
> +	lbz	r10, 0(r29)


Again, this is not marked as a board-specific file.  How do you expect
customers to adapt this mechanism to their boards?

> +
> +	/* prefecth code to cache so that executing code after disable DDR */
> +1:	lwz	r3, 0(r8)
> +	addi	r8, r8, 4
> +	cmpw	r8, r9
> +	blt	1b
> +	msync

Instructions don't execute from dcache...  I guess you're assuming it
will allocate in, and stay in, L2/CPC.  It'd be safer to lock those
cache lines in icache, or copy the code to SRAM.

> +	FSL_DIS_ALL_IRQ
> +
> +	/*
> +	 * Place DDR controller in self refresh mode.
> +	 * From here on, DDR can't be access any more.
> +	 */
> +	lwz	r10, 0(r13)
> +	oris	r10, r10, CCSR_DDR_SDRAM_CFG_2_FRC_SR@h
> +	stw	r10, 0(r13)
> +
> +	/* can't call udelay() here, so use a macro to delay */
> +	FSLDELAY(50)

A timebase loop doesn't require accessing DDR.

You also probably want to do a "sync, readback, data dependency, isync"
sequence to make sure that the store has hit CCSR before you begin your
delay (or is a delay required at all if you do that?).

> +	/*
> +	 * Enable deep sleep signals by write external CPLD/FPGA register.
> +	 * The bootloader will disable them when wakeup from deep sleep.
> +	 */
> +	lbz	r10, 0(r29)
> +	PPC_LCMPI  0, r28, FPGA_FLAG
> +	beq	22f
> +	ori	r10, r10, CPLD_MISCCSR_SLEEPEN
> +22:
> +	ori	r10, r10, QIXIS_PWR_CTL2_PCTL
> +	stb	r10, 0(r29)
> +
> +	/*
> +	 * Set GPIO1_29 to lock the signal MCKE down during deep sleep.
> +	 * The bootloader will clear it when wakeup.
> +	 */
> +	lwz	r10, 0(r11)
> +	ori	r10, r10, CCSR_GPIO1_GPDAT_29
> +	stw	r10, 0(r11)
> +
> +	FSLDELAY(10)
> +
> +	/* Clear the QMan CITI Credits */
> +	lwz	r10, 0(r16)
> +	oris	r10, r10, CCSR_SCFG_QMCRDTRSTCR_CRDTRST@h
> +	stw	r10, 0(r16)
> +
> +	/* Enable all EPU Counters */
> +	li	r10, 0
> +	oris	r10, r10, DCSR_EPU_EPGCR_GCE@h
> +	stw	r10, 0(r14)
> +
> +	/* Enable SCU15 to trigger on RCPM Concentrator 0 */
> +	lwz	r10, 0(r15)
> +	oris	r10, r10, DCSR_EPU_EPECR15_IC0@h
> +	stw	r10, 0(r15)
> +
> +	/* put Core0 in PH15 mode, trigger EPU FSM */
> +	lwz	r10, 0(r12)
> +	ori	r10, r10, CCSR_RCPM_PCPH15SETR_CORE0
> +	stw	r10, 0(r12)

Shouldn't there be a sync to ensure that the previous I/O happens before
the final store to enter PH15?

-Scott


