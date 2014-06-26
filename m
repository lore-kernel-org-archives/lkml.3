Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbaFZBzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:55:09 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37720 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbaFZBzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <53AB1CC1.4010907@codeaurora.org>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
	<e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
	<53AB1CC1.4010907@codeaurora.org>
Date: Thu, 26 Jun 2014 07:25:05 +0530
Message-ID: <CAKohpomUSzrx+6L9AZEpF3wyU+zmmw+ersgNcTdG2Tubvtfm9g@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2014 00:32, Stephen Boyd <sboyd@codeaurora.org> wrote:
> It should be easy enough to read the clocks property from DT for all the
> CPU nodes and check to see if they're the same?

Not everybody has clocks supported in DT and I am not sure if it will
even work for the current users as well..

But yeah, that's one way of finding it out.

> I don't think we need an affected-cpus property.

There was some work going around to fix bindings for CPUs that share
resources, for the bigger task of making "cpufreq work well with
scheduler". And we can use them probably.

> Also I'd like to see current DTs specifying the
> same data (clocks, regulators, opps) for each CPU node even if they all
> share the same clock, regulator, and opp. It seems that the cpu0 binding
> just wanted to save some space in the DT by consolidating them all under
> one node, but that seems misguided. Case in point, now that we have
> configurations that need more than one clock per cluster the code is
> complicated and the binding is not uniform.

Hmm, probably you are right. But again we may not have nodes for
these in DT for few users of cpufreq-cpu0 and we need to investigate
for that.

>> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> This patch would be less noisy and easier to review if we used local
> variables in this function for cpu_req, voltage_tolerance, and cpu_clk.
> Can we do that please?

Hmm, yeah will try to make it less noisy.

