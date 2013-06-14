Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3FNMTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:19:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49484 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3FNMTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:19:34 -0400
Date: Fri, 14 Jun 2013 13:19:26 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Pawel Moll <Pawel.Moll@arm.com>, Achin Gupta <Achin.Gupta@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [RFC PATCH v3 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
Message-ID: <20130614121926.GA32753@e102568-lin.cambridge.arm.com>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1370512763-32200-3-git-send-email-lorenzo.pieralisi@arm.com>
 <20130613225233.GB22310@quad.lixom.net>
MIME-Version: 1.0
In-Reply-To: <20130613225233.GB22310@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Jun 2013 12:19:29.0462 (UTC) FILETIME=[6B2D9D60:01CE68F9]
X-MC-Unique: 113061413193100201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

thank you very much for having a look.

On Thu, Jun 13, 2013 at 11:52:33PM +0100, Olof Johansson wrote:
> Hi,
> 
> Overall this driver looks like it just needs more cooking
> time. It's... gritty.  Complicated when it should be simple and
> layered. Naming is nonobvious, and overall it's hard to glance at a
> function and say "ah, it does <x>".

It is hard to make it clear too, and I am not on the defensive, it is
not a standard component following a standard interface, but point taken
I will do my best to improve it according to your reviews.

> I think some of this might be because of naming conventions. Lots of long
> prefixes, subsystem indirection, etc. I wish I had a straight answer to
> what would make it better, but just more overall polish.
> 
> So, I have a bunch of comments below. Most of these are related to
> readability, which is one of the most important things of new code
> these days.
> 
> Please find a shorter suitable prefix than vexpress_spc_.* too, it's
> way too long.

Ok.

> On Thu, Jun 06, 2013 at 10:59:23AM +0100, Lorenzo Pieralisi wrote:
> > The TC2 versatile express core tile integrates a logic block that provides the
> > interface between the dual cluster test-chip and the M3 microcontroller that
> > carries out power management. The logic block, called Serial Power Controller
> > (SPC), contains several memory mapped registers to control among other things
> > low-power states, operating points and reset control.
> >
> > This patch provides a driver that enables run-time control of features
> > implemented by the SPC control logic.
> >
> > The driver also provides a bridge interface through the vexpress config
> > infrastructure. Operations allowing to read/write operating points are
> > made to go via the same interface as configuration transactions so that
> > all requests to M3 are serialized.
> >
> > Device tree bindings documentation for the SPC component is provided with
> > the patchset.
> >
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Cc: Amit Kucheria <amit.kucheria@linaro.org>
> > Cc: Jon Medhurst <tixy@linaro.org>
> > Signed-off-by: Achin Gupta <achin.gupta@arm.com>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Signed-off-by: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
> > Reviewed-by: Nicolas Pitre <nico@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/mfd/vexpress-spc.txt |  35 +
> >  drivers/mfd/Kconfig                                    |   7 +
> >  drivers/mfd/Makefile                                   |   1 +
> >  drivers/mfd/vexpress-spc.c                             | 633 ++++++++++
> >  include/linux/vexpress.h                               |  43 +
> >  5 files changed, 719 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/mfd/vexpress-spc.txt b/Documentation/devicetree/bindings/mfd/vexpress-spc.txt
> > new file mode 100644
> > index 0000000..1d71dc2
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/vexpress-spc.txt
> > @@ -0,0 +1,35 @@
> > +* ARM Versatile Express Serial Power Controller device tree bindings
> > +
> > +Latest ARM development boards implement a power management interface (serial
> > +power controller - SPC) that is capable of managing power/voltage and
> > +operating point transitions, through memory mapped registers interface.
> > +
> > +On testchips like TC2 it also provides a configuration interface that can
> > +be used to read/write values which cannot be read/written through simple
> > +memory mapped reads/writes.
> 
> A configuration interface for what? Just having it as a PMIC doesn't warrant it
> being an MFD, really.

Ok, description added.

> > +- spc node
> > +
> > +     - compatible:
> > +             Usage: required
> > +             Value type: <stringlist>
> > +             Definition: must be
> > +                         "arm,vexpress-spc,v2p-ca15_a7","arm,vexpress-spc"
> > +     - reg:
> > +             Usage: required
> > +             Value type: <prop-encode-array>
> > +             Definition: A standard property that specifies the base address
> > +                         and the size of the SPC address space
> > +     - interrupts:
> > +             Usage: required
> > +             Value type: <prop-encoded-array>
> > +             Definition:  SPC interrupt configuration. A standard property
> > +                          that follows ePAPR interrupts specifications
> > +
> > +Example:
> > +
> > +spc: spc@7fff0000 {
> > +     compatible = "arm,vexpress-spc,v2p-ca15_a7","arm,vexpress-spc";
> 
> Nit: space after comma between strings.
> 
> > +     reg = <0 0x7FFF0000 0 0x1000>;
> 
> #size-cells 2 on the parent bus? That's somewhat unusual. We tend to prefer
> lowercase hex.
> 

Ok on both counts.

> > +     interrupts = <0 95 4>;
> > +};
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index d54e985..391eda1 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -1148,3 +1148,10 @@ config VEXPRESS_CONFIG
> >       help
> >         Platform configuration infrastructure for the ARM Ltd.
> >         Versatile Express.
> > +
> > +config VEXPRESS_SPC
> > +     bool "Versatile Express SPC driver support"
> > +     depends on ARM
> > +     depends on VEXPRESS_CONFIG
> > +     help
> > +       Serial Power Controller driver for ARM Ltd. test chips.
> 
> One more line as to what conditions you'd like to have this enabled for would
> be good.

Done.

> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index 718e94a..3a01203 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -153,5 +153,6 @@ obj-$(CONFIG_MFD_SEC_CORE)        += sec-core.o sec-irq.o
> >  obj-$(CONFIG_MFD_SYSCON)     += syscon.o
> >  obj-$(CONFIG_MFD_LM3533)     += lm3533-core.o lm3533-ctrlbank.o
> >  obj-$(CONFIG_VEXPRESS_CONFIG)        += vexpress-config.o vexpress-sysreg.o
> > +obj-$(CONFIG_VEXPRESS_SPC)   += vexpress-spc.o
> >  obj-$(CONFIG_MFD_RETU)               += retu-mfd.o
> >  obj-$(CONFIG_MFD_AS3711)     += as3711.o
> > diff --git a/drivers/mfd/vexpress-spc.c b/drivers/mfd/vexpress-spc.c
> > new file mode 100644
> > index 0000000..0c6718a
> > --- /dev/null
> > +++ b/drivers/mfd/vexpress-spc.c
> > @@ -0,0 +1,633 @@
> > +/*
> > + * Versatile Express Serial Power Controller (SPC) support
> > + *
> > + * Copyright (C) 2013 ARM Ltd.
> > + *
> > + * Authors: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> > + *          Achin Gupta           <achin.gupta@arm.com>
> > + *          Lorenzo Pieralisi     <lorenzo.pieralisi@arm.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> > + * kind, whether express or implied; without even the implied warranty
> > + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/err.h>
> > +#include <linux/io.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/slab.h>
> > +#include <linux/vexpress.h>
> > +
> > +#include <asm/cacheflush.h>
> > +
> > +#define SCC_CFGREG19         0x120
> > +#define SCC_CFGREG20         0x124
> > +#define A15_CONF             0x400
> > +#define A7_CONF                      0x500
> > +#define SYS_INFO             0x700
> > +#define PERF_LVL_A15         0xB00
> > +#define PERF_REQ_A15         0xB04
> > +#define PERF_LVL_A7          0xB08
> > +#define PERF_REQ_A7          0xB0c
> > +#define SYS_CFGCTRL          0xB10
> > +#define SYS_CFGCTRL_REQ              0xB14
> > +#define PWC_STATUS           0xB18
> > +#define PWC_FLAG             0xB1c
> > +#define WAKE_INT_MASK                0xB24
> > +#define WAKE_INT_RAW         0xB28
> > +#define WAKE_INT_STAT                0xB2c
> > +#define A15_PWRDN_EN         0xB30
> > +#define A7_PWRDN_EN          0xB34
> > +#define A7_PWRDNACK          0xB54
> > +#define A15_BX_ADDR0         0xB68
> > +#define SYS_CFG_WDATA                0xB70
> > +#define SYS_CFG_RDATA                0xB74
> > +#define A7_BX_ADDR0          0xB78
> 
> These are register offsets? A shared shrot prefix could make that more obvious
> when reading the code below.

Done.

> > +
> > +#define GBL_WAKEUP_INT_MSK   (0x3 << 10)
> > +
> > +#define CLKF_SHIFT           16
> > +#define CLKF_MASK            0x1FFF
> > +#define CLKR_SHIFT           0
> > +#define CLKR_MASK            0x3F
> > +#define CLKOD_SHIFT          8
> > +#define CLKOD_MASK           0xF
> 
> What registers are these for? Having them defined right below the register
> helps the mental grouping.

CLK* removed, multiplier hardcoded, see below. I will comment on the
wake up mask.

> > +
> > +#define OPP_FUNCTION         6
> > +#define OPP_BASE_DEVICE              0x300
> > +#define OPP_A15_OFFSET               0x4
> > +#define OPP_A7_OFFSET                0xc
> > +
> > +#define SYS_CFGCTRL_START    (1 << 31)
> > +#define SYS_CFGCTRL_WRITE    (1 << 30)
> > +#define SYS_CFGCTRL_FUNC(n)  (((n) & 0x3f) << 20)
> > +#define SYS_CFGCTRL_DEVICE(n)        (((n) & 0xfff) << 0)
> > +
> > +#define MAX_OPPS     8
> > +#define MAX_CLUSTERS 2
> > +
> > +enum {
> > +     A15_OPP_TYPE            = 0,
> > +     A7_OPP_TYPE             = 1,
> > +     SYS_CFGCTRL_TYPE        = 2,
> > +     INVALID_TYPE
> > +};
> 
> Some brief notes about what the OPPs are here would be beneficial.
> 
> Also, prefixing makes more sense:
> 
> OPP_TYPE_A15
> OPP_TYPE_A7
> ...

Ok.

> > +#define STAT_COMPLETE(type)  ((1 << 0) << (type << 2))
> > +#define STAT_ERR(type)               ((1 << 1) << (type << 2))
> > +#define RESPONSE_MASK(type)  (STAT_COMPLETE(type) | STAT_ERR(type))
> > +
> > +struct vexpress_spc_drvdata {
> > +     void __iomem *baseaddr;
> > +     u32 a15_clusid;
> > +     int irq;
> > +     u32 cur_req_type;
> > +     u32 freqs[MAX_CLUSTERS][MAX_OPPS];
> > +     int freqs_cnt[MAX_CLUSTERS];
> 
> Please document the non-obvious ones. Is a15 the dynamic cluster id of the A15
> cluster perhaps?

It is A15-MPIDR[15:8], I will document it.

> > +};
> > +
> > +enum spc_func_type {
> > +     CONFIG_FUNC = 0,
> > +     PERF_FUNC   = 1,
> > +};
> > +
> > +struct vexpress_spc_func {
> > +     enum spc_func_type type;
> > +     u32 function;
> > +     u32 device;
> > +};
> > +
> > +static struct vexpress_spc_drvdata *info;
> > +static u32 *vexpress_spc_config_data;
> > +static struct vexpress_config_bridge *vexpress_spc_config_bridge;
> > +static struct vexpress_config_func *opp_func, *perf_func;
> > +
> > +static int vexpress_spc_load_result = -EAGAIN;
> 
> I think Sam already commented on some of these.

Most of them are dynamically allocated now.

> > +
> > +static bool vexpress_spc_initialized(void)
> > +{
> > +     return vexpress_spc_load_result == 0;
> > +}
> > +
> > +/**
> > + * vexpress_spc_write_resume_reg() - set the jump address used for warm boot
> > + *
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + * @cpu: mpidr[7:0] bitfield describing cpu affinity level
> > + * @addr: physical resume address
> > + */
> > +void vexpress_spc_write_resume_reg(u32 cluster, u32 cpu, u32 addr)
> > +{
> > +     void __iomem *baseaddr;
> > +
> > +     if (WARN_ON_ONCE(cluster >= MAX_CLUSTERS))
> > +             return;
> 
> Do you really need these in every function down the call chain?

I will remove them.

> > +
> > +     if (cluster != info->a15_clusid)
> 
> You make this test in a bunch of places, I think a helper would be beneficial.
> 
> cluster_is_a15(cluster), or whatever.

Done.

> > +             baseaddr = info->baseaddr + A7_BX_ADDR0 + (cpu << 2);
> > +     else
> > +             baseaddr = info->baseaddr + A15_BX_ADDR0 + (cpu << 2);
> > +
> > +     writel_relaxed(addr, baseaddr);
> > +}
> > +
> > +/**
> > + * vexpress_spc_get_nb_cpus() - get number of cpus in a cluster
> > + *
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + *
> > + * Return: number of cpus in the cluster
> > + *         -EINVAL if cluster number invalid
> > + */
> > +int vexpress_spc_get_nb_cpus(u32 cluster)
> 
> Nit: nb_cpus? nr_cpus is more common.

Ok.

> > +{
> > +     u32 val;
> > +
> > +     if (WARN_ON_ONCE(cluster >= MAX_CLUSTERS))
> > +             return -EINVAL;
> > +
> > +     val = readl_relaxed(info->baseaddr + SYS_INFO);
> > +     val = (cluster != info->a15_clusid) ? (val >> 20) : (val >> 16);
> > +     return val & 0xf;
> > +}
> > +EXPORT_SYMBOL_GPL(vexpress_spc_get_nb_cpus);
> > +
> > +/**
> > + * vexpress_spc_get_performance - get current performance level of cluster
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + * @freq: pointer to the performance level to be assigned
> 
> Can't you return the perf level instead, with negative for error?

Ok.

> > + *
> > + * Return: 0 on success
> > + *         < 0 on read error
> > + */
> > +int vexpress_spc_get_performance(u32 cluster, u32 *freq)
> 
> This seems to be a get_freq function, should be named accordingly.

Right, those are leftovers from the conversion from performance level to
frequencies, I will change them.

> > +{
> > +     u32 perf_cfg_reg;
> > +     int perf, ret;
> > +
> > +     if (!vexpress_spc_initialized() || (cluster >= MAX_CLUSTERS))
> > +             return -EINVAL;
> > +
> > +     perf_cfg_reg = cluster != info->a15_clusid ? PERF_LVL_A7 : PERF_LVL_A15;
> > +     ret = vexpress_config_read(perf_func, perf_cfg_reg, &perf);
> > +
> > +     if (!ret)
> > +             *freq = info->freqs[cluster][perf];
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vexpress_spc_get_performance);
> > +
> > +/**
> > + * vexpress_spc_get_perf_index - get performance level corresponding to
> > + *                            a frequency
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + * @freq: frequency to be looked-up
> > + *
> > + * Return: perf level index on success
> > + *         -EINVAL on error
> > + */
> 
> Can there be such a thing as overdocumenting stuff? Maybe. :-) For trivial
> helpers that don't export an interface it's much better if the code is so
> obvious to read than needing a defined interface.

