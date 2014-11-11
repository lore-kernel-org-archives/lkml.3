Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaKKMSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:18:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaKKMSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:18:52 -0500
Message-ID: <5461FEA0.5070706@redhat.com>
Date: Tue, 11 Nov 2014 07:18:40 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 5/5] cpufreq, add BUG() messages in critical paths to
 aid debugging failures
References: <1415199239-19019-1-git-send-email-prarit@redhat.com> <1415199239-19019-6-git-send-email-prarit@redhat.com> <CAKohpon3ybK1YhemeZ_kxFCLowsJSZSO3P7=CTZaWpAMwNh7Dg@mail.gmail.com>
In-Reply-To: <CAKohpon3ybK1YhemeZ_kxFCLowsJSZSO3P7=CTZaWpAMwNh7Dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/10/2014 11:23 PM, Viresh Kumar wrote:
> On 5 November 2014 20:23, Prarit Bhargava <prarit@redhat.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index b1ee597..f158882 100644
>> --- a/drivers/cpufreq/cpufreq_governor.c
>> +++ b/drivers/cpufreq/cpufreq_governor.c
>> @@ -161,9 +161,18 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
>>
>>  static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
>> -               unsigned int delay)
>> +                                   unsigned int delay,
>> +                                   struct cpufreq_policy *policy)
>>  {
>> -       struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
> 
> I will let it crash right here instead of additional code :)

the problem is tht the userful information is the values of initialized,
enabled, and what the  event was :(

in every case i ended up needing the values.

> 
>> @@ -258,7 +268,13 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>> -       WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));
>> +       if (!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT)) {
>> +               pr_emerg("governor_data is NULL but governor %s is initialized = %d [governor_enabled = %d event = %u]\n",
>> +                        policy->governor->name,
>> +                        atomic_read(&policy->governor->initialized),
>> +                        policy->governor_enabled, event);
>> +               BUG();
> 
> How is the BUG better than the WARN here ?
> 

we null pointer panic later on, and again the useful values are the ones displayed.

>>         switch (event) {
>>         case CPUFREQ_GOV_POLICY_INIT:
>> @@ -329,6 +345,12 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>         case CPUFREQ_GOV_POLICY_EXIT:
>>                 mutex_lock(&dbs_data->usage_count_mutex);
>>                 if (atomic_dec_and_test(&dbs_data->usage_count)) {
>> +                       if (atomic_read(&policy->governor->initialized) > 1) {
> 
> Isn't this wrong? Consider 4 CPUs with separate clock line and have set
> governor-per-policy to true. EXIT will be called for every CPU hotplug and
> initialized will be 4 initially..
> 
> Or I am still vacation lag'd ? :)

oh, is that right?  i'll look into that.

P.
> 
>> +                               pr_emerg("Removing governor %s but initialized = %d, dbs_data->usage_count = 0\n",
>> +                                        policy->governor->name,
>> +                                  atomic_read(&policy->governor->initialized));
>> +                               BUG();
>> +                       }
>>                         sysfs_remove_group(get_governor_parent_kobj(policy),
>>                                         get_sysfs_attr(dbs_data));
>>
>> --
>> 1.7.9.3
>>
