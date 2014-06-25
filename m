Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaFYTC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:02:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59089 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaFYTC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:02:27 -0400
Message-ID: <53AB1CC1.4010907@codeaurora.org>
Date: Wed, 25 Jun 2014 12:02:25 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, shawn.guo@linaro.org, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Mark Brown <broonie@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
References: <cover.1403684824.git.viresh.kumar@linaro.org> <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
In-Reply-To: <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/14 01:42, Viresh Kumar wrote:
> cpufreq-cpu0 driver supports only platforms which have single clock line shared
> among all CPUs.
>
> We already have platforms where this limitation doesn't hold true.For example on
> Qualcomm's KRAIT all CPUs have separate clock line and so have separate
> policies.

Krait is not all capitalized.

>
> Instead of adding another driver for this (Stephen just tried that:
> https://lkml.org/lkml/2014/6/24/918), we must reuse cpufreq-cpu0 driver.
>
> cpufreq-cpu0 must be updated to break the assumption on which it is based (all
> cores sharing clock line) and this patch tries to do exactly that.
>
> As we don't have standard DT bindings to mention CPUs sharing clock-line, i.e.
> affected_cpus, this patch also have few limitations. Though easy to fix once we
> have proper bindings.

It should be easy enough to read the clocks property from DT for all the
CPU nodes and check to see if they're the same? I don't think we need an
affected-cpus property. Also I'd like to see current DTs specifying the
same data (clocks, regulators, opps) for each CPU node even if they all
share the same clock, regulator, and opp. It seems that the cpu0 binding
just wanted to save some space in the DT by consolidating them all under
one node, but that seems misguided. Case in point, now that we have
configurations that need more than one clock per cluster the code is
complicated and the binding is not uniform.

>
> Limitation: We only supports two types of platforms:
> - All CPUs sharing same clock line, existing user platforms
> - All CPUs have separate clock lines, KRAIT
>
> And so platforms which have multiple clusters with multiple CPUs per cluster
> aren't supported yet. We need proper bindings for that first.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   8 +-
>  drivers/cpufreq/Kconfig                            |   5 +-
>  drivers/cpufreq/cpufreq-cpu0.c                     | 280 +++++++++++++--------
>  3 files changed, 190 insertions(+), 103 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> index f055515..fa8861e 100644
> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> @@ -1,15 +1,17 @@
>  Generic CPU0 cpufreq driver
>  
> -It is a generic cpufreq driver for CPU0 frequency management.  It
> +It is a generic cpufreq driver for CPU frequency management.  It
>  supports both uniprocessor (UP) and symmetric multiprocessor (SMP)
> -systems which share clock and voltage across all CPUs.
> +systems which share clock and voltage across all CPUs OR have separate
> +clock and voltage for all CPUs.
>  
>  Both required and optional properties listed below must be defined
>  under node /cpus/cpu@0.
>  
>  Required properties:
>  - operating-points: Refer to Documentation/devicetree/bindings/power/opp.txt
> -  for details
> +  for details. This should either be present only in cpu@0, if CPUs share clock
> +  line OR should be present in all cpu nodes, if they have separate clock lines.
>  
>  Optional properties:
>  - clock-latency: Specify the possible maximum transition latency for clock,
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index ee1ae30..d29f6a0 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -25,34 +25,43 @@
>  #include <linux/slab.h>
>  #include <linux/thermal.h>
>  
> -static unsigned int transition_latency;
> -static unsigned int voltage_tolerance; /* in percentage */
> +struct private_data {
> +	struct device *cpu_dev;
> +	struct regulator *cpu_reg;
> +	struct thermal_cooling_device *cdev;
> +	unsigned int voltage_tolerance; /* in percentage */
> +};
>  
> -static struct device *cpu_dev;
> -static struct clk *cpu_clk;
> -static struct regulator *cpu_reg;
> -static struct cpufreq_frequency_table *freq_table;
> -static struct thermal_cooling_device *cdev;
> +/*
> + * Currently this driver supports only two types of platforms:
> + * - All CPUs sharing same clock line, clock_per_cpu == false
> + * - All CPUs having separate clock lines, clock_per_cpu == true
> + *
> + * TODO: Scan affected/related CPUs from proper DT bindings
> + */
> +bool clock_per_cpu = false;
>  
>  static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
>  {
>  	struct dev_pm_opp *opp;
> +	struct private_data *priv = policy->driver_data;
>  	unsigned long volt = 0, volt_old = 0, tol = 0;
>  	unsigned int old_freq, new_freq;
>  	long freq_Hz, freq_exact;
>  	int ret;
>  
> -	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
> +	freq_Hz = clk_round_rate(policy->clk,
> +				 policy->freq_table[index].frequency * 1000);
>  	if (freq_Hz <= 0)
> -		freq_Hz = freq_table[index].frequency * 1000;
> +		freq_Hz = policy->freq_table[index].frequency * 1000;
>  
>  	freq_exact = freq_Hz;
>  	new_freq = freq_Hz / 1000;
> -	old_freq = clk_get_rate(cpu_clk) / 1000;
> +	old_freq = clk_get_rate(policy->clk) / 1000;
>  
> -	if (!IS_ERR(cpu_reg)) {
> +	if (!IS_ERR(priv->cpu_reg)) {
>  		rcu_read_lock();
> -		opp = dev_pm_opp_find_freq_ceil(cpu_dev, &freq_Hz);
> +		opp = dev_pm_opp_find_freq_ceil(priv->cpu_dev, &freq_Hz);
>  		if (IS_ERR(opp)) {
>  			rcu_read_unlock();
>  			pr_err("failed to find OPP for %ld\n", freq_Hz);
> @@ -60,8 +69,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
>  		}
>  		volt = dev_pm_opp_get_voltage(opp);
>  		rcu_read_unlock();
> -		tol = volt * voltage_tolerance / 100;
> -		volt_old = regulator_get_voltage(cpu_reg);
> +		tol = volt * priv->voltage_tolerance / 100;
> +		volt_old = regulator_get_voltage(priv->cpu_reg);
>  	}
>  
>  	pr_debug("%u MHz, %ld mV --> %u MHz, %ld mV\n",

This patch would be less noisy and easier to review if we used local
variables in this function for cpu_req, voltage_tolerance, and cpu_clk.
Can we do that please?

>
> @@ -99,77 +108,70 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
>  
>  static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
>  {
> -	policy->clk = cpu_clk;
> -	return cpufreq_generic_init(policy, freq_table, transition_latency);
> -}
> -
> -static struct cpufreq_driver cpu0_cpufreq_driver = {
> -	.flags = CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
> -	.verify = cpufreq_generic_frequency_table_verify,
> -	.target_index = cpu0_set_target,
> -	.get = cpufreq_generic_get,
> -	.init = cpu0_cpufreq_init,
> -	.name = "generic_cpu0",
> -	.attr = cpufreq_generic_attr,
> -};
> -
> -static int cpu0_cpufreq_probe(struct platform_device *pdev)
> -{
> +	struct cpufreq_frequency_table *freq_table;
> +	struct private_data *priv;
>  	struct device_node *np;
> -	int ret;
> +	char name[] = "cpuX";
> +	int ret, cpu = policy->cpu;
>  
> -	cpu_dev = get_cpu_device(0);
> -	if (!cpu_dev) {
> -		pr_err("failed to get cpu0 device\n");
> -		return -ENODEV;
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		pr_err("%s: Memory allocation failed\n", __func__);

Useless allocation error message.

> +		return -ENOMEM;
>  	}
>  
> -	np = of_node_get(cpu_dev->of_node);
> -	if (!np) {
> -		pr_err("failed to find cpu0 node\n");
> -		return -ENOENT;
> -	}
> +	/* Below calls can't fail from here */
> +	priv->cpu_dev = get_cpu_device(cpu);
> +	np = of_node_get(priv->cpu_dev->of_node);
>  
> -	cpu_reg = regulator_get_optional(cpu_dev, "cpu0");
> -	if (IS_ERR(cpu_reg)) {
> -		/*
> -		 * If cpu0 regulator supply node is present, but regulator is
> -		 * not yet registered, we should try defering probe.
> -		 */
> -		if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
> -			dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
> -			ret = -EPROBE_DEFER;
> -			goto out_put_node;
> -		}
> -		pr_warn("failed to get cpu0 regulator: %ld\n",
> -			PTR_ERR(cpu_reg));
> +	policy->clk = clk_get(priv->cpu_dev, NULL);
> +	if (IS_ERR(policy->clk)) {
> +		ret = PTR_ERR(policy->clk);
> +		pr_err("%s: failed to get cpu%d clock: %d\n", __func__, cpu,
> +		       ret);
> +		goto out_put_node;
>  	}

This won't work all the time. We need probe defer to work for the clocks
because sometimes CPU clocks are registered after this driver probes. In
my case this is always true unless I play games with initcall levels.
The same is true for regulators.

>  
> -	cpu_clk = clk_get(cpu_dev, NULL);
> -	if (IS_ERR(cpu_clk)) {
> -		ret = PTR_ERR(cpu_clk);
> -		pr_err("failed to get cpu0 clock: %d\n", ret);
> -		goto out_put_reg;
> +	ret = of_init_opp_table(priv->cpu_dev);
> +	if (ret) {
> +		pr_err("%s: failed to init OPP table for cpu%d: %d\n", __func__,
> +		       cpu, ret);
> +		goto out_put_clk;
>  	}
>  
> -	ret = of_init_opp_table(cpu_dev);
> +	ret = dev_pm_opp_init_cpufreq_table(priv->cpu_dev, &freq_table);
>  	if (ret) {
> -		pr_err("failed to init OPP table: %d\n", ret);
> +		pr_err("%s: failed to init cpufreq table for cpu%d: %d\n",
> +		       __func__, cpu, ret);
>  		goto out_put_clk;
>  	}
>  
> -	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
> +	ret = cpufreq_table_validate_and_show(policy, freq_table);
>  	if (ret) {
> -		pr_err("failed to init cpufreq table: %d\n", ret);
> -		goto out_put_clk;
> +		pr_err("%s: invalid frequency table for cpu%d: %d\n", __func__,
> +		       cpu, ret);
> +		goto out_put_reg;
>  	}
>  
> -	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
> +	/* Set mask of CPUs sharing clock line with policy->cpu */
> +	if (!clock_per_cpu)
> +		cpumask_setall(policy->cpus);
>  
> -	if (of_property_read_u32(np, "clock-latency", &transition_latency))
> -		transition_latency = CPUFREQ_ETERNAL;
> +	of_property_read_u32(np, "voltage-tolerance", &priv->voltage_tolerance);
>  
> -	if (!IS_ERR(cpu_reg)) {
> +	if (of_property_read_u32(np, "clock-latency",
> +				 &policy->cpuinfo.transition_latency))
> +		policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
> +
> +	/* NOTE: Supports only 10 CPUs: 0-9 */
> +	WARN_ONCE(cpu > 9, "cpu: %d", cpu);

Why would the supply name be called cpuN-supply? Why not use cpu-supply
in each CPU node? That way there is no limit on the number of CPUs. We
can always check for cpu0-supply first to be compatible with older DTs
but going forward we should be able to just use cpu-supply.

> +
> +	name[3] = '0' + cpu;
> +	priv->cpu_reg = regulator_get_optional(priv->cpu_dev, name);
> +	if (IS_ERR(priv->cpu_reg)) {
> +		pr_warn("%s: failed to get cpu%d's regulator: %ld\n", __func__,
> +			cpu, PTR_ERR(priv->cpu_reg));
> +	} else {
>  		struct dev_pm_opp *opp;
>  		unsigned long min_uV, max_uV;
>  		int i;
[...]
> +
> +static int cpu0_cpufreq_probe(struct platform_device *pdev)
> +{
> +	const struct property *prop;
> +	struct device *cpu_dev;
> +	struct regulator *cpu_reg;
> +	int ret, cpu, count = 0;
> +
> +	/* Optimization for regulator's -EPROBE_DEFER case */
> +	if (unlikely(clock_per_cpu))
> +		goto scan_regulator;

Why not look for the regulator first then?

> +
> +	/*
> +	 * Scan all CPU nodes to set clock_per_cpu
> +	 *
> +	 * FIXME: Scan affected-CPUs from DT and remove this loop.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		cpu_dev = get_cpu_device(cpu);
> +		if (!cpu_dev) {
> +			pr_err("%s: failed to get cpu%d device\n", __func__,
> +			       cpu);
> +			return -ENODEV;
> +		}
> +
> +		/* Count how many CPU nodes have defined operating-points */
> +		prop = of_find_property(cpu_dev->of_node, "operating-points",
> +					NULL);
> +		if (prop) {
> +			count++;
> +		} else if (cpu == 0) {
> +			pr_err("%s: operating-points missing: cpu%d\n",
> +			       __func__, cpu);
> +			return -ENOENT;
> +		}
> +	}
> +
> +	/* Either one or all CPUs must have operating-points property */
> +	if (count == cpu + 1) {

Is this supposed to be count == cpu? At this point in the code count
equals the number of CPUs present.

> +		clock_per_cpu = true;
> +	} else if (count != 1) {
> +		pr_err("%s: operating-points missing for few CPUs\n", __func__);
> +		return -ENOENT;
> +	}
> +
> +scan_regulator:
> +	/* Check only CPU0's regulator for EPROBE_DEFER */
> +	cpu_dev = get_cpu_device(0); /* Can't fail now */
> +	cpu_reg = regulator_get_optional(cpu_dev, "cpu0");
> +	if (!IS_ERR(cpu_reg)) {
> +		regulator_put(cpu_reg);
> +	} else if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
> +		/*
> +		 * If cpu0 regulator supply node is present, but regulator is
> +		 * not yet registered, we should try defering probe.
> +		 */
> +		dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
> +		return -EPROBE_DEFER;
> +	}

I don't think this driver should be using regulator_get_optional() (Mark
B. please correct me if I'm wrong). I doubt a supply is actually
optional for CPUs, just some DTs aren't specifying them. In those cases,
the regulator core will insert a dummy supply and the code will work
without having to check for probe defer and error pointers.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

