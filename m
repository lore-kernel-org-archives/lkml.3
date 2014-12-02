Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaLBOtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:49:33 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:51373 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaLBOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:49:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKQcstteVi2O2ZE9PWeH9XfCzf9V3jhNnxXn9+1bcW6yA@mail.gmail.com>
References: <1416832111-367-1-git-send-email-tomeu.vizoso@collabora.com>
 <1416832111-367-3-git-send-email-tomeu.vizoso@collabora.com> <CAAVeFuKQcstteVi2O2ZE9PWeH9XfCzf9V3jhNnxXn9+1bcW6yA@mail.gmail.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 2 Dec 2014 15:49:07 +0100
X-Google-Sender-Auth: f1AfePtqSRz1uwxKgknWmtKzea0
Message-ID: <CAAObsKB+o0r=wLr1F2kaiMv7oxVzC_ytJvkeoiCuc-2LqEGQSA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] PM / devfreq: tegra: add devfreq driver for Tegra
 Activity Monitor
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2014 at 11:02, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Mon, Nov 24, 2014 at 9:28 PM, Tomeu Vizoso
> <tomeu.vizoso@collabora.com> wrote:
>> The ACTMON block can monitor several counters, providing averaging and firing
>> interrupts based on watermarking configuration. This implementation monitors
>> the MCALL and MCCPU counters to choose an appropriate frequency for the
>> external memory clock.
>>
>> This patch is based on work by Alex Frid <afrid@nvidia.com> and Mikko
>> Perttunen <mikko.perttunen@kapsi.fi>.
>
> Thanks for taking the time to adapt this driver to use devfreq.
> Looking at it, I am more and more convinced that's the correct way to
> do.
>
> I made some comments inline, but I'd like to bring Arto Merilainen
> into this discussion. Arto thought (and might even have some code)
> about adding watermarks support to devfreq's core and using a generic
> "watermark" governor which I believe would greatly benefit this patch
> set.

Do you know of any other SoC family that would be able to use that code?

> Arto, do you have some concrete code you could submit here? If
> you lack the time for doing so, some guidance so we could implement
> this support ourselves would be great.
>
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>
>> ---
>>
>> v2:     * Use devfreq
>> ---
>>  drivers/devfreq/Kconfig         |  10 +
>>  drivers/devfreq/Makefile        |   1 +
>>  drivers/devfreq/tegra-devfreq.c | 718 ++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 729 insertions(+)
>>  create mode 100644 drivers/devfreq/tegra-devfreq.c
>>
>> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
>> index faf4e70..4aab799 100644
>> --- a/drivers/devfreq/Kconfig
>> +++ b/drivers/devfreq/Kconfig
>> @@ -87,4 +87,14 @@ config ARM_EXYNOS5_BUS_DEVFREQ
>>           It reads PPMU counters of memory controllers and adjusts the
>>           operating frequencies and voltages with OPP support.
>>
>> +config ARM_TEGRA_DEVFREQ
>> +       tristate "Tegra DEVFREQ Driver"
>> +       depends on ARCH_TEGRA_124_SOC
>> +       select DEVFREQ_GOV_SIMPLE_ONDEMAND
>> +       select PM_OPP
>> +       help
>> +         This adds the DEVFREQ driver for the Tegra family of SoCs.
>> +         It reads ACTMON counters of memory controllers and adjusts the
>> +         operating frequencies and voltages with OPP support.
>> +
>>  endif # PM_DEVFREQ
>> diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
>> index 16138c9..0ea991f 100644
>> --- a/drivers/devfreq/Makefile
>> +++ b/drivers/devfreq/Makefile
>> @@ -7,3 +7,4 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)     += governor_userspace.o
>>  # DEVFREQ Drivers
>>  obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)  += exynos/
>>  obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)  += exynos/
>> +obj-$(CONFIG_ARM_TEGRA_DEVFREQ)                += tegra-devfreq.o
>> diff --git a/drivers/devfreq/tegra-devfreq.c b/drivers/devfreq/tegra-devfreq.c
>> new file mode 100644
>> index 0000000..3479096
>> --- /dev/null
>> +++ b/drivers/devfreq/tegra-devfreq.c
>
> This file should probably be named tegra-actmon-devfreq.c, for nothing
> guarantees that we will not have more devfreq devices for Tegra in the
> future.

Good point.

