Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbbATHGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:06:19 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:38374 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbbATHGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:06:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokoS9UiwuuzzAs=1RCaAkBpVDK_AVNNGe7VCe=7SScmnw@mail.gmail.com>
References: <1420797291-15972-1-git-send-email-pi-cheng.chen@linaro.org>
	<1420797291-15972-3-git-send-email-pi-cheng.chen@linaro.org>
	<CAKohpokoS9UiwuuzzAs=1RCaAkBpVDK_AVNNGe7VCe=7SScmnw@mail.gmail.com>
Date: Tue, 20 Jan 2015 15:06:15 +0800
Message-ID: <CALx668VdmCgvJzGhm5Nmxdms221v++x0CB0DAj67mmLmoYEZFA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: add cpufreq driver for Mediatek MT8173 SoC
From: Pi-Cheng Chen <pi-cheng.chen@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Thanks for reviewing.

On 19 January 2015 at 18:42, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 9 January 2015 at 15:24, pi-cheng.chen <pi-cheng.chen@linaro.org> wrote:
>> When doing DVFS on MT8173 SoC, 2 rules should be followed to make sure the
>> SoC works properly:
>> 1. When doing frequency scaling of CPUs, the clock source should be switched
>>    to another PLL, then switched back to the orignal until it's stable.
>> 2. When doing voltage scaling of CA57 cluster, Vproc and Vsram need to be
>>    controlled concurrently and 2 limitations should be followed:
>>    a. Vsram > Vproc
>>    b. Vsram - Vproc < 200 mV
>>
>> To address these needs, we reuse cpufreq-dt but do voltage scaling in the
>> cpufreq notifier.
>
> I haven't understood how is all this working..
> - How are you switching to intermediate freq when its support isn't there
> in cpufreq-dt.
> - How is changing of volt after switching to freq working? Specially when freq
> is higher than older freq and it requires changing of voltage before freq..
>

I was trying to switch clock source to the intermediate clock in the
pre-notitifer
and post-notifier by calling the function cpuclk_mux_set defined below and I
understand it's not a goood idea. I will try to work on adding
intermediate freqs
suppport in cpufreq-dt so that it will also greatly reduce the
complexity of this
driver.

Voltage changing was also handled in pre-notifier and post-notifier. Please see
below.

>>
>> Signed-off-by: pi-cheng.chen <pi-cheng.chen@linaro.org>
>> ---
>>  drivers/cpufreq/Kconfig.arm      |   6 +
>>  drivers/cpufreq/Makefile         |   1 +
>>  drivers/cpufreq/mt8173-cpufreq.c | 459 +++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 466 insertions(+)
>>  create mode 100644 drivers/cpufreq/mt8173-cpufreq.c
>>
>> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
>> index 0f9a2c3..97ed7dd 100644
>> --- a/drivers/cpufreq/Kconfig.arm
>> +++ b/drivers/cpufreq/Kconfig.arm
>> @@ -255,3 +255,9 @@ config ARM_PXA2xx_CPUFREQ
>>           This add the CPUFreq driver support for Intel PXA2xx SOCs.
>>
>>           If in doubt, say N.
>> +
>> +config ARM_MT8173_CPUFREQ
>> +       bool "Mediatek MT8173 CPUFreq support"
>> +       depends on ARCH_MEDIATEK && CPUFREQ_DT && REGULATOR
>> +       help
>> +         This adds the CPUFreq driver support for Mediatek MT8173 SoC.
>> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
>> index b3ca7b0..67b7f17 100644
>> --- a/drivers/cpufreq/Makefile
>> +++ b/drivers/cpufreq/Makefile
>> @@ -76,6 +76,7 @@ obj-$(CONFIG_ARM_SA1110_CPUFREQ)      += sa1110-cpufreq.o
>>  obj-$(CONFIG_ARM_SPEAR_CPUFREQ)                += spear-cpufreq.o
>>  obj-$(CONFIG_ARM_TEGRA_CPUFREQ)                += tegra-cpufreq.o
>>  obj-$(CONFIG_ARM_VEXPRESS_SPC_CPUFREQ) += vexpress-spc-cpufreq.o
>> +obj-$(CONFIG_ARM_MT8173_CPUFREQ)       += mt8173-cpufreq.o
>
> Add this in alphanumeric order please.
>

