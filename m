Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbbATHdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:33:17 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:49969 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbATHdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:33:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpok7Q3CpMospA=3PAqiLtEERfkAJdHkcH+9GKvYBsof0UQ@mail.gmail.com>
References: <1420797291-15972-1-git-send-email-pi-cheng.chen@linaro.org>
	<1420797291-15972-2-git-send-email-pi-cheng.chen@linaro.org>
	<CAKohpok7Q3CpMospA=3PAqiLtEERfkAJdHkcH+9GKvYBsof0UQ@mail.gmail.com>
Date: Tue, 20 Jan 2015 15:33:14 +0800
Message-ID: <CALx668V5TKkx-qGnMjFAspTQ5pu3XsM1012wXsBHvR3CNsuCew@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq-dt: check CPU clock/power domain during initializing
From: Pi-Cheng Chen <pi-cheng.chen@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Thanks for reviewing.

On 19 January 2015 at 16:00, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 9 January 2015 at 15:24, pi-cheng.chen <pi-cheng.chen@linaro.org> wrote:
>> Currently the DT based cpufreq driver is missing some way to check which
>> CPUs share clocks. In the 1st patch, CPU clock/power domain information is
>> added to the platform_data of cpufreq-dt so that cpufreq-dt driver could
>> check which CPUs share clock/power.
>>
>> Signed-off-by: pi-cheng.chen <pi-cheng.chen@linaro.org>
>> ---
>>  drivers/cpufreq/cpufreq-dt.c | 15 +++++++++++++++
>>  include/linux/cpufreq-dt.h   |  6 ++++++
>>  2 files changed, 21 insertions(+)
>>
>> diff --git a/drivers/cpufreq/cpufreq-dt.c b/drivers/cpufreq/cpufreq-dt.c
>> index fde97d6..ff8c266 100644
>> --- a/drivers/cpufreq/cpufreq-dt.c
>> +++ b/drivers/cpufreq/cpufreq-dt.c
>> @@ -296,6 +296,21 @@ static int cpufreq_init(struct cpufreq_policy *policy)
>>         pd = cpufreq_get_driver_data();
>>         if (!pd || !pd->independent_clocks)
>>                 cpumask_setall(policy->cpus);
>> +       else if (pd && !list_empty(&pd->domain_list)) {
>> +               struct list_head *domain_node;
>> +
>> +               list_for_each(domain_node, &pd->domain_list) {
>> +                       struct cpufreq_cpu_domain *domain;
>
> Define this with domain_node.
>

Will do it.

>> +
>> +                       domain = container_of(domain_node,
>> +                                             struct cpufreq_cpu_domain, node);
>> +                       if (!cpumask_test_cpu(policy->cpu, &domain->cpus))
>> +                               continue;
>> +
>> +                       cpumask_copy(policy->cpus, &domain->cpus);
>> +                       break;
>> +               }
>> +       }
>>
>>         of_node_put(np);
>>
>> diff --git a/include/linux/cpufreq-dt.h b/include/linux/cpufreq-dt.h
>> index 0414009..92bffd3 100644
>> --- a/include/linux/cpufreq-dt.h
>> +++ b/include/linux/cpufreq-dt.h
>> @@ -10,6 +10,11 @@
>>  #ifndef __CPUFREQ_DT_H__
>>  #define __CPUFREQ_DT_H__
>>
>> +struct cpufreq_cpu_domain {
>> +       struct list_head node;
>> +       cpumask_t cpus;
>> +};
>> +
>>  struct cpufreq_dt_platform_data {
>>         /*
>>          * True when each CPU has its own clock to control its
>> @@ -17,6 +22,7 @@ struct cpufreq_dt_platform_data {
>>          * clock.
>>          */
>>         bool independent_clocks;
>> +       struct list_head domain_list;
>>  };
>
> Though we need to keep only one of these two, but I don't think
> any of these will stay for long time. So, its okay..
>
> Looks fine. Thanks.

Thanks.
I will also try to add intermediate frequency support in next version.
BTW, do you think it's a good idea to add a new device tree binding like
intermediate_clock = <&clksys MAINPLL>
and so that cpufreq-dt could get the intermediate clock?

Best Regards,
Pi-Cheng
