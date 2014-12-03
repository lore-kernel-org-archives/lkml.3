Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaLCPJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:09:24 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:61760 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaLCPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:09:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141202111501.GE6135@ulmo>
References: <1416832111-367-1-git-send-email-tomeu.vizoso@collabora.com>
 <1416832111-367-3-git-send-email-tomeu.vizoso@collabora.com> <20141202111501.GE6135@ulmo>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Wed, 3 Dec 2014 16:09:00 +0100
X-Google-Sender-Auth: Kd8GPEshjmI8UIAfY0Dv2w4Iflw
Message-ID: <CAAObsKB9hqU5F6ptJn=qC_AEE8YW7yGKhNaTY6RfJPxOt1y-VQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] PM / devfreq: tegra: add devfreq driver for Tegra
 Activity Monitor
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 December 2014 at 12:15, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Mon, Nov 24, 2014 at 01:28:17PM +0100, Tomeu Vizoso wrote:
>> The ACTMON block can monitor several counters, providing averaging and firing
>> interrupts based on watermarking configuration. This implementation monitors
>> the MCALL and MCCPU counters to choose an appropriate frequency for the
>> external memory clock.
>>
>> This patch is based on work by Alex Frid <afrid@nvidia.com> and Mikko
>> Perttunen <mikko.perttunen@kapsi.fi>.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>
>> ---
>>
>> v2:   * Use devfreq
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
>>         It reads PPMU counters of memory controllers and adjusts the
>>         operating frequencies and voltages with OPP support.
>>
>> +config ARM_TEGRA_DEVFREQ
>> +       tristate "Tegra DEVFREQ Driver"
>> +       depends on ARCH_TEGRA_124_SOC
>
> I think ACTMON exists at least on Tegra30 and Tegra114 as well and it
> would be surprising if it didn't exist on Tegra132, so perhaps make this
> dependency simply ARCH_TEGRA?

Ok.

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
>> @@ -7,3 +7,4 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)   += governor_userspace.o
>>  # DEVFREQ Drivers
>>  obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)        += exynos/
>>  obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)        += exynos/
>> +obj-$(CONFIG_ARM_TEGRA_DEVFREQ)              += tegra-devfreq.o
>> diff --git a/drivers/devfreq/tegra-devfreq.c b/drivers/devfreq/tegra-devfreq.c
>> new file mode 100644
>> index 0000000..3479096
>> --- /dev/null
>> +++ b/drivers/devfreq/tegra-devfreq.c
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
> [...]
>> +/* activity counter is incremented every 256 memory transactions, and each
>
> Proper block-comments should be:
>
>         /*
>          * activity counter...
>          * ...
>          */
>
> Also it's a sentence, therefore should start with a capital 'A'.

Done.

