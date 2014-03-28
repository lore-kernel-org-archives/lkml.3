Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaC1KpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:45:11 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59462 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaC1KpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:45:07 -0400
Date: Fri, 28 Mar 2014 16:14:39 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH] cpufreq: use kzalloc() to allocate memory for
 cpufreq_frequency_table
Message-ID: <20140328104439.GB28960@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
 <f6aa622dc5acfd3ab9b1360973c0d15b3972c6b6.1396001532.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6aa622dc5acfd3ab9b1360973c0d15b3972c6b6.1396001532.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032810-0928-0000-0000-000000CC8C2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 03:44:24PM +0530, Viresh Kumar wrote:
> Few drivers are using kmalloc() to allocate memory for frequency tables and once
> we have an additional field '.flags' in 'struct cpufreq_frequency_table', these
> might become unstable. Better get these fixed by replacing kmalloc() by
> kzalloc() instead.
> 
> Along with that we also remove use of .driver_data from SPEAr driver as it
> doesn't use it at all. Also, writing zero to .driver_data is not required for
> powernow-k8 as it is already zero.
> 
> Reported-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>

> ---
> @Rafael: Please apply this one before:
> 
> http://permalink.gmane.org/gmane.linux.kernel/1673994
> 
> so that git bisect doesn't break. Though the chances of this field getting
> initialized to a value equal to BOOST, i.e. 0x1 are very rare.
> 
>  drivers/cpufreq/acpi-cpufreq.c      | 2 +-
>  drivers/cpufreq/ia64-acpi-cpufreq.c | 2 +-
>  drivers/cpufreq/longhaul.c          | 2 +-
>  drivers/cpufreq/powernow-k8.c       | 5 ++---
>  drivers/cpufreq/s3c24xx-cpufreq.c   | 4 ++--
>  drivers/cpufreq/spear-cpufreq.c     | 7 ++-----
>  6 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index d5eaedb..000e4e0 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -754,7 +754,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  		goto err_unreg;
>  	}
> 
> -	data->freq_table = kmalloc(sizeof(*data->freq_table) *
> +	data->freq_table = kzalloc(sizeof(*data->freq_table) *
>  		    (perf->state_count+1), GFP_KERNEL);
>  	if (!data->freq_table) {
>  		result = -ENOMEM;
> diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
> index beb191b..c30aaa6 100644
> --- a/drivers/cpufreq/ia64-acpi-cpufreq.c
> +++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
> @@ -254,7 +254,7 @@ acpi_cpufreq_cpu_init (
>  	}
> 
>  	/* alloc freq_table */
> -	data->freq_table = kmalloc(sizeof(*data->freq_table) *
> +	data->freq_table = kzalloc(sizeof(*data->freq_table) *
>  	                           (data->acpi_data.state_count + 1),
>  	                           GFP_KERNEL);
>  	if (!data->freq_table) {
> diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
> index 5c440f8..d00e5d1 100644
> --- a/drivers/cpufreq/longhaul.c
> +++ b/drivers/cpufreq/longhaul.c
> @@ -475,7 +475,7 @@ static int longhaul_get_ranges(void)
>  		return -EINVAL;
>  	}
> 
> -	longhaul_table = kmalloc((numscales + 1) * sizeof(*longhaul_table),
> +	longhaul_table = kzalloc((numscales + 1) * sizeof(*longhaul_table),
>  			GFP_KERNEL);
>  	if (!longhaul_table)
>  		return -ENOMEM;
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index 770a9e1..1b6ae6b 100644
> --- a/drivers/cpufreq/powernow-k8.c
> +++ b/drivers/cpufreq/powernow-k8.c
> @@ -623,7 +623,7 @@ static int fill_powernow_table(struct powernow_k8_data *data,
>  	if (check_pst_table(data, pst, maxvid))
>  		return -EINVAL;
> 
> -	powernow_table = kmalloc((sizeof(*powernow_table)
> +	powernow_table = kzalloc((sizeof(*powernow_table)
>  		* (data->numps + 1)), GFP_KERNEL);
>  	if (!powernow_table) {
>  		printk(KERN_ERR PFX "powernow_table memory alloc failure\n");
> @@ -793,7 +793,7 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
>  	}
> 
>  	/* fill in data->powernow_table */
> -	powernow_table = kmalloc((sizeof(*powernow_table)
> +	powernow_table = kzalloc((sizeof(*powernow_table)
>  		* (data->acpi_data.state_count + 1)), GFP_KERNEL);
>  	if (!powernow_table) {
>  		pr_debug("powernow_table memory alloc failure\n");
> @@ -810,7 +810,6 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
> 
>  	powernow_table[data->acpi_data.state_count].frequency =
>  		CPUFREQ_TABLE_END;
> -	powernow_table[data->acpi_data.state_count].driver_data = 0;
>  	data->powernow_table = powernow_table;
> 
>  	if (cpumask_first(cpu_core_mask(data->cpu)) == data->cpu)
> diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
> index a3dc192..be1b2b5 100644
> --- a/drivers/cpufreq/s3c24xx-cpufreq.c
> +++ b/drivers/cpufreq/s3c24xx-cpufreq.c
> @@ -586,7 +586,7 @@ static int s3c_cpufreq_build_freq(void)
>  	size = cpu_cur.info->calc_freqtable(&cpu_cur, NULL, 0);
>  	size++;
> 
> -	ftab = kmalloc(sizeof(*ftab) * size, GFP_KERNEL);
> +	ftab = kzalloc(sizeof(*ftab) * size, GFP_KERNEL);
>  	if (!ftab) {
>  		printk(KERN_ERR "%s: no memory for tables\n", __func__);
>  		return -ENOMEM;
> @@ -664,7 +664,7 @@ int __init s3c_plltab_register(struct cpufreq_frequency_table *plls,
> 
>  	size = sizeof(*vals) * (plls_no + 1);
> 
> -	vals = kmalloc(size, GFP_KERNEL);
> +	vals = kzalloc(size, GFP_KERNEL);
>  	if (vals) {
>  		memcpy(vals, plls, size);
>  		pll_reg = vals;
> diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
> index 4cfdcff..3867839 100644
> --- a/drivers/cpufreq/spear-cpufreq.c
> +++ b/drivers/cpufreq/spear-cpufreq.c
> @@ -195,18 +195,15 @@ static int spear_cpufreq_probe(struct platform_device *pdev)
>  	cnt = prop->length / sizeof(u32);
>  	val = prop->value;
> 
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
> 
>  	spear_cpufreq.freq_tbl = freq_tbl;
> -- 
> 1.7.12.rc2.18.g61b472e
> 

