Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaCFBIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:08:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60553 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755512AbaCFBI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:08:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Plattner <aplattner@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: use cpufreq_cpu_get to avoid cpufreq_get race conditions
Date: Thu, 06 Mar 2014 02:23:39 +0100
Message-ID: <2327882.a9zobM63G6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393965735-15610-1-git-send-email-aplattner@nvidia.com>
References: <1393965735-15610-1-git-send-email-aplattner@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 04, 2014 12:42:15 PM Aaron Plattner wrote:
> If a module calls cpufreq_get while cpufreq is initializing, it's possible for
> it to be called after cpufreq_driver is set but before cpufreq_cpu_data is
> written during subsys_interface_register.  This happens because cpufreq_get
> doesn't take the cpufreq_driver_lock around its use of cpufreq_cpu_data.

Is this a theoretical race, or can you actually reproduce it?  If so, on what
system/driver?  Or are there any bug reports related to this you can point me
to?

> Fix this by using cpufreq_cpu_get(cpu) to look up the policy rather than reading
> it out of cpufreq_cpu_data directly.  cpufreq_cpu_get takes the appropriate
> locks to prevent this race from happening.
> 
> Since it's possible for policy to be NULL if the caller passes in an invalid CPU
> number or calls the function before cpufreq is initialized, delete the
> BUG_ON(!policy) and simply return 0.  Don't try to return -ENOENT because that's
> negative and the function returns an unsigned integer.
> 
> Signed-off-by: Aaron Plattner <aplattner@nvidia.com>

Viresh, have you seen this?

> ---
>  drivers/cpufreq/cpufreq.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 8d19f7c..158d0b5 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1447,23 +1447,16 @@ static unsigned int __cpufreq_get(unsigned int cpu)
>   */
>  unsigned int cpufreq_get(unsigned int cpu)
>  {
> -	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
> +	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
>  	unsigned int ret_freq = 0;
>  
> -	if (cpufreq_disabled() || !cpufreq_driver)
> -		return -ENOENT;
> -
> -	BUG_ON(!policy);
> -
> -	if (!down_read_trylock(&cpufreq_rwsem))
> -		return 0;
> -
> -	down_read(&policy->rwsem);
> -
> -	ret_freq = __cpufreq_get(cpu);
> +	if (policy) {
> +		down_read(&policy->rwsem);
> +		ret_freq = __cpufreq_get(cpu);
> +		up_read(&policy->rwsem);
>  
> -	up_read(&policy->rwsem);
> -	up_read(&cpufreq_rwsem);
> +		cpufreq_cpu_put(policy);
> +	}
>  
>  	return ret_freq;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
