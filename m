Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab3CEBTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:19:00 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:46316 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969Ab3CEBS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:18:58 -0500
MIME-Version: 1.0
In-Reply-To: <1362216854-6633-1-git-send-email-amit.daniel@samsung.com>
References: <1362216854-6633-1-git-send-email-amit.daniel@samsung.com>
Date: Tue, 5 Mar 2013 09:18:57 +0800
Message-ID: <CAKohpomHoDSNVyc21VVif8BrDKyZ=fSeCnWCZjDHL+64Bo+dgg@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] cpufreq: exynos: Adding cpufreq driver for exynos5440
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 March 2013 15:04, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> This patch adds dvfs support for exynos5440 SOC. This soc has 4 cores and
> they run at same frequency. The nature of exynos5440 clock controller is
> different from previous exynos controllers so not using the common exynos
> cpufreq framework. The major difference being interrupt notfication for
> frequency change. Also, OPP library is used for device tree parsing to get
> different parameters like frequency, voltage etc. Since the opp library sorts
> the frequency table in ascending order so they are again re-arranged in
> descending order. This will have one-to-one mapping with the clock controller
> state management logic.
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
> Changes in V2:
> * Added OPP library support to parse DT parameters.
> * Removed a hack to handle interrupts in bootup.
> * Added many review comments from Viresh and Inder.

Added? Thanks :)