Agreed.

> I think you'd be better off without the helper here, since it's only used
> a single time.

I am not sure, it is called every time a DVFS OPP is set, maybe it is better
wrapped in a function.

> > +static int vexpress_spc_find_perf_index(u32 cluster, u32 freq)
> > +{
> > +     int idx;
> > +
> > +     for (idx = 0; idx < info->freqs_cnt[cluster]; idx++)
> > +             if (info->freqs[cluster][idx] == freq)
> > +                     break;
> > +     return (idx == info->freqs_cnt[cluster]) ? -EINVAL : idx;
> > +}
> > +
> > +/**
> > + * vexpress_spc_set_performance - set current performance level of cluster
> > + *
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + * @freq: performance level to be programmed
> 
> Performance level, or target frequency frequency? Either the help is
> wrong, or the name is confusing.

You are right, see above.

> > + *
> > + * Returns: 0 on success
> > + *          < 0 on write error
> > + */
> > +int vexpress_spc_set_performance(u32 cluster, u32 freq)
> 
> Again, set_freq() seems more appropriate.

Ditto.

> > +{
> > +     int ret, perf, offset;
> > +
> > +     if (!vexpress_spc_initialized() || (cluster >= MAX_CLUSTERS))
> > +             return -EINVAL;
> > +
> > +     offset = (cluster != info->a15_clusid) ? PERF_LVL_A7 : PERF_LVL_A15;
> > +
> > +     perf = vexpress_spc_find_perf_index(cluster, freq);
> > +
> > +     if (perf < 0 || perf >= MAX_OPPS)
> > +             return -EINVAL;
> > +
> > +     ret = vexpress_config_write(perf_func, offset, perf);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vexpress_spc_set_performance);
> > +
> > +static void vexpress_spc_set_wake_intr(u32 mask)
> > +{
> > +     writel_relaxed(mask & VEXPRESS_SPC_WAKE_INTR_MASK,
> > +                    info->baseaddr + WAKE_INT_MASK);
> > +}
> > +
> > +static inline void reg_bitmask(u32 *reg, u32 mask, bool set)
> > +{
> > +     if (set)
> > +             *reg |= mask;
> > +     else
> > +             *reg &= ~mask;
> > +}
> > +
> > +/**
> > + * vexpress_spc_set_global_wakeup_intr()
> > + *
> > + * Function to set/clear global wakeup IRQs. Not protected by locking since
> > + * it might be used in code paths where normal cacheable locks are not
> > + * working. Locking must be provided by the caller to ensure atomicity.
> > + *
> > + * @set: if true, global wake-up IRQs are set, if false they are cleared
> > + */
> > +void vexpress_spc_set_global_wakeup_intr(bool set)
> 
> vexpress_spc_set_foo, which passes in "set" which can either be true or false? Say what?

