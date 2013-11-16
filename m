Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3KPNnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 08:43:24 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:34295
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab3KPNnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 08:43:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 16 Nov 2013 21:44:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nishanth Menon <nm@ti.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
Message-ID: <20131116134445.GI11014@S2101-09.ap.freescale.net>
References: <1384568535-26611-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1384568535-26611-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 08:22:15PM -0600, Nishanth Menon wrote:
> On many development platforms, at boot, the bootloader configured
> frequency maynot match the valid frequencies that are stated to be
> supported in OPP table. This may occur due to various reasons:
> a) older or default bootloader in development platform without latest
> updates
> b) SoC documentation update that may have occurred in kernel
> c) kernel definitions are out of date Vs bootloader which is updated
> etc..
> 
> In these cases, we should assume from a kernel perspective, the only
> safe frequency that the system can be on is the ones available in the
> OPP table. This may not handle case (c), but, that is a different
> kernel bug of it's own.

No, it's not a kernel bug.

OPP is not a definition that belongs to kernel.  Instead, it's
characteristics of hardware, and that's why we can naturally put the
definition into device tree.  Bear it in mind that device tree is a
hardware description and should be OS agnostic.  So it shouldn't be
treated as part of Linux kernel in any case, even though the device
tree source is currently maintained in kernel tree.

Device tree is designed as a way for firmware/bootloader to describe
hardware to kernel.  That said, device tree is more part of bootloader
than kernel.  If bootloader runs at a frequency that does not match the
OPP in device tree, the one should be fixed is either bootloader or
device tree but never kernel.

However, I agree we should at least have a check in cpufreq-cpu0 driver
and fail out in case that a mismatch is detected.

Shawn

> 
> Considering that in many existing or development platforms, (a) or
> (b) is common, enforce a sanity check and reprogram to a conservative
> start configuration at probe to allow sane operation independent of
> bootloader.
> 
> Reported-by: Carlos Hernandez <ceh@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> 
> based on v3.12 tag - however, a rebase with opp function name change
> is needed for v3.13-rc1 if folks are ok, I can repost with updates.
> 
> Identified when during debug of https://patchwork.kernel.org/patch/3191411/
> on TI vendor kernel based on v3.12 tag.
> 
> In the case discussed, bootloader booted OMAP5uEVM at 1.1GHz when the available
> frequencies were 500MHz, 1GHz, 1.5GHz.
> 
> To prevent system from functioning at this invalid configuration (and hence
> trigger the bug seen in stats), we should remove the dependence of the kernel
> from bootloader configuration.
> With this patch, in the mentioned boot scenario, we get the following log:
> [   25.649736] cpufreq_cpu0: bootloader freq 1100000000 no match to table, Using 1000000000
> 
> Artificially modifying the bootloader to create other boundary conditions:
> (lower bound check)
> [   25.633535] cpufreq_cpu0: bootloader freq 300000000Hz no match to table, Using 500000000Hz
> (upper bound check)
> [   27.355837] cpufreq_cpu0: bootloader freq 1600000000Hz no match to table, Using 1500000000Hz
> 
> The other alternative(to reduce code churn) would be to just report a
> mismatch and continue to function at the potentially risky OPP - but
> in the cases such as using userspace governor, the system could be in
> unstable state resulting in hard to debug behavior.
> 
> The last alternative is to always expect bootloader to be in sync with proper
> OPP configuration, which rarely happens correctly.
> 
>  drivers/cpufreq/cpufreq-cpu0.c |   84 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index c522a95..9765050 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -176,7 +176,8 @@ static struct cpufreq_driver cpu0_cpufreq_driver = {
>  static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np;
> -	int ret;
> +	int ret, i;
> +	long boot_freq;
>  
>  	cpu_dev = get_cpu_device(0);
>  	if (!cpu_dev) {
> @@ -232,7 +233,6 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  	if (!IS_ERR(cpu_reg)) {
>  		struct opp *opp;
>  		unsigned long min_uV, max_uV;
> -		int i;
>  
>  		/*
>  		 * OPP is maintained in order of increasing frequency, and
> @@ -254,6 +254,86 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  			transition_latency += ret * 1000;
>  	}
>  
> +	boot_freq = clk_get_rate(cpu_clk);
> +
> +	/* See if we have a perfect match */
> +	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
> +		if (boot_freq == freq_table[i].frequency * 1000)
> +			break;
> +
> +	/* If we have a bad bootloader config, try recovery */
> +	if (freq_table[i].frequency == CPUFREQ_TABLE_END) {
> +		struct opp *opp;
> +		long new_freq = boot_freq, freq_exact;
> +		unsigned long volt = 0, tol = 0;
> +
> +		ret = 0;
> +		rcu_read_lock();
> +
> +		/* Try a conservative match */
> +		opp = opp_find_freq_floor(cpu_dev, &new_freq);
> +
> +		/* If we did not get a floor match, try least available freq */
> +		if (IS_ERR(opp)) {
> +			new_freq = freq_table[0].frequency * 1000;
> +			opp = opp_find_freq_exact(cpu_dev, new_freq, true);
> +		}
> +		if (IS_ERR(opp))
> +			ret = -ERANGE;
> +		if (!IS_ERR(opp) && !IS_ERR(cpu_reg)) {
> +			volt = opp_get_voltage(opp);
> +			tol = volt * voltage_tolerance / 100;
> +		}
> +		rcu_read_unlock();
> +		if (ret) {
> +			pr_err("Fail to find match boot clock rate: %lu\n",
> +			       boot_freq);
> +			goto out_free_table;
> +		}
> +
> +		/* We dont expect to endup with same result */
> +		WARN_ON(boot_freq == new_freq);
> +
> +		freq_exact = clk_round_rate(cpu_clk, new_freq);
> +		if (freq_exact < 0) {
> +			pr_err("Fail to find valid boot clock rate: %lu\n",
> +			       freq_exact);
> +			goto out_free_table;
> +		}
> +
> +		/* Warn to get developer to fix bootloader */
> +		pr_err("Bootloader freq %luHz no match to table, Using %luHz\n",
> +		       boot_freq, new_freq);
> +
> +		/*
> +		 * For voltage sequencing we *assume* that bootloader has at
> +		 * least set the voltage appropriate for the boot_frequency
> +		 */
> +		if (!IS_ERR(cpu_reg) && boot_freq < new_freq) {
> +			ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
> +			if (ret) {
> +				pr_err("Fail to scale boot voltage up: %d\n",
> +				       ret);
> +				goto out_free_table;
> +			}
> +		}
> +
> +		ret = clk_set_rate(cpu_clk, freq_exact);
> +		if (ret) {
> +			pr_err("Fail to set boot clock rate: %d\n", ret);
> +			goto out_free_table;
> +		}
> +
> +		if (!IS_ERR(cpu_reg) && boot_freq > new_freq) {
> +			ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
> +			if (ret) {
> +				pr_err("Fail to scale boot voltage down: %d\n",
> +				       ret);
> +				goto out_free_table;
> +			}
> +		}
> +	}
> +
>  	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
>  	if (ret) {
>  		pr_err("failed register driver: %d\n", ret);
> -- 
> 1.7.9.5
> 