>> + * transaction takes 4 EMC clocks for Tegra124; So the COUNT_WEIGHT is
>> + * 4 * 256 = 1024.
>> + */
>> +#define ACTMON_COUNT_WEIGHT                                  0x400
>> +
>> +/*
>> + * ACTMON_AVERAGE_WINDOW_LOG2: default value for @DEV_CTRL_K_VAL, which
>> + * translates to 2 ^ (K_VAL + 1). ex: 2 ^ (6 + 1) = 128
>> + */
>> +#define ACTMON_AVERAGE_WINDOW_LOG2                   6
>> +#define ACTMON_SAMPLING_PERIOD                               12 /* ms */
>> +#define ACTMON_DEFAULT_AVG_BAND                              6  /* 1/10 of % */
>> +
>> +#define KHZ                                                  1000
>> +
>> +/* Assume that the bus is saturated if the utilization is 25% */
>> +#define BUS_SATURATION_RATIO                                 25
> [...]
>> +static void tegra_actmon_configure_device(struct tegra_devfreq *tegra,
>> +                                       struct tegra_devfreq_device *dev)
>> +{
>> +     u32 val;
>> +
>> +     dev->avg_band_freq = tegra->max_freq * ACTMON_DEFAULT_AVG_BAND / KHZ;
>> +     dev->target_freq = tegra->cur_freq;
>> +
>> +     dev->avg_count = tegra->cur_freq * ACTMON_SAMPLING_PERIOD;
>> +     writel(dev->avg_count, dev->regs + ACTMON_DEV_INIT_AVG);
>> +
>> +     tegra_devfreq_update_avg_wmark(dev);
>> +     tegra_devfreq_update_wmark(tegra, dev);
>> +
>> +     writel(ACTMON_COUNT_WEIGHT, dev->regs + ACTMON_DEV_COUNT_WEIGHT);
>> +     writel(ACTMON_INTR_STATUS_CLEAR, dev->regs + ACTMON_DEV_INTR_STATUS);
>> +
>> +     val = 0;
>
> You could initialize this to 0 and then save this one line.

Cool.

>> +     val |= ACTMON_DEV_CTRL_ENB_PERIODIC |
>> +            ACTMON_DEV_CTRL_AVG_ABOVE_WMARK_EN |
>> +            ACTMON_DEV_CTRL_AVG_BELOW_WMARK_EN;
>> +     val |= (ACTMON_AVERAGE_WINDOW_LOG2 - 1)
>> +             << ACTMON_DEV_CTRL_K_VAL_SHIFT;
>> +     val |= (ACTMON_BELOW_WMARK_WINDOW - 1)
>> +             << ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_NUM_SHIFT;
>> +     val |= (ACTMON_ABOVE_WMARK_WINDOW - 1)
>> +             << ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_NUM_SHIFT;
>> +     val |= ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN |
>> +            ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN;
>> +
>> +     writel(val, dev->regs + ACTMON_DEV_CTRL);
>> +
>> +     actmon_write_barrier(tegra);
>> +
>> +     val = readl(dev->regs + ACTMON_DEV_CTRL);
>> +     val |= ACTMON_DEV_CTRL_ENB;
>> +     writel(val, dev->regs + ACTMON_DEV_CTRL);
>> +
>> +     actmon_write_barrier(tegra);
>> +}
>> +
>> +static int tegra_devfreq_suspend(struct device *dev)
>> +{
>> +     struct platform_device *pdev;
>> +     struct tegra_devfreq *tegra;
>> +     struct tegra_devfreq_device *actmon_dev;
>> +     unsigned int i;
>> +     u32 val;
>> +
>> +     pdev = container_of(dev, struct platform_device, dev);
>> +     tegra = platform_get_drvdata(pdev);
>
> This is equivalent to just:
>
>         struct tegra_devfreq *tegra = dev_get_drvdata(dev);
>
> which you can then simply put at the top of the local variable
> declarations.

Good, thanks.

>> +
>> +     for (i = 0; i < ARRAY_SIZE(tegra->devices); i++) {
>> +             actmon_dev = &tegra->devices[i];
>> +
>> +             val = readl(actmon_dev->regs + ACTMON_DEV_CTRL);
>> +             val &= ~ACTMON_DEV_CTRL_ENB;
>> +             writel(val, actmon_dev->regs + ACTMON_DEV_CTRL);
>> +
>> +             writel(ACTMON_INTR_STATUS_CLEAR,
>> +                    actmon_dev->regs + ACTMON_DEV_INTR_STATUS);
>
> Why do you need to clear pending interrupts on suspend? Isn't this going
> to cause pending ones to be missed upon resume?

We are completely reconfiguring the ACTMON devices on resume, so I
think we want to ignore any pending interrupts.

>> +
>> +             actmon_write_barrier(tegra);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int tegra_devfreq_resume(struct device *dev)
>> +{
>> +     struct platform_device *pdev;
>> +     struct tegra_devfreq *tegra;
>> +     struct tegra_devfreq_device *actmon_dev;
>> +     unsigned int i;
>> +
>> +     pdev = container_of(dev, struct platform_device, dev);
>> +     tegra = platform_get_drvdata(pdev);
>
> Same here. And in a few other places as well.
>
>> +
>> +     for (i = 0; i < ARRAY_SIZE(tegra->devices); i++) {
>> +             actmon_dev = &tegra->devices[i];
>> +
>> +             tegra_actmon_configure_device(tegra, actmon_dev);
>> +     }
>> +
>> +     return 0;
>> +}
>
> You'll want to protect the tegra_devfreq_{suspend,resume}() with an
> #ifdef CONFIG_PM_SLEEP to avoid potential build warnings (in randconfig
> builds for example).
>
> These are also somewhat oddly placed. Perhaps move them below
> tegra_devfreq_remove() for more natural ordering?

Good, thanks.

>> +static int tegra_devfreq_probe(struct platform_device *pdev)
>> +{
>> +     struct tegra_devfreq *tegra;
>> +     struct tegra_devfreq_device *dev;
>> +     struct resource *res;
>> +     unsigned long max_freq;
>> +     unsigned int i;
>> +     int irq;
>> +     int err;
>> +
>> +     tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
>> +     if (!tegra)
>> +             return -ENOMEM;
>> +
>> +     spin_lock_init(&tegra->lock);
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (!res) {
>> +             dev_err(&pdev->dev, "Failed to get regs resource\n");
>> +             return -ENODEV;
>> +     }
>
> No need for this check, devm_ioremap_resource() does it for you.
>
>> +
>> +     tegra->regs = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(tegra->regs)) {
>> +             dev_err(&pdev->dev, "Failed to get IO memory\n");
>
> No need for the error message either.

Nice.

>> +             return PTR_ERR(tegra->regs);
>> +     }
>> +
>> +     tegra->reset = devm_reset_control_get(&pdev->dev, "actmon");
>> +     if (IS_ERR(tegra->reset)) {
>> +             dev_err(&pdev->dev, "Failed to get reset\n");
>> +             return PTR_ERR(tegra->reset);
>> +     }
>> +
>> +     tegra->clock = devm_clk_get(&pdev->dev, "actmon");
>> +     if (IS_ERR(tegra->clock)) {
>> +             dev_err(&pdev->dev, "Failed to get actmon clock\n");
>> +             return PTR_ERR(tegra->clock);
>> +     }
>> +
>> +     tegra->emc_clock = devm_clk_get(&pdev->dev, "emc");
>> +     if (IS_ERR(tegra->emc_clock)) {
>> +             dev_err(&pdev->dev, "Failed to get emc clock\n");
>> +             return PTR_ERR(tegra->emc_clock);
>> +     }
>> +
>> +     err = of_init_opp_table(&pdev->dev);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "Failed to init operating point table\n");
>> +             return err;
>> +     }
>> +
>> +     tegra->rate_change_nb.notifier_call = tegra_actmon_rate_notify_cb;
>> +     err = clk_notifier_register(tegra->emc_clock, &tegra->rate_change_nb);
>> +     if (err) {
>> +             dev_err(&pdev->dev,
>> +                     "Failed to register rate change notifier\n");
>> +             return err;
>> +     }
>> +
>> +     reset_control_assert(tegra->reset);
>> +
>> +     err = clk_prepare_enable(tegra->clock);
>> +     if (err) {
>> +             reset_control_deassert(tegra->reset);
>
> I'm not so sure if it makes much sense to deassert reset when the driver
> fails to probe.

Ok.

>> +             return err;
>> +     }
>> +
>> +     reset_control_deassert(tegra->reset);
>> +
>> +     max_freq = clk_round_rate(tegra->emc_clock, ULONG_MAX);
>> +     tegra->max_freq = max_freq / KHZ;
>> +
>> +     clk_set_rate(tegra->emc_clock, max_freq);
>> +
>> +     tegra->cur_freq = clk_get_rate(tegra->emc_clock) / KHZ;
>> +
>> +     writel(ACTMON_SAMPLING_PERIOD - 1,
>> +            tegra->regs + ACTMON_GLB_PERIOD_CTRL);
>> +
>> +     for (i = 0; i < ARRAY_SIZE(actmon_device_configs); i++) {
>> +             dev = tegra->devices + i;
>> +             dev->config = actmon_device_configs + i;
>> +             dev->regs = tegra->regs + dev->config->offset;
>> +
>> +             tegra_actmon_configure_device(tegra, tegra->devices + i);
>
> The second parameter can simply be "dev" here, can't it?

You are right.

>> +     }
>> +
>> +     err = devfreq_add_governor(&tegra_devfreq_governor);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "Failed to add governor\n");
>> +             return err;
>> +     }
>> +
>> +     tegra_devfreq_profile.initial_freq = clk_get_rate(tegra->emc_clock);
>> +     tegra->devfreq = devm_devfreq_add_device(&pdev->dev,
>> +                                              &tegra_devfreq_profile,
>> +                                              "tegra",
>> +                                              NULL);
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     err = devm_request_threaded_irq(&pdev->dev, irq, actmon_isr,
>> +                                     actmon_thread_isr, IRQF_SHARED,
>> +                                     "tegra-devfreq", tegra);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "Interrupt request failed\n");
>> +             return err;
>> +     }
>> +
>> +     platform_set_drvdata(pdev, tegra);
>> +
>> +     return 0;
>> +}
>> +
>> +static int tegra_devfreq_remove(struct platform_device *pdev)
>> +{
>> +     struct tegra_devfreq *tegra = platform_get_drvdata(pdev);
>> +
>> +     clk_notifier_unregister(tegra->emc_clock, &tegra->rate_change_nb);
>> +
>> +     clk_disable_unprepare(tegra->clock);
>> +
>> +     return 0;
>> +}
>
> You'll need to be wary about using devm_request_threaded_irq(). You have
> to make sure that the interrupt handler isn't accessing any data that
> could be freed via the devres mechanism before the IRQ is freed. Given
> that devres frees resources in the opposite order than they were
> allocated, and given that you request the interrupt last it /should be/
> safe.
>
> Then again you do disable and unprepare the clock, so if you were to
> access registers from the interrupt handler (called after clock disable
> and before IRQ free) you could possibly cause a hang.
>
> Often the simplest is to just explicitly call devm_free_irq() in your
> .remove().

