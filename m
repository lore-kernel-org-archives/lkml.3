Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3BVPOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:14:32 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56931 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab3BVPOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:14:31 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/2] cpustat: use accessor functions for get/set/add
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
	<1361512604-2720-2-git-send-email-khilman@linaro.org>
	<CAOh2x=kFL5_H=LqLf14yxYQEs7zSTT8Ue8mjUEVN4_a0c53Rdg@mail.gmail.com>
Date: Fri, 22 Feb 2013 07:14:27 -0800
In-Reply-To: <CAOh2x=kFL5_H=LqLf14yxYQEs7zSTT8Ue8mjUEVN4_a0c53Rdg@mail.gmail.com>
	(Viresh Kumar's message of "Fri, 22 Feb 2013 11:51:43 +0530")
Message-ID: <87txp41iuk.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> On Fri, Feb 22, 2013 at 11:26 AM, Kevin Hilman <khilman@linaro.org> wrote:
>> Add some accessor functions in order to facilitate the conversion to
>> atomic reads/writes of cpustat values.
>>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>> ---
>>  drivers/cpufreq/cpufreq_governor.c | 18 ++++++++---------
>>  drivers/cpufreq/cpufreq_ondemand.c |  2 +-
>
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index 6c5f1d3..ec6c315 100644
>> --- a/drivers/cpufreq/cpufreq_governor.c
>> +++ b/drivers/cpufreq/cpufreq_governor.c
>> @@ -36,12 +36,12 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
>>
>>         cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
>>
>> -       busy_time = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
>> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
>> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
>> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
>> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
>> -       busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
>> +       busy_time = kcpustat_cpu_get(cpu, CPUTIME_USER);
>> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_SYSTEM);
>> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_IRQ);
>> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_SOFTIRQ);
>> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_STEAL);
>> +       busy_time += kcpustat_cpu_get(cpu, CPUTIME_NICE);
>>
>>         idle_time = cur_wall_time - busy_time;
>>         if (wall)
>> @@ -103,7 +103,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>                         u64 cur_nice;
>>                         unsigned long cur_nice_jiffies;
>>
>> -                       cur_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE] -
>> +                       cur_nice = kcpustat_cpu_get(j, CPUTIME_NICE) -
>>                                          cdbs->prev_cpu_nice;
>>                         /*
>>                          * Assumption: nice time between sampling periods will
>> @@ -113,7 +113,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>                                         cputime64_to_jiffies64(cur_nice);
>>
>>                         cdbs->prev_cpu_nice =
>> -                               kcpustat_cpu(j).cpustat[CPUTIME_NICE];
>> +                               kcpustat_cpu_get(j, CPUTIME_NICE);
>>                         idle_time += jiffies_to_usecs(cur_nice_jiffies);
>>                 }
>>
>> @@ -216,7 +216,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
>>                                         &j_cdbs->prev_cpu_wall);
>>                         if (ignore_nice)
>>                                 j_cdbs->prev_cpu_nice =
>> -                                       kcpustat_cpu(j).cpustat[CPUTIME_NICE];
>> +                                       kcpustat_cpu_get(j, CPUTIME_NICE);
>>                 }
>>
>>                 /*
>> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
>> index 7731f7c..ac5d49f 100644
>> --- a/drivers/cpufreq/cpufreq_ondemand.c
>> +++ b/drivers/cpufreq/cpufreq_ondemand.c
>> @@ -403,7 +403,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
>>                                                 &dbs_info->cdbs.prev_cpu_wall);
>>                 if (od_tuners.ignore_nice)
>>                         dbs_info->cdbs.prev_cpu_nice =
>> -                               kcpustat_cpu(j).cpustat[CPUTIME_NICE];
>> +                               kcpustat_cpu_get(j, CPUTIME_NICE);
>>
>>         }
>>         return count;
>
> For cpufreq:
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Though i believe you also need this:
>
> diff --git a/drivers/cpufreq/cpufreq_conservative.c
> b/drivers/cpufreq/cpufreq_conservative.c
> index 64ef737..38e3ad7 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -242,7 +242,7 @@ static ssize_t store_ignore_nice_load(struct
> kobject *a, struct attribute *b,
>                                                 &dbs_info->cdbs.prev_cpu_wall);
>                 if (cs_tuners.ignore_nice)
>                         dbs_info->cdbs.prev_cpu_nice =
> -                               kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> +                               kcpustat_cpu_get(j, CPUTIME_NICE);
>         }
>         return count;
>  }

Thanks, I missed that one.  I've added it in locally.

Kevin