>
> All these patches are dependent on Thomas Abraham common clock patches.
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg15860.html
>
>  .../bindings/cpufreq/cpufreq-exynos5440.txt        |   32 ++
>  drivers/cpufreq/Kconfig.arm                        |    9 +
>  drivers/cpufreq/Makefile                           |    1 +
>  drivers/cpufreq/exynos5440-cpufreq.c               |  450 ++++++++++++++++++++
>  4 files changed, 492 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
>  create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c
>
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
> new file mode 100644
> index 0000000..caa3f8d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
> @@ -0,0 +1,32 @@
> +
> +Exynos5440 cpufreq driver
> +-------------------
> +
> +Exynos5440 SoC cpufreq driver for CPU frequency scaling.
> +
> +Required properties:
> +- interrupts: Interrupt to know the completion of cpu frequency change.
> +- operating-points: Table of frequencies and voltage CPU could be transitioned into,
> +       in the decreasing order. Frequency should be in KHZ units and voltage
> +       should be in microvolts.
> +- clocks: phandle of the clock from common clock binding. More description can
> +       be found in Documentation/devicetree/bindings/clock/clock-bindings.txt.
> +
> +Optional properties:
> +- clock-latency: Clock transition latency in microsecond.
> +
> +All the required listed above must be defined under node cpufreq.
> +
> +Example:
> +--------
> +       cpufreq@160000 {
> +               compatible = "samsung,exynos5440-cpufreq";
> +               reg = <0x160000 0x1000>;
> +               interrupts = <0 57 0>;
> +               operating-points = <
> +                               1000000 975000
> +                               800000  925000>;
> +               clocks = <&clock 2>;
> +               clock-latency = <100000>;
> +       };
> +
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 030ddf6..7ed9c4a 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -77,6 +77,15 @@ config ARM_EXYNOS5250_CPUFREQ
>           This adds the CPUFreq driver for Samsung EXYNOS5250
>           SoC.
>
> +config ARM_EXYNOS5440_CPUFREQ
> +       def_bool SOC_EXYNOS5440
> +       depends on HAVE_CLK && PM_OPP && OF
> +       help
> +         This adds the CPUFreq driver for Samsung EXYNOS5440
> +         SoC. The nature of exynos5440 clock controller is
> +         different than previous exynos controllers so not using
> +         the common exynos framework.
> +
>  config ARM_KIRKWOOD_CPUFREQ
>         def_bool ARCH_KIRKWOOD && OF
>         help
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 863fd18..c841438 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -52,6 +52,7 @@ obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)      += exynos-cpufreq.o
>  obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)   += exynos4210-cpufreq.o
>  obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)   += exynos4x12-cpufreq.o
>  obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)   += exynos5250-cpufreq.o
> +obj-$(CONFIG_ARM_EXYNOS5440_CPUFREQ)   += exynos5440-cpufreq.o
>  obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)     += kirkwood-cpufreq.o
>  obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)    += omap-cpufreq.o
>  obj-$(CONFIG_ARM_SPEAR_CPUFREQ)                += spear-cpufreq.o
> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> new file mode 100644
> index 0000000..2dc43b1
> --- /dev/null
> +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> @@ -0,0 +1,450 @@
> +/*
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * Amit Daniel Kachhap <amit.daniel@samsung.com>
> + *
> + * EXYNOS5440 - CPU frequency scaling support
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/

Add following here to get better prints from the driver:

#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt

> +
> +#include <linux/clk.h>
> +#include <linux/cpu.h>
> +#include <linux/cpufreq.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>

Probably include of.h instead of above two?

> +#include <linux/opp.h>
> +#include <linux/slab.h>
> +

> +struct exynos_dvfs_data {
> +       void __iomem *base;
> +       struct resource *mem;
> +       int irq;
> +       struct clk *cpu_clk;
> +       unsigned int cur_frequency;
> +       unsigned int latency;
> +       struct cpufreq_frequency_table *freq_table;
> +       unsigned int freq_count;
> +       struct device *dev;
> +       struct work_struct irq_work;
> +};
> +
> +static struct exynos_dvfs_data *dvfs_info;
> +static DEFINE_MUTEX(cpufreq_lock);
> +static struct cpufreq_freqs freqs;
> +
> +static int init_div_table(void)
> +{
> +       struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
> +       unsigned int tmp, clk_div, ema_div, freq, volt_id;
> +       int i = 0;
> +       struct opp *opp;
> +
> +       for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
> +
> +               opp = opp_find_freq_exact(dvfs_info->dev,
> +                                       freq_tbl[i].frequency * 1000, true);
> +               if (IS_ERR(opp)) {
> +                       pr_err("failed to find valid OPP for %u KHZ\n",
> +                                       freq_tbl[i].frequency);
> +                       return PTR_ERR(opp);
> +               }
> +
> +               freq = freq_tbl[i].frequency / 1000; /*In MHZ*/
> +               clk_div = ((freq / CPU_DIV_FREQ_MAX) & P0_7_CPUCLKDEV_MASK)
> +                                       << P0_7_CPUCLKDEV_SHIFT;
> +               clk_div |= ((freq / CPU_ATB_FREQ_MAX) & P0_7_ATBCLKDEV_MASK)
> +                                       << P0_7_ATBCLKDEV_SHIFT;
> +               clk_div |= ((freq / CPU_DBG_FREQ_MAX) & P0_7_CSCLKDEV_MASK)
> +                                       << P0_7_CSCLKDEV_SHIFT;
> +
> +               /*Calculate EMA*/
> +               volt_id = opp_get_voltage(opp);
> +               volt_id = (MAX_VOLTAGE - volt_id) / VOLTAGE_STEP;
> +               if (volt_id < PMIC_HIGH_VOLT) {
> +                       ema_div = (CPUEMA_HIGH << P0_7_CPUEMA_SHIFT) |
> +                               (L2EMA_HIGH << P0_7_L2EMA_SHIFT);
> +               } else if (volt_id > PMIC_LOW_VOLT) {
> +                       ema_div = (CPUEMA_LOW << P0_7_CPUEMA_SHIFT) |
> +                               (L2EMA_LOW << P0_7_L2EMA_SHIFT);
> +               } else {
> +                       ema_div = (CPUEMA_MID << P0_7_CPUEMA_SHIFT) |
> +                               (L2EMA_MID << P0_7_L2EMA_SHIFT);
> +               }
> +
> +               tmp = (clk_div | ema_div | (volt_id << P0_7_VDD_SHIFT)
> +                       | ((freq / FREQ_UNIT) << P0_7_FREQ_SHIFT));
> +
> +               __raw_writel(tmp, dvfs_info->base + XMU_PMU_P0_7 + 4 * i);
> +       }
> +
> +       return 0;
> +}
> +
> +void exynos_enable_dvfs(void)
> +{
> +       unsigned int tmp, i, cpu;
> +       struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
> +       /*Disable DVFS*/

Please give space after /* and before */ all over your driver.

> +       __raw_writel(0, dvfs_info->base + XMU_DVFS_CTRL);
> +
> +       /*Enable PSTATE Change Event*/
> +       tmp = __raw_readl(dvfs_info->base + XMU_PMUEVTEN);
> +       tmp |= (1 << PSTATE_CHANGED_EVTEN_SHIFT);
> +        __raw_writel(tmp, dvfs_info->base + XMU_PMUEVTEN);
> +
> +       /Enable* PSTATE Change IRQ*/
> +       tmp = __raw_readl(dvfs_info->base + XMU_PMUIRQEN);
> +       tmp |= (1 << PSTATE_CHANGED_IRQEN_SHIFT);
> +        __raw_writel(tmp, dvfs_info->base + XMU_PMUIRQEN);
> +
> +       /*Set initial performance index*/
> +       for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
> +               if (freq_table[i].frequency == dvfs_info->cur_frequency)
> +                       break;
> +
> +       if (freq_table[i].frequency == CPUFREQ_TABLE_END) {
> +               pr_crit("Boot up frequency not supported\n");
> +               /*Assign the highest frequency*/
> +               i = 0;
> +               dvfs_info->cur_frequency = freq_table[i].frequency;
> +       }
> +
> +       pr_info("Setting dvfs initial frequency = %u",
> +                                               dvfs_info->cur_frequency);
> +
> +       for (cpu = 0; cpu < CONFIG_NR_CPUS; cpu++) {
> +               tmp = __raw_readl(dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
> +               tmp &= ~(P_VALUE_MASK << C0_3_PSTATE_NEW_SHIFT);
> +               tmp |= (i << C0_3_PSTATE_NEW_SHIFT);
> +               __raw_writel(tmp, dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
> +       }
> +
> +       /*Enable DVFS*/
> +       __raw_writel(1 << XMU_DVFS_CTRL_EN_SHIFT,
> +                               dvfs_info->base + XMU_DVFS_CTRL);
> +}
> +
> +static int exynos_verify_speed(struct cpufreq_policy *policy)
> +{
> +       return cpufreq_frequency_table_verify(policy,
> +                                             dvfs_info->freq_table);
> +}
> +
> +static unsigned int exynos_getspeed(unsigned int cpu)
> +{
> +       return dvfs_info->cur_frequency;
> +}
> +
> +static int exynos_target(struct cpufreq_policy *policy,
> +                         unsigned int target_freq,
> +                         unsigned int relation)
> +{
> +       unsigned int index, tmp;
> +       int ret = 0, i;
> +       struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
> +
> +       mutex_lock(&cpufreq_lock);
> +       freqs.old = dvfs_info->cur_frequency;
> +
> +       if (cpufreq_frequency_table_target(policy, freq_table,
> +                                          target_freq, relation, &index)) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       freqs.new = freq_table[index].frequency;
> +       freqs.cpu = policy->cpu;
> +
> +       for_each_cpu(freqs.cpu, policy->cpus)
> +               cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
> +
> +       /*Set the target frequency in all C0_3_PSTATE register*/
> +       for_each_cpu(i, policy->cpus) {
> +               tmp = __raw_readl(dvfs_info->base + XMU_C0_3_PSTATE + i * 4);
> +               tmp &= ~(P_VALUE_MASK << C0_3_PSTATE_NEW_SHIFT);
> +               tmp |= (index << C0_3_PSTATE_NEW_SHIFT);
> +
> +               __raw_writel(tmp, dvfs_info->base + XMU_C0_3_PSTATE + i * 4);
> +       }
> +out:
> +       mutex_unlock(&cpufreq_lock);
> +       return ret;
> +}
> +
> +static void exynos_cpufreq_work(struct work_struct *work)
> +{
> +       unsigned int cur_pstate, index;
> +       struct cpufreq_policy *policy = cpufreq_cpu_get(0); /* boot CPU */
> +       struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
> +
> +       if (policy == NULL)
> +               goto skip_work;

How can that be true? And if it can be, you will miss POSTCHANGE notifications
too.

> +       mutex_lock(&cpufreq_lock);
> +       freqs.old = dvfs_info->cur_frequency;
> +
> +       cur_pstate = __raw_readl(dvfs_info->base + XMU_P_STATUS);
> +       if (cur_pstate >> C0_3_PSTATE_VALID_SHIFT & 0x1)
> +               index = (cur_pstate >> C0_3_PSTATE_CURR_SHIFT) & P_VALUE_MASK;
> +       else
> +               index = (cur_pstate >> C0_3_PSTATE_NEW_SHIFT) & P_VALUE_MASK;
> +
> +       if (index < dvfs_info->freq_count) {

What if index is greater than count? That's a problem, isn't it?

> +               freqs.new = freq_table[index].frequency;
> +               for_each_cpu(freqs.cpu, policy->cpus)
> +                       cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
> +               dvfs_info->cur_frequency = freqs.new;
> +       }
> +
> +       cpufreq_cpu_put(policy);
> +       mutex_unlock(&cpufreq_lock);
> +skip_work:
> +       enable_irq(dvfs_info->irq);
> +}
> +
> +static irqreturn_t exynos_cpufreq_irq(int irq, void *id)
> +{
> +       unsigned int tmp;
> +
> +       tmp = __raw_readl(dvfs_info->base + XMU_PMUIRQ);
> +       if (tmp >> PSTATE_CHANGED_SHIFT & 0x1) {
> +               __raw_writel(tmp, dvfs_info->base + XMU_PMUIRQ);
> +               disable_irq_nosync(irq);
> +               schedule_work(&dvfs_info->irq_work);
> +       }
> +       return IRQ_HANDLED;
> +}
> +
> +static void exynos_sort_descend_freq_table(void)
> +{
> +       struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
> +       int i = 0, index;
> +       unsigned int tmp_freq;
> +
> +       /*
> +        *Freq table is already in ascending order as it is created from

You need space after * here too :)

> +        *OPP library, so just swap the elements to make it descending.
> +        */
> +       for (i = 0; i < dvfs_info->freq_count / 2; i++) {
> +               index = dvfs_info->freq_count - i - 1;
> +               tmp_freq = freq_tbl[i].frequency;
> +               freq_tbl[i].frequency = freq_tbl[index].frequency;
> +               freq_tbl[index].frequency = tmp_freq;
> +       }
> +}
> +
> +static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
> +{
> +
> +       policy->cur = dvfs_info->cur_frequency;
> +       cpufreq_frequency_table_get_attr(dvfs_info->freq_table, policy->cpu);
> +
> +       /* set the transition latency value */
> +       policy->cpuinfo.transition_latency = dvfs_info->latency;
> +
> +       cpumask_setall(policy->cpus);
> +
> +       return cpufreq_frequency_table_cpuinfo(policy, dvfs_info->freq_table);
> +}
> +
> +static struct cpufreq_driver exynos_driver = {
> +       .flags          = CPUFREQ_STICKY,
> +       .verify         = exynos_verify_speed,
> +       .target         = exynos_target,
> +       .get            = exynos_getspeed,
> +       .init           = exynos_cpufreq_cpu_init,
> +       .name           = DRIVER_NAME,
> +};
> +
> +static int __init exynos_cpufreq_init(void)

probably calling it probe might make more sense?

> +{
> +       int ret = -EINVAL;
> +       struct device_node *np;
> +
> +       np =  of_find_compatible_node(NULL, NULL, "samsung,exynos5440-cpufreq");
> +       if (IS_ERR(np))

!np ??

> +               return -ENODEV;
> +
> +       dvfs_info = kzalloc(sizeof(struct exynos_dvfs_data), GFP_KERNEL);

sizeof(*dvfs_info) ??

> +       if (IS_ERR(dvfs_info)) {

IS_ERR_OR_NULL? But i believe kzalloc only returns NULL to show error, so
you may end up using if(!dvfs_info)

> +               ret = -ENOMEM;
> +               goto err_mem_data;
> +       }
> +
> +       dvfs_info->base = of_iomap(np, 0);
> +       if (IS_ERR(dvfs_info->base)) {

same here too..

> +               pr_err("No cpufreq memory map found\n");
> +               ret = -ENODEV;
> +               goto err_map;
> +       }
> +
> +       dvfs_info->irq = irq_of_parse_and_map(np, 0);
> +

can remove blank line.

> +       if (dvfs_info->irq == 0) {
> +               pr_err("No cpufreq irq found\n");
> +               ret = -ENODEV;
> +               goto err_irq_parse;
> +       }
> +
> +       dvfs_info->dev = get_cpu_device(0);

What about using this dev instance to call devm_*** routines everywhere in init.

> +       if (IS_ERR(dvfs_info->dev)) {
> +               pr_err("failed to get cpu0 device\n");
> +               ret = -ENODEV;
> +               goto err_irq_parse;
> +       }
> +
> +       dvfs_info->dev->of_node = np;

So you are setting cpufreq node as node of cpu, I don't know if this is a
good idea. In that case it would be better to create the cpu node instead
and put the table into it.

> +       ret = of_init_opp_table(dvfs_info->dev);
> +       if (ret) {
> +               pr_err("failed to init OPP table: %d\n", ret);
> +               goto err_irq_parse;
> +       }
> +
> +       ret = opp_init_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
> +       if (ret) {
> +               pr_err("failed to init cpufreq table: %d\n", ret);
> +               goto err_irq_parse;
> +       }
> +       dvfs_info->freq_count = opp_get_opp_count(dvfs_info->dev);
> +       exynos_sort_descend_freq_table();
> +
> +       if (of_property_read_u32(np, "clock-latency", &dvfs_info->latency))
> +               dvfs_info->latency = DEF_TRANS_LATENCY;
> +
> +       dvfs_info->cpu_clk = of_clk_get(np, 0);
> +       if (IS_ERR(dvfs_info->cpu_clk)) {
> +               pr_err("Failed to get cpu clock\n");
> +               ret = PTR_ERR(dvfs_info->cpu_clk);
> +               goto err_clk_get;
> +       }
> +
> +       dvfs_info->cur_frequency = clk_get_rate(dvfs_info->cpu_clk);
> +       if (!dvfs_info->cur_frequency) {
> +               pr_err("Failed to get clock rate\n");
> +               ret = -EINVAL;
> +               goto err_clk_get_rate;
> +       }
> +       dvfs_info->cur_frequency /= 1000;
> +
> +       INIT_WORK(&dvfs_info->irq_work, exynos_cpufreq_work);
> +       if (request_irq(dvfs_info->irq, exynos_cpufreq_irq,
> +                               IRQF_TRIGGER_NONE, DRIVER_NAME, dvfs_info)) {
> +               pr_err("Failed to register IRQ\n");
> +               ret = -ENODEV;
> +               goto err_clk_get_rate;
> +       }
> +
> +       ret = init_div_table();
> +       if (ret) {
> +               pr_err("Failed to initialise div table\n");

s/initialise/initialize

> +               goto err_div_table;
> +       }
> +
> +       exynos_enable_dvfs();
> +       ret = cpufreq_register_driver(&exynos_driver);
> +       if (ret) {
> +               pr_err("%s: failed to register cpufreq driver\n", __func__);
> +               goto err_div_table;
> +       }
> +
> +       of_node_put(np);
> +
> +       pr_info("exynos5440 DVFS initialised.\n");
> +
> +       return 0;
> +
> +err_div_table:
> +       free_irq(dvfs_info->irq, dvfs_info);
> +err_clk_get_rate:
> +       clk_put(dvfs_info->cpu_clk);
> +err_clk_get:
> +       opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
> +err_irq_parse:
> +       iounmap(dvfs_info->base);
> +err_map:
> +       kfree(dvfs_info);
> +err_mem_data:
> +       of_node_put(np);
> +       pr_err("%s: failed initialization\n", __func__);
> +       return ret;
> +}
> +late_initcall(exynos_cpufreq_init);
> --
> 1.7.1
>
