Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaCXIxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:53:04 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39201 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaCXIxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:53:00 -0400
Date: Mon, 24 Mar 2014 14:22:39 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, l.majewski@samsung.com
Subject: Re: [PATCH] cpufreq: set value of CPUFREQ_BOOST_FREQ to 0xABABABAB
Message-ID: <20140324085239.GA30828@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032408-7182-0000-0000-00000A1EFE6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 12:18:14PM +0530, Viresh Kumar wrote:
> Ideally, .driver_data field of struct cpufreq_frequency_table must not be used
> by core at all. But during a recent change if its value is same as
> CPUFREQ_BOOST_FREQ macro, then it is treated specially by core.
> 
> The value of this macro was set to ~2 earlier, i.e. 0xFFFFFFFD. In case some
> driver is using this field for its own data and sets this field to -3, then with
> two's complement that value will also become 0xFFFFFFFD.
> 
> To fix this issue, lets change value of this flag to a very uncommon value which
> shouldn't be used by any driver unless they want to use BOOST
> feature
> 
> Along with this update comments to make this more clear.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> 
> Gautham/Vaidy: I hope this fixes the problem we discussed for your
> patchset.

Since the type of .driver_data is "unsigned int", the cpufreq core
seems to be assuming that the value cannot be -ve. So, drivers should
be storing -ve values in these fields at their own risk. Because apart
from determining whether the corresponding frequency is a boost
frequency or not, the cpufreq core seems to be using the .driver_data
field in pr_debugs(). The value of .driver_data formatted as "%u" is
not useful in these pr_debugs, if the driver stores -ve value in this
field.

On the other hand, if we change the type of .driver_data to "int" then
restricting the driver to not use specific values is unreasonable
since .driver_data field is supposed to be private to the driver and
the core is not supposed to intepret it. In which case we should
be having a separate field for determining if the frequency is a BOOST
frequency or not.

So while it fixes the problem for us, I don't think this patch fixes
the problem in general for the reasons mentioned above.

--
Thanks and Regards
gautham.

> 
>  include/linux/cpufreq.h | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index c48e595..9f25d9d 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -455,12 +455,18 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
>   *                     FREQUENCY TABLE HELPERS                       *
>   *********************************************************************/
> 
> +/* Special Values of .frequency field */
>  #define CPUFREQ_ENTRY_INVALID ~0
>  #define CPUFREQ_TABLE_END     ~1
> -#define CPUFREQ_BOOST_FREQ    ~2
> +/* Special Values of .driver_data field */
> +#define CPUFREQ_BOOST_FREQ    0xABABABAB
> 
>  struct cpufreq_frequency_table {
> -	unsigned int	driver_data; /* driver specific data, not used by core */
> +	/*
> +	 * driver specific data, not used by core unless it is set to
> +	 * CPUFREQ_BOOST_FREQ.
> +	 */
> +	unsigned int	driver_data;
>  	unsigned int	frequency; /* kHz - doesn't need to be in ascending
>  				    * order */
>  };
> -- 
> 1.7.12.rc2.18.g61b472e
> 

