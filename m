Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaG1OBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:01:43 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52024 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaG1OBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:01:42 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 02/14] clk: Create of_clk_shared_by_cpus()
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net,
        shawn.guo@linaro.org
Cc: nm@ti.com, linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, t.figa@samsung.com,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org,
        thomas.ab@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>,
        arvind.chauhan@arm.com, spk.linux@gmail.com
In-Reply-To: <5f7164d789e87c62d722b575980c92dfd0504334.1404231535.git.viresh.kumar@linar
	o.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<5f7164d789e87c62d722b575980c92dfd0504334.1404231535.git.viresh.kumar@linaro.org>
Date: Mon, 28 Jul 2014 08:01:15 -0600
Message-Id: <20140728140115.D8FCEC40BFD@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jul 2014 22:02:31 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Create a new routine of_clk_shared_by_cpus() that finds if clock lines are
> shared between two CPUs. This is verified by comparing "clocks" property from
> CPU's DT node.
> 
> Returns 1 if clock line is shared between them, 0 if clock isn't shared and
> return appropriate errors in case nodes/properties are missing.
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/clk/clk.c   | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h |  6 ++++++
>  2 files changed, 62 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 8b73ede..497735c 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/clk-private.h>
> +#include <linux/cpu.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> @@ -2528,6 +2529,61 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
>  }
>  EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
>  
> +/**
> + * of_clk_shared_by_cpus - Finds if clock line is shared between CPUs
> + * @cpu1, cpu2: CPU numbers
> + *
> + * Finds if clock lines are shared by two CPUs. This is verified by comparing
> + * "clocks" property from CPU's DT node.
> + *
> + * Returns 1 if clock line is shared between them, 0 if clock isn't shared.
> + * Return appropriate errors in case some requirements aren't met.
> + */
> +int of_clk_shared_by_cpus(int cpu1, int cpu2)
> +{
> +	struct device *cpu1_dev, *cpu2_dev;
> +	struct device_node *np1, *np2;
> +	int ret;
> +
> +	cpu1_dev = get_cpu_device(cpu1);
> +	if (!cpu1_dev) {
> +		pr_err("%s: failed to get cpu_dev for cpu%d\n", __func__, cpu1);
> +		return -ENODEV;
> +	}
> +
> +	cpu2_dev = get_cpu_device(cpu2);
> +	if (!cpu2_dev) {
> +		pr_err("%s: failed to get cpu_dev for cpu%d\n", __func__, cpu2);
> +		return -ENODEV;
> +	}
> +
> +	np1 = of_node_get(cpu1_dev->of_node);
> +	if (!np1) {
> +		pr_err("%s: failed to find of_node for cpu%d\n", __func__,
> +		       cpu1);
> +		return -ENODEV;
> +	}
> +
> +	np2 = of_node_get(cpu2_dev->of_node);
> +	if (!np2) {
> +		pr_err("%s: failed to find of_node for cpu%d\n", __func__,
> +		       cpu2);
> +		ret = -ENODEV;
> +		goto put_np1;
> +	}
> +
> +	/* Match "clocks" property */
> +	ret = of_property_match(np1, np2, "clocks");

This looks naïve. It is entirely possible for different clock specifiers
to resolve to the same clock line, or for there to be multple clocks in
the clocks property. This looks like a buggy way to do it. The only
reliable way to determine if two clocks resolve to the same thing is to
resolve the references with the clock controller.

g.