Will fix it.

>>
>>  ##################################################################################
>>  # PowerPC platform drivers
>> diff --git a/drivers/cpufreq/mt8173-cpufreq.c b/drivers/cpufreq/mt8173-cpufreq.c
>> new file mode 100644
>> index 0000000..b578c10
>> --- /dev/null
>> +++ b/drivers/cpufreq/mt8173-cpufreq.c
>> @@ -0,0 +1,459 @@
>> +/*
>> +* Copyright (c) 2015 Linaro.
>> +* Author: Pi-Cheng Chen <pi-cheng.chen@linaro.org>
>> +*
>> +* This program is free software; you can redistribute it and/or modify
>> +* it under the terms of the GNU General Public License version 2 as
>> +* published by the Free Software Foundation.
>> +*
>> +* This program is distributed in the hope that it will be useful,
>> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +* GNU General Public License for more details.
>> +*/
>> +
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/cpufreq.h>
>> +#include <linux/cpufreq-dt.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/slab.h>
>> +#include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>
> This driver isn't a clock provider, right? Then why are
> you including this file?
>

I included this file because I was using __clk_lookup to get the
intermediate clk and I just realize it is not a right way.
Thank Mike for pointing me out the right API to do it.
Will fix it.

>> +#include <linux/regulator/consumer.h>
>> +#include <linux/cpu.h>
>> +#include <linux/pm_opp.h>
>
> keep them in alphanumeric order please.
>

Will fix it.