Eh, again leftovers from API refactoring.

> > +{
> > +     u32 wake_int_mask_reg = 0;
> > +
> > +     wake_int_mask_reg = readl_relaxed(info->baseaddr + WAKE_INT_MASK);
> > +     reg_bitmask(&wake_int_mask_reg, GBL_WAKEUP_INT_MSK, set);
> 
> This helper just obfuscates, in my opinion.

I will have a look.

> > +     vexpress_spc_set_wake_intr(wake_int_mask_reg);
> > +}
> > +
> > +/**
> > + * vexpress_spc_set_cpu_wakeup_irq()
> > + *
> > + * Function to set/clear per-CPU wake-up IRQs. Not protected by locking since
> > + * it might be used in code paths where normal cacheable locks are not
> > + * working. Locking must be provided by the caller to ensure atomicity.
> > + *
> > + * @cpu: mpidr[7:0] bitfield describing cpu affinity level
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + * @set: if true, wake-up IRQs are set, if false they are cleared
> > + */
> > +void vexpress_spc_set_cpu_wakeup_irq(u32 cpu, u32 cluster, bool set)
> 
> Same here, set in name vs set argument.

Correct.

> > +{
> > +     u32 mask = 0;
> > +     u32 wake_int_mask_reg = 0;
> > +
> > +     mask = 1 << cpu;
> > +     if (info->a15_clusid != cluster)
> > +             mask <<= 4;
> > +
> > +     wake_int_mask_reg = readl_relaxed(info->baseaddr + WAKE_INT_MASK);
> > +     reg_bitmask(&wake_int_mask_reg, mask, set);
> > +     vexpress_spc_set_wake_intr(wake_int_mask_reg);
> > +}
> > +
> > +/**
> > + * vexpress_spc_powerdown_enable()
> > + *
> > + * Function to enable/disable cluster powerdown. Not protected by locking
> > + * since it might be used in code paths where normal cacheable locks are not
> > + * working. Locking must be provided by the caller to ensure atomicity.
> > + *
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + * @enable: if true enables powerdown, if false disables it
> > + */
> > +void vexpress_spc_powerdown_enable(u32 cluster, bool enable)
> 
> Again with the enable in name vs argument.

