Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041Ab3DIRCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:02:49 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54290 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3DIRCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:02:48 -0400
MIME-Version: 1.0
In-Reply-To: <51642BD5.4030803@ti.com>
References: <1365465287-24530-1-git-send-email-abrestic@chromium.org>
	<51642BD5.4030803@ti.com>
Date: Tue, 9 Apr 2013 10:02:47 -0700
Message-ID: <CAL1qeaGW=m+DNbGhEzTJBDt1NNpPrVcBzzWzhk447hf2tyb2fw@mail.gmail.com>
Subject: Re: [PATCH] thermal: fix frequency table lookup bugs
From: Andrew Bresticker <abrestic@google.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Andrew Bresticker <abrestic@chromium.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Tue, Apr 9, 2013 at 7:55 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> Hi Andrew,
>
>
> On 08-04-2013 19:54, Andrew Bresticker wrote:
>>
>> The loops which are used to perform lookups in CPU frequency tables in
>> cpu_cooling and the Exynos thermal driver do not update the loop counter
>> if they encounter an invalid table entry, leading to an infinite loop in
>> that case.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>   drivers/thermal/cpu_cooling.c    | 19 ++++++++++---------
>>   drivers/thermal/exynos_thermal.c |  8 ++++----
>>   2 files changed, 14 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>> index 836828e..e6db441 100644
>> --- a/drivers/thermal/cpu_cooling.c
>> +++ b/drivers/thermal/cpu_cooling.c
>> @@ -124,14 +124,14 @@ static int is_cpufreq_valid(int cpu)
>>   static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long
>> level)
>>   {
>>         int ret = 0, i = 0;
>> -       unsigned long level_index;
>> +       unsigned long level_index = 0;
>>         bool descend = false;
>>         struct cpufreq_frequency_table *table =
>>                                         cpufreq_frequency_get_table(cpu);
>>         if (!table)
>>                 return ret;
>>
>> -       while (table[i].frequency != CPUFREQ_TABLE_END) {
>> +       for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>>                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>>                         continue;
>
> Wouldn't be easier to just increase the index i before doing a continue?

I think this is cleaner.  The code is iterating through an array -- it
should be a for loop.

>
>
>>
>> @@ -143,24 +143,25 @@ static unsigned int get_cpu_frequency(unsigned int
>> cpu, unsigned long level)
>>                 }
>>
>>                 /*return if level matched and table in descending order*/
>> -               if (descend && i == level)
>> +               if (descend && level_index == level)
>>                         return table[i].frequency;
>
>
> What this has to do with the patch description?

I'm using level_index as the counter of valid frequencies, where as i
is the index into the array.  If there are invalid entries, they are
not necessarily equal.  The point of this function is to find the
level-th *valid* frequency in the table.

> Besides why would you be comparing level against 0 all the time (you have
> initialized level_index to 0 at this point).

Huh? level_index is clearly incremented below...

>
>> -               i++;
>> +               level_index++;
>
>
> level_index wont be updated in case of INVALID entry.

That's the point.

>
>
>>         }
>>         i--;
>> +       level_index--;
>>
>> -       if (level > i || descend)
>> +       if (level > level_index || descend)
>>                 return ret;
>> -       level_index = i - level;
>> +       level = level_index - level;
>>
>>         /*Scan the table in reverse order and match the level*/
>> -       while (i >= 0) {
>> +       for (; i >= 0; i--) {
>>                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>>                         continue;
>>                 /*return if level matched*/
>> -               if (i == level_index)
>> +               if (level_index == level)
>>                         return table[i].frequency;
>> -               i--;
>> +               level_index--;
>>         }
>
>
> I believe you do more than what you have described in your intention under
> you patch description

I disagree.  I'm fixing the loop so that it properly handles invalid
entries and thus the infinite loop problem I mention in the commit
message.

> Can you please split your patch into smaller changes?

I don't think there is a need for separate patches to cpu_cooling.c.

>
>>         return ret;
>>   }
>> diff --git a/drivers/thermal/exynos_thermal.c
>> b/drivers/thermal/exynos_thermal.c
>> index d5e6267..524b2a0 100644
>> --- a/drivers/thermal/exynos_thermal.c
>> +++ b/drivers/thermal/exynos_thermal.c
>> @@ -237,7 +237,7 @@ static int exynos_get_crit_temp(struct
>> thermal_zone_device *thermal,
>>
>>   static int exynos_get_frequency_level(unsigned int cpu, unsigned int
>> freq)
>>   {
>> -       int i = 0, ret = -EINVAL;
>> +       int i, level = 0, ret = -EINVAL;
>>         struct cpufreq_frequency_table *table = NULL;
>>   #ifdef CONFIG_CPU_FREQ
>>         table = cpufreq_frequency_get_table(cpu);
>> @@ -245,12 +245,12 @@ static int exynos_get_frequency_level(unsigned int
>> cpu, unsigned int freq)
>>         if (!table)
>>                 return ret;
>>
>> -       while (table[i].frequency != CPUFREQ_TABLE_END) {
>> +       for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>>                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>>                         continue;
>>                 if (table[i].frequency == freq)
>> -                       return i;
>> -               i++;
>> +                       return level;
>> +               level++;
>
>
> Can you please send a separate patch on this driver instead?

Sure.

>
>
>
>>         }
>>         return ret;
>>   }
>>
>

Thanks,
Andrew