>> -static int cpu0_cpufreq_probe(struct platform_device *pdev)
>> -{
>> +     struct cpufreq_frequency_table *freq_table;
>> +     struct private_data *priv;
>>       struct device_node *np;
>> -     int ret;
>> +     char name[] = "cpuX";
>> +     int ret, cpu = policy->cpu;
>>
>> -     cpu_dev = get_cpu_device(0);
>> -     if (!cpu_dev) {
>> -             pr_err("failed to get cpu0 device\n");
>> -             return -ENODEV;
>> +     priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>> +     if (!priv) {
>> +             pr_err("%s: Memory allocation failed\n", __func__);
>
> Useless allocation error message.

Why so useless? You meant we should mention 'priv' here?
Will do.

>> +             return -ENOMEM;
>>       }
>>
>> -     np = of_node_get(cpu_dev->of_node);
>> -     if (!np) {
>> -             pr_err("failed to find cpu0 node\n");
>> -             return -ENOENT;
>> -     }
>> +     /* Below calls can't fail from here */
>> +     priv->cpu_dev = get_cpu_device(cpu);
>> +     np = of_node_get(priv->cpu_dev->of_node);
>>
>> -     cpu_reg = regulator_get_optional(cpu_dev, "cpu0");
>> -     if (IS_ERR(cpu_reg)) {
>> -             /*
>> -              * If cpu0 regulator supply node is present, but regulator is
>> -              * not yet registered, we should try defering probe.
>> -              */
>> -             if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
>> -                     dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
>> -                     ret = -EPROBE_DEFER;
>> -                     goto out_put_node;
>> -             }
>> -             pr_warn("failed to get cpu0 regulator: %ld\n",
>> -                     PTR_ERR(cpu_reg));
>> +     policy->clk = clk_get(priv->cpu_dev, NULL);
>> +     if (IS_ERR(policy->clk)) {
>> +             ret = PTR_ERR(policy->clk);
>> +             pr_err("%s: failed to get cpu%d clock: %d\n", __func__, cpu,
>> +                    ret);
>> +             goto out_put_node;
>>       }
>
> This won't work all the time. We need probe defer to work for the clocks
> because sometimes CPU clocks are registered after this driver probes. In
> my case this is always true unless I play games with initcall levels.
> The same is true for regulators.

Okay..

>> -     cpu_clk = clk_get(cpu_dev, NULL);
>> -     if (IS_ERR(cpu_clk)) {
>> -             ret = PTR_ERR(cpu_clk);
>> -             pr_err("failed to get cpu0 clock: %d\n", ret);
>> -             goto out_put_reg;
>> +     ret = of_init_opp_table(priv->cpu_dev);
>> +     if (ret) {
>> +             pr_err("%s: failed to init OPP table for cpu%d: %d\n", __func__,
>> +                    cpu, ret);
>> +             goto out_put_clk;
>>       }
>>
>> -     ret = of_init_opp_table(cpu_dev);
>> +     ret = dev_pm_opp_init_cpufreq_table(priv->cpu_dev, &freq_table);
>>       if (ret) {
>> -             pr_err("failed to init OPP table: %d\n", ret);
>> +             pr_err("%s: failed to init cpufreq table for cpu%d: %d\n",
>> +                    __func__, cpu, ret);
>>               goto out_put_clk;
>>       }
>>
>> -     ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
>> +     ret = cpufreq_table_validate_and_show(policy, freq_table);
>>       if (ret) {
>> -             pr_err("failed to init cpufreq table: %d\n", ret);
>> -             goto out_put_clk;
>> +             pr_err("%s: invalid frequency table for cpu%d: %d\n", __func__,
>> +                    cpu, ret);
>> +             goto out_put_reg;
>>       }
>>
>> -     of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
>> +     /* Set mask of CPUs sharing clock line with policy->cpu */
>> +     if (!clock_per_cpu)
>> +             cpumask_setall(policy->cpus);
>>
>> -     if (of_property_read_u32(np, "clock-latency", &transition_latency))
>> -             transition_latency = CPUFREQ_ETERNAL;
>> +     of_property_read_u32(np, "voltage-tolerance", &priv->voltage_tolerance);
>>
>> -     if (!IS_ERR(cpu_reg)) {
>> +     if (of_property_read_u32(np, "clock-latency",
>> +                              &policy->cpuinfo.transition_latency))
>> +             policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
>> +
>> +     /* NOTE: Supports only 10 CPUs: 0-9 */
>> +     WARN_ONCE(cpu > 9, "cpu: %d", cpu);
>
> Why would the supply name be called cpuN-supply? Why not use cpu-supply
> in each CPU node? That way there is no limit on the number of CPUs. We
> can always check for cpu0-supply first to be compatible with older DTs
> but going forward we should be able to just use cpu-supply.

Will investigate on what all needs to change for it to work..

>> +static int cpu0_cpufreq_probe(struct platform_device *pdev)
>> +{
>> +     const struct property *prop;
>> +     struct device *cpu_dev;
>> +     struct regulator *cpu_reg;
>> +     int ret, cpu, count = 0;
>> +
>> +     /* Optimization for regulator's -EPROBE_DEFER case */
>> +     if (unlikely(clock_per_cpu))
>> +             goto scan_regulator;
>
> Why not look for the regulator first then?

Maybe yes.

>> +     /*
>> +      * Scan all CPU nodes to set clock_per_cpu
>> +      *
>> +      * FIXME: Scan affected-CPUs from DT and remove this loop.
>> +      */
>> +     for_each_possible_cpu(cpu) {
>> +             cpu_dev = get_cpu_device(cpu);
>> +             if (!cpu_dev) {
>> +                     pr_err("%s: failed to get cpu%d device\n", __func__,
>> +                            cpu);
>> +                     return -ENODEV;
>> +             }
>> +
>> +             /* Count how many CPU nodes have defined operating-points */
>> +             prop = of_find_property(cpu_dev->of_node, "operating-points",
>> +                                     NULL);
>> +             if (prop) {
>> +                     count++;
>> +             } else if (cpu == 0) {
>> +                     pr_err("%s: operating-points missing: cpu%d\n",
>> +                            __func__, cpu);
>> +                     return -ENOENT;
>> +             }
>> +     }
>> +
>> +     /* Either one or all CPUs must have operating-points property */
>> +     if (count == cpu + 1) {
>
> Is this supposed to be count == cpu? At this point in the code count
> equals the number of CPUs present.

Let me know if my calculations are wrong but I wrote this intentionally.

CPUs start from zero and count is incremented by one for each cpu.
So, if there are 4 CPUs, then count is going to be 4 and cpu is going
to be 3?

>> +     cpu_reg = regulator_get_optional(cpu_dev, "cpu0");

> I don't think this driver should be using regulator_get_optional() (Mark
> B. please correct me if I'm wrong). I doubt a supply is actually
> optional for CPUs, just some DTs aren't specifying them. In those cases,
> the regulator core will insert a dummy supply and the code will work
> without having to check for probe defer and error pointers.

Wasn't aware of this, will see if that can be done in a separate patch.
