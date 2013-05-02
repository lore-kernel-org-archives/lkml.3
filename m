Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab3EBCtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:49:08 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:29656
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757234Ab3EBCtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:49:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 2 May 2013 10:48:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <arvind.chauhan@arm.com>, <nm@ti.com>
Subject: Re: [PATCH] cpufreq: cpu0: Free parent node for error cases
Message-ID: <20130502024849.GF3442@S2101-09.ap.freescale.net>
References: <ad5f8a25684dbdd6fcb385fb420da0b4709e7392.1367384647.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ad5f8a25684dbdd6fcb385fb420da0b4709e7392.1367384647.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 10:34:43AM +0530, Viresh Kumar wrote:
> We are freeing parent node in success cases but not in failure cases. Lets do
> it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 3ab8294..c025714 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -189,7 +189,8 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  
>  	if (!np) {
>  		pr_err("failed to find cpu0 node\n");
> -		return -ENOENT;
> +		ret = -ENOENT;
> +		goto out_put_parent;
>  	}
>  
>  	cpu_dev = &pdev->dev;
> @@ -199,7 +200,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  	if (IS_ERR(cpu_clk)) {
>  		ret = PTR_ERR(cpu_clk);
>  		pr_err("failed to get cpu0 clock: %d\n", ret);
> -		goto out_put_node;
> +		goto out_put_np;
>  	}
>  
>  	cpu_reg = devm_regulator_get(cpu_dev, "cpu0");
> @@ -211,13 +212,13 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  	ret = of_init_opp_table(cpu_dev);
>  	if (ret) {
>  		pr_err("failed to init OPP table: %d\n", ret);
> -		goto out_put_node;
> +		goto out_put_np;
>  	}
>  
>  	ret = opp_init_cpufreq_table(cpu_dev, &freq_table);
>  	if (ret) {
>  		pr_err("failed to init cpufreq table: %d\n", ret);
> -		goto out_put_node;
> +		goto out_put_np;
>  	}
>  
>  	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
> @@ -262,8 +263,10 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  
>  out_free_table:
>  	opp_free_cpufreq_table(cpu_dev, &freq_table);
> -out_put_node:
> +out_put_np:

Unnecessary renaming brings unnecessary diffstat?

Shawn

>  	of_node_put(np);
> +out_put_parent:
> +	of_node_put(parent);
>  	return ret;
>  }
>  
> -- 
> 1.7.12.rc2.18.g61b472e
> 

