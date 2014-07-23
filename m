Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaGWMfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:35:53 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5999 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGWMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:35:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 23 Jul 2014 05:24:02 -0700
Message-ID: <53CFAC22.40106@nvidia.com>
Date: Wed, 23 Jul 2014 15:35:46 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com> <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com> <20140723070949.GB15759@ulmo.nvidia.com>
In-Reply-To: <20140723070949.GB15759@ulmo.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/07/14 10:09, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Jul 21, 2014 at 06:39:00PM +0300, Tuomas Tynkkynen wrote:
> [...]
>> diff --git a/drivers/cpufreq/tegra124-cpufreq.c b/drivers/cpufreq/tegra124-cpufreq.c
> [...]
>> +static int tegra124_cpu_switch_to_dfll(void)
>> +{
>> +	struct clk *original_cpu_clk_parent;
> 
> Maybe just "parent"?
> 
>> +	unsigned long rate;
>> +	struct dev_pm_opp *opp;
>> +	int ret;
>> +
>> +	rate = clk_get_rate(cpu_clk);
>> +	opp = dev_pm_opp_find_freq_ceil(cpu_dev, &rate);
>> +	if (IS_ERR(opp))
>> +		return PTR_ERR(opp);
>> +
>> +	ret = clk_set_rate(dfll_clk, rate);
>> +	if (ret)
>> +		return ret;
>> +
>> +	original_cpu_clk_parent = clk_get_parent(cpu_clk);
>> +	clk_set_parent(cpu_clk, pllp_clk);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = clk_prepare_enable(dfll_clk);
>> +	if (ret)
>> +		goto out_switch_to_original_parent;
> 
> This could simply be "out" or "err" or anything else shorter than the
> above.
> 
>> +
>> +	clk_set_parent(cpu_clk, dfll_clk);
>> +
>> +	return 0;
>> +
>> +out_switch_to_original_parent:
>> +	clk_set_parent(cpu_clk, original_cpu_clk_parent);
>> +
>> +	return ret;
>> +}
>> +
>> +static struct platform_device_info cpufreq_cpu0_devinfo = {
>> +	.name = "cpufreq-cpu0",
>> +};
>> +
>> +static int tegra124_cpufreq_probe(struct platform_device *pdev)
>> +{
>> +	int ret;
>> +
>> +	cpu_dev = get_cpu_device(0);
>> +	if (!cpu_dev)
>> +		return -ENODEV;
>> +
>> +	cpu_clk = of_clk_get_by_name(cpu_dev->of_node, "cpu_g");
>> +	if (IS_ERR(cpu_clk))
>> +		return PTR_ERR(cpu_clk);
>> +
>> +	dfll_clk = of_clk_get_by_name(cpu_dev->of_node, "dfll");
>> +	if (IS_ERR(dfll_clk)) {
>> +		ret = PTR_ERR(dfll_clk);
>> +		goto out_put_cpu_clk;
>> +	}
>> +
>> +	pllx_clk = of_clk_get_by_name(cpu_dev->of_node, "pll_x");
>> +	if (IS_ERR(pllx_clk)) {
>> +		ret = PTR_ERR(pllx_clk);
>> +		goto out_put_dfll_clk;
>> +	}
>> +
>> +	pllp_clk = of_clk_get_by_name(cpu_dev->of_node, "pll_p");
>> +	if (IS_ERR(pllp_clk)) {
>> +		ret = PTR_ERR(pllp_clk);
>> +		goto out_put_pllx_clk;
>> +	}
> 
> Can the above not be devm_clk_get(cpu_dev, "...") so that you can remove
> all the clk_put() calls in the cleanup code below?

That would allocate the clks under the cpu_dev's devres list, i.e. all the
clk_puts wouldn't happen when the cpufreq driver goes away, but only when
cpu_dev itself goes away.

> 
>> +
>> +	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
>> +	if (ret)
>> +		goto out_put_pllp_clk;
>> +
>> +	ret = tegra124_cpu_switch_to_dfll();
>> +	if (ret)
>> +		goto out_free_table;
>> +
>> +	platform_device_register_full(&cpufreq_cpu0_devinfo);
> 
> Should the cpufreq_cpu0_devinfo device perhaps be a child of pdev?

Yeah, I suppose it should.

>> +
>> +	return 0;
>> +
>> +out_free_table:
>> +	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
>> +out_put_pllp_clk:
>> +	clk_put(pllp_clk);
>> +out_put_pllx_clk:
>> +	clk_put(pllx_clk);
>> +out_put_dfll_clk:
>> +	clk_put(dfll_clk);
>> +out_put_cpu_clk:
>> +	clk_put(cpu_clk);
>> +
>> +	return ret;
>> +}
>> +
>> +static struct platform_driver tegra124_cpufreq_platdrv = {
>> +	.driver = {
>> +		.name	= "cpufreq-tegra124",
>> +		.owner	= THIS_MODULE,
>> +	},
>> +	.probe		= tegra124_cpufreq_probe,
> 
> Note that simply leaving out .remove() here doesn't guarantee that the
> driver won't be unloaded. Also building it into the kernel doesn't
> prevent that. You can still unbind the driver via sysfs. So you'd need
> to add a .suppress_bind_attrs = true above.

I hadn't heard about suppress_bind_attrs before, it indeed sounds useful.

> But is there even a reason why we need that? Couldn't we make the
> driver's .remove() undo what .probe() did so that the driver can be
> unloaded?

I guess that could be done, though to fully undo everything the regulator
voltage would also need to be saved/restored.

> Otherwise it probably makes more sense not to use a driver (and dummy
> device) at all as Viresh already mentioned.
> 

The dummy platform device is only required for probe deferral, if that
could be solved in a different way then yes.

>> +};
>> +
>> +static const struct of_device_id soc_of_matches[] = {
>> +	{ .compatible = "nvidia,tegra124", },
>> +	{}
>> +};
>> +
>> +static int __init tegra_cpufreq_init(void)
>> +{
>> +	int ret;
>> +	struct platform_device *pdev;
>> +
>> +	if (!of_find_matching_node(NULL, soc_of_matches))
>> +		return -ENODEV;
> 
> I think this could be of_machine_is_compatible() since there's only a
> single entry in the match table. If there's a good chance that we may
> end up with more entries, perhaps now would be a good time to add an
> of_match_machine() function?

I think this driver should work on Tegra132 without modifications.
of_match_machine() does sound useful for some of the other cpufreq
drivers as well and likely for your soc_is_tegra() from the PMC
series as well.

> 
>> +
>> +	ret = platform_driver_register(&tegra124_cpufreq_platdrv);
>> +	if (ret)
>> +		return ret;
>> +
>> +	pdev = platform_device_register_simple("cpufreq-tegra124", -1, NULL, 0);
>> +	if (IS_ERR(pdev)) {
>> +		platform_driver_unregister(&tegra124_cpufreq_platdrv);
>> +		return PTR_ERR(pdev);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +MODULE_AUTHOR("Tuomas Tynkkynen <ttynkkynen@nvidia.com>");
>> +MODULE_DESCRIPTION("cpufreq driver for nVIDIA Tegra124");
> 
> We use "NVIDIA" everywhere nowadays.
> 
>> +MODULE_LICENSE("GPLv2");
> 
> The correct license string is "GPL v2".
> 
>> +module_init(tegra_cpufreq_init);
> 
> The placement of this is unusual. It should go immediately below the
> tegra_cpufreq_init() function.
> 

Ok.

Thanks,
Tuomas

-- 
nvpublic