Thanks for the explanation.

>> +static SIMPLE_DEV_PM_OPS(tegra_devfreq_pm_ops,
>> +                      tegra_devfreq_suspend,
>> +                      tegra_devfreq_resume);
>> +
>> +static struct of_device_id tegra_devfreq_of_match[] = {
>> +     { .compatible = "nvidia,tegra124-actmon" },
>> +     { },
>> +};
>> +
>> +static struct platform_driver tegra_devfreq_driver = {
>> +     .probe  = tegra_devfreq_probe,
>> +     .remove = tegra_devfreq_remove,
>> +     .driver = {
>> +             .name           = "tegra-devfreq",
>> +             .owner          = THIS_MODULE,
>
> No need for this with module_platform_driver().

I see.

>> +             .of_match_table = tegra_devfreq_of_match,
>> +             .pm             = &tegra_devfreq_pm_ops,
>
> Also you use tabs and spaces inconsistently here. I'd just get rid of
> any attempt to align these and simply use a single space on either side
> of the '='.

Agreed.

>> +     },
>> +};
>> +module_platform_driver(tegra_devfreq_driver);
>> +
>> +MODULE_LICENSE("GPL");
>
> According to the header comment this should be "GPL v2".

Oops.

>> +MODULE_DESCRIPTION("Tegra devfreq driver");
>> +MODULE_AUTHOR("Tomeu Vizoso <tomeu.vizoso@collabora.com>");
>> +MODULE_DEVICE_TABLE(of, tegra_devfreq_of_match);
>
> I think it's more common to have this immediately below the OF match
> table.

Cool, thanks a lot!

Regards,

Tomeu
