Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaIDKDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:03:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39818 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaIDKDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:03:19 -0400
Message-ID: <540838DB.1070202@linux.vnet.ibm.com>
Date: Thu, 04 Sep 2014 15:33:07 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com> <CAKohpomLW17B=Sk42tczzDF+VGwn7hT521osWPi5TcgqpCPZ_w@mail.gmail.com> <53296AD0.5090908@linux.vnet.ibm.com>	<19131121.D211TBerqb@vostro.rjw.lan> <CAKohpom0+bbyffZML2tJjXQDc+2q4PM8sVkL5pDA5WX=rmvtKA@mail.gmail.com> <54082C68.8030400@linux.vnet.ibm.com> <CAKohpokvpWDbCbPYcV+fzzpaztZSi=yacdmyYfBLoSs4U2YO9A@mail.gmail.com>
In-Reply-To: <CAKohpokvpWDbCbPYcV+fzzpaztZSi=yacdmyYfBLoSs4U2YO9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090410-5806-0000-0000-0000006182E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 02:46 PM, Viresh Kumar wrote:
> On 4 September 2014 14:40, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> cpufreq: Allow stop CPU callback to be used by all cpufreq drivers
>>
>> Commit 367dc4aa introduced the stop CPU callback for intel_pstate
>> drivers. During the CPU_DOWN_PREPARE stage, this callback is invoked
>> so that drivers can take some action on the pstate of the cpu
>> before it is taken offline. This callback was assumed to be useful
>> only for those drivers which have implemented the set_policy CPU
>> callback because they have no other way to take action about the
>> cpufreq of a CPU which is being hotplugged out except in the exit
>> callback which is called very late in the offline process.
>>
>> The drivers which implement the target/target_index callbacks were
>> expected to take care of requirements like the ones that commit
>> 367dc4aa addresses in the GOV_STOP notification event. But there
>> are disadvantages to restricting the usage of stop CPU callback
>> to cpufreq drivers that implement the set_policy callbacks and who
>> want to take explicit action on the setting the cpufreq during a
>> hotplug operation.
>>
>> 1.GOV_STOP gets called for every CPU offline and drivers would usually
>>   want to take action when the last cpu in the policy->cpus mask
>>   is taken offline. As long as there is more than one cpu in the
>>   policy->cpus mask, cpufreq core itself makes sure that the freq
>>   for the other cpus in this mask is set according to the maximum load.
>>   This is sensible and drivers which implement the target_index callback
>>   would mostly not want to modify that. However the cpufreq core leaves a
>>   loose end when the cpu in the policy->cpus mask is the last one to go offline;
>>   it does nothing explicit to the frequency of the core. Drivers may need
>>   a way to take some action here and stop CPU callback mechanism is the
>>   best way to do it today.
>>
>> 2.We cannot implement driver specific actions in the GOV_STOP mechanism.
>>   So we will need another driver callback which is invoked from here which is
>>   unnecessary.
>>
>>   Therefore this patch extends the usage of stop CPU callback to be used
>>   by all cpufreq drivers as long as they have this callback implemented
>>   and irrespective of whether they are set_policy/target_index drivers.
>>   The assumption is if the drivers find the GOV_STOP path to be a suitable
>>   way of implementing what they want to do with the freq of the cpu
>>   going offine,they will not implement the stop CPU callback at all.
>>
>>   Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index d9fdedd..6463f35 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1380,7 +1380,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>>                 if (!cpufreq_suspended)
>>                         pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
>>                                  __func__, new_cpu, cpu);
>> -       } else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
>> +       } else if (cpufreq_driver->stop_cpu) {
>>                 cpufreq_driver->stop_cpu(policy);
>>         }
> 
> Rafael explicitly said earlier that he want to see a separate callback for
> ->target() drivers, don't know why..

I think Rafael's point was that since no driver that had implemented the
target_index callback was using it at the time that this patch was
proposed, it was be best to couple the check on existence of stop_cpu
callback with the the check on the kind of cpufreq driver. However
powerpc is also in need of this today and we implement the target_index
callback and find it convenient to use the stop CPU callback.

Rafael, in which case would it not make sense to remove the check on
driver->setpolicy above?

Besides, I don't understand very well why we had this double check in
the first place. Only if the drivers are in need of the functionality
like stop_cpu, would they have implemented this callback right? If we
are to assume that the drivers which have implemented the target_index
callback should never be needing it, they would not have implemented the
stop CPU callback either. So what was that, which was blatantly wrong
with just having a check on stop_cpu? I did go through the discussion
but did not find a convincing answer to this.

Rafael?

Regards
Preeti U Murthy

> 
> It looks fine to me though.
> 

