Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab3BERz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:55:26 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37611 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3BERzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:55:24 -0500
MIME-Version: 1.0
In-Reply-To: <1360058399.2216.7.camel@rzhang1-mobl4>
References: <1359041045-24341-1-git-send-email-gu1@aeroxteam.fr>
	<1359705569.2241.107.camel@rzhang1-mobl4>
	<CADGdYn4iw3X-+LrYgqYQgVpXiCUnBAK7x8VM2M9G5bLULV+3nQ@mail.gmail.com>
	<1360058399.2216.7.camel@rzhang1-mobl4>
Date: Tue, 5 Feb 2013 09:55:23 -0800
X-Google-Sender-Auth: lHowAvwvWpqAdCvOuDZa6NrGO4U
Message-ID: <CADGdYn7jM4zcW3K6XFE3xm5Wu2dLji89b8cvSii2PAD-fAX4EA@mail.gmail.com>
Subject: Re: [PATCH] Thermal: fix iteration over CPU frequency list
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Gu1 <gu1@aeroxteam.fr>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 1:59 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> On Mon, 2013-02-04 at 11:49 -0800, amit daniel kachhap wrote:
>> On Thu, Jan 31, 2013 at 11:59 PM, Zhang Rui <rui.zhang@intel.com> wrote:
>> > On Thu, 2013-01-24 at 16:24 +0100, Gu1 wrote:
>> >> In different places in the Thermal code, the CPU frequency list is iterated
>> >> in an incorrect way, leading to endless loops when the frequency list contains
>> >> a CPUFREQ_TABLE_INVALID entry, which is the case by default in the the Exynos
>> >> 4x12 cpufreq driver, for example.
>> >>
>> >> The frequency list is iterated with a while loop, and when a
>> >> CPUFREQ_TABLE_INVALID entry is encountered, the continue; statement is used to
>> >> skip it, but the index is not incremented, causing an endless loop.
>> >>
>> >> A similar bug was fixed by hongbo.zhang in commit:
>> >>   Thermal: fix bug of counting cpu frequencies
>> >>
>> >> Signed-off-by: Gu1 <gu1@aeroxteam.fr>
>> >> ---
>> >>  drivers/thermal/cpu_cooling.c    | 8 +++-----
>> >>  drivers/thermal/exynos_thermal.c | 9 +++++----
>> >>  2 files changed, 8 insertions(+), 9 deletions(-)
>> >>
>> >> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>> >> index 836828e..51acd26 100644
>> >> --- a/drivers/thermal/cpu_cooling.c
>> >> +++ b/drivers/thermal/cpu_cooling.c
>> >> @@ -123,7 +123,7 @@ static int is_cpufreq_valid(int cpu)
>> >>   */
>> >>  static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>> >>  {
>> >> -     int ret = 0, i = 0;
>> >> +     int ret = 0, i;
>> >>       unsigned long level_index;
>> >>       bool descend = false;
>> >>       struct cpufreq_frequency_table *table =
>> >> @@ -131,7 +131,7 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>> >>       if (!table)
>> >>               return ret;
>> >>
>> >> -     while (table[i].frequency != CPUFREQ_TABLE_END) {
>> >> +     for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>> >>               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> >>                       continue;
>> >>
>> >> @@ -145,7 +145,6 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>> >>               /*return if level matched and table in descending order*/
>> >>               if (descend && i == level)
>> >>                       return table[i].frequency;
>> >> -             i++;
>> >>       }
>> >>       i--;
>> >>
>> >> @@ -154,13 +153,12 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>> >>       level_index = i - level;
>> >>
>> >>       /*Scan the table in reverse order and match the level*/
>> >> -     while (i >= 0) {
>> >> +     for (; i >= 0; i--) {
>> >>               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> >>                       continue;
>> >>               /*return if level matched*/
>> >>               if (i == level_index)
>> >>                       return table[i].frequency;
>> >> -             i--;
>> >>       }
>> >>       return ret;
>> >>  }
>> >
>> > so the "level" parameter is the index in the frequency table, right?
>> >
>> >> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
>> >> index 224751e..fa9e1d7 100644
>> >> --- a/drivers/thermal/exynos_thermal.c
>> >> +++ b/drivers/thermal/exynos_thermal.c
>> >> @@ -233,7 +233,8 @@ static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>> >>
>> >>  static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>> >>  {
>> >> -     int i = 0, ret = -EINVAL;
>> >> +     int i, ret = -EINVAL;
>> >> +     unsigned int count = 0;
>> >>       struct cpufreq_frequency_table *table = NULL;
>> >>  #ifdef CONFIG_CPU_FREQ
>> >>       table = cpufreq_frequency_get_table(cpu);
>> >> @@ -241,12 +242,12 @@ static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>> >>       if (!table)
>> >>               return ret;
>> >>
>> >> -     while (table[i].frequency != CPUFREQ_TABLE_END) {
>> >> +     for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>> >>               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> >>                       continue;
>> >>               if (table[i].frequency == freq)
>> >> -                     return i;
>> >> -             i++;
>> >> +                     return count;
>> >> +             count++;
>> >>       }
>> >>       return ret;
>> >>  }
>> >
>> > but we ignore the invalid entry here.
>> >
>> > take the following cpufreq table for example, with your patch,
>> > entry  frequency
>> >  0     2.4G
>> >  1     invalid
>> >  2     2G
>> >  3     invalid
>> >  4     1.6G
>> >  5     end
>> >
>> > in exynos_get_frequency_level(), freq 1.6G is translated to level 2,
>> > because count is increased only twice, for entry 0 and entry 2, right?
>>
>> Hi Rui,
>>
>> Gui fixes looks fine for infinite loop issue. After Gui's fixes 1.6G
>> in translated to level 4 which is fine.
>>
>> Thanks,
>> Amit Daniel
>>
>> >
>> > but then, in get_cpu_frequency(), level 2 is translated to 2G HZ, which
>> > I do not think is what we want.
>> >
>> > I think we are doing something wrong here, and here is a cleanup patch I made
>> > to fix this issue, please review.
>> >
>> > From a868d68fdcd94a29ac9d3998283119a453decb4b Mon Sep 17 00:00:00 2001
>> > From: Zhang Rui <rui.zhang@intel.com>
>> > Date: Fri, 1 Feb 2013 15:41:47 +0800
>> > Subject: [PATCH] Thermal cpu_cooling: fix inconsistent use of CPU frequency
>> >  table
>> >
>> > there are three kinds of entries in CPU frequency table.
>> > 1. invalid entry, its frequency is CPUFREQ_ENTRY_INVALID.
>> > 2. duplicate entry, two entry may share the same frequency,
>> >    And we should treat it as on valid entry.
>> > 3. valid entry with a proper frequency.
>> >
>> > And when talking about cpufreq cooling device cooling state,
>> > it should be the same thing, in both cpu_cooling.c and its users,
>> > AKA, max_cooling_state of a cpufreq cooling device equals the
>> > number of VALID entries (type #3 above) in CPU frequency table.
>> > And when setting a cpufreq cooling device to state X, it means set
>> > the cpufreq cooling device to Xth maximum frequency in the
>> > cpufreq frequency table.
>> >
>> > This patch does a cleanup in both drivers/thermal/cpu_cooling.c
>> > and drivers/thermal/exynos_thermal.c to make them be consistent
>> > in using cpu level/cpufreq cooling state.
>> >
>> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>> > ---
>> >  drivers/thermal/cpu_cooling.c    |  122 ++++++++++++++++++++++++--------------
>> >  drivers/thermal/exynos_thermal.c |   17 +-----
>> >  include/linux/cpu_cooling.h      |   12 ++++
>> >  3 files changed, 91 insertions(+), 60 deletions(-)
>> >
>> > diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>> > index 836828e..c16795b 100644
>> > --- a/drivers/thermal/cpu_cooling.c
>> > +++ b/drivers/thermal/cpu_cooling.c
>> > @@ -116,6 +116,40 @@ static int is_cpufreq_valid(int cpu)
>> >  }
>> >
>> >  /**
>> > + * cpufreq_cooling_get_max_level - function to get max valid cpufreq levels
>> > + * @cpu: cpu for which frequency is fetched.
>> > + */
>> > +int cpufreq_cooling_get_max_level(unsigned int cpu)
>> > +{
>> > +       int i, level;
>> > +       unsigned int freq = CPUFREQ_ENTRY_INVALID;
>> > +       struct cpufreq_frequency_table *table =
>> > +                                       cpufreq_frequency_get_table(cpu);
>> > +
>> > +       if (!table)
>> > +               return -EINVAL;
>> > +
>> > +       for (i = 0, level = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>> > +               /* Invalid entry */
>> > +               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> > +                       continue;
>> > +
>> > +               /* Duplicate entry */
>> > +               if (freq == table[i].frequency)
>> > +                       continue;
>> > +
>> > +               /* First valid entry */
>> > +               if (freq == CPUFREQ_ENTRY_INVALID)
>> > +                       freq = table[i].frequency;
>> > +
>> > +               level++;
>> > +       }
>> > +
>> > +       return level;
>> > +}
>> > +EXPORT_SYMBOL(cpufreq_cooling_get_max_level);
>> > +
>> > +/**
>> >   * get_cpu_frequency - get the absolute value of frequency from level.
>> >   * @cpu: cpu for which frequency is fetched.
>> >   * @level: level of frequency of the CPU
>
> I have a question about this comment.
> it says that.
>  * @level: level of frequency of the CPU
>  *      e.g level=1 --> 1st MAX FREQ, LEVEL=2 ---> 2nd MAX
> FREQ, ....etc"
> I think this is wrong because level equals cooling state, which starts
> from 0, rather than 1.
> IMO, it should be "level (cooling state) = 0 --> 1st MAX FREQ".
> what do you think?

Yes the comments are not correct. level 0 means 1st max freq.

Thanks,
Amit Daniel
>
>> > @@ -123,46 +157,58 @@ static int is_cpufreq_valid(int cpu)
>> >   */
>> >  static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>> >  {
>> > -       int ret = 0, i = 0;
>> > -       unsigned long level_index;
>> > +       int i, count;
>> > +       int max_level;
>> > +       unsigned int freq = CPUFREQ_ENTRY_INVALID;
>> >         bool descend = false;
>> >         struct cpufreq_frequency_table *table =
>> >                                         cpufreq_frequency_get_table(cpu);
>> > -       if (!table)
>> > -               return ret;
>> >
>> > -       while (table[i].frequency != CPUFREQ_TABLE_END) {
>> > +       max_level = cpufreq_cooling_get_max_level(cpu);
>> > +
>> > +       if (max_level < 0)
>> > +               return max_level;
>> > +
>> > +       if (level > max_level)
>> > +               return -EINVAL;
>> > +
>> > +       for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>> >                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> >                         continue;
>> >
>> > -               /*check if table in ascending or descending order*/
>> > -               if ((table[i + 1].frequency != CPUFREQ_TABLE_END) &&
>> > -                       (table[i + 1].frequency < table[i].frequency)
>> > -                       && !descend) {
>> > -                       descend = true;
>> > +               if (freq == CPUFREQ_ENTRY_INVALID)
>> > +                       /* first valid entry */
>> > +                       freq = table[i].frequency;
>> > +               else if (freq == table[i].frequency)
>> > +                       /* duplicate entry */
>> > +                       continue;
>> > +               else {
>> > +                       /* two valid entries, check frequency order */
>> > +                       descend = !!(freq > table[i].frequency);
>> > +                       break;
>> >                 }
>> > -
>> > -               /*return if level matched and table in descending order*/
>> > -               if (descend && i == level)
>> > -                       return table[i].frequency;
>> > -               i++;
>> >         }
>> > -       i--;
>> >
>> > -       if (level > i || descend)
>> > -               return ret;
>> > -       level_index = i - level;
>> > +       /* level equals "the index of valid entries" in cpufreq table */
>> > +       level = descend ? level : max_level - level + 1;
>> >
>> > -       /*Scan the table in reverse order and match the level*/
>> > -       while (i >= 0) {
>> > +       freq = CPUFREQ_ENTRY_INVALID;
>> > +       for (i = 0, count = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>> > +               /* ignore invalid entry */
>> >                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> >                         continue;
>> > -               /*return if level matched*/
>> > -               if (i == level_index)
>> > +
>> > +               if (freq == CPUFREQ_ENTRY_INVALID)
>> > +                       /* first valid entry */
>> > +                       freq = table[i].frequency;
>> > +               else if (freq == table[i].frequency)
>> > +                       /* ignore duplicate entry */
>> > +                       continue;
>> > +               count++;
>> > +               if (level == count)
>> >                         return table[i].frequency;
>> > -               i--;
>> >         }
>> > -       return ret;
>> > +       return -ENODEV;
>> >  }
>> >
>> >  /**
>> > @@ -244,29 +290,17 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>> >         struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
>> >         struct cpumask *maskPtr = &cpufreq_device->allowed_cpus;
>> >         unsigned int cpu;
>> > -       struct cpufreq_frequency_table *table;
>> > -       unsigned long count = 0;
>> > -       int i = 0;
>> > +       int max_level;
>> >
>> >         cpu = cpumask_any(maskPtr);
>> > -       table = cpufreq_frequency_get_table(cpu);
>> > -       if (!table) {
>> > -               *state = 0;
>> > -               return 0;
>> > -       }
>> > -
>> > -       for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
>> > -               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> > -                       continue;
>> > -               count++;
>> > -       }
>> >
>> > -       if (count > 0) {
>> > -               *state = --count;
>> > -               return 0;
>> > -       }
>> > +       max_level = cpufreq_cooling_get_max_level(cpu);
>> >
>> > -       return -EINVAL;
>> > +       if (max_level < 0)
>> > +               return max_level;
>> > +       else
>> > +               *state = max_level;
>> > +       return 0;
>> >  }
>> >
>> >  /**
>> > diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
>> > index cd71e24..5ac2de1 100644
>> > --- a/drivers/thermal/exynos_thermal.c
>> > +++ b/drivers/thermal/exynos_thermal.c
>> > @@ -241,22 +241,7 @@ static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>> >
>> >  static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
>> >  {
>> > -       int i = 0, ret = -EINVAL;
>> > -       struct cpufreq_frequency_table *table = NULL;
>> > -#ifdef CONFIG_CPU_FREQ
>> > -       table = cpufreq_frequency_get_table(cpu);
>> > -#endif
>> > -       if (!table)
>> > -               return ret;
>> > -
>> > -       while (table[i].frequency != CPUFREQ_TABLE_END) {
>> > -               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> > -                       continue;
>> > -               if (table[i].frequency == freq)
>> > -                       return i;
>> > -               i++;
>> > -       }
>> > -       return ret;
>> > +       return cpufreq_cooling_get_max_level(cpu);
>> This is not correct as it always gives the highest level.
>
> you are right. I'm proposing another patch.
>
> thanks,
> rui
>> >  }
>> >
>> >  /* Bind callback functions for thermal zone */
>> > diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
>> > index 40b4ef5..2de9319 100644
>> > --- a/include/linux/cpu_cooling.h
>> > +++ b/include/linux/cpu_cooling.h
>> > @@ -42,6 +42,14 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>> >   * @cdev: thermal cooling device pointer.
>> >   */
>> >  void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
>> > +
>> > +/**
>> > + * cpufreq_cooling_get_max_level - function to get maxinum cooling state
>> > + *                                of a cpufreq cooling device
>> > + * @cpu: cpu of which frequency is fetched.
>> > + */
>> > +int cpufreq_cooling_get_max_level(unsigned int cpu);
>> > +
>> >  #else /* !CONFIG_CPU_THERMAL */
>> >  static inline struct thermal_cooling_device *cpufreq_cooling_register(
>> >         const struct cpumask *clip_cpus)
>> > @@ -53,6 +61,10 @@ static inline void cpufreq_cooling_unregister(
>> >  {
>> >         return;
>> >  }
>> > +static inline int cpufreq_cooling_get_max_level(unsigned int cpu)
>> > +{
>> > +       return -ENODEV;
>> > +}
>> >  #endif /* CONFIG_CPU_THERMAL */
>> >
>> >  #endif /* __CPU_COOLING_H__ */
>> > --
>> > 1.7.9.5
>> >
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
