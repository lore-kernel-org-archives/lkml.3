Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaJPIXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:23:24 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59325 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaJPIXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <1413357812-16895-1-git-send-email-keguang.zhang@gmail.com>
References: <1413357812-16895-1-git-send-email-keguang.zhang@gmail.com>
Date: Thu, 16 Oct 2014 13:53:19 +0530
Message-ID: <CAKohpok9T1mT0Pb9ue0Pe8SMo4e6DEXzBn2mPoTo2rUHG+MTXQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] cpufreq: Loongson1: Add cpufreq driver for Loongson1B (UPDATED)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not how we send updated versions, GIT and other tools will commit
the "(UPDATED)" part while applying. What you were required to do was
something like:

git format-patch A..B --subject-prefix="PATCH V2"

On 15 October 2014 12:53, Kelvin Cheung <keguang.zhang@gmail.com> wrote:
> +static int ls1x_cpufreq_remove(struct platform_device *pdev)
> +{
> +       cpufreq_unregister_notifier(&ls1x_cpufreq_notifier_block,
> +                                   CPUFREQ_TRANSITION_NOTIFIER);
> +       cpufreq_unregister_driver(&ls1x_cpufreq_driver);
> +       clk_put(ls1x_cpufreq.osc_clk);
> +       clk_put(ls1x_cpufreq.clk);
> +
> +       return 0;
> +}
> +
> +static int ls1x_cpufreq_probe(struct platform_device *pdev)
> +{
> +       struct plat_ls1x_cpufreq *pdata = pdev->dev.platform_data;
> +       struct clk *clk;
> +       int ret;
> +
> +       if (!pdata)
> +               return -EINVAL;
> +       if (!pdata->clk_name)
> +               return -EINVAL;
> +       if (!pdata->osc_clk_name)
> +               return -EINVAL;

I didn't wanted you to do this, You could have done this:

       if (!pdata || !pdata->clk_name || !pdata->osc_clk_name)
               return -EINVAL;

So, just a || instead of && :)

> +
> +       ls1x_cpufreq.dev = &pdev->dev;
> +
> +       clk = clk_get(NULL, pdata->clk_name);

I believe we agreed for devm_clk_get(), isn't it ?

> +       if (IS_ERR(clk)) {
> +               dev_err(ls1x_cpufreq.dev, "unable to get %s clock\n",
> +                       pdata->clk_name);
> +               ret = PTR_ERR(clk);
> +               goto out;
> +       }
> +       ls1x_cpufreq.clk = clk;
> +
> +       clk = clk_get_parent(clk);
> +       if (IS_ERR(clk)) {
> +               dev_err(ls1x_cpufreq.dev, "unable to get parent of %s clock\n",
> +                       __clk_get_name(ls1x_cpufreq.clk));
> +               ret = PTR_ERR(clk);
> +               goto err_mux;
> +       }
> +       ls1x_cpufreq.mux_clk = clk;
> +
> +       clk = clk_get_parent(clk);
> +       if (IS_ERR(clk)) {
> +               dev_err(ls1x_cpufreq.dev, "unable to get parent of %s clock\n",
> +                       __clk_get_name(ls1x_cpufreq.mux_clk));
> +               ret = PTR_ERR(clk);
> +               goto err_mux;
> +       }
> +       ls1x_cpufreq.pll_clk = clk;
> +
> +       clk = clk_get(NULL, pdata->osc_clk_name);
> +       if (IS_ERR(clk)) {
> +               dev_err(ls1x_cpufreq.dev, "unable to get %s clock\n",
> +                       pdata->osc_clk_name);
> +               ret = PTR_ERR(clk);
> +               goto err_mux;
> +       }
> +       ls1x_cpufreq.osc_clk = clk;
> +
> +       ls1x_cpufreq.max_freq = pdata->max_freq;
> +       ls1x_cpufreq.min_freq = pdata->min_freq;
> +
> +       ret = cpufreq_register_driver(&ls1x_cpufreq_driver);
> +       if (ret) {
> +               dev_err(ls1x_cpufreq.dev,
> +                       "failed to register cpufreq driver: %d\n", ret);
> +               goto err_driver;
> +       }
> +
> +       ret = cpufreq_register_notifier(&ls1x_cpufreq_notifier_block,
> +                                       CPUFREQ_TRANSITION_NOTIFIER);
> +
> +       if (!ret)
> +               goto out;
> +
> +       dev_err(ls1x_cpufreq.dev, "failed to register cpufreq notifier: %d\n",
> +               ret);
> +
> +       cpufreq_unregister_driver(&ls1x_cpufreq_driver);
> +err_driver:
> +       clk_put(ls1x_cpufreq.osc_clk);
> +err_mux:
> +       clk_put(ls1x_cpufreq.clk);
> +out:
> +       return ret;
> +}
> +
> +static struct platform_driver ls1x_cpufreq_platdrv = {
> +       .driver = {
> +               .name   = "ls1x-cpufreq",
> +               .owner  = THIS_MODULE,
> +       },
> +       .probe          = ls1x_cpufreq_probe,
> +       .remove         = ls1x_cpufreq_remove,
> +};
> +
> +module_platform_driver(ls1x_cpufreq_platdrv);
> +
> +MODULE_AUTHOR("Kelvin Cheung <keguang.zhang@gmail.com>");
> +MODULE_DESCRIPTION("Loongson 1 CPUFreq driver");
> +MODULE_LICENSE("GPL");
> --
> 1.9.1
>
