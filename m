Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab3ICT3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:29:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54342 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061Ab3ICT31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:29:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: sboyd@codeaurora.org, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
Date: Tue, 03 Sep 2013 21:40:14 +0200
Message-ID: <5197493.kSPF7VUWqc@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5225E205.7080008@linux.vnet.ibm.com>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <80c4bd8c577e5da0aa63342671773be5cdc26a9a.1378012620.git.viresh.kumar@linaro.org> <5225E205.7080008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 03, 2013 06:50:05 PM Srivatsa S. Bhat wrote:
> On 09/01/2013 10:56 AM, Viresh Kumar wrote:
> > We can't take a big lock around __cpufreq_governor() as this causes recursive
> > locking for some cases. But calls to this routine must be serialized for every
> > policy.
> > 
> > Lets introduce another variable which would guarantee serialization here.
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  drivers/cpufreq/cpufreq.c | 7 ++++++-
> >  include/linux/cpufreq.h   | 1 +
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index f320a20..4d5723db 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -1692,13 +1692,15 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
> >  						policy->cpu, event);
> > 
> >  	mutex_lock(&cpufreq_governor_lock);
> > -	if ((policy->governor_enabled && (event == CPUFREQ_GOV_START)) ||
> > +	if (policy->governor_busy ||
> > +		(policy->governor_enabled && (event == CPUFREQ_GOV_START)) ||
> >  		(!policy->governor_enabled && ((event == CPUFREQ_GOV_LIMITS) ||
> >  					       (event == CPUFREQ_GOV_STOP)))) {
> >  		mutex_unlock(&cpufreq_governor_lock);
> >  		return -EBUSY;
> >  	}
> > 
> > +	policy->governor_busy = true;
> >  	if (event == CPUFREQ_GOV_STOP)
> >  		policy->governor_enabled = false;
> >  	else if (event == CPUFREQ_GOV_START)
> > @@ -1727,6 +1729,9 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
> >  			((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
> >  		module_put(policy->governor->owner);
> > 
> > +	mutex_lock(&cpufreq_governor_lock);
> > +	policy->governor_busy = false;
> > +	mutex_unlock(&cpufreq_governor_lock);
> >  	return ret;
> >  }
> > 
> 
> This doesn't solve the problem completely: it prevents the store_*() task
> from continuing *only* when it concurrently executes the __cpufreq_governor()
> function along with the CPU offline task. But if the two calls don't overlap,
> we will still have the possibility where the store_*() task tries to acquire
> the timer mutex after the CPU offline task has just finished destroying it.

Yeah, I overlooked that.

> So, IMHO, the right fix is to synchronize with CPU hotplug. That way, the
> store_*() thread will wait until the entire CPU offline operation is completed.
> After that, if it continues, it will get -EBUSY, due to patch [1], since
> policy->governor_enabled will be set to false.
> 
> [1]. https://patchwork.kernel.org/patch/2852463/
> 
> So here is the (completely untested) fix that I propose, as a replacement to
> this patch [2/2]:

That looks reasonable to me.

Viresh?

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 5c75e31..71c4fb2 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -440,17 +440,24 @@ static ssize_t store_##file_name					\
>  	unsigned int ret;						\
>  	struct cpufreq_policy new_policy;				\
>  									\
> +	get_online_cpus();						\
>  	ret = cpufreq_get_policy(&new_policy, policy->cpu);		\
> -	if (ret)							\
> -		return -EINVAL;						\
> +	if (ret) {							\
> +		ret = -EINVAL;						\
> +		goto out;						\
> +	}								\
>  									\
>  	ret = sscanf(buf, "%u", &new_policy.object);			\
> -	if (ret != 1)							\
> -		return -EINVAL;						\
> +	if (ret != 1) {							\
> +		ret = -EINVAL;						\
> +		goto out;						\
> +	}								\
>  									\
>  	ret = __cpufreq_set_policy(policy, &new_policy);		\
>  	policy->user_policy.object = policy->object;			\
>  									\
> +out:									\
> +	put_online_cpus();						\
>  	return ret ? ret : count;					\
>  }
>  
> @@ -494,17 +501,22 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
>  	char	str_governor[16];
>  	struct cpufreq_policy new_policy;
>  
> +	get_online_cpus();
>  	ret = cpufreq_get_policy(&new_policy, policy->cpu);
>  	if (ret)
> -		return ret;
> +		goto out;
>  
>  	ret = sscanf(buf, "%15s", str_governor);
> -	if (ret != 1)
> -		return -EINVAL;
> +	if (ret != 1) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>  
>  	if (cpufreq_parse_governor(str_governor, &new_policy.policy,
> -						&new_policy.governor))
> -		return -EINVAL;
> +						&new_policy.governor)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>  
>  	/*
>  	 * Do not use cpufreq_set_policy here or the user_policy.max
> @@ -515,6 +527,9 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
>  	policy->user_policy.policy = policy->policy;
>  	policy->user_policy.governor = policy->governor;
>  
> +out:
> +	put_online_cpus();
> +
>  	if (ret)
>  		return ret;
>  	else
> 
> 
> Regards,
> Srivatsa S. Bhat
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
