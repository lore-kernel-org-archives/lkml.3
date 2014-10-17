Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaJQKhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:37:52 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:64631 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaJQKhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <1413541411-26609-1-git-send-email-keguang.zhang@gmail.com>
References: <1413541411-26609-1-git-send-email-keguang.zhang@gmail.com>
Date: Fri, 17 Oct 2014 16:07:50 +0530
Message-ID: <CAKohponU38r6V_VvGz0bd_nXsNeZQy5=KYK2UGKAQxpey7q9cg@mail.gmail.com>
Subject: Re: [PATCH V3 6/6] cpufreq: Loongson1: Add cpufreq driver for Loongson1B
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

On 17 October 2014 15:53, Kelvin Cheung <keguang.zhang@gmail.com> wrote:
> This patch adds cpufreq driver for Loongson1B which
> is capable of changing the CPU frequency dynamically.
>
> Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
>
> ---
> V3:
>    Remove superfluous devm_clk_put().

Sorry for being bad to you :)

> +static int ls1x_cpufreq_probe(struct platform_device *pdev)
> +{
> +       struct plat_ls1x_cpufreq *pdata = pdev->dev.platform_data;
> +       struct clk *clk;
> +       int ret;
> +
> +       if (!pdata || !pdata->clk_name || !pdata->osc_clk_name)
> +               return -EINVAL;
> +
> +       ls1x_cpufreq.dev = &pdev->dev;
> +
> +       clk = devm_clk_get(&pdev->dev, pdata->clk_name);
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
> +               goto out;
> +       }
> +       ls1x_cpufreq.mux_clk = clk;
> +
> +       clk = clk_get_parent(clk);
> +       if (IS_ERR(clk)) {
> +               dev_err(ls1x_cpufreq.dev, "unable to get parent of %s clock\n",
> +                       __clk_get_name(ls1x_cpufreq.mux_clk));
> +               ret = PTR_ERR(clk);
> +               goto out;
> +       }
> +       ls1x_cpufreq.pll_clk = clk;
> +
> +       clk = devm_clk_get(&pdev->dev, pdata->osc_clk_name);
> +       if (IS_ERR(clk)) {
> +               dev_err(ls1x_cpufreq.dev, "unable to get %s clock\n",
> +                       pdata->osc_clk_name);
> +               ret = PTR_ERR(clk);
> +               goto out;
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
> +               goto out;
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
> +out:

But all these goto out; doesn't make sense anymore. Just issue returns
from all places and add

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
