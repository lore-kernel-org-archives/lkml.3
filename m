Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaKIONC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 09:13:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbaKIONA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 09:13:00 -0500
Message-ID: <545F765A.3040007@redhat.com>
Date: Sun, 09 Nov 2014 09:12:42 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, robert.schoene@tu-dresden.de,
        sboyd@codeaurora.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 5/5] cpufreq, add BUG() messages in critical paths to
 aid debugging failures
References: <1415199239-19019-1-git-send-email-prarit@redhat.com> <1908314.5SSPFg5MrY@vostro.rjw.lan> <545E1BAF.4060801@redhat.com> <1874335.TzunrgXvuB@vostro.rjw.lan>
In-Reply-To: <1874335.TzunrgXvuB@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/08/2014 04:46 PM, Rafael J. Wysocki wrote:
> On Saturday, November 08, 2014 08:33:35 AM Prarit Bhargava wrote:
>>
>> On 11/07/2014 09:00 PM, Rafael J. Wysocki wrote:
>>> On Wednesday, November 05, 2014 09:53:59 AM Prarit Bhargava wrote:
>>>> Add some additional debug to capture failures in the locking scheme for
>>>> cpufreq.  Instead of just a NULL pointer, these warnings will capture failure
>>>> points if the locking scheme for cpufreq is broken.
>>>>
>>>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
>>>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>>>> Cc: linux-pm@vger.kernel.org
>>>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>>>> ---
>>>>  drivers/cpufreq/cpufreq_governor.c |   32 +++++++++++++++++++++++++++-----
>>>>  1 file changed, 27 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>>>> index b1ee597..f158882 100644
>>>> --- a/drivers/cpufreq/cpufreq_governor.c
>>>> +++ b/drivers/cpufreq/cpufreq_governor.c
>>>> @@ -161,9 +161,18 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>>>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
>>>>  
>>>>  static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
>>>> -		unsigned int delay)
>>>> +				    unsigned int delay,
>>>> +				    struct cpufreq_policy *policy)
>>>>  {
>>>> -	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
>>>> +	struct cpu_dbs_common_info *cdbs;
>>>> +
>>>> +	if (!dbs_data->cdata) {
>>>> +		pr_emerg("common_dbs_data is NULL for %s but initialized = %d",
>>>> +			 policy->governor->name,
>>>> +			 atomic_read(&policy->governor->initialized));
>>>> +		BUG();
>>>
>>> Is it necessary to crash the kernel here?
>>
>> Yes.  dbs_data->cdata is referenced right below.
>>
>>>
>>>> +	}
>>>> +	cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
>>
>> and we'll NULL pointer panic right here without any of the debug info above :(
> 
> Can we possibly avoid the panic?
> 
> Adding BUG() instead of a NULL pointer deref is not much improvement.

(sorry  for the lowercase typing.  i fractured my elbow and have resorted to
single hand typing ....)

rafael, i understand your concern and my description is clearly lacking for this
patch.  this patch is not meant to be a fix but is meant to capture debug info
for future issues in this code.  i thought about only doing the pr_emerg() but
that results in situations where other threads may continue processing and i
lose state in crashdump :(.   bug() is a good idea here imo.

P.
> 
>>
>>>>  
>>>>  	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
>>>>  }
>>>> @@ -185,10 +194,11 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>>>>  		 * those works are canceled during CPU_DOWN_PREPARE so they
>>>>  		 * can't possibly run on any other CPU.
>>>>  		 */
>>>> -		__gov_queue_work(raw_smp_processor_id(), dbs_data, delay);
>>>> +		__gov_queue_work(raw_smp_processor_id(), dbs_data, delay,
>>>> +				 policy);
>>>>  	} else {
>>>>  		for_each_cpu(i, policy->cpus)
>>>> -			__gov_queue_work(i, dbs_data, delay);
>>>> +			__gov_queue_work(i, dbs_data, delay, policy);
>>>>  	}
>>>>  
>>>>  out_unlock:
>>>> @@ -258,7 +268,13 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>>>  	else
>>>>  		dbs_data = cdata->gdbs_data;
>>>>  
>>>> -	WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));
>>>> +	if (!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT)) {
>>>> +		pr_emerg("governor_data is NULL but governor %s is initialized = %d [governor_enabled = %d event = %u]\n",
>>>> +			 policy->governor->name,
>>>> +			 atomic_read(&policy->governor->initialized),
>>>> +			 policy->governor_enabled, event);
>>>> +		BUG();
>>>
>>> And here?
>>>
>>
>> Ditto -- dbs_data is dereferenced in the call path and will NULL pointer panic.
>>
>> P.
>>
>>>> +	}
>>>>  
>>>>  	switch (event) {
>>>>  	case CPUFREQ_GOV_POLICY_INIT:
>>>> @@ -329,6 +345,12 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>>>  	case CPUFREQ_GOV_POLICY_EXIT:
>>>>  		mutex_lock(&dbs_data->usage_count_mutex);
>>>>  		if (atomic_dec_and_test(&dbs_data->usage_count)) {
>>>> +			if (atomic_read(&policy->governor->initialized) > 1) {
>>>> +				pr_emerg("Removing governor %s but initialized = %d, dbs_data->usage_count = 0\n",
>>>> +					 policy->governor->name,
>>>> +				   atomic_read(&policy->governor->initialized));
>>>> +				BUG();
>>>> +			}
>>>>  			sysfs_remove_group(get_governor_parent_kobj(policy),
>>>>  					get_sysfs_attr(dbs_data));
>>>>  
>>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
