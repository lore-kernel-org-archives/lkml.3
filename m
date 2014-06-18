Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaFRXkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:40:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50000 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753095AbaFRXkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:40:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Plattner <aplattner@nvidia.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v2] cpufreq: unlock when failing cpufreq_update_policy()
Date: Thu, 19 Jun 2014 01:57:54 +0200
Message-ID: <3158268.Ad2sxChQ89@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403116052-4659-1-git-send-email-aplattner@nvidia.com>
References: <1403050362-20809-1-git-send-email-aplattner@nvidia.com> <1403116052-4659-1-git-send-email-aplattner@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 18, 2014 11:27:32 AM Aaron Plattner wrote:
> Commit bd0fa9bb455d introduced a failure path to cpufreq_update_policy() if
> cpufreq_driver->get(cpu) returns NULL.  However, it jumps to the 'no_policy'
> label, which exits without unlocking any of the locks the function acquired
> earlier.  This causes later calls into cpufreq to hang.
> 
> Fix this by creating a new 'unlock' label and jumping to that instead.
> 
> v2: Delete the no_policy label and just return early if policy is NULL.
> 
> Fixes: bd0fa9bb455d ("cpufreq: Return error if ->get() failed in cpufreq_update_policy()")
> Link: https://devtalk.nvidia.com/default/topic/751903/kernel-3-15-and-nv-drivers-337-340-failed-to-initialize-the-nvidia-kernel-module-gtx-550-ti-/
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Aaron Plattner <aplattner@nvidia.com>

Applied, thanks!

> ---
> v1 of this was tested by the user affected by the problem, but I don't have his
> email address so I can't add it as a Tested-by line.
> 
>  drivers/cpufreq/cpufreq.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index aed2b0cb83dc..62259d27f03e 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2242,10 +2242,8 @@ int cpufreq_update_policy(unsigned int cpu)
>  	struct cpufreq_policy new_policy;
>  	int ret;
>  
> -	if (!policy) {
> -		ret = -ENODEV;
> -		goto no_policy;
> -	}
> +	if (!policy)
> +		return -ENODEV;
>  
>  	down_write(&policy->rwsem);
>  
> @@ -2264,7 +2262,7 @@ int cpufreq_update_policy(unsigned int cpu)
>  		new_policy.cur = cpufreq_driver->get(cpu);
>  		if (WARN_ON(!new_policy.cur)) {
>  			ret = -EIO;
> -			goto no_policy;
> +			goto unlock;
>  		}
>  
>  		if (!policy->cur) {
> @@ -2279,10 +2277,10 @@ int cpufreq_update_policy(unsigned int cpu)
>  
>  	ret = cpufreq_set_policy(policy, &new_policy);
>  
> +unlock:
>  	up_write(&policy->rwsem);
>  
>  	cpufreq_cpu_put(policy);
> -no_policy:
>  	return ret;
>  }
>  EXPORT_SYMBOL(cpufreq_update_policy);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
