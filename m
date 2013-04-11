Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232Ab3DKV0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:26:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56515 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696Ab3DKV0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:26:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] cpufreq: Call __cpufreq_governor() with correct policy->cpus mask
Date: Thu, 11 Apr 2013 23:34:03 +0200
Message-ID: <1706828.TqVJcHNWlq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <e3001264b4d7328b41130857adbb51e93d224c26.1365667475.git.viresh.kumar@linaro.org>
References: <e3001264b4d7328b41130857adbb51e93d224c26.1365667475.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 01:34:53 PM Viresh Kumar wrote:
> __cpufreq_governor() must be called with correct policy->cpus mask. In
> __cpufreq_remove_dev() we initially clear policy->cpus with cpumask_clear_cpu()
> and then call __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT). In case
> governor is doing some per-cpu stuff in EXIT callback, this can create uncertain
> behavior.
> 
> Generic governors in drivers/cpufreq/ doesn't do any per-cpu stuff in EXIT
> callback and so we don't face any issues currently. But its better to keep the
> code clean, so we don't face any issues in future.
> 
> Now, we call cpumask_clear_cpu() only when multiple cpus are managed by policy.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied.

Thanks,
Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index fd97a62..3564947 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1105,7 +1105,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>  
>  	WARN_ON(lock_policy_rwsem_write(cpu));
>  	cpus = cpumask_weight(data->cpus);
> -	cpumask_clear_cpu(cpu, data->cpus);
> +
> +	if (cpus > 1)
> +		cpumask_clear_cpu(cpu, data->cpus);
>  	unlock_policy_rwsem_write(cpu);
>  
>  	if (cpu != data->cpu) {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
