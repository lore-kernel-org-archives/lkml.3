Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaC1N3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:29:24 -0400
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:34075 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752076AbaC1N3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:29:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:2910:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:4321:4605:5007:6119:7652:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12296:12438:12517:12519:12740:13138:13161:13229:13231:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Cu
X-HE-Tag: coil40_341fdf1574f30
X-Filterd-Recvd-Size: 3815
Message-ID: <1396013356.31134.27.camel@joe-AO722>
Subject: Re: [PATCH] cpufreq: use kzalloc() to allocate memory for
 cpufreq_frequency_table
From: Joe Perches <joe@perches.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Date: Fri, 28 Mar 2014 06:29:16 -0700
In-Reply-To: <f6aa622dc5acfd3ab9b1360973c0d15b3972c6b6.1396001532.git.viresh.kumar@linaro.org>
References: <b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
	 <f6aa622dc5acfd3ab9b1360973c0d15b3972c6b6.1396001532.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 15:44 +0530, Viresh Kumar wrote:
> Few drivers are using kmalloc() to allocate memory for frequency tables and once
> we have an additional field '.flags' in 'struct cpufreq_frequency_table', these
> might become unstable. Better get these fixed by replacing kmalloc() by
> kzalloc() instead.

There seems to be some sort of bug fix in the
patch at the very end too?

Perhaps a better fix would be to use kcalloc for
all the allocs with a multiply.

> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
[]
> @@ -754,7 +754,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
[]
> -	data->freq_table = kmalloc(sizeof(*data->freq_table) *
> +	data->freq_table = kzalloc(sizeof(*data->freq_table) *
>  		    (perf->state_count+1), GFP_KERNEL);

> diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
[]
> @@ -254,7 +254,7 @@ acpi_cpufreq_cpu_init (
[]
> -	data->freq_table = kmalloc(sizeof(*data->freq_table) *
> +	data->freq_table = kzalloc(sizeof(*data->freq_table) *
>  	                           (data->acpi_data.state_count + 1),
>  	                           GFP_KERNEL);

> diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
[]
> @@ -475,7 +475,7 @@ static int longhaul_get_ranges(void)
[]
> -	longhaul_table = kmalloc((numscales + 1) * sizeof(*longhaul_table),

> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
[]
> @@ -623,7 +623,7 @@ static int fill_powernow_table(struct powernow_k8_data *data,
[]
> -	powernow_table = kmalloc((sizeof(*powernow_table)
> +	powernow_table = kzalloc((sizeof(*powernow_table)
>  		* (data->numps + 1)), GFP_KERNEL);

> diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
[]
> @@ -586,7 +586,7 @@ static int s3c_cpufreq_build_freq(void)
[]
> -	ftab = kmalloc(sizeof(*ftab) * size, GFP_KERNEL);
> +	ftab = kzalloc(sizeof(*ftab) * size, GFP_KERNEL);

> diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
[]
> @@ -195,18 +195,15 @@ static int spear_cpufreq_probe(struct platform_device *pdev)
[]
> -	freq_tbl = kmalloc(sizeof(*freq_tbl) * (cnt + 1), GFP_KERNEL);
> +	freq_tbl = kzalloc(sizeof(*freq_tbl) * (cnt + 1), GFP_KERNEL);
>  	if (!freq_tbl) {
>  		ret = -ENOMEM;
>  		goto out_put_node;
>  	}
>  
> -	for (i = 0; i < cnt; i++) {
> -		freq_tbl[i].driver_data = i;
> +	for (i = 0; i < cnt; i++)
>  		freq_tbl[i].frequency = be32_to_cpup(val++);
> -	}
>  
> -	freq_tbl[i].driver_data = i;
>  	freq_tbl[i].frequency = CPUFREQ_TABLE_END;

Is this some bug fix?


