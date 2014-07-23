Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbaGWHJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:09:58 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38620 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbaGWHJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:09:56 -0400
Date: Wed, 23 Jul 2014 09:09:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
Message-ID: <20140723070949.GB15759@ulmo.nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
 <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 21, 2014 at 06:39:00PM +0300, Tuomas Tynkkynen wrote:
[...]
> diff --git a/drivers/cpufreq/tegra124-cpufreq.c b/drivers/cpufreq/tegra124-cpufreq.c
[...]
> +static int tegra124_cpu_switch_to_dfll(void)
> +{
> +	struct clk *original_cpu_clk_parent;

Maybe just "parent"?

> +	unsigned long rate;
> +	struct dev_pm_opp *opp;
> +	int ret;
> +
> +	rate = clk_get_rate(cpu_clk);
> +	opp = dev_pm_opp_find_freq_ceil(cpu_dev, &rate);
> +	if (IS_ERR(opp))
> +		return PTR_ERR(opp);
> +
> +	ret = clk_set_rate(dfll_clk, rate);
> +	if (ret)
> +		return ret;
> +
> +	original_cpu_clk_parent = clk_get_parent(cpu_clk);
> +	clk_set_parent(cpu_clk, pllp_clk);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_prepare_enable(dfll_clk);
> +	if (ret)
> +		goto out_switch_to_original_parent;

This could simply be "out" or "err" or anything else shorter than the
above.

> +
> +	clk_set_parent(cpu_clk, dfll_clk);
> +
> +	return 0;
> +
> +out_switch_to_original_parent:
> +	clk_set_parent(cpu_clk, original_cpu_clk_parent);
> +
> +	return ret;
> +}
> +
> +static struct platform_device_info cpufreq_cpu0_devinfo = {
> +	.name = "cpufreq-cpu0",
> +};
> +
> +static int tegra124_cpufreq_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	cpu_dev = get_cpu_device(0);
> +	if (!cpu_dev)
> +		return -ENODEV;
> +
> +	cpu_clk = of_clk_get_by_name(cpu_dev->of_node, "cpu_g");
> +	if (IS_ERR(cpu_clk))
> +		return PTR_ERR(cpu_clk);
> +
> +	dfll_clk = of_clk_get_by_name(cpu_dev->of_node, "dfll");
> +	if (IS_ERR(dfll_clk)) {
> +		ret = PTR_ERR(dfll_clk);
> +		goto out_put_cpu_clk;
> +	}
> +
> +	pllx_clk = of_clk_get_by_name(cpu_dev->of_node, "pll_x");
> +	if (IS_ERR(pllx_clk)) {
> +		ret = PTR_ERR(pllx_clk);
> +		goto out_put_dfll_clk;
> +	}
> +
> +	pllp_clk = of_clk_get_by_name(cpu_dev->of_node, "pll_p");
> +	if (IS_ERR(pllp_clk)) {
> +		ret = PTR_ERR(pllp_clk);
> +		goto out_put_pllx_clk;
> +	}

Can the above not be devm_clk_get(cpu_dev, "...") so that you can remove
all the clk_put() calls in the cleanup code below?

> +
> +	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
> +	if (ret)
> +		goto out_put_pllp_clk;
> +
> +	ret = tegra124_cpu_switch_to_dfll();
> +	if (ret)
> +		goto out_free_table;
> +
> +	platform_device_register_full(&cpufreq_cpu0_devinfo);

Should the cpufreq_cpu0_devinfo device perhaps be a child of pdev?

