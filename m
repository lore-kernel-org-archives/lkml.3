Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaIHEqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 00:46:22 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57245 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaIHEqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 00:46:20 -0400
MIME-Version: 1.0
In-Reply-To: <1409957256-23729-16-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
	<1409957256-23729-16-git-send-email-sboyd@codeaurora.org>
Date: Mon, 8 Sep 2014 10:16:19 +0530
Message-ID: <CAKohpokLFMMK-h2657=_BCBr3oXCTiQDA+C-rDgorxfrPR-9YQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/15] cpufreq: Add module to register cpufreq on Krait CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 September 2014 04:17, Stephen Boyd <sboyd@codeaurora.org> wrote:

> diff --git a/drivers/cpufreq/qcom-cpufreq.c b/drivers/cpufreq/qcom-cpufreq.c
> new file mode 100644
> index 000000000000..aa8eb97144b6
> --- /dev/null
> +++ b/drivers/cpufreq/qcom-cpufreq.c
> @@ -0,0 +1,199 @@
> +/* Copyright (c) 2014, The Linux Foundation. All rights reserved.

Shouldn't this have Qcom instead?

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/cpu.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/pm_opp.h>
> +#include <linux/init.h>

Would be good if these can be in alphanumeric order. That helps maintaining
them later on..

> +static void __init get_krait_bin_format_a(int *speed, int *pvs, int *pvs_ver)
> +{

> +}
> +
> +static void __init get_krait_bin_format_b(int *speed, int *pvs, int *pvs_ver)
> +{

> +}

To be honest, I didn't try to apply much brain on the above routines :)

> +static int __init qcom_cpufreq_populate_opps(void)
> +{
> +       int len, num_rows, i, k;
> +       char table_name[] = "qcom,speedXX-pvsXX-bin-vXX";
> +       struct device_node *np;
> +       struct device *dev;
> +       int cpu = 0;
> +       int speed, pvs, pvs_ver;
> +       int cols;

All the 'int' declarations can be combined in a single line if you would like.

> +       np = of_find_node_by_name(NULL, "qcom,pvs");
> +       if (!np)
> +               pr_warn("Can't find PVS node\n");
> +
> +       if (of_property_read_bool(np, "qcom,pvs-format-a")) {
> +               get_krait_bin_format_a(&speed, &pvs, &pvs_ver);
> +               cols = 2;
> +       } else {
> +               get_krait_bin_format_b(&speed, &pvs, &pvs_ver);
> +               cols = 3;
> +       }
> +
> +       snprintf(table_name, sizeof(table_name),
> +                       "qcom,speed%d-pvs%d-bin-v%d", speed, pvs, pvs_ver);
> +again:
> +       dev = get_cpu_device(cpu);
> +       if (!dev)
> +               return -ENODEV;
> +
> +       if (!of_find_property(np, table_name, &len))
> +               return -EINVAL;
> +
> +       len /= sizeof(u32);
> +       if (len % cols || len == 0)
> +               return -EINVAL;
> +
> +       num_rows = len / cols;
> +
> +       for (i = 0, k = 0; i < num_rows; i++) {
> +               u32 freq, volt;
> +
> +               of_property_read_u32_index(np, table_name, k++, &freq);
> +               of_property_read_u32_index(np, table_name, k++, &volt);
> +               while (k % cols)
> +                       k++; /* Skip uA entries if present */
> +               if (dev_pm_opp_add(dev, freq, volt))
> +                       pr_warn("failed to add OPP %u\n", freq);
> +       }
> +
> +       if (cpu++ < num_possible_cpus())
> +               goto again;
> +
> +       return 0;
> +}
> +
> +static int __init qcom_cpufreq_driver_init(void)
> +{
> +       struct platform_device_info devinfo = { .name = "cpufreq-generic", };
> +       struct device *cpu_dev;
> +       struct device_node *np;
> +       struct platform_device *pdev;
> +
> +       cpu_dev = get_cpu_device(0);
> +       if (!cpu_dev)
> +               return -ENODEV;
> +
> +       np = of_node_get(cpu_dev->of_node);
> +       if (!np)
> +               return -ENOENT;
> +
> +       if (!of_device_is_compatible(np, "qcom,krait")) {
> +               of_node_put(np);
> +               return -ENODEV;
> +       }
> +       of_node_put(np);
> +
> +       qcom_cpufreq_populate_opps();
> +       pdev = platform_device_register_full(&devinfo);
> +
> +       return PTR_ERR_OR_ZERO(pdev);
> +}
> +module_init(qcom_cpufreq_driver_init);
> +
> +MODULE_DESCRIPTION("Qualcomm CPUfreq driver");

A module author as well?

> +MODULE_LICENSE("GPL v2");

Otherwise mostly good:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
