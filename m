Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3GJI5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:57:50 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43700 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3GJI5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:57:48 -0400
Message-ID: <51DD21FF.4090905@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 16:57:35 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [v3.10 regression] deadlock on cpu hotplug
References: <1443144.WnBWEpaopK@amdc1032> <51DB724F.9050708@linux.vnet.ibm.com> <1754044.EVIH1UZj6p@amdc1032> <51DCC9B0.9090507@linux.vnet.ibm.com>
In-Reply-To: <51DCC9B0.9090507@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071008-9264-0000-0000-0000041965C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 10:40 AM, Michael Wang wrote:
> On 07/09/2013 07:51 PM, Bartlomiej Zolnierkiewicz wrote:
> [snip]
>>
>> It doesn't help and unfortunately it just can't help as it only
>> addresses lockdep functionality while the issue is not a lockdep
>> problem but a genuine locking problem. CPU hot-unplug invokes
>> _cpu_down() which calls cpu_hotplug_begin() which in turn takes
>> &cpu_hotplug.lock. The lock is then hold during __cpu_notify()
>> call. Notifier chain goes up to cpufreq_governor_dbs() which for
>> CPUFREQ_GOV_STOP event does gov_cancel_work(). This function
>> flushes pending work and waits for it to finish. The all above
>> happens in one kernel thread. At the same time the other kernel
>> thread is doing the work we are waiting to complete and it also
>> happens to do gov_queue_work() which calls get_online_cpus().
>> Then the code tries to take &cpu_hotplug.lock which is already
>> held by the first thread and deadlocks.
> 
> Hmm...I think I get your point, some thread hold the lock and
> flush some work which also try to hold the same lock, correct?
> 
> Ok, that's a problem, let's figure out a good way to solve it :)

And besides the patch from Srivatsa, I also suggest below fix, it's
try to really stop all the works during down notify, I'd like to know
how do you think about it ;-)

Regards,
Michael Wang

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index dc9b72e..a64b544 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -178,13 +178,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 {
 	int i;
 
+	if (dbs_data->queue_stop)
+		return;
+
 	if (!all_cpus) {
 		__gov_queue_work(smp_processor_id(), dbs_data, delay);
 	} else {
-		get_online_cpus();
 		for_each_cpu(i, policy->cpus)
 			__gov_queue_work(i, dbs_data, delay);
-		put_online_cpus();
 	}
 }
 EXPORT_SYMBOL_GPL(gov_queue_work);
@@ -193,12 +194,27 @@ static inline void gov_cancel_work(struct dbs_data *dbs_data,
 		struct cpufreq_policy *policy)
 {
 	struct cpu_dbs_common_info *cdbs;
-	int i;
+	int i, round = 2;
 
+	dbs_data->queue_stop = 1;
+redo:
+	round--;
 	for_each_cpu(i, policy->cpus) {
 		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
 		cancel_delayed_work_sync(&cdbs->work);
 	}
+
+	/*
+	 * Since there is no lock to prvent re-queue the
+	 * cancelled work, some early cancelled work might
+	 * have been queued again by later cancelled work.
+	 *
+	 * Flush the work again with dbs_data->queue_stop
+	 * enabled, this time there will be no survivors.
+	 */
+	if (round)
+		goto redo;
+	dbs_data->queue_stop = 0;
 }
 
 /* Will return if we need to evaluate cpu load again or not */
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index e16a961..9116135 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -213,6 +213,7 @@ struct dbs_data {
 	unsigned int min_sampling_rate;
 	int usage_count;
 	void *tuners;
+	int queue_stop;
 
 	/* dbs_mutex protects dbs_enable in governor start/stop */
 	struct mutex mutex;




> 
> Regards,
> Michael Wang
> 
> 
> 
> 
>>
>> Best regards,
>> --
>> Bartlomiej Zolnierkiewicz
>> Samsung R&D Institute Poland
>> Samsung Electronics
>>
>>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>>> index 5af40ad..aa05eaa 100644
>>> --- a/drivers/cpufreq/cpufreq_governor.c
>>> +++ b/drivers/cpufreq/cpufreq_governor.c
>>> @@ -229,6 +229,8 @@ static void set_sampling_rate(struct dbs_data *dbs_data,
>>>         }
>>>  }
>>>  
>>> +static struct lock_class_key j_cdbs_key;
>>> +
>>>  int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>>                 struct common_dbs_data *cdata, unsigned int event)
>>>  {
>>> @@ -366,6 +368,8 @@ int (struct cpufreq_policy *policy,
>>>                                         kcpustat_cpu(j).cpustat[CPUTIME_NICE];
>>>  
>>>                         mutex_init(&j_cdbs->timer_mutex);
>>> +                       lockdep_set_class(&j_cdbs->timer_mutex, &j_cdbs_key);
>>> +
>>>                         INIT_DEFERRABLE_WORK(&j_cdbs->work,
>>>                                              dbs_data->cdata->gov_dbs_timer);
>>>                 }
>>>
>>> Regards,
>>> Michael Wang
>>
> 

