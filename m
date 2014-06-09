Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaFIIcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:32:53 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64777 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682AbaFIIcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <53955CE0.1090408@linux.vnet.ibm.com>
References: <d4241c6ef57c901dde270380cce74e24effa4852.1402291351.git.viresh.kumar@linaro.org>
	<53955CE0.1090408@linux.vnet.ibm.com>
Date: Mon, 9 Jun 2014 14:02:44 +0530
Message-ID: <CAKohpo=jkznKBhQOkv8F+aa9kVAVk2zd9gaf1XsMJtwQ+DzPDw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governor: remove copy_prev_load from 'struct cpu_dbs_common_info'
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 June 2014 12:36, Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 06/09/2014 10:54 AM, Viresh Kumar wrote:

> Well, to be honest, I'm not a great fan of writing tricky code (i.e.,
> overloading multiple semantics onto one single thing). However, in this case,

I am somewhat, but it shouldn't be confusing at all. Here the same variable
can be used without changing its meaning and that's why I did it :)

> it does save a bool for every CPU in the system, and this savings might be
> worthwhile on some systems.
>
> Perhaps you should also mention in the changelog that the true load can also
> turn out to be zero during long idle intervals (and hence the actual value of
> 'prev_load' and the overloaded value can clash). However this is not a problem
> because, if the true load was really zero in the previous interval, it makes
> more sense to evaluate the load afresh for the current interval rather than
> copying the previous load.

Hmm.

>> There is another change here which was probably missed by Srivatsa during the
>> last version of updates he made. The unlikely in the 'if' statement was covering
>> only half of the condition and the whole line should actually come under it.
>>
>
> Well, I had thought about that too, but I felt that the second AND condition
> was actually not that infrequent when compared to the first AND condition. And
> the C language already guarantees that the second part won't be evaluated if
> the first one turns out to be false. So I thought of making use of that and
> hence wrapped only the first part within unlikely(), so that we can just
> evaluate a subset of the 'if' condition most of the time.

I am not a compiler expert but that sounds confusing :(, not sure.

This looks wrong: "so that we can just evaluate a subset of the 'if'
condition most
of the time"..

It doesn't matter what we got into the unlikely() block, C will work the way it
is supposed to. And we will evaluate only the first one here if it fails.

AFAIK, unlikely() is just a compiler flag and doesn't have anything to do with
how code is going to execute.

The only use of unlikely() is to avoid branches (Which will also mean avoid
pipeline flushes and better performance). So, with only half of the expression
in unlikely there are still some chances that we will do a branch to reach the
else block and as that's the most common case overall performance will get
hit..

And so we *must* get complete expression inside unlikely() ..

> But anyway, your
> version looks good too, so I don't mind.

:)

>> Also checkpatch is made more silent as it was reporting this (--strict option):
>>
>> CHECK: Alignment should match open parenthesis
>> +             if (unlikely(wall_time > (2 * sampling_rate) &&
>> +                                             j_cdbs->prev_load)) {
>
> Sure, this one is a welcome cleanup, thanks!

:)

>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/cpufreq/cpufreq_governor.c | 13 ++++++++-----
>>  drivers/cpufreq/cpufreq_governor.h |  8 ++++----
>>  2 files changed, 12 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index 9004450..a1ad804 100644
>> --- a/drivers/cpufreq/cpufreq_governor.c
>> +++ b/drivers/cpufreq/cpufreq_governor.c
>> @@ -132,14 +132,18 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>                * an unusually large 'wall_time' (as compared to the sampling
>>                * rate) indicates this scenario.
>>                */
>> -             if (unlikely(wall_time > (2 * sampling_rate)) &&
>> -                                             j_cdbs->copy_prev_load) {
>> +             if (unlikely(wall_time > (2 * sampling_rate) &&
>> +                          j_cdbs->prev_load)) {
>>                       load = j_cdbs->prev_load;
>> -                     j_cdbs->copy_prev_load = false;
>> +
>> +                     /*
>> +                      * Ensure that we copy the previous load only once, upon
>> +                      * the first wake-up from idle.
>> +                      */
>
> Can you also add the term 'destructive copy' to the comment, while you are at it?
> Because, that term (which means that we destroy the source during a copy) explains
> the situation very aptly. Something like this:
>
> Perform a destructive copy, to ensure that we copy the previous load only once,
> upon the first wake-up from idle.

ok.

>> +                     j_cdbs->prev_load = 0;
>>               } else {
>>                       load = 100 * (wall_time - idle_time) / wall_time;
>>                       j_cdbs->prev_load = load;
>> -                     j_cdbs->copy_prev_load = true;
>>               }
>>
>>               if (load > max_load)
>> @@ -373,7 +377,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>>                               (j_cdbs->prev_cpu_wall - j_cdbs->prev_cpu_idle);
>>                       j_cdbs->prev_load = 100 * prev_load /
>>                                       (unsigned int) j_cdbs->prev_cpu_wall;
>> -                     j_cdbs->copy_prev_load = true;
>>
>>                       if (ignore_nice)
>>                               j_cdbs->prev_cpu_nice =
>> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
>> index c2a5b7e..d3082ee 100644
>> --- a/drivers/cpufreq/cpufreq_governor.h
>> +++ b/drivers/cpufreq/cpufreq_governor.h
>> @@ -134,12 +134,12 @@ struct cpu_dbs_common_info {
>>       u64 prev_cpu_idle;
>>       u64 prev_cpu_wall;
>>       u64 prev_cpu_nice;
>> -     unsigned int prev_load;
>>       /*
>> -      * Flag to ensure that we copy the previous load only once, upon the
>> -      * first wake-up from idle.
>> +      * Used to store system load before going into idle, when set to zero:
>> +      * used as a flag to ensure that we copy the previous load only once,
>> +      * upon the first wake-up from idle.
>
> Perhaps a bit of a touch-up to the comment would be worthwhile. Something
> like this:
>
> Used to keep track of the load in the previous interval. However, when
> explicitly set to zero, it is used as a flag to ensure that we copy the
> previous load to the current interval only once, upon the first wake-up
> from idle.

ok.