>> @@ -0,0 +1,718 @@
>> +/*
>> + * A devfreq driver for NVIDIA Tegra SoCs
>> + *
>> + * Copyright (c) 2014 NVIDIA CORPORATION. All rights reserved.
>> + * Copyright (C) 2014 Google, Inc
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
>> + *
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/cpufreq.h>
>> +#include <linux/devfreq.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm_opp.h>
>> +#include <linux/reset.h>
>> +
>> +#include "governor.h"
>> +
>> +#define ACTMON_GLB_STATUS                                      0x0
>> +#define ACTMON_GLB_PERIOD_CTRL                                 0x4
>> +
>> +#define ACTMON_DEV_CTRL                                                0x0
>> +#define ACTMON_DEV_CTRL_K_VAL_SHIFT                            10
>> +#define ACTMON_DEV_CTRL_ENB_PERIODIC                           BIT(18)
>> +#define ACTMON_DEV_CTRL_AVG_BELOW_WMARK_EN                     BIT(20)
>> +#define ACTMON_DEV_CTRL_AVG_ABOVE_WMARK_EN                     BIT(21)
>> +#define ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_NUM_SHIFT      23
>> +#define ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_NUM_SHIFT      26
>> +#define ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN             BIT(29)
>> +#define ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN             BIT(30)
>> +#define ACTMON_DEV_CTRL_ENB                                    BIT(31)
>> +
>> +#define ACTMON_DEV_UPPER_WMARK                                 0x4
>> +#define ACTMON_DEV_LOWER_WMARK                                 0x8
>> +#define ACTMON_DEV_INIT_AVG                                    0xc
>> +#define ACTMON_DEV_AVG_UPPER_WMARK                             0x10
>> +#define ACTMON_DEV_AVG_LOWER_WMARK                             0x14
>> +#define ACTMON_DEV_COUNT_WEIGHT                                        0x18
>> +#define ACTMON_DEV_AVG_COUNT                                   0x20
>> +#define ACTMON_DEV_INTR_STATUS                                 0x24
>> +
>> +#define ACTMON_INTR_STATUS_CLEAR                               0xffffffff
>> +
>> +#define ACTMON_DEV_INTR_CONSECUTIVE_UPPER                      BIT(31)
>> +#define ACTMON_DEV_INTR_CONSECUTIVE_LOWER                      BIT(30)
>> +
>> +#define ACTMON_ABOVE_WMARK_WINDOW                              1
>> +#define ACTMON_BELOW_WMARK_WINDOW                              3
>> +#define ACTMON_BOOST_FREQ_STEP                                 16000
>> +
>> +/* activity counter is incremented every 256 memory transactions, and each
>> + * transaction takes 4 EMC clocks for Tegra124; So the COUNT_WEIGHT is
>> + * 4 * 256 = 1024.
>> + */
>> +#define ACTMON_COUNT_WEIGHT                                    0x400
>> +
>> +/*
>> + * ACTMON_AVERAGE_WINDOW_LOG2: default value for @DEV_CTRL_K_VAL, which
>> + * translates to 2 ^ (K_VAL + 1). ex: 2 ^ (6 + 1) = 128
>> + */
>> +#define ACTMON_AVERAGE_WINDOW_LOG2                     6
>> +#define ACTMON_SAMPLING_PERIOD                         12 /* ms */
>> +#define ACTMON_DEFAULT_AVG_BAND                                6  /* 1/10 of % */
>> +
>> +#define KHZ                                                    1000
>> +
>> +/* Assume that the bus is saturated if the utilization is 25% */
>> +#define BUS_SATURATION_RATIO                                   25
>> +
>> +/**
>> + * struct tegra_devfreq_device_config - configuration specific to an ACTMON
>> + * device
>> + *
>> + * Coefficients and thresholds are in %
>
> Short comments about what the members are for would be perfect (same
> for other structures). It is not immediatly obvious what e.g.
> avg_dependency_threshold is for.

Fair enough.

>> + */
>> +struct tegra_devfreq_device_config {
>> +       u32             offset;
>> +       u32             irq_mask;
>> +
>> +       unsigned int    boost_up_coeff;
>> +       unsigned int    boost_down_coeff;
>> +       unsigned int    boost_up_threshold;
>> +       unsigned int    boost_down_threshold;
>> +       u32             avg_dependency_threshold;
>> +};
>> +
>> +enum tegra_actmon_device {
>> +       MCALL = 0,
>> +       MCCPU,
>> +};
>> +
>> +static struct tegra_devfreq_device_config actmon_device_configs[] = {
>> +       {
>> +               /* MCALL */
>> +               .offset = 0x1c0,
>> +               .irq_mask = 1 << 26,
>> +               .boost_up_coeff = 200,
>> +               .boost_down_coeff = 50,
>> +               .boost_up_threshold = 60,
>> +               .boost_down_threshold = 40,
>> +       },
>> +       {
>> +               /* MCCPU */
>> +               .offset = 0x200,
>> +               .irq_mask = 1 << 25,
>> +               .boost_up_coeff = 800,
>> +               .boost_down_coeff = 90,
>> +               .boost_up_threshold = 27,
>> +               .boost_down_threshold = 10,
>> +               .avg_dependency_threshold = 50000,
>
> The boost_* and avg_dependency_threshold parameters are calling to be
> exported through debugfs in some future patch. :)
>
> Just for my education, why do we need to monitor both MCALL and MCCPU,
> since MCCPU accesses are included in MCALL? Do we want to boost things
> differently in case of CPU activity?

Yeah, I started by using only MCALL and found that performance
decreased substantially in scenarios with high CPU loads. Once I took
into account CPU frequency and the MCCPU counters as per downstream,
performance improved greatly.

I cannot tell why MCALL isn't enough though, maybe you can find a
fellow NVIDIAn that knows about it? Couldn't find anything in the
public TRM about it.

>> +       },
>> +};
>> +
>> +/**
>> + * struct tegra_devfreq_device - state specific to an ACTMON device
>> + *
>> + * Frequencies are in kHz.
>> + */
>> +struct tegra_devfreq_device {
>> +       const struct tegra_devfreq_device_config *config;
>> +
>> +       void __iomem    *regs;
>> +       u32             avg_band_freq;
>> +       u32             avg_count;
>> +
>> +       unsigned long   target_freq;
>> +       unsigned long   boost_freq;
>> +};
>> +
>> +struct tegra_devfreq {
>> +       struct devfreq          *devfreq;
>> +
>> +       struct platform_device  *pdev;
>> +       struct reset_control    *reset;
>> +       struct clk              *clock;
>> +       void __iomem            *regs;
>> +
>> +       spinlock_t              lock;
>> +
>> +       struct clk              *emc_clock;
>> +       unsigned long           max_freq;
>> +       unsigned long           cur_freq;
>> +       struct notifier_block   rate_change_nb;
>> +
>> +       struct tegra_devfreq_device devices[ARRAY_SIZE(actmon_device_configs)];
>> +};
>> +
>> +struct tegra_actmon_emc_ratio {
>> +       unsigned long cpu_freq;
>> +       unsigned long emc_freq;
>> +};
>> +
>> +static struct tegra_actmon_emc_ratio actmon_emc_ratios[] = {
>> +       { 1400000, ULONG_MAX },
>> +       { 1200000,    750000 },
>> +       { 1100000,    600000 },
>> +       { 1000000,    500000 },
>> +       {  800000,    375000 },
>> +       {  500000,    200000 },
>> +       {  250000,    100000 },
>
> Aren't these numbers board-specific? Should they be moved to the DT maybe?

I would expect it to be common to all boards with the same SoC.

>> +};
>> +
>> +static unsigned long do_percent(unsigned long val, unsigned int pct)
>> +{
>> +       return val * pct / 100;
>> +}
>> +
>> +static void tegra_devfreq_update_avg_wmark(struct tegra_devfreq_device *dev)
>> +{
>> +       u32 avg = dev->avg_count;
>> +       u32 band = dev->avg_band_freq * ACTMON_SAMPLING_PERIOD;
>> +
>> +       writel(avg + band, dev->regs + ACTMON_DEV_AVG_UPPER_WMARK);
>
> Having actmon_readl() and actmon_writel() inline functions that make
> the "dev->regs +" unnecessary would be nicer to read and less
> error-prone IMHO.

Will try that.

>> +       avg = max(avg, band);
>> +       writel(avg - band, dev->regs + ACTMON_DEV_AVG_LOWER_WMARK);
>> +}
>> +
>> +static void tegra_devfreq_update_wmark(struct tegra_devfreq *tegra,
>> +                                      struct tegra_devfreq_device *dev)
>> +{
>> +       u32 val = tegra->cur_freq * ACTMON_SAMPLING_PERIOD;
>> +
>> +       writel(do_percent(val, dev->config->boost_up_threshold),
>> +              dev->regs + ACTMON_DEV_UPPER_WMARK);
>> +
>> +       writel(do_percent(val, dev->config->boost_down_threshold),
>> +              dev->regs + ACTMON_DEV_LOWER_WMARK);
>> +}
>> +
>> +static void actmon_write_barrier(struct tegra_devfreq *tegra)
>> +{
>> +       /* ensure the update has reached the ACTMON */
>> +       wmb();
>> +       readl(tegra->regs + ACTMON_GLB_STATUS);
>> +}
>> +
>> +static irqreturn_t actmon_isr(int irq, void *data)
>> +{
>> +       struct tegra_devfreq *tegra = data;
>> +       struct tegra_devfreq_device *dev = NULL;
>> +       unsigned long flags;
>> +       u32 val;
>> +       unsigned int i;
>> +
>> +       val = readl(tegra->regs + ACTMON_GLB_STATUS);
>> +
>> +       for (i = 0; i < ARRAY_SIZE(tegra->devices); i++) {
>> +               if (val & tegra->devices[i].config->irq_mask) {
>> +                       dev = tegra->devices + i;
>> +                       break;
>> +               }
>> +       }
>> +
>> +       if (!dev)
>> +               return IRQ_NONE;
>> +
>> +       spin_lock_irqsave(&tegra->lock, flags);
>> +
>> +       dev->avg_count = readl(dev->regs + ACTMON_DEV_AVG_COUNT);
>> +       tegra_devfreq_update_avg_wmark(dev);
>> +
>> +       val = readl(dev->regs + ACTMON_DEV_INTR_STATUS);
>> +       if (val & ACTMON_DEV_INTR_CONSECUTIVE_UPPER) {
>> +               val = readl(dev->regs + ACTMON_DEV_CTRL) |
>> +                       ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN |
>> +                       ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>> +
>> +               /*
>> +                * new_boost = min(old_boost * up_coef + step, max_freq)
>> +                */
>> +               dev->boost_freq = do_percent(dev->boost_freq,
>> +                                            dev->config->boost_up_coeff);
>> +               dev->boost_freq += ACTMON_BOOST_FREQ_STEP;
>> +               if (dev->boost_freq >= tegra->max_freq) {
>> +                       dev->boost_freq = tegra->max_freq;
>> +                       val &= ~ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN;
>
> Instead of setting this flag to possibly remove it later, maybe set it
> only if this condition is not met?

That sounds better indeed, thanks.

>> +               }
>> +               writel(val, dev->regs + ACTMON_DEV_CTRL);
>> +       } else if (val & ACTMON_DEV_INTR_CONSECUTIVE_LOWER) {
>> +               val = readl(dev->regs + ACTMON_DEV_CTRL) |
>> +                       ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN |
>> +                       ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>> +
>> +               /*
>> +                * new_boost = old_boost * down_coef
>> +                * or 0 if (old_boost * down_coef < step / 2)
>> +                */
>> +               dev->boost_freq = do_percent(dev->boost_freq,
>> +                                            dev->config->boost_down_coeff);
>> +               if (dev->boost_freq < (ACTMON_BOOST_FREQ_STEP >> 1)) {
>> +                       dev->boost_freq = 0;
>> +                       val &= ~ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>
> Same here.
>
>> +               }
>> +               writel(val, dev->regs + ACTMON_DEV_CTRL);
>> +       }
>> +
>> +       if (dev->config->avg_dependency_threshold) {
>> +               val = readl(dev->regs + ACTMON_DEV_CTRL);
>> +               if (dev->avg_count >= dev->config->avg_dependency_threshold)
>> +                       val |= ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>> +               else if (dev->boost_freq == 0)
>> +                       val &= ~ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>> +               writel(val, dev->regs + ACTMON_DEV_CTRL);
>> +       }
>> +
>> +       writel(ACTMON_INTR_STATUS_CLEAR, dev->regs + ACTMON_DEV_INTR_STATUS);
>> +
>> +       actmon_write_barrier(tegra);
>> +
>> +       spin_unlock_irqrestore(&tegra->lock, flags);
>> +
>> +       return IRQ_WAKE_THREAD;
>> +}
>> +
>> +static unsigned long actmon_cpu_to_emc_rate(struct tegra_devfreq *tegra,
>> +                                           unsigned long cpu_freq)
>> +{
>> +       unsigned int i;
>> +       struct tegra_actmon_emc_ratio *ratio = actmon_emc_ratios;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(actmon_emc_ratios); i++, ratio++) {
>> +               if (cpu_freq >= ratio->cpu_freq) {
>> +                       if (ratio->emc_freq >= tegra->max_freq)
>> +                               return tegra->max_freq;
>> +                       else
>> +                               return ratio->emc_freq;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void actmon_update_target(struct tegra_devfreq *tegra,
>> +                                struct tegra_devfreq_device *dev)
>> +{
>> +       unsigned long cpu_freq = 0;
>> +       unsigned long static_cpu_emc_freq = 0;
>> +       unsigned int avg_sustain_coef;
>> +       unsigned long flags;
>> +
>> +       if (dev->config->avg_dependency_threshold) {
>> +               cpu_freq = cpufreq_get(0);
>> +               static_cpu_emc_freq = actmon_cpu_to_emc_rate(tegra, cpu_freq);
>> +       }
>> +
>> +       spin_lock_irqsave(&tegra->lock, flags);
>> +
>> +       dev->target_freq = dev->avg_count / ACTMON_SAMPLING_PERIOD;
>> +       avg_sustain_coef = 100 * 100 / dev->config->boost_up_threshold;
>> +       dev->target_freq = do_percent(dev->target_freq, avg_sustain_coef);
>> +       dev->target_freq += dev->boost_freq;
>> +
>> +       if (dev->avg_count >= dev->config->avg_dependency_threshold)
>> +               dev->target_freq = max(dev->target_freq, static_cpu_emc_freq);
>> +
>> +       spin_unlock_irqrestore(&tegra->lock, flags);
>> +}
>> +
>> +static irqreturn_t actmon_thread_isr(int irq, void *data)
>> +{
>> +       struct tegra_devfreq *tegra = data;
>> +
>> +       mutex_lock(&tegra->devfreq->lock);
>> +       update_devfreq(tegra->devfreq);
>> +       mutex_unlock(&tegra->devfreq->lock);
>> +
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static int tegra_actmon_rate_notify_cb(struct notifier_block *nb,
>> +                                      unsigned long action, void *ptr)
>> +{
>> +       struct clk_notifier_data *data = ptr;
>> +       struct tegra_devfreq *tegra = container_of(nb, struct tegra_devfreq,
>> +                                                  rate_change_nb);
>> +       unsigned int i;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&tegra->lock, flags);
>> +
>> +       switch (action) {
>> +       case POST_RATE_CHANGE:
>> +               tegra->cur_freq = data->new_rate / KHZ;
>> +
>> +               for (i = 0; i < ARRAY_SIZE(tegra->devices); i++)
>> +                       tegra_devfreq_update_wmark(tegra, tegra->devices + i);
>> +
>> +               actmon_write_barrier(tegra);
>> +               break;
>> +       case PRE_RATE_CHANGE:
>> +               /* fall through */
>> +       case ABORT_RATE_CHANGE:
>
> Can't you use "default:" here instead?

Yeah, this needs simplifying.

>> +               break;
>> +       };
>> +
>> +       spin_unlock_irqrestore(&tegra->lock, flags);
>> +
>> +       return NOTIFY_OK;
>> +}
>> +
>> +static void tegra_actmon_configure_device(struct tegra_devfreq *tegra,
>> +                                         struct tegra_devfreq_device *dev)
>> +{
>> +       u32 val;
>> +
>> +       dev->avg_band_freq = tegra->max_freq * ACTMON_DEFAULT_AVG_BAND / KHZ;
>> +       dev->target_freq = tegra->cur_freq;
>> +
>> +       dev->avg_count = tegra->cur_freq * ACTMON_SAMPLING_PERIOD;
>> +       writel(dev->avg_count, dev->regs + ACTMON_DEV_INIT_AVG);
>> +
>> +       tegra_devfreq_update_avg_wmark(dev);
>> +       tegra_devfreq_update_wmark(tegra, dev);
>> +
>> +       writel(ACTMON_COUNT_WEIGHT, dev->regs + ACTMON_DEV_COUNT_WEIGHT);
>> +       writel(ACTMON_INTR_STATUS_CLEAR, dev->regs + ACTMON_DEV_INTR_STATUS);
>> +
>> +       val = 0;
>> +       val |= ACTMON_DEV_CTRL_ENB_PERIODIC |
>> +              ACTMON_DEV_CTRL_AVG_ABOVE_WMARK_EN |
>> +              ACTMON_DEV_CTRL_AVG_BELOW_WMARK_EN;
>> +       val |= (ACTMON_AVERAGE_WINDOW_LOG2 - 1)
>> +               << ACTMON_DEV_CTRL_K_VAL_SHIFT;
>> +       val |= (ACTMON_BELOW_WMARK_WINDOW - 1)
>> +               << ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_NUM_SHIFT;
>> +       val |= (ACTMON_ABOVE_WMARK_WINDOW - 1)
>> +               << ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_NUM_SHIFT;
>> +       val |= ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN |
>> +              ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN;
>> +
>> +       writel(val, dev->regs + ACTMON_DEV_CTRL);
>> +
>> +       actmon_write_barrier(tegra);
>> +
>> +       val = readl(dev->regs + ACTMON_DEV_CTRL);
>> +       val |= ACTMON_DEV_CTRL_ENB;
>> +       writel(val, dev->regs + ACTMON_DEV_CTRL);
>> +
>> +       actmon_write_barrier(tegra);
>> +}
>> +
>> +static int tegra_devfreq_suspend(struct device *dev)
>> +{
>> +       struct platform_device *pdev;
>> +       struct tegra_devfreq *tegra;
>> +       struct tegra_devfreq_device *actmon_dev;
>> +       unsigned int i;
>> +       u32 val;
>> +
>> +       pdev = container_of(dev, struct platform_device, dev);
>> +       tegra = platform_get_drvdata(pdev);
>> +
>> +       for (i = 0; i < ARRAY_SIZE(tegra->devices); i++) {
>> +               actmon_dev = &tegra->devices[i];
>> +
>> +               val = readl(actmon_dev->regs + ACTMON_DEV_CTRL);
>> +               val &= ~ACTMON_DEV_CTRL_ENB;
>> +               writel(val, actmon_dev->regs + ACTMON_DEV_CTRL);
>> +
>> +               writel(ACTMON_INTR_STATUS_CLEAR,
>> +                      actmon_dev->regs + ACTMON_DEV_INTR_STATUS);
>> +
>> +               actmon_write_barrier(tegra);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int tegra_devfreq_resume(struct device *dev)
>> +{
>> +       struct platform_device *pdev;
>> +       struct tegra_devfreq *tegra;
>> +       struct tegra_devfreq_device *actmon_dev;
>> +       unsigned int i;
>> +
>> +       pdev = container_of(dev, struct platform_device, dev);
>> +       tegra = platform_get_drvdata(pdev);
>> +
>> +       for (i = 0; i < ARRAY_SIZE(tegra->devices); i++) {
>> +               actmon_dev = &tegra->devices[i];
>> +
>> +               tegra_actmon_configure_device(tegra, actmon_dev);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int tegra_devfreq_target(struct device *dev, unsigned long *freq,
>> +                               u32 flags)
>> +{
>> +       struct platform_device *pdev;
>> +       struct tegra_devfreq *tegra;
>> +       struct dev_pm_opp *opp;
>> +       unsigned long rate = *freq * KHZ;
>> +
>> +       pdev = container_of(dev, struct platform_device, dev);
>> +       tegra = platform_get_drvdata(pdev);
>> +
>> +       rcu_read_lock();
>> +       opp = devfreq_recommended_opp(dev, &rate, flags);
>> +       if (IS_ERR(opp)) {
>> +               rcu_read_unlock();
>> +               dev_err(dev, "Failed to find opp for %lu KHz\n", *freq);
>> +               return PTR_ERR(opp);
>> +       }
>> +       rate = dev_pm_opp_get_freq(opp);
>> +       rcu_read_unlock();
>> +
>> +       /* TODO: Once we have per-user clk constraints, set a floor */
>> +       clk_set_rate(tegra->emc_clock, rate);
>> +
>> +       /* TODO: Set voltage as well */
>> +
>> +       return 0;
>> +}
>> +
>> +static int tegra_devfreq_get_dev_status(struct device *dev,
>> +                                       struct devfreq_dev_status *stat)
>> +{
>> +       struct platform_device *pdev;
>> +       struct tegra_devfreq *tegra;
>> +       struct tegra_devfreq_device *actmon_dev;
>> +
>> +       pdev = container_of(dev, struct platform_device, dev);
>> +       tegra = platform_get_drvdata(pdev);
>> +
>> +       stat->current_frequency = tegra->cur_freq;
>> +
>> +       /* To be used by the tegra governor */
>> +       stat->private_data = tegra;
>> +
>> +       /* The below are to be used by the other governors */
>> +
>> +       actmon_dev = &tegra->devices[MCALL];
>> +
>> +       /* Number of cycles spent on memory access */
>> +       stat->busy_time = actmon_dev->avg_count;
>> +
>> +       /* The bus can be considered to be saturated way before 100% */
>> +       stat->busy_time *= 100 / BUS_SATURATION_RATIO;
>> +
>> +       /* Number of cycles in a sampling period */
>> +       stat->total_time = ACTMON_SAMPLING_PERIOD * tegra->cur_freq;
>> +
>> +       return 0;
>> +}
>> +
>> +static int tegra_devfreq_get_target(struct devfreq *devfreq,
>> +                                   unsigned long *freq)
>> +{
>> +       struct devfreq_dev_status stat;
>> +       struct tegra_devfreq *tegra;
>> +       struct tegra_devfreq_device *dev;
>> +       unsigned long target_freq = 0;
>> +       unsigned int i;
>> +       int err;
>> +
>> +       err = devfreq->profile->get_dev_status(devfreq->dev.parent, &stat);
>> +       if (err)
>> +               return err;
>> +
>> +       tegra = stat.private_data;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(tegra->devices); i++) {
>> +               dev = &tegra->devices[i];
>> +
>> +               actmon_update_target(tegra, dev);
>> +
>> +               target_freq = max(target_freq, dev->target_freq);
>> +       }
>
> I *think* you should be able to remove the dependency on
> tegra_devfreq_device from this function (ideally, governors should be
> device-agnostic). Since you call get_dev_status() from this function
> anyway, why not moving the actmon_update_target() calls into
> tegra_devfreq_get_dev_status(), and write busy_time/total_time values
> that will make tegra_devfreq_get_target() infer the right frequency?
>
>> +
>> +       *freq = target_freq;
>> +
>> +       return 0;
>> +}
>> +
>> +static int tegra_devfreq_event_handler(struct devfreq *devfreq,
>> +                                      unsigned int event, void *data)
>> +{
>> +       return 0;
>> +}
>
> I think you will need an implementation of this. Upon
> DEVFREQ_GOV_START/DEVFREQ_GOV_RESUME, enable actmon interrupts. On
> DEVFREQ_GOV_STOP/DEVFREQ_GOV_SUSPEND, disable interrupts. I know you
> are doing it somewhere, but it should be done here as this is what
> devfreq expects (e.g. to correctly stop interrupts if you switch from
> the "tegra" to the "performance" governor).
>
> Sadly, this adds the exact same dependency on tegra_devfreq that I
> tried to remove from the previous function, which is unfortunate. This
> is where watermarking support in devfreq would be useful - when
> starting the governor, we could ask the device to monitor some low and
> high marks through new hooks and handle all this nicely.

Wonder if the devfreq maintainers have an opinion on this.

>> +
>> +static struct devfreq_governor tegra_devfreq_governor = {
>> +       .name = "tegra",
>
> This governor could certainly get a more specific name. :P

Fair.

>> +       .get_target_freq = tegra_devfreq_get_target,
>> +       .event_handler = tegra_devfreq_event_handler,
>> +};
>> +
>> +static struct devfreq_dev_profile tegra_devfreq_profile = {
>> +       .polling_ms     = 0,
>> +       .target         = tegra_devfreq_target,
>> +       .get_dev_status = tegra_devfreq_get_dev_status,
>> +};
>
> Maybe move this declaration right after the declaration of
> tegra_devfreq_get_dev_status() to make things easier to put together
> in the reader's mind.

Agreed.

>> +
>> +static int tegra_devfreq_probe(struct platform_device *pdev)
>> +{
>> +       struct tegra_devfreq *tegra;
>> +       struct tegra_devfreq_device *dev;
>> +       struct resource *res;
>> +       unsigned long max_freq;
>> +       unsigned int i;
>> +       int irq;
>> +       int err;
>> +
>> +       tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
>> +       if (!tegra)
>> +               return -ENOMEM;
>> +
>> +       spin_lock_init(&tegra->lock);
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       if (!res) {
>> +               dev_err(&pdev->dev, "Failed to get regs resource\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       tegra->regs = devm_ioremap_resource(&pdev->dev, res);
>> +       if (IS_ERR(tegra->regs)) {
>> +               dev_err(&pdev->dev, "Failed to get IO memory\n");
>> +               return PTR_ERR(tegra->regs);
>> +       }
>> +
>> +       tegra->reset = devm_reset_control_get(&pdev->dev, "actmon");
>> +       if (IS_ERR(tegra->reset)) {
>> +               dev_err(&pdev->dev, "Failed to get reset\n");
>> +               return PTR_ERR(tegra->reset);
>> +       }
>> +
>> +       tegra->clock = devm_clk_get(&pdev->dev, "actmon");
>> +       if (IS_ERR(tegra->clock)) {
>> +               dev_err(&pdev->dev, "Failed to get actmon clock\n");
>> +               return PTR_ERR(tegra->clock);
>> +       }
>> +
>> +       tegra->emc_clock = devm_clk_get(&pdev->dev, "emc");
>> +       if (IS_ERR(tegra->emc_clock)) {
>> +               dev_err(&pdev->dev, "Failed to get emc clock\n");
>> +               return PTR_ERR(tegra->emc_clock);
>> +       }
>> +
>> +       err = of_init_opp_table(&pdev->dev);
>> +       if (err) {
>> +               dev_err(&pdev->dev, "Failed to init operating point table\n");
>> +               return err;
>> +       }
>> +
>> +       tegra->rate_change_nb.notifier_call = tegra_actmon_rate_notify_cb;
>> +       err = clk_notifier_register(tegra->emc_clock, &tegra->rate_change_nb);
>> +       if (err) {
>> +               dev_err(&pdev->dev,
>> +                       "Failed to register rate change notifier\n");
>> +               return err;
>> +       }
>> +
>> +       reset_control_assert(tegra->reset);
>> +
>> +       err = clk_prepare_enable(tegra->clock);
>> +       if (err) {
>> +               reset_control_deassert(tegra->reset);
>> +               return err;
>> +       }
>> +
>> +       reset_control_deassert(tegra->reset);
>> +
>> +       max_freq = clk_round_rate(tegra->emc_clock, ULONG_MAX);
>> +       tegra->max_freq = max_freq / KHZ;
>> +
>> +       clk_set_rate(tegra->emc_clock, max_freq);
>> +
>> +       tegra->cur_freq = clk_get_rate(tegra->emc_clock) / KHZ;
>> +
>> +       writel(ACTMON_SAMPLING_PERIOD - 1,
>> +              tegra->regs + ACTMON_GLB_PERIOD_CTRL);
>> +
>> +       for (i = 0; i < ARRAY_SIZE(actmon_device_configs); i++) {
>> +               dev = tegra->devices + i;
>> +               dev->config = actmon_device_configs + i;
>> +               dev->regs = tegra->regs + dev->config->offset;
>> +
>> +               tegra_actmon_configure_device(tegra, tegra->devices + i);
>> +       }
>> +
>> +       err = devfreq_add_governor(&tegra_devfreq_governor);
>
> This should probably be done in an initcall (that would be executed
> before probe() is called). We can in theory have several instances of
> ACTMON, but the governor should only be added once in all cases. I
> understand that this is unlikely to happen in practice though.

Will look at this.

>> +       if (err) {
>> +               dev_err(&pdev->dev, "Failed to add governor\n");
>> +               return err;
>> +       }
>> +
>> +       tegra_devfreq_profile.initial_freq = clk_get_rate(tegra->emc_clock);
>> +       tegra->devfreq = devm_devfreq_add_device(&pdev->dev,
>> +                                                &tegra_devfreq_profile,
>> +                                                "tegra",
>
> I think "tegra_actmon" would look better here. :)

Agreed.

>> +                                                NULL);
>> +
>> +       irq = platform_get_irq(pdev, 0);
>> +       err = devm_request_threaded_irq(&pdev->dev, irq, actmon_isr,
>> +                                       actmon_thread_isr, IRQF_SHARED,
>> +                                       "tegra-devfreq", tegra);
>
> You probably ought to do this *before* adding the devfreq device,
> otherwise you are at risk of receiving interrupts nobody will handle.

I don't get this one. The IRQ is requested as soon as everything is in
place to handle it.

>> +       if (err) {
>> +               dev_err(&pdev->dev, "Interrupt request failed\n");
>> +               return err;
>> +       }
>> +
>> +       platform_set_drvdata(pdev, tegra);
>
> This should also be done before the call to devfreq_add_device().

Shouldn't this be done between devfreq_add_device and
devm_request_threaded_irq? Guess I'm missing something.

>> +
>> +       return 0;
>> +}
>> +
>> +static int tegra_devfreq_remove(struct platform_device *pdev)
>> +{
>> +       struct tegra_devfreq *tegra = platform_get_drvdata(pdev);
>> +
>> +       clk_notifier_unregister(tegra->emc_clock, &tegra->rate_change_nb);
>> +
>> +       clk_disable_unprepare(tegra->clock);
>
> There seems to be a lot missing in this function, like removing the
> devfreq device?

Those resources are managed, so devm should take care of releasing them.

Thanks,

Tomeu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