>> +
>> +#define CPUCLK_MUX_ARMPLL      0x1
>> +#define CPUCLK_MUX_MAINPLL     0x2
>> +#define VOLT_SHIFT_LIMIT       150000
>> +
>> +enum {
>> +       LITTLE_CLUSTER = 0,
>> +       BIG_CLUSTER,
>> +       NR_CLUSTERS
>> +};
>> +
>> +static struct cluster_dvfs_info {
>> +       int cpu;
>> +       struct cpumask cpus;
>> +       struct device *cpu_dev;
>> +       struct regulator *proc_reg;
>> +       struct regulator *sram_reg;
>> +       int inter_volt;
>> +       u32 volt_tol;
>> +} *dvfs_info;
>> +
>> +static unsigned long mainpll_freq;
>> +static void __iomem *clk_mux_regs;
>> +static spinlock_t lock;
>> +
>> +static void cpuclk_mux_set(int cluster, u32 sel)
>> +{
>> +       u32 val;
>> +       u32 mask = 0x3;
>> +
>> +       if (cluster == BIG_CLUSTER) {
>> +               mask <<= 2;
>> +               sel <<= 2;
>> +       }
>> +
>> +       spin_lock(&lock);
>> +
>> +       val = readl(clk_mux_regs);
>> +       val = (val & ~mask) | sel;
>> +       writel(val, clk_mux_regs);
>> +
>> +       spin_unlock(&lock);
>> +}
>> +
>> +static int mt8173_cpufreq_voltage_step(struct cluster_dvfs_info *dvfs,
>> +                                      unsigned long old_vproc,
>> +                                      unsigned long new_vproc)
>> +{
>> +       int cur_vsram, cur_vproc, target_volt, tol;
>> +
>> +       if (old_vproc > new_vproc) {
>> +               while (1) {
>> +                       cur_vsram = regulator_get_voltage(dvfs->sram_reg);
>> +                       if (cur_vsram - new_vproc < VOLT_SHIFT_LIMIT &&
>> +                           cur_vsram > new_vproc) {
>> +                               tol = new_vproc * dvfs->volt_tol / 100;
>> +                               regulator_set_voltage_tol(dvfs->proc_reg,
>> +                                                         new_vproc, tol);
>> +                               break;
>> +                       }
>> +
>> +                       target_volt = cur_vsram - VOLT_SHIFT_LIMIT;
>> +                       tol = target_volt * dvfs->volt_tol / 100;
>> +                       regulator_set_voltage_tol(dvfs->proc_reg, target_volt,
>> +                                                 tol);
>> +
>> +                       cur_vproc = regulator_get_voltage(dvfs->proc_reg);
>> +                       target_volt = cur_vproc + 1;
>> +                       tol = target_volt * dvfs->volt_tol / 100;
>> +                       regulator_set_voltage_tol(dvfs->sram_reg, target_volt,
>> +                                                 tol);
>> +               }
>> +       } else if (old_vproc < new_vproc) {
>> +               while (1) {
>> +                       cur_vsram = regulator_get_voltage(dvfs->sram_reg);
>> +                       if (cur_vsram - new_vproc < VOLT_SHIFT_LIMIT &&
>> +                           cur_vsram > new_vproc) {
>> +                               tol = new_vproc * dvfs->volt_tol / 100;
>> +                               regulator_set_voltage_tol(dvfs->proc_reg,
>> +                                                         new_vproc, tol);
>> +                               break;
>> +                       }
>> +
>> +                       cur_vproc = regulator_get_voltage(dvfs->proc_reg);
>> +                       target_volt = cur_vproc + VOLT_SHIFT_LIMIT;
>> +                       tol = target_volt * dvfs->volt_tol / 100;
>> +                       regulator_set_voltage_tol(dvfs->sram_reg, target_volt,
>> +                                                 tol);
>> +
>> +                       if (new_vproc - cur_vproc > VOLT_SHIFT_LIMIT) {
>> +                               cur_vsram = regulator_get_voltage(
>> +                                                       dvfs->sram_reg);
>> +                               target_volt = cur_vsram - 1;
>> +                               tol = target_volt * dvfs->volt_tol / 100;
>> +                               regulator_set_voltage_tol(dvfs->proc_reg,
>> +                                                         target_volt, tol);
>> +                       }
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int get_opp_voltage(struct device *dev, unsigned long freq_hz)
>> +{
>> +       struct dev_pm_opp *opp;
>> +       int volt;
>> +
>> +       rcu_read_lock();
>> +       opp = dev_pm_opp_find_freq_ceil(dev, &freq_hz);
>> +       if (IS_ERR(opp)) {
>> +               rcu_read_unlock();
>> +               pr_err("%s: failed to find OPP for %lu\n", __func__, freq_hz);
>> +               return PTR_ERR(opp);
>> +       }
>> +       volt = dev_pm_opp_get_voltage(opp);
>> +       rcu_read_unlock();
>> +
>> +       return volt;
>> +}
>> +
>> +static int mt8173_cpufreq_get_intermediate_voltage(int cluster)
>> +{
>> +       struct cluster_dvfs_info *dvfs = &dvfs_info[cluster];
>> +
>> +       if (dvfs->inter_volt == 0)
>> +               dvfs->inter_volt = get_opp_voltage(dvfs->cpu_dev,
>> +                                                  mainpll_freq);
>> +
>> +       return dvfs->inter_volt;
>> +}
>> +
>> +static void mt8173_cpufreq_set_voltage(int cluster, int old_volt, int new_volt)
>> +{
>> +       struct cluster_dvfs_info *dvfs = &dvfs_info[cluster];
>> +       int ret = 0;
>> +
>> +       if (cluster == LITTLE_CLUSTER) {
>> +               int tol;
>> +
>> +               tol = new_volt * dvfs->volt_tol / 100;
>> +               ret = regulator_set_voltage_tol(dvfs->proc_reg, new_volt, tol);
>> +       } else {
>> +               ret = mt8173_cpufreq_voltage_step(dvfs, old_volt, new_volt);
>> +       }
>> +
>> +       if (ret)
>> +               pr_err("%s: cluster%d failed to scale voltage (%dmV to %dmV)",
>> +                      __func__, cluster, old_volt, new_volt);
>> +}
>> +
>> +static int mt8173_cpufreq_notify(struct notifier_block *nb,
>> +                                unsigned long action, void *data)
>> +{
>> +       struct cpufreq_freqs *freqs = data;
>> +       struct cluster_dvfs_info *dvfs;
>> +       unsigned long old_volt, new_volt, inter_volt;
>> +       int cluster;
>> +
>> +       if (freqs->cpu == dvfs_info[BIG_CLUSTER].cpu)
>
> You should check it against cpumask. freqs->cpu can change on the event
> of hotplug of CPUs.
>

Will fix it.

>> +               cluster = BIG_CLUSTER;
>> +       else if (freqs->cpu == dvfs_info[LITTLE_CLUSTER].cpu)
>> +               cluster = LITTLE_CLUSTER;
>> +       else
>> +               return NOTIFY_DONE;
>> +
>> +       dvfs = &dvfs_info[cluster];
>> +
>> +       old_volt = regulator_get_voltage(dvfs->proc_reg);
>> +
>> +       new_volt = get_opp_voltage(dvfs->cpu_dev, freqs->new * 1000);
>> +       inter_volt = mt8173_cpufreq_get_intermediate_voltage(cluster);
>> +
>> +       if (action == CPUFREQ_PRECHANGE) {
>> +               if (old_volt < inter_volt || old_volt < new_volt) {
>> +                       new_volt = inter_volt > new_volt ?
>> +                                  inter_volt : new_volt;
>> +                       mt8173_cpufreq_set_voltage(cluster, old_volt,
>> +                                                  new_volt);
>> +               }
>> +
>> +               cpuclk_mux_set(cluster, CPUCLK_MUX_MAINPLL);
>> +       } else if (action == CPUFREQ_POSTCHANGE) {
>> +               cpuclk_mux_set(cluster, CPUCLK_MUX_ARMPLL);
>> +
>> +               if (new_volt < old_volt)
>> +                       mt8173_cpufreq_set_voltage(cluster, old_volt,
>> +                                                  new_volt);
>> +       }
>> +

Here is the place I am handling voltage changing.

>> +       return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block mt8173_cpufreq_nb = {
>> +       .notifier_call = mt8173_cpufreq_notify,
>> +};
>> +
>> +static struct cpufreq_dt_platform_data *pd;
>> +
>> +static int cpu_in_domain_list(struct list_head *domain_list, int cpu)
>> +{
>> +       struct list_head *node;
>> +
>> +       list_for_each(node, domain_list) {
>> +               struct cpufreq_cpu_domain *domain;
>> +
>> +               domain = container_of(node, struct cpufreq_cpu_domain, node);
>> +               if (cpumask_test_cpu(cpu, &domain->cpus))
>> +                       return 1;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void cpufreq_dt_pdata_release(void)
>> +{
>> +       if (!pd)
>> +               return;
>> +
>> +       if (!list_empty(&pd->domain_list)) {
>> +               struct list_head *node, *tmp;
>> +               struct cpufreq_cpu_domain *domain;
>> +
>> +               list_for_each_safe(node, tmp, &pd->domain_list) {
>> +                       list_del(node);
>> +                       domain = container_of(node, struct cpufreq_cpu_domain,
>> +                                             node);
>> +                       kfree(domain);
>> +               }
>> +       }
>> +
>> +       kfree(pd);
>> +}
>> +
>> +static int cpufreq_dt_pdata_init(void)
>> +{
>> +       int cpu;
>> +
>> +       pd = kmalloc(sizeof(*pd), GFP_KERNEL);
>> +       if (!pd)
>> +               return -ENOMEM;
>> +
>> +       pd->independent_clocks = 1,
>> +       INIT_LIST_HEAD(&pd->domain_list);
>> +
>> +       for_each_possible_cpu(cpu) {
>> +               struct cpufreq_cpu_domain *new_domain;
>> +
>> +               if (cpu_in_domain_list(&pd->domain_list, cpu))
>> +                       continue;
>> +
>> +               new_domain = kzalloc(sizeof(*new_domain), GFP_KERNEL);
>> +               if (!new_domain) {
>> +                       cpufreq_dt_pdata_release();
>> +                       return -ENOMEM;
>> +               }
>> +
>> +               cpumask_copy(&new_domain->cpus,
>> +                            &cpu_topology[cpu].core_sibling);
>> +               list_add(&new_domain->node, &pd->domain_list);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void mt8173_cpufreq_dvfs_info_release(void)
>> +{
>> +       int i;
>> +
>> +       if (!dvfs_info)
>> +               return;
>> +
>> +       for (i = 0; i < NR_CLUSTERS; ++i) {
>> +               struct cluster_dvfs_info *dvfs = &dvfs_info[i];
>> +
>> +               if (!IS_ERR_OR_NULL(dvfs->proc_reg))
>> +                       regulator_put(dvfs->proc_reg);
>> +
>> +               if (!IS_ERR_OR_NULL(dvfs->sram_reg))
>> +                       regulator_put(dvfs->sram_reg);
>> +       }
>> +
>> +       if (clk_mux_regs)
>> +               iounmap(clk_mux_regs);
>> +}
>> +
>> +static int mt8173_cpufreq_dvfs_info_init(void)
>> +{
>> +       struct list_head *node;
>> +       struct device_node *np;
>> +       struct clk *mainpll;
>> +       int i, ret;
>> +
>> +       dvfs_info = kzalloc(sizeof(*dvfs) * NR_CLUSTERS, GFP_KERNEL);
>> +       if (!dvfs_info)
>> +               return -ENOMEM;
>> +
>> +       list_for_each(node, &pd->domain_list) {
>> +               struct cpufreq_cpu_domain *domain = container_of(
>> +                                       node, struct cpufreq_cpu_domain, node);
>> +               int cpu = cpumask_next(0, &domain->cpus);
>
> cpumask_first() ?
>

Yes. Will fix it.

>> +
>> +               np = of_get_cpu_node(cpu, NULL);
>
> This can fail..
>

I'll add error checking for this.

>> +
>> +               if (of_property_match_string(np, "compatible",
>> +                                            "arm,cortex-a53") >= 0)
>> +                       cpumask_copy(&dvfs_info[LITTLE_CLUSTER].cpus,
>> +                                    &domain->cpus);
>> +               else if (of_property_match_string(np, "compatible",
>> +                                                 "arm,cortex-a57") >= 0)
>> +                       cpumask_copy(&dvfs_info[BIG_CLUSTER].cpus,
>> +                                    &domain->cpus);
>> +               else {
>> +                       of_node_put(np);
>> +                       pr_err("%s: unknown CPU core\n", __func__);
>> +                       return -EINVAL;
>> +               }
>> +
>> +               of_node_put(np);
>> +       }
>> +
>> +       for (i = 0; i < NR_CLUSTERS; i++) {
>
> You can merge this for-loop with the above for-loop..
>

Will fix it.

>> +               struct cluster_dvfs_info *dvfs = &dvfs_info[i];
>> +               int cpu;
>> +
>> +               for_each_cpu_mask(cpu, dvfs->cpus) {
>> +                       struct device_node *np;
>> +
>> +                       dvfs->cpu_dev = get_cpu_device(cpu);
>> +                       dvfs->proc_reg = regulator_get(dvfs->cpu_dev, "proc");
>> +                       if (IS_ERR(dvfs->proc_reg))
>> +                               continue;
>> +
>> +                       dvfs->cpu = cpu;
>> +                       dvfs->sram_reg = regulator_get(dvfs->cpu_dev, "sram");
>> +
>> +                       np = of_node_get(dvfs->cpu_dev->of_node);
>> +                       of_property_read_u32(np, "voltage-tolerance",
>> +                                            &dvfs->volt_tol);
>> +                       of_node_put(np);
>> +                       break;
>> +               }
>> +
>> +               if (IS_ERR(dvfs->proc_reg)) {
>> +                       pr_err("%s: no proc regulator for cluster %d\n",
>> +                              __func__, i);
>> +                       ret = -ENODEV;
>> +                       goto dvfs_info_release;
>> +               }
>> +
>> +               if (IS_ERR(dvfs->sram_reg) && BIG_CLUSTER == i) {
>> +                       pr_err("%s: no sram regulator for cluster %d\n",
>> +                              __func__, i);
>> +                       ret = -ENODEV;
>> +                       goto dvfs_info_release;
>> +               }
>> +       }
>> +
>> +       mainpll = __clk_lookup("mainpll");
>> +       if (!mainpll) {
>> +               pr_err("failed to get mainpll clk\n");
>> +               ret = -ENOENT;
>> +               goto dvfs_info_release;
>> +       }
>> +       mainpll_freq = clk_get_rate(mainpll);
>> +
>> +       np = of_find_compatible_node(NULL, NULL, "mediatek,mt8173-infrasys");
>> +       if (!np) {
>> +               pr_err("failed to find clock mux registers\n");
>> +               ret = -ENODEV;
>> +               goto dvfs_info_release;
>> +       }
>> +
>> +       clk_mux_regs = of_iomap(np, 0);
>> +       if (!clk_mux_regs) {
>> +               pr_err("failed to map clock mux registers\n");
>> +               ret = -EFAULT;
>> +               goto dvfs_info_release;
>> +       }
>> +       of_node_put(np);
>> +
>> +       spin_lock_init(&lock);
>> +
>> +       return 0;
>> +
>> +dvfs_info_release:
>> +       mt8173_cpufreq_dvfs_info_release();
>> +       return ret;
>> +}
>> +
>> +static int mt8173_cpufreq_driver_init(void)
>> +{
>> +       int ret;
>> +
>> +       if (!of_machine_is_compatible("mediatek,mt8173"))
>> +               return -ENODEV;
>> +
>> +       ret = cpufreq_dt_pdata_init();
>> +       if (ret) {
>> +               pr_err("failed to initialize platform data: %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       ret = mt8173_cpufreq_dvfs_info_init();
>> +       if (ret) {
>> +               pr_err("failed to initialize mt8173 dvfs info: %d\n", ret);
>> +               goto dt_pdata_release;
>> +       }
>> +
>> +       ret = cpufreq_register_notifier(&mt8173_cpufreq_nb,
>> +                                       CPUFREQ_TRANSITION_NOTIFIER);
>> +       if (ret) {
>> +               pr_err("failed to register cpufreq notifier: %d\n", ret);
>> +               goto dt_pdata_release;
>
> dvfs_info_release here ?
>

Yes. Will fix this error path.

>> +       }
>> +
>> +       platform_device_register_data(NULL, "cpufreq-dt", -1,
>> +                                     pd, sizeof(*pd));
>
> can't this fail?
>

Yes. I'll add error checking for this.

Thanks again for your reviewing.

Best Regards,
Pi-Cheng

>> +
>> +       return 0;
>> +
>> +dt_pdata_release:
>> +       cpufreq_dt_pdata_release();
>> +       return ret;
>> +}
>> +
>> +module_init(mt8173_cpufreq_driver_init);
>> +
>> +MODULE_AUTHOR("Pi-Cheng Chen <pi-cheng.chen@linaro.org>");
>> +MODULE_DESCRIPTION("Mediatek MT8173 cpufreq driver");
>> +MODULE_LICENSE("GPL");