> +
> +	return 0;
> +
> +out_free_table:
> +	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
> +out_put_pllp_clk:
> +	clk_put(pllp_clk);
> +out_put_pllx_clk:
> +	clk_put(pllx_clk);
> +out_put_dfll_clk:
> +	clk_put(dfll_clk);
> +out_put_cpu_clk:
> +	clk_put(cpu_clk);
> +
> +	return ret;
> +}
> +
> +static struct platform_driver tegra124_cpufreq_platdrv = {
> +	.driver = {
> +		.name	= "cpufreq-tegra124",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= tegra124_cpufreq_probe,

Note that simply leaving out .remove() here doesn't guarantee that the
driver won't be unloaded. Also building it into the kernel doesn't
prevent that. You can still unbind the driver via sysfs. So you'd need
to add a .suppress_bind_attrs = true above.

But is there even a reason why we need that? Couldn't we make the
driver's .remove() undo what .probe() did so that the driver can be
unloaded?

Otherwise it probably makes more sense not to use a driver (and dummy
device) at all as Viresh already mentioned.

> +};
> +
> +static const struct of_device_id soc_of_matches[] = {
> +	{ .compatible = "nvidia,tegra124", },
> +	{}
> +};
> +
> +static int __init tegra_cpufreq_init(void)
> +{
> +	int ret;
> +	struct platform_device *pdev;
> +
> +	if (!of_find_matching_node(NULL, soc_of_matches))
> +		return -ENODEV;

I think this could be of_machine_is_compatible() since there's only a
single entry in the match table. If there's a good chance that we may
end up with more entries, perhaps now would be a good time to add an
of_match_machine() function?

> +
> +	ret = platform_driver_register(&tegra124_cpufreq_platdrv);
> +	if (ret)
> +		return ret;
> +
> +	pdev = platform_device_register_simple("cpufreq-tegra124", -1, NULL, 0);
> +	if (IS_ERR(pdev)) {
> +		platform_driver_unregister(&tegra124_cpufreq_platdrv);
> +		return PTR_ERR(pdev);
> +	}
> +
> +	return 0;
> +}
> +
> +MODULE_AUTHOR("Tuomas Tynkkynen <ttynkkynen@nvidia.com>");
> +MODULE_DESCRIPTION("cpufreq driver for nVIDIA Tegra124");

We use "NVIDIA" everywhere nowadays.

> +MODULE_LICENSE("GPLv2");

The correct license string is "GPL v2".

> +module_init(tegra_cpufreq_init);

The placement of this is unusual. It should go immediately below the
tegra_cpufreq_init() function.

Thierry

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTz1+9AAoJEN0jrNd/PrOh/EAQAJBcwuXVkH5dl3y34PdjlYX2
yU1D4sfgqW8uwyuinNSbYCnOxNbvrSUHj+qFZ2N5ODjQq0NzYN+u1nYJT4Mke/By
kjtx5tFOQZz0K1CvDaHu6sR9YBhd2ELz4BPM+ZBBhE3GFB6cD/K7i0fbMrS7c3Mz
Je+xd279cPZwMYWE5K9BVylLjNiQf+ICHuFKtGc0X0/Y/YzAg7239HE3mzR1IjCN
jVdKCfU7l9xRQBRT1/zFYes88U/L8ZMafoFbzd8mUyCNefTjKnzUCvzfdc9qQHUs
/Zzf/8ctkmKSpyistuFPEdGDMpa0jai6j1Bj6lQjdsk8jV1HKE2zBp+FAWirvhEO
piTtRyH/3XFjMpaVEJBU1BVZoo1KOi2GdFwY2vFHHIwczWPD6KMRhz+0nOq+A0y6
lpbp8MDZGDykxnR/IaT7gK3jzuHNPfkRUXYRVshOkA6ccB8ldOvyI6hquYKfNcoN
Ifzpq6MfQjDGfvjtuBEYinl7WZy2UkwiMWGnTz7zBeRD4SbRPN4U09oVyTlYWmoO
tu52/oVzt3EZn3PMY7OW60d4U6qiY74Ow3lAQ/+elcYq91M4jTCbxTF6QbD/CzJl
7R6dp93MuKRLBRuaozWAUX9zKiBfND/vAPoKqVL83zZRaRsEVmwUOtTZFyaoVgvX
+GiJXWBm5Gce54ay1SlI
=JKm2
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
