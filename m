Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaCRMuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:50:25 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57261 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaCRMuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:50:21 -0400
Message-ID: <532840FD.308@linux.vnet.ibm.com>
Date: Tue, 18 Mar 2014 18:20:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC V2] cpufreq: make sure frequency transitions are serialized
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
In-Reply-To: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031812-3864-0000-0000-00000D094A17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 01:13 PM, Viresh Kumar wrote:
> Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
> POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
> shouldn't be called twice continuously. Following examples show why this is
> important:
> 
[...] 
> This was discussed earlier here:
> https://lkml.org/lkml/2013/9/25/402
> 
> Where Rafael asked for better fix, as he called the V1 fixes: "quick and dirty".
> This is another approach, much simpler than previous one. Please see if this
> looks fine. There is a TODO note in there as I wanted some suggestions on how
> exactly should we wait for a transition to get over.
> 
>  drivers/cpufreq/cpufreq.c | 39 +++++++++++++++++++++++++++++++++++++--
>  include/linux/cpufreq.h   |  2 ++
>  2 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2677ff1..66bdfff 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -324,6 +324,13 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>  	}
>  }
> 
> +static void notify_transition_for_each_cpu(struct cpufreq_policy *policy,
> +		struct cpufreq_freqs *freqs, unsigned int state)
> +{
> +	for_each_cpu(freqs->cpu, policy->cpus)
> +		__cpufreq_notify_transition(policy, freqs, state);
> +}
> +
>  /**
>   * cpufreq_notify_transition - call notifier chain and adjust_jiffies
>   * on frequency transition.
> @@ -335,8 +342,35 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>  void cpufreq_notify_transition(struct cpufreq_policy *policy,
>  		struct cpufreq_freqs *freqs, unsigned int state)
>  {
> -	for_each_cpu(freqs->cpu, policy->cpus)
> -		__cpufreq_notify_transition(policy, freqs, state);
> +	if ((state != CPUFREQ_PRECHANGE) && (state != CPUFREQ_POSTCHANGE))

Wait a min, when is this condition ever true? I mean, what else can
'state' ever be, apart from CPUFREQ_PRECHANGE and POSTCHANGE?

> +		return notify_transition_for_each_cpu(policy, freqs, state);
> +
> +	/* Serialize pre-post notifications */
> +	mutex_lock(&policy->transition_lock);

Nope, this is definitely not the way to go, IMHO. We should enforce that
the *callers* serialize the transitions, something like this:

	cpufreq_transition_lock();

	cpufreq_notify_transition(CPUFREQ_PRECHANGE);

	//Perform the frequency change

	cpufreq_notify_transition(CPUFREQ_POSTCHANGE);

	cpufreq_transition_unlock();

That's it!

[ We can either introduce a new "transition" lock or perhaps even reuse
the cpufreq_driver_lock if it fits... but the point is, the _caller_ has
to perform the locking; trying to be smart inside cpufreq_notify_transition()
is a recipe for headache :-( ]

Is there any problem with this approach due to which you didn't take
this route?

> +	if (unlikely(WARN_ON(!policy->transition_ongoing &&
> +				(state == CPUFREQ_POSTCHANGE)))) {
> +		mutex_unlock(&policy->transition_lock);
> +		return;
> +	}
> +
> +	if (state == CPUFREQ_PRECHANGE) {
> +		while (policy->transition_ongoing) {
> +			mutex_unlock(&policy->transition_lock);
> +			/* TODO: Can we do something better here? */
> +			cpu_relax();
> +			mutex_lock(&policy->transition_lock);

If the caller takes care of the synchronization, we can avoid
these sorts of acrobatics ;-)

Regards,
Srivatsa S. Bhat

> +		}
> +
> +		policy->transition_ongoing = true;
> +		mutex_unlock(&policy->transition_lock);
> +	}
> +
> +	notify_transition_for_each_cpu(policy, freqs, state);
> +
> +	if (state == CPUFREQ_POSTCHANGE) {
> +		policy->transition_ongoing = false;
> +		mutex_unlock(&policy->transition_lock);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
> 
> @@ -983,6 +1017,7 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)
> 
>  	INIT_LIST_HEAD(&policy->policy_list);
>  	init_rwsem(&policy->rwsem);
> +	mutex_init(&policy->transition_lock);
> 
>  	return policy;
> 
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 31c431e..e5cebce 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -104,6 +104,8 @@ struct cpufreq_policy {
>  	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
>  	 */
>  	struct rw_semaphore	rwsem;
> +	bool			transition_ongoing; /* Tracks transition status */
> +	struct mutex		transition_lock;
>  };
> 
>  /* Only for ACPI */
> 

