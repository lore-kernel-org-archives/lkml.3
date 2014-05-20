Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaETQth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:49:37 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:38347 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaETQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:49:35 -0400
MIME-Version: 1.0
In-Reply-To: <0fcd08cda4001198c02fb41f3e6437bf758417d1.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
	<0fcd08cda4001198c02fb41f3e6437bf758417d1.1400302114.git.viresh.kumar@linaro.org>
Date: Tue, 20 May 2014 09:49:35 -0700
X-Google-Sender-Auth: 9IySa4BwcEZZjib9iQcoNvf4GSM
Message-ID: <CAD=FV=Wt2n=uZF2oZ9pnjTTjU2E-fbjk40mNXDxE067Z6uutZA@mail.gmail.com>
Subject: Re: [PATCH V3 4/4] cpufreq: Tegra: implement intermediate frequency callbacks
From: Doug Anderson <dianders@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh,

On Fri, May 16, 2014 at 9:51 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Tegra had always been switching to intermediate frequency (pll_p_clk) since
> ever. CPUFreq core has better support for handling notifications for these
> frequencies and so we can adapt Tegra's driver to it.
>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/tegra-cpufreq.c | 71 +++++++++++++++++++++--------------------
>  1 file changed, 37 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
> index 6e774c6..fc66442 100644
> --- a/drivers/cpufreq/tegra-cpufreq.c
> +++ b/drivers/cpufreq/tegra-cpufreq.c
> @@ -46,10 +46,19 @@ static struct clk *pll_x_clk;
>  static struct clk *pll_p_clk;
>  static struct clk *emc_clk;
>
> -static int tegra_cpu_clk_set_rate(unsigned long rate)
> +static unsigned int
> +tegra_get_intermediate(struct cpufreq_policy *policy, unsigned int index)
> +{
> +       return clk_get_rate(pll_p_clk) / 1000; /* kHz */
> +}
> +
> +static int
> +tegra_target_intermediate(struct cpufreq_policy *policy, unsigned int frequency)

Note that in the old code you used to set the "emc" clock before the
transition to the intermediate clock.  Now you don't.  Are you sure
it's OK to change this order?


> @@ -98,10 +88,21 @@ static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
>         else
>                 clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
>
> -       ret = tegra_cpu_clk_set_rate(rate * 1000);
> +       if (rate == clk_get_rate(pll_p_clk))

Shouldn't this be "rate * 1000 =="?

> +               goto out;
> +
> +       ret = clk_set_rate(pll_x_clk, rate * 1000);
> +       if (ret) {
> +               pr_err("Failed to change pll_x to %lu\n", rate);
> +               goto out;
> +       }

I feel like this should be in tegra_target_intermediate(), since it
could fail (right?).  Essentially we want to be as sure as possible
that tegra_target() doesn't return an error code.


> +
> +       ret = clk_set_parent(cpu_clk, pll_x_clk);

Presumably this won't actually ever fail, since that violates the
rules that target() shouldn't fail if you used an intermediate
frequency.

-Doug