Ditto.

> > +{
> > +     u32 pwdrn_reg = 0;
> > +
> > +     if (cluster >= MAX_CLUSTERS)
> > +             return;
> > +     pwdrn_reg = cluster != info->a15_clusid ? A7_PWRDN_EN : A15_PWRDN_EN;
> > +     writel_relaxed(enable, info->baseaddr + pwdrn_reg);
> > +}
> > +
> > +irqreturn_t vexpress_spc_irq_handler(int irq, void *data)
> > +{
> > +     int ret;
> > +     u32 status = readl_relaxed(info->baseaddr + PWC_STATUS);
> 
> Why readl_relaxed() here? Can't you use a normal readl()?

Nico replied to this.

> > +     if (!(status & RESPONSE_MASK(info->cur_req_type)))
> > +             return IRQ_NONE;
> 
> "pending" is maybe a better term to use than "current" here. I.e. "pending_req"
> as a variable name instead.

Ok.

> > +
> > +     if ((status == STAT_COMPLETE(SYS_CFGCTRL_TYPE))
> > +                     && vexpress_spc_config_data) {
> > +             *vexpress_spc_config_data =
> > +                             readl_relaxed(info->baseaddr + SYS_CFG_RDATA);
> > +             vexpress_spc_config_data = NULL;
> > +     }
> > +
> > +     ret = STAT_COMPLETE(info->cur_req_type) ? 0 : -EIO;

This is a bug, fixed, STAT_COMPLETE should be checked against status.

> > +     info->cur_req_type = INVALID_TYPE;
> 
> INVALID_TYPE is 3, so the RESPONSE_MASK() check above will pass. That's
> probably not desireable.

Not sure I follow you here, but it helped me unearth the bug above.

> > +     vexpress_config_complete(vexpress_spc_config_bridge, ret);
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +/**
> > + * Based on the firmware documentation, this is always fixed to 20
> 
> What is always fixed to 20? the multiplication factor? So why do we need to get
> it?

Removed.

> > + * All the 4 OSC: A15 PLL0/1, A7 PLL0/1 must be programmed same
> > + * values for both control and value registers.
> > + * This function uses A15 PLL 0 registers to compute multiple factor
> > + * F out = F in * (CLKF + 1) / ((CLKOD + 1) * (CLKR + 1))
> > + */
> > +static inline int __get_mult_factor(void)
> 
> __get_opp_freq_unit()?

Gone :-)

