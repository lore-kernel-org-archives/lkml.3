Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3GOHwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:52:42 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52474 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3GOHwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:52:40 -0400
Message-ID: <51E3AA3B.9090003@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 15:52:27 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
References: <20130625211544.GA2270@swordfish> <51D10899.1080501@linux.vnet.ibm.com> <20130710231305.GA4046@swordfish> <51DE1BE1.3090707@linux.vnet.ibm.com> <20130714114721.GB2178@swordfish> <20130714120629.GA4067@swordfish> <51E37194.1080103@linux.vnet.ibm.com>
In-Reply-To: <51E37194.1080103@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071507-7014-0000-0000-0000035172B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 11:50 AM, Michael Wang wrote:
> On 07/14/2013 08:06 PM, Sergey Senozhatsky wrote:
>> On (07/14/13 14:47), Sergey Senozhatsky wrote:
>>>
>>> Now, as I fixed radeon kms, I can see:
>>>
>>> [  806.660530] ------------[ cut here ]------------
>>> [  806.660539] WARNING: CPU: 0 PID: 2389 at arch/x86/kernel/smp.c:124
>>> native_smp_send_reschedule+0x57/0x60()
>>
>> Well, this one is obviously not a lockdep error, I meant that previous
>> tests with disabled lockdep were invalid. Will re-do.
>>
> 
> And may be we could try below patch to get more info, I've moved the timing
> of restore stop flag from 'after STOP' to 'before START', I suppose that
> could create a window to prevent the work re-queue, it could at least provide
> us more info...
> 
> I think I may need to setup a environment for debug now, what's the steps to
> produce this WARN?

I have done some test, although I failed to reproduce this WARN, but I
found that the work is still running and re-queue itself after STOP,
even with my prev suggestion...

However, enlarge the stop window as my suggestion below, the work do
stopped...I suppose it will also stop the first WARN too.

Now we need to figure out the reason...

Regards,
Michael Wang

