Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935351AbaKNXfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:35:44 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61183 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933635AbaKNXfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:35:42 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vince Hsu <vinceh@nvidia.com>
Cc: viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, =bilhuang@nvidia.com, dgreid@google.com,
        olofj@chromium.org
Subject: Re: [PATCH V2] cpufreq: respect the min/max settings from user space
Date: Sat, 15 Nov 2014 00:56:41 +0100
Message-ID: <4263460.gtRjLEEEsM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415600090-14233-1-git-send-email-vinceh@nvidia.com>
References: <1415600090-14233-1-git-send-email-vinceh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 10, 2014 02:14:50 PM Vince Hsu wrote:
> When the user space tries to set scaling_(max|min)_freq through
> sysfs, the cpufreq_set_policy() asks other driver's opinions
> for the max/min frequencies. Some device drivers, like Tegra
> CPU EDP which is not upstreamed yet though, may constrain the
> CPU maximum frequency dynamically because of board design.
> So if the user space access happens and some driver is capping
> the cpu frequency at the same time, the user_policy->(max|min)
> is overridden by the capped value, and that's not expected by
> the user space. And if the user space is not invoked again,
> the CPU will always be capped by the user_policy->(max|min)
> even no drivers limit the CPU frequency any more.
> 
> This patch preserves the user specified min/max settings, so that
> every time the cpufreq policy is updated, the new max/min can
> be re-evaluated correctly based on the user's expection and
> the present device drivers' status.
> 
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up for 3.19, thanks!

> ---
> v2: added Viresh's Acked-by
> 
>  drivers/cpufreq/cpufreq.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 644b54e1e7d1..0721ab352e2a 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -535,7 +535,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
>  static ssize_t store_##file_name					\
>  (struct cpufreq_policy *policy, const char *buf, size_t count)		\
>  {									\
> -	int ret;							\
> +	int ret, temp;							\
>  	struct cpufreq_policy new_policy;				\
>  									\
>  	ret = cpufreq_get_policy(&new_policy, policy->cpu);		\
> @@ -546,8 +546,10 @@ static ssize_t store_##file_name					\
>  	if (ret != 1)							\
>  		return -EINVAL;						\
>  									\
> +	temp = new_policy.object;					\
>  	ret = cpufreq_set_policy(policy, &new_policy);		\
> -	policy->user_policy.object = policy->object;			\
> +	if (!ret)							\
> +		policy->user_policy.object = temp;			\
>  									\
>  	return ret ? ret : count;					\
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