> > +{
> > +     int i_div, o_div, f_div;
> > +     u32 tmp;
> > +
> > +     tmp = readl(info->baseaddr + SCC_CFGREG19);
> > +     f_div = (tmp >> CLKF_SHIFT) & CLKF_MASK;
> > +
> > +     tmp = readl(info->baseaddr + SCC_CFGREG20);
> > +     o_div = (tmp >> CLKOD_SHIFT) & CLKOD_MASK;
> > +     i_div = (tmp >> CLKR_SHIFT) & CLKR_MASK;
> > +
> > +     return (f_div + 1) / ((o_div + 1) * (i_div + 1));
> > +}
> > +
> > +/**
> > + * vexpress_spc_populate_opps() - initialize opp tables from microcontroller
> > + *
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + *
> > + * Return: 0 on success
> > + *         < 0 on error
> > + */
> > +static int vexpress_spc_populate_opps(u32 cluster)
> > +{
> > +     u32 data = 0, ret, i, offset;
> > +     int mult_fact = __get_mult_factor();
> > +
> > +     if (WARN_ON_ONCE(cluster >= MAX_CLUSTERS))
> > +             return -EINVAL;
> > +
> > +     offset = cluster != info->a15_clusid ? OPP_A7_OFFSET : OPP_A15_OFFSET;
> > +     for (i = 0; i < MAX_OPPS; i++) {
> > +             ret = vexpress_config_read(opp_func, i + offset, &data);
> 
> offset + i

Ok.

> > +             if (!ret)
> > +                     info->freqs[cluster][i] = (data & 0xFFFFF) * mult_fact;
> > +             else
> > +                     break;
> > +     }
> > +
> > +     info->freqs_cnt[cluster] = i;
> > +     return ret;
> > +}
> > +
> > +/**
> > + * vexpress_spc_get_freq_table() - Retrieve a pointer to the frequency
> > + *                              table for a given cluster
> > + *
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + * @fptr: pointer to be initialized
> > + * Return: operating points count on success
> > + *         -EINVAL on pointer error
> > + */
> > +int vexpress_spc_get_freq_table(u32 cluster, u32 **fptr)
> > +{
> > +     if (WARN_ON_ONCE(!fptr || cluster >= MAX_CLUSTERS))
> > +             return -EINVAL;
> > +     *fptr = info->freqs[cluster];
> > +     return info->freqs_cnt[cluster];
> > +}
> > +EXPORT_SYMBOL_GPL(vexpress_spc_get_freq_table);
> 
> Exporting the pointer to the table is a little scary since the caller
> could then modify it. Would be nicer to pass in an array that is
> populated.