> 
> Regards,
> Michael Wang
> 
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index dc9b72e..b1446fe 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -178,13 +178,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  {
>  	int i;
> 
> +	if (!dbs_data->queue_start)
> +		return;
> +
>  	if (!all_cpus) {
>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
>  	} else {
> -		get_online_cpus();
>  		for_each_cpu(i, policy->cpus)
>  			__gov_queue_work(i, dbs_data, delay);
> -		put_online_cpus();
>  	}
>  }
>  EXPORT_SYMBOL_GPL(gov_queue_work);
> @@ -193,12 +194,26 @@ static inline void gov_cancel_work(struct dbs_data *dbs_data,
>  		struct cpufreq_policy *policy)
>  {
>  	struct cpu_dbs_common_info *cdbs;
> -	int i;
> +	int i, round = 2;
> 
> +	dbs_data->queue_start = 0;
> +redo:
> +	round--;
>  	for_each_cpu(i, policy->cpus) {
>  		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
>  		cancel_delayed_work_sync(&cdbs->work);
>  	}
> +
> +	/*
> +	 * Since there is no lock to prvent re-queue the
> +	 * cancelled work, some early cancelled work might
> +	 * have been queued again by later cancelled work.
> +	 *
> +	 * Flush the work again with dbs_data->queue_stop
> +	 * enabled, this time there will be no survivors.
> +	 */
> +	if (round)
> +		goto redo;
>  }
> 
>  /* Will return if we need to evaluate cpu load again or not */
> @@ -391,6 +406,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> 
>  		/* Initiate timer time stamp */
>  		cpu_cdbs->time_stamp = ktime_get();
> +		dbs_data->queue_start = 1;
> 
>  		gov_queue_work(dbs_data, policy,
>  				delay_for_sampling_rate(sampling_rate), true);
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index e16a961..9116135 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -213,6 +213,7 @@ struct dbs_data {
>  	unsigned int min_sampling_rate;
>  	int usage_count;
>  	void *tuners;
> +	int queue_start;
> 
>  	/* dbs_mutex protects dbs_enable in governor start/stop */
>  	struct mutex mutex;
> 
> 
> 
>> 	-ss
>>
>>>> Regards,
>>>> Michael Wang
>>>>
>>>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>>>> index dc9b72e..a64b544 100644
>>>> --- a/drivers/cpufreq/cpufreq_governor.c
>>>> +++ b/drivers/cpufreq/cpufreq_governor.c
>>>> @@ -178,13 +178,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>>>>  {
>>>>  	int i;
>>>>  
>>>> +	if (dbs_data->queue_stop)
>>>> +		return;
>>>> +
>>>>  	if (!all_cpus) {
>>>>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
>>>>  	} else {
>>>> -		get_online_cpus();
>>>>  		for_each_cpu(i, policy->cpus)
>>>>  			__gov_queue_work(i, dbs_data, delay);
>>>> -		put_online_cpus();
>>>>  	}
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(gov_queue_work);
>>>> @@ -193,12 +194,27 @@ static inline void gov_cancel_work(struct dbs_data *dbs_data,
>>>>  		struct cpufreq_policy *policy)
>>>>  {
>>>>  	struct cpu_dbs_common_info *cdbs;
>>>> -	int i;
>>>> +	int i, round = 2;
>>>>  
>>>> +	dbs_data->queue_stop = 1;
>>>> +redo:
>>>> +	round--;
>>>>  	for_each_cpu(i, policy->cpus) {
>>>>  		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
>>>>  		cancel_delayed_work_sync(&cdbs->work);
>>>>  	}
>>>> +
>>>> +	/*
>>>> +	 * Since there is no lock to prvent re-queue the
>>>> +	 * cancelled work, some early cancelled work might
>>>> +	 * have been queued again by later cancelled work.
>>>> +	 *
>>>> +	 * Flush the work again with dbs_data->queue_stop
>>>> +	 * enabled, this time there will be no survivors.
>>>> +	 */
>>>> +	if (round)
>>>> +		goto redo;
>>>> +	dbs_data->queue_stop = 0;
>>>>  }
>>>>  
>>>>  /* Will return if we need to evaluate cpu load again or not */
>>>> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
>>>> index e16a961..9116135 100644
>>>> --- a/drivers/cpufreq/cpufreq_governor.h
>>>> +++ b/drivers/cpufreq/cpufreq_governor.h
>>>> @@ -213,6 +213,7 @@ struct dbs_data {
>>>>  	unsigned int min_sampling_rate;
>>>>  	int usage_count;
>>>>  	void *tuners;
>>>> +	int queue_stop;
>>>>  
>>>>  	/* dbs_mutex protects dbs_enable in governor start/stop */
>>>>  	struct mutex mutex;
>>>>
>>>>>
>>>>> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>>>>>
>>>>> ---
>>>>>
>>>>>  drivers/cpufreq/cpufreq.c          |  5 +----
>>>>>  drivers/cpufreq/cpufreq_governor.c | 17 +++++++++++------
>>>>>  drivers/cpufreq/cpufreq_stats.c    |  2 +-
>>>>>  3 files changed, 13 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>>>> index 6a015ad..f8aacf1 100644
>>>>> --- a/drivers/cpufreq/cpufreq.c
>>>>> +++ b/drivers/cpufreq/cpufreq.c
>>>>> @@ -1943,13 +1943,10 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
>>>>>  		case CPU_ONLINE:
>>>>>  			cpufreq_add_dev(dev, NULL);
>>>>>  			break;
>>>>> -		case CPU_DOWN_PREPARE:
>>>>> +		case CPU_POST_DEAD:
>>>>>  		case CPU_UP_CANCELED_FROZEN:
>>>>>  			__cpufreq_remove_dev(dev, NULL);
>>>>>  			break;
>>>>> -		case CPU_DOWN_FAILED:
>>>>> -			cpufreq_add_dev(dev, NULL);
>>>>> -			break;
>>>>>  		}
>>>>>  	}
>>>>>  	return NOTIFY_OK;
>>>>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>>>>> index 4645876..681d5d6 100644
>>>>> --- a/drivers/cpufreq/cpufreq_governor.c
>>>>> +++ b/drivers/cpufreq/cpufreq_governor.c
>>>>> @@ -125,7 +125,11 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
>>>>>  		unsigned int delay)
>>>>>  {
>>>>>  	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
>>>>> -
>>>>> +	/* cpu offline might block existing gov_queue_work() user,
>>>>> +	 * unblocking it after CPU_DEAD and before CPU_POST_DEAD.
>>>>> +	 * thus potentially we can hit offlined CPU */
>>>>> +	if (unlikely(cpu_is_offline(cpu)))
>>>>> +		return;
>>>>>  	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
>>>>>  }
>>>>>
>>>>> @@ -133,15 +137,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>>>>>  		unsigned int delay, bool all_cpus)
>>>>>  {
>>>>>  	int i;
>>>>> -
>>>>> +	get_online_cpus();
>>>>>  	if (!all_cpus) {
>>>>>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
>>>>>  	} else {
>>>>> -		get_online_cpus();
>>>>>  		for_each_cpu(i, policy->cpus)
>>>>>  			__gov_queue_work(i, dbs_data, delay);
>>>>> -		put_online_cpus();
>>>>>  	}
>>>>> +	put_online_cpus();
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(gov_queue_work);
>>>>>
>>>>> @@ -354,8 +357,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>>>>  		/* Initiate timer time stamp */
>>>>>  		cpu_cdbs->time_stamp = ktime_get();
>>>>>
>>>>> -		gov_queue_work(dbs_data, policy,
>>>>> -				delay_for_sampling_rate(sampling_rate), true);
>>>>> +		/* hotplug lock already held */
>>>>> +		for_each_cpu(j, policy->cpus)
>>>>> +			__gov_queue_work(j, dbs_data,
>>>>> +				delay_for_sampling_rate(sampling_rate));
>>>>>  		break;
>>>>>
>>>>>  	case CPUFREQ_GOV_STOP:
>>>>> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
>>>>> index cd9e817..833816e 100644
>>>>> --- a/drivers/cpufreq/cpufreq_stats.c
>>>>> +++ b/drivers/cpufreq/cpufreq_stats.c
>>>>> @@ -355,7 +355,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
>>>>>  	case CPU_DOWN_PREPARE:
>>>>>  		cpufreq_stats_free_sysfs(cpu);
>>>>>  		break;
>>>>> -	case CPU_DEAD:
>>>>> +	case CPU_POST_DEAD:
>>>>>  		cpufreq_stats_free_table(cpu);
>>>>>  		break;
>>>>>  	case CPU_UP_CANCELED_FROZEN:
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

