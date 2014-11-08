Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaKHBTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:19:13 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56089 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752442AbaKHBTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:19:11 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Kelvin Cheung <keguang.zhang@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH V3 6/6] cpufreq: Loongson1: Add cpufreq driver for Loongson1B
Date: Sat, 08 Nov 2014 02:40 +0100
Message-ID: <15391417.y1hO0MjdpJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponU38r6V_VvGz0bd_nXsNeZQy5=KYK2UGKAQxpey7q9cg@mail.gmail.com>
References: <1413541411-26609-1-git-send-email-keguang.zhang@gmail.com> <CAKohponU38r6V_VvGz0bd_nXsNeZQy5=KYK2UGKAQxpey7q9cg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 17, 2014 04:07:50 PM Viresh Kumar wrote:
> On 17 October 2014 15:53, Kelvin Cheung <keguang.zhang@gmail.com> wrote:
> > This patch adds cpufreq driver for Loongson1B which
> > is capable of changing the CPU frequency dynamically.
> >
> > Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
> >
> > ---
> > V3:
> >    Remove superfluous devm_clk_put().
> 
> Sorry for being bad to you :)
> 
> > +static int ls1x_cpufreq_probe(struct platform_device *pdev)
> > +{
> > +       struct plat_ls1x_cpufreq *pdata = pdev->dev.platform_data;
> > +       struct clk *clk;
> > +       int ret;
> > +
> > +       if (!pdata || !pdata->clk_name || !pdata->osc_clk_name)
> > +               return -EINVAL;
> > +
> > +       ls1x_cpufreq.dev = &pdev->dev;
> > +
> > +       clk = devm_clk_get(&pdev->dev, pdata->clk_name);
> > +       if (IS_ERR(clk)) {
> > +               dev_err(ls1x_cpufreq.dev, "unable to get %s clock\n",
> > +                       pdata->clk_name);
> > +               ret = PTR_ERR(clk);
> > +               goto out;
> > +       }
> > +       ls1x_cpufreq.clk = clk;
> > +
> > +       clk = clk_get_parent(clk);
> > +       if (IS_ERR(clk)) {
> > +               dev_err(ls1x_cpufreq.dev, "unable to get parent of %s clock\n",
> > +                       __clk_get_name(ls1x_cpufreq.clk));
> > +               ret = PTR_ERR(clk);
> > +               goto out;
> > +       }
> > +       ls1x_cpufreq.mux_clk = clk;
> > +
> > +       clk = clk_get_parent(clk);
> > +       if (IS_ERR(clk)) {
> > +               dev_err(ls1x_cpufreq.dev, "unable to get parent of %s clock\n",
> > +                       __clk_get_name(ls1x_cpufreq.mux_clk));
> > +               ret = PTR_ERR(clk);
> > +               goto out;
> > +       }
> > +       ls1x_cpufreq.pll_clk = clk;
> > +
> > +       clk = devm_clk_get(&pdev->dev, pdata->osc_clk_name);
> > +       if (IS_ERR(clk)) {
> > +               dev_err(ls1x_cpufreq.dev, "unable to get %s clock\n",
> > +                       pdata->osc_clk_name);
> > +               ret = PTR_ERR(clk);
> > +               goto out;
> > +       }
> > +       ls1x_cpufreq.osc_clk = clk;
> > +
> > +       ls1x_cpufreq.max_freq = pdata->max_freq;
> > +       ls1x_cpufreq.min_freq = pdata->min_freq;
> > +
> > +       ret = cpufreq_register_driver(&ls1x_cpufreq_driver);
> > +       if (ret) {
> > +               dev_err(ls1x_cpufreq.dev,
> > +                       "failed to register cpufreq driver: %d\n", ret);
> > +               goto out;
> > +       }
> > +
> > +       ret = cpufreq_register_notifier(&ls1x_cpufreq_notifier_block,
> > +                                       CPUFREQ_TRANSITION_NOTIFIER);
> > +
> > +       if (!ret)
> > +               goto out;
> > +
> > +       dev_err(ls1x_cpufreq.dev, "failed to register cpufreq notifier: %d\n",
> > +               ret);
> > +
> > +       cpufreq_unregister_driver(&ls1x_cpufreq_driver);
> > +out:
> 
> But all these goto out; doesn't make sense anymore. Just issue returns
> from all places and add
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Patch queued up for 3.19-rc1, thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
