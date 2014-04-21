Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaDUVwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:52:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51583 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753489AbaDUVwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:52:02 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH RESEND 1/2] cpufreq: imx6q: Drop devm_clk/regulator_get usage
Date: Tue, 22 Apr 2014 00:08:20 +0200
Message-ID: <6608663.Uaf3xkE0GI@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397468817-23266-1-git-send-email-p.zabel@pengutronix.de>
References: <1397468817-23266-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 14, 2014 11:46:56 AM Philipp Zabel wrote:
> This driver is using devres managed calls incorrectly, giving the cpu0
> device as first parameter instead of the cpufreq platform device.
> This results in resources not being freed if the cpufreq platform device
> is unbound, for example if probing has to be deferred for a missing
> regulator.
> Supporting probe deferral properly is a prerequisite to enabling the
> internal LDO bypass on i.MX6 and regulating the CPU voltage with an
> external regulator.
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Acked-by: Shawn Guo <shawn.guo@freescale.com>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> This didn't turn up in v3.15-rc1. Resend in case it fell through the cracks.

Please resend with a CC to linux-pm@vger.kernel.org (and you can drop cpufreq
from the CC list).

> ---
>  drivers/cpufreq/imx6q-cpufreq.c | 53 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 39 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
> index e27fca8..92a82ec 100644
> --- a/drivers/cpufreq/imx6q-cpufreq.c
> +++ b/drivers/cpufreq/imx6q-cpufreq.c
> @@ -170,25 +170,25 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
>  		return -ENOENT;
>  	}
>  
> -	arm_clk = devm_clk_get(cpu_dev, "arm");
> -	pll1_sys_clk = devm_clk_get(cpu_dev, "pll1_sys");
> -	pll1_sw_clk = devm_clk_get(cpu_dev, "pll1_sw");
> -	step_clk = devm_clk_get(cpu_dev, "step");
> -	pll2_pfd2_396m_clk = devm_clk_get(cpu_dev, "pll2_pfd2_396m");
> +	arm_clk = clk_get(cpu_dev, "arm");
> +	pll1_sys_clk = clk_get(cpu_dev, "pll1_sys");
> +	pll1_sw_clk = clk_get(cpu_dev, "pll1_sw");
> +	step_clk = clk_get(cpu_dev, "step");
> +	pll2_pfd2_396m_clk = clk_get(cpu_dev, "pll2_pfd2_396m");
>  	if (IS_ERR(arm_clk) || IS_ERR(pll1_sys_clk) || IS_ERR(pll1_sw_clk) ||
>  	    IS_ERR(step_clk) || IS_ERR(pll2_pfd2_396m_clk)) {
>  		dev_err(cpu_dev, "failed to get clocks\n");
>  		ret = -ENOENT;
> -		goto put_node;
> +		goto put_clk;
>  	}
>  
> -	arm_reg = devm_regulator_get(cpu_dev, "arm");
> -	pu_reg = devm_regulator_get(cpu_dev, "pu");
> -	soc_reg = devm_regulator_get(cpu_dev, "soc");
> +	arm_reg = regulator_get(cpu_dev, "arm");
> +	pu_reg = regulator_get(cpu_dev, "pu");
> +	soc_reg = regulator_get(cpu_dev, "soc");
>  	if (IS_ERR(arm_reg) || IS_ERR(pu_reg) || IS_ERR(soc_reg)) {
>  		dev_err(cpu_dev, "failed to get regulators\n");
>  		ret = -ENOENT;
> -		goto put_node;
> +		goto put_reg;
>  	}
>  
>  	/*
> @@ -201,21 +201,21 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
>  		ret = of_init_opp_table(cpu_dev);
>  		if (ret < 0) {
>  			dev_err(cpu_dev, "failed to init OPP table: %d\n", ret);
> -			goto put_node;
> +			goto put_reg;
>  		}
>  
>  		num = dev_pm_opp_get_opp_count(cpu_dev);
>  		if (num < 0) {
>  			ret = num;
>  			dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
> -			goto put_node;
> +			goto put_reg;
>  		}
>  	}
>  
>  	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
>  	if (ret) {
>  		dev_err(cpu_dev, "failed to init cpufreq table: %d\n", ret);
> -		goto put_node;
> +		goto put_reg;
>  	}
>  
>  	/* Make imx6_soc_volt array's size same as arm opp number */
> @@ -301,7 +301,24 @@ soc_opp_out:
>  
>  free_freq_table:
>  	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
> -put_node:
> +put_reg:
> +	if (!IS_ERR(arm_reg))
> +		regulator_put(arm_reg);
> +	if (!IS_ERR(pu_reg))
> +		regulator_put(pu_reg);
> +	if (!IS_ERR(soc_reg))
> +		regulator_put(soc_reg);
> +put_clk:
> +	if (!IS_ERR(arm_clk))
> +		clk_put(arm_clk);
> +	if (!IS_ERR(pll1_sys_clk))
> +		clk_put(pll1_sys_clk);
> +	if (!IS_ERR(pll1_sw_clk))
> +		clk_put(pll1_sw_clk);
> +	if (!IS_ERR(step_clk))
> +		clk_put(step_clk);
> +	if (!IS_ERR(pll2_pfd2_396m_clk))
> +		clk_put(pll2_pfd2_396m_clk);
>  	of_node_put(np);
>  	return ret;
>  }
> @@ -310,6 +327,14 @@ static int imx6q_cpufreq_remove(struct platform_device *pdev)
>  {
>  	cpufreq_unregister_driver(&imx6q_cpufreq_driver);
>  	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
> +	regulator_put(arm_reg);
> +	regulator_put(pu_reg);
> +	regulator_put(soc_reg);
> +	clk_put(arm_clk);
> +	clk_put(pll1_sys_clk);
> +	clk_put(pll1_sw_clk);
> +	clk_put(step_clk);
> +	clk_put(pll2_pfd2_396m_clk);
>  
>  	return 0;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