Probably better.

> I feel like a hypocrite for having to say this, but here's there's a need for
> docs. You've documented the short trivial functions and not some of the long
> ones... :)

I will do that.

> > +static void *vexpress_spc_func_get(struct device *dev,
> > +             struct device_node *node, const char *id)
> > +{
> > +     struct vexpress_spc_func *spc_func;
> > +     u32 func_device[2];
> > +     int err = 0;
> > +
> > +     spc_func = kzalloc(sizeof(*spc_func), GFP_KERNEL);
> > +     if (!spc_func)
> > +             return NULL;
> > +
> > +     if (strcmp(id, "opp") == 0) {
> > +             spc_func->type = CONFIG_FUNC;
> > +             spc_func->function = OPP_FUNCTION;
> > +             spc_func->device = OPP_BASE_DEVICE;
> > +     } else if (strcmp(id, "perf") == 0) {
> > +             spc_func->type = PERF_FUNC;
> > +     } else if (node) {
> > +             of_node_get(node);
> > +             err = of_property_read_u32_array(node,
> > +                             "arm,vexpress-sysreg,func", func_device,
> > +                             ARRAY_SIZE(func_device));
> > +             of_node_put(node);
> > +             spc_func->type = CONFIG_FUNC;
> > +             spc_func->function = func_device[0];
> > +             spc_func->device = func_device[1];
> > +     }
> > +
> > +     if (WARN_ON(err)) {
> > +             kfree(spc_func);
> > +             return NULL;
> > +     }
> > +
> > +     pr_debug("func 0x%p = 0x%x, %d %d\n", spc_func,
> > +                                          spc_func->function,
> > +                                          spc_func->device,
> > +                                          spc_func->type);
> > +
> > +     return spc_func;
> > +}
> > +
> > +static void vexpress_spc_func_put(void *func)
> > +{
> > +     kfree(func);
> > +}
> > +
> > +static int vexpress_spc_func_exec(void *func, int offset, bool write,
> > +                               u32 *data)
> > +{
> > +     struct vexpress_spc_func *spc_func = func;
> > +     u32 command;
> > +
> > +     if (!data)
> > +             return -EINVAL;
> > +     /*
> > +      * Setting and retrieval of operating points is not part of
> > +      * DCC config interface. It was made to go through the same
> > +      * code path so that requests to the M3 can be serialized
> > +      * properly with config reads/writes through the common
> > +      * vexpress config interface
> > +      */
> > +     switch (spc_func->type) {
> > +     case PERF_FUNC:
> > +             if (write) {
> > +                     info->cur_req_type = (offset == PERF_LVL_A15) ?
> > +                                     A15_OPP_TYPE : A7_OPP_TYPE;
> > +                     writel_relaxed(*data, info->baseaddr + offset);
> > +                     return VEXPRESS_CONFIG_STATUS_WAIT;
> > +             } else {
> > +                     *data = readl_relaxed(info->baseaddr + offset);
> > +                     return VEXPRESS_CONFIG_STATUS_DONE;
> > +             }
> > +     case CONFIG_FUNC:
> > +             info->cur_req_type = SYS_CFGCTRL_TYPE;
> > +
> > +             command = SYS_CFGCTRL_START;
> > +             command |= write ? SYS_CFGCTRL_WRITE : 0;
> > +             command |= SYS_CFGCTRL_FUNC(spc_func->function);
> > +             command |= SYS_CFGCTRL_DEVICE(spc_func->device + offset);
> > +
> > +             pr_debug("command %x\n", command);
> > +
> > +             if (!write)
> > +                     vexpress_spc_config_data = data;
> > +             else
> > +                     writel_relaxed(*data, info->baseaddr + SYS_CFG_WDATA);
> > +             writel_relaxed(command, info->baseaddr + SYS_CFGCTRL);
> > +
> > +             return VEXPRESS_CONFIG_STATUS_WAIT;
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +}
> > +
> > +struct vexpress_config_bridge_info vexpress_spc_config_bridge_info = {
> > +     .name = "vexpress-spc",
> > +     .func_get = vexpress_spc_func_get,
> > +     .func_put = vexpress_spc_func_put,
> > +     .func_exec = vexpress_spc_func_exec,
> > +};
> 
> Caveat: I'm running out of time reviewing this one driver, and didn't look into
> the vexpress_config_bridge stuff. Seems like a pretty awkward interface but
> I didn't look closer.

Pawel commented on that code earlier.

> > +
> > +static const struct of_device_id vexpress_spc_ids[] __initconst = {
> > +     { .compatible = "arm,vexpress-spc,v2p-ca15_a7" },
> > +     { .compatible = "arm,vexpress-spc" },
> > +     {},
> > +};
> > +
> > +static int __init vexpress_spc_init(void)
> > +{
> > +     int ret;
> > +     struct device_node *node = of_find_matching_node(NULL,
> > +                                                      vexpress_spc_ids);
> > +
> > +     if (!node)
> > +             return -ENODEV;
> > +
> > +     info = kzalloc(sizeof(*info), GFP_KERNEL);
> > +     if (!info) {
> > +             pr_err("%s: unable to allocate mem\n", __func__);
> > +             return -ENOMEM;
> > +     }
> > +     info->cur_req_type = INVALID_TYPE;
> > +
> > +     info->baseaddr = of_iomap(node, 0);
> > +     if (WARN_ON(!info->baseaddr)) {
> 
> pr_err() something or other.

Yeah, added for all error conditions below.

> > +             ret = -ENXIO;
> > +             goto mem_free;
> > +     }
> > +
> > +     info->irq = irq_of_parse_and_map(node, 0);
> > +
> > +     if (WARN_ON(!info->irq)) {
> 
> pr_err() something or other.
> 
> > +             ret = -ENXIO;
> > +             goto unmap;
> > +     }
> > +
> > +     readl_relaxed(info->baseaddr + PWC_STATUS);
> > +
> > +     ret = request_irq(info->irq, vexpress_spc_irq_handler,
> > +             IRQF_DISABLED | IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> > +             "arm-spc", info);
> > +
> > +     if (ret) {
> > +             pr_err("IRQ %d request failed\n", info->irq);
> > +             ret = -ENODEV;
> > +             goto unmap;
> > +     }
> > +
> > +     info->a15_clusid = readl_relaxed(info->baseaddr + A15_CONF) & 0xf;
> > +
> > +     vexpress_spc_config_bridge = vexpress_config_bridge_register(
> > +                     node, &vexpress_spc_config_bridge_info);
> > +
> > +     if (WARN_ON(!vexpress_spc_config_bridge)) {
> 
> pr_err()
> 
> > +             ret = -ENODEV;
> > +             goto unmap;
> > +     }
> > +
> > +     opp_func = vexpress_config_func_get(vexpress_spc_config_bridge, "opp");
> > +     perf_func =
> > +             vexpress_config_func_get(vexpress_spc_config_bridge, "perf");
> 
> Your identifiers are so long that you can't fit a simple call on minimum
> indentation without wrapping the line. That should be a pretty strong indicator
> that it needs to be shortened.

Ok, point taken.

> > +
> > +     if (!opp_func || !perf_func) {
> 
> ...pr_err()
> 
> > +             ret = -ENODEV;
> > +             goto unmap;
> > +     }
> > +
> > +     if (vexpress_spc_populate_opps(0) || vexpress_spc_populate_opps(1)) {
> > +             if (info->irq)
> > +                     free_irq(info->irq, info);
> > +             pr_err("failed to build OPP table\n");
> > +             ret = -ENODEV;
> > +             goto unmap;
> > +     }
> > +     /*
> > +      * Multi-cluster systems may need this data when non-coherent, during
> > +      * cluster power-up/power-down. Make sure it reaches main memory:
> > +      */
> > +     sync_cache_w(info);
> > +     sync_cache_w(&info);
> > +     pr_info("vexpress-spc loaded at %p\n", info->baseaddr);
> > +     return 0;
> > +
> > +unmap:
> > +     iounmap(info->baseaddr);
> > +
> > +mem_free:
> > +     kfree(info);
> > +     return ret;
> > +}
> > +
> > +static bool __init __vexpress_spc_check_loaded(void);
> > +/*
> > + * Pointer spc_check_loaded is swapped after init hence it is safe
> > + * to initialize it to a function in the __init section
> > + */
> > +static bool (*spc_check_loaded)(void) __refdata = &__vexpress_spc_check_loaded;
> > +
> > +static bool __init __vexpress_spc_check_loaded(void)
> > +{
> > +     if (vexpress_spc_load_result == -EAGAIN)
> > +             vexpress_spc_load_result = vexpress_spc_init();
> > +     spc_check_loaded = &vexpress_spc_initialized;
> > +     return vexpress_spc_initialized();
> > +}
> 
> Whoa. A "check_foo" function with side effects. Red flag.
> 
> So, you only want to try to run vexpress_spc_init() on the very first call to
> spc_check_loaded()? Just do so in vexpress_spc_initalized() instead and keep
> a static bool first_call = true; variable instead. Still confusing and with
> side effects though.

Well, I think the best thing to do is to call it eg spc_init(). That's what it
does anyway and there is no need for syntactic sugar that just hides side
effects.

> > +
> > +/*
> > + * Function exported to manage early_initcall ordering.
> > + * SPC code is needed very early in the boot process
> > + * to bring CPUs out of reset and initialize power
> > + * management back-end. After boot swap pointers to
> > + * make the functionality check available to loadable
> > + * modules, when early boot init functions have been
> > + * already freed from kernel address space.
> > + */
> > +bool vexpress_spc_check_loaded(void)
> > +{
> > +     return spc_check_loaded();
> > +}
> > +EXPORT_SYMBOL_GPL(vexpress_spc_check_loaded);
> 
> Or, you do that test I mentioned right above here instead.

Commented above.

Thank you very much for the review.
Lorenzo

