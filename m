Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaC1Kni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:43:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56903 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaC1Knf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:43:35 -0400
Date: Fri, 28 Mar 2014 16:13:06 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, l.majewski@samsung.com
Subject: Re: [PATCH] cpufreq: create another field .flags in
 cpufreq_frequency_table
Message-ID: <20140328104306.GA28960@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
 <b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032810-1542-0000-0000-000000B1CC6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 02:23:20PM +0530, Viresh Kumar wrote:
> Currently cpufreq frequency table has two fields: frequency and driver_data.
> driver_data is only for driver's internal use and cpufreq core shouldn't use it
> at all. But with the introduction of BOOST frequencies, this assumption was
> broken and we started using it as a flag instead.
> 
> There are two problems due to this:
> - It is against the description of this field, as driver's data is used by core
>   now.
> - if drivers fill it with -3 for any frequency, then those frequencies are never
>   considered by cpufreq core as it is exactly same as value of
>   CPUFREQ_BOOST_FREQ, i.e. ~2.
> 
> The best way to get this fixed is by creating another field flags which will be
> used for such flags. This patch does that. Along with that various drivers need
> modifications due to the change of struct cpufreq_frequency_table.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks for this patch. A minor comment below:

> diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
> index 7c11ace..8c4c6a5 100644
> --- a/drivers/cpufreq/exynos4x12-cpufreq.c
> +++ b/drivers/cpufreq/exynos4x12-cpufreq.c
> @@ -30,21 +30,21 @@ static unsigned int exynos4x12_volt_table[] = {
>  };
> 
>  static struct cpufreq_frequency_table exynos4x12_freq_table[] = {
> -	{CPUFREQ_BOOST_FREQ, 1500 * 1000},
> -	{L1, 1400 * 1000},
> -	{L2, 1300 * 1000},
> -	{L3, 1200 * 1000},
> -	{L4, 1100 * 1000},
> -	{L5, 1000 * 1000},
> -	{L6,  900 * 1000},
> -	{L7,  800 * 1000},
> -	{L8,  700 * 1000},
> -	{L9,  600 * 1000},
> -	{L10, 500 * 1000},
> -	{L11, 400 * 1000},
> -	{L12, 300 * 1000},
> -	{L13, 200 * 1000},
> -	{0, CPUFREQ_TABLE_END},
> +	{CPUFREQ_BOOST_FREQ, 0, 1500 * 1000},
                            ^^^
Functionally it might make no difference, but may be this line can be
rewritten as:
	  {CPUFREQ_BOOST_FREQ, L0, 1500 * 1000}
in order to be consistent with the subsequent entries of the table
which use the .driver_data field to record the indices. And L0 has
been defined in exynos-cpufreq.h 

But I shall leave it to you and Lukasz to decide if it is worth the
while.

> +	{0, L1, 1400 * 1000},
> +	{0, L2, 1300 * 1000},
> +	{0, L3, 1200 * 1000},
> +	{0, L4, 1100 * 1000},
> +	{0, L5, 1000 * 1000},
> +	{0, L6,  900 * 1000},
> +	{0, L7,  800 * 1000},
> +	{0, L8,  700 * 1000},
> +	{0, L9,  600 * 1000},
> +	{0, L10, 500 * 1000},
> +	{0, L11, 400 * 1000},
> +	{0, L12, 300 * 1000},
> +	{0, L13, 200 * 1000},
> +	{0, 0, CPUFREQ_TABLE_END},
>  };
> 

Reviewed-by: Gautham R Shenoy <ego@linux.vnet.ibm.com>

--
Thanks and Regards
gautham.

