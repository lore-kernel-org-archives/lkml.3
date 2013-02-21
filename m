Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3BURtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:49:09 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39573 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754598Ab3BURtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:49:06 -0500
Message-ID: <51265E0F.6090209@sgi.com>
Date: Thu, 21 Feb 2013 11:49:03 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] cpufreq: Convert the cpufreq_driver_lock to use
 the rcu
References: <1360116290-23849-1-git-send-email-nzimmer@sgi.com> <1361404583-5557-1-git-send-email-nzimmer@sgi.com> <1361404583-5557-3-git-send-email-nzimmer@sgi.com> <CAKohponMWRPspZF=tPN6MXoxkcjw7CK_sLnSdsKe+EDoiADvGA@mail.gmail.com>
In-Reply-To: <CAKohponMWRPspZF=tPN6MXoxkcjw7CK_sLnSdsKe+EDoiADvGA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 11:50 PM, Viresh Kumar wrote:
> On 21 February 2013 05:26, Nathan Zimmer <nzimmer@sgi.com> wrote:
>> In general rwlocks are discourged so we are moving it to use the rcu instead.
>> This does require a bit of care since the cpufreq_driver_lock protects both
>> the cpufreq_driver and the cpufreq_cpu_data array.
>> Also since many of the function pointers on cpufreq_driver may sleep when
>> called we have to grab them under the rcu_read_lock but call them after
>> rcu_read_unlock();
> Even i have started reading rcu documentation now :)
>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
>> ---
>>   drivers/cpufreq/cpufreq.c | 312 +++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 224 insertions(+), 88 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> @@ -255,20 +258,21 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
>>   void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
>>   {
>>          struct cpufreq_policy *policy;
>> -       unsigned long flags;
>> +       u8 flags;
> I think you can get rid of flags.
>
>>          BUG_ON(irqs_disabled());
>>
>>          if (cpufreq_disabled())
>>                  return;
>>
>> -       freqs->flags = cpufreq_driver->flags;
>>          pr_debug("notification %u of frequency transition to %u kHz\n",
>>                  state, freqs->new);
>>
>> -       read_lock_irqsave(&cpufreq_driver_lock, flags);
>> +       rcu_read_lock();
>> +       flags = rcu_dereference(cpufreq_driver)->flags;
> use freq->flags here ...
>
>>          policy = per_cpu(cpufreq_cpu_data, freqs->cpu);
>> -       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> +       rcu_read_unlock();
>> +       freqs->flags = flags;
>>
>>          switch (state) {
>>
>> @@ -277,7 +281,7 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
>>                   * which is not equal to what the cpufreq core thinks is
>>                   * "old frequency".
>>                   */
>> -               if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
>> +               if (!(flags & CPUFREQ_CONST_LOOPS)) {
> and here.
Of course.
>>                          if ((policy) && (policy->cpu == freqs->cpu) &&
>>                              (policy->cur) && (policy->cur != freqs->old)) {
>>                                  pr_debug("Warning: CPU frequency is"
>
>> @@ -742,35 +773,39 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
>> -       write_lock_irqsave(&cpufreq_driver_lock, flags);
>> +       spin_lock_irqsave(&cpufreq_driver_lock, flags);
>>          for_each_cpu(j, policy->cpus) {
>>                  per_cpu(cpufreq_cpu_data, j) = policy;
>>                  per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
>>          }
>> -       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> +       spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> +       synchronize_rcu();
> I don't think (but i can be wrong too :) ), that we need a synchronize_rcu()
> here. We need it only at places where we have updated the cpufreq_driver
> pointer.
>
> As we aren't doing any rcu specific read/update for cpufreq_cpu_data.
Good point.
I placed a similar sycnronize_rcu in cpufreq_add_policy_cpu and 
cpufreq_add_dev.
I will remove them also.


Thanks, I will respin.
Nate

