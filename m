Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaGaUrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:47:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50635 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaGaUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:47:50 -0400
Message-ID: <53DAAB74.7050003@codeaurora.org>
Date: Thu, 31 Jul 2014 13:47:48 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4 1/5] cpufreq: Don't wait for CPU to going offline to
 restart governor
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org> <1406250448-470-2-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1406250448-470-2-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 06:07 PM, Saravana Kannan wrote:
> There's no need to wait for the CPU going down to fully go offline to
> restart the governor. We can stop the governor, change policy->cpus and
> immediately restart the governor. This should reduce the time without any
> CPUfreq monitoring and also help future patches with simplifying the code.
>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>   drivers/cpufreq/cpufreq.c | 33 ++++++++++++++++++---------------
>   1 file changed, 18 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 62259d2..ee0eb7b 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1390,6 +1390,21 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>   		cpufreq_driver->stop_cpu(policy);
>   	}
>
> +	down_write(&policy->rwsem);
> +	cpumask_clear_cpu(cpu, policy->cpus);
> +	up_write(&policy->rwsem);
> +
> +	if (cpus > 1 && has_target()) {
> +		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
> +		if (!ret)
> +			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +
> +		if (ret) {
> +			pr_err("%s: Failed to start governor\n", __func__);
> +			return ret;
> +		}
> +	}
> +
>   	return 0;
>   }
>
> @@ -1410,15 +1425,12 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>   		return -EINVAL;
>   	}
>
> -	down_write(&policy->rwsem);
> +	down_read(&policy->rwsem);
>   	cpus = cpumask_weight(policy->cpus);
> -
> -	if (cpus > 1)
> -		cpumask_clear_cpu(cpu, policy->cpus);
> -	up_write(&policy->rwsem);
> +	up_read(&policy->rwsem);
>
>   	/* If cpu is last user of policy, free policy */
> -	if (cpus == 1) {
> +	if (cpus == 0) {
>   		if (has_target()) {
>   			ret = __cpufreq_governor(policy,
>   					CPUFREQ_GOV_POLICY_EXIT);
> @@ -1447,15 +1459,6 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>
>   		if (!cpufreq_suspended)
>   			cpufreq_policy_free(policy);
> -	} else if (has_target()) {
> -		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
> -		if (!ret)
> -			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> -
> -		if (ret) {
> -			pr_err("%s: Failed to start governor\n", __func__);
> -			return ret;
> -		}
>   	}
>
>   	per_cpu(cpufreq_cpu_data, cpu) = NULL;
>

This patch should also fix another issue reported in-house recently. 
cpufreq_update_policy() fails for an ONLINE CPU. This is the scenario 
that triggers it:

Thead A
- Cluster with 4 CPUs
- CPU3 is going down.
- Governor is STOPed.
- CPU3 is removed, but governor not STARTed yet.

Thread B
- get_online_cpus()
- We cross this hotplug barrier since since POST_DEAD is sent AFTER 
releasing the hotplug lock.
- cpufreq_update_policy(CPU0) does a bunch of stuff
- Then sends GOV_LIMITS to governor.
- governor is currently STOPed, so it returns an error and 
cpufreq_update_policy() fails.

Thread A
- In POST_DEAD notifier, STARTs the governor again.

So, a perfectly valid call (doing get_online_cpus() and checking for 
cpu_online() on a CPU before calling) fails.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
