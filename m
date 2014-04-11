Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaDKEYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:24:23 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:37435 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaDKEYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <534714D0.2010803@semaphore.gr>
References: <534714D0.2010803@semaphore.gr>
Date: Fri, 11 Apr 2014 09:54:20 +0530
Message-ID: <CAKohpo=u9hHtp94A_KLKupi9de+eZYCWQfEdUV-NS+iryH-gHw@mail.gmail.com>
Subject: Re: [RFC PATCH] cpufreq: Introduce macros for cpufreq_frequency_table iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org >> LKML" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 April 2014 03:31, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> This patch intoduces 2 macros which can be used for iteration
> over cpufreq_frequency_table:
>
> - cpufreq_for_each_entry: iterate over each entry of the table
> - cpufreq_for_each_valid_entry: iterate over each entry of the
> table that contains a valid frequency.
>
> It should have no functional changes.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>
> I found about 20 occurrences in various drivers that these macros
> can be used. I will proceed with the necessary changes if you
> approve something like this.
>
> Thanks in advance for your time,

Thanks for your time and I find it useful enough. So its a yes from
me :)

But, have you tested this yet?

> Stratos Karafotis.
> ---
>
>  drivers/cpufreq/freq_table.c | 54 ++++++++++++++++++++------------------------
>  include/linux/cpufreq.h      | 29 ++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
> index 08e7bbc..19bf0c4 100644
> --- a/drivers/cpufreq/freq_table.c
> +++ b/drivers/cpufreq/freq_table.c
> @@ -21,22 +21,18 @@
>  int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
>                                     struct cpufreq_frequency_table *table)
>  {
> +       struct cpufreq_frequency_table *pos;
>         unsigned int min_freq = ~0;
>         unsigned int max_freq = 0;
> -       unsigned int i;
>
> -       for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
> -               unsigned int freq = table[i].frequency;
> -               if (freq == CPUFREQ_ENTRY_INVALID) {
> -                       pr_debug("table entry %u is invalid, skipping\n", i);
> +       cpufreq_for_each_valid_entry(pos, table) {
> +               unsigned int freq = pos->frequency;

move the definition part to the top of this routine, we don't need
to create freq for every iteration here. It was bad earlier as well :)

>
> -                       continue;
> -               }
>                 if (!cpufreq_boost_enabled()
> -                   && (table[i].flags & CPUFREQ_BOOST_FREQ))
> +                   && (pos->flags & CPUFREQ_BOOST_FREQ))
>                         continue;
>
> -               pr_debug("table entry %u: %u kHz\n", i, freq);
> +               pr_debug("table entry %lu: %u kHz\n", pos - table, freq);
>                 if (freq < min_freq)
>                         min_freq = freq;
>                 if (freq > max_freq)
> @@ -57,7 +53,8 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_cpuinfo);
>  int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
>                                    struct cpufreq_frequency_table *table)
>  {
> -       unsigned int next_larger = ~0, freq, i = 0;
> +       struct cpufreq_frequency_table *pos;
> +       unsigned int next_larger = ~0, freq;
>         bool found = false;
>
>         pr_debug("request for verification of policy (%u - %u kHz) for cpu %u\n",
> @@ -65,9 +62,9 @@ int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
>
>         cpufreq_verify_within_cpu_limits(policy);
>
> -       for (; freq = table[i].frequency, freq != CPUFREQ_TABLE_END; i++) {
> -               if (freq == CPUFREQ_ENTRY_INVALID)
> -                       continue;
> +       cpufreq_for_each_valid_entry(pos, table) {
> +               freq = pos->frequency;
> +
>                 if ((freq >= policy->min) && (freq <= policy->max)) {
>                         found = true;
>                         break;
> @@ -118,7 +115,8 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
>                 .driver_data = ~0,
>                 .frequency = 0,
>         };
> -       unsigned int i;
> +       struct cpufreq_frequency_table *pos;
> +       unsigned int i = 0;
>
>         pr_debug("request for target %u kHz (relation: %u) for cpu %u\n",
>                                         target_freq, relation, policy->cpu);
> @@ -132,10 +130,10 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
>                 break;
>         }
>
> -       for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
> -               unsigned int freq = table[i].frequency;
> -               if (freq == CPUFREQ_ENTRY_INVALID)
> -                       continue;
> +       cpufreq_for_each_valid_entry(pos, table) {
> +               unsigned int freq = pos->frequency;

same here.

> +
> +               i = pos - table;
>                 if ((freq < policy->min) || (freq > policy->max))
>                         continue;
>                 switch (relation) {
> @@ -184,8 +182,7 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
>  int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
>                 unsigned int freq)
>  {
> -       struct cpufreq_frequency_table *table;
> -       int i;
> +       struct cpufreq_frequency_table *pos, *table;
>
>         table = cpufreq_frequency_get_table(policy->cpu);
>         if (unlikely(!table)) {
> @@ -193,9 +190,9 @@ int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
>                 return -ENOENT;
>         }
>
> -       for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
> -               if (table[i].frequency == freq)
> -                       return i;
> +       cpufreq_for_each_entry(pos, table) {

use cpufreq_for_each_valid_entry() here as well.

> +               if (pos->frequency == freq)
> +                       return pos - table;
>         }
>
>         return -EINVAL;
> @@ -208,16 +205,13 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_index);
>  static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
>                                     bool show_boost)
>  {
> -       unsigned int i = 0;
>         ssize_t count = 0;
> -       struct cpufreq_frequency_table *table = policy->freq_table;
> +       struct cpufreq_frequency_table *pos, *table = policy->freq_table;
>
>         if (!table)
>                 return -ENODEV;
>
> -       for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
> -               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
> -                       continue;
> +       cpufreq_for_each_valid_entry(pos, table) {
>                 /*
>                  * show_boost = true and driver_data = BOOST freq
>                  * display BOOST freqs
> @@ -229,10 +223,10 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
>                  * show_boost = false and driver_data != BOOST freq
>                  * display NON BOOST freqs
>                  */
> -               if (show_boost ^ (table[i].flags & CPUFREQ_BOOST_FREQ))
> +               if (show_boost ^ (pos->flags & CPUFREQ_BOOST_FREQ))
>                         continue;
>
> -               count += sprintf(&buf[count], "%d ", table[i].frequency);
> +               count += sprintf(&buf[count], "%d ", pos->frequency);
>         }
>         count += sprintf(&buf[count], "\n");
>
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 5ae5100..1c221c8 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -468,6 +468,35 @@ struct cpufreq_frequency_table {
>                                     * order */
>  };
>
> +static inline bool validate_entry(struct cpufreq_frequency_table *pos)
> +{
> +       while (pos->frequency != CPUFREQ_TABLE_END)
> +               if (pos->frequency == CPUFREQ_ENTRY_INVALID)
> +                       pos++;

This is why I asked you if you have tested it or not.

pos is a local variable here and so pos++ wouldn't reflect in the parent
function. But your code will still work as we will check again for the next
INVALID frequency.

Another important thing: This routine is going to be used from a Macro
and so making it inline is very *inefficient*. We are going to use it from
Atleast 20-25 places (as you mentioned) and we definitely aren't looking
to have so many copies of this one :)

So, you should move this to cpufreq.c

> +               else
> +                       return true;
> +       return false;
> +}
> +
> +/*
> + * cpufreq_for_each_entry -    iterate over a cpufreq_frequency_table
> + * @pos:       the cpufreq_frequency_table * to use as a loop cursor.
> + * @table:     the cpufreq_frequency_table * to iterate over.
> + */
> +
> +#define cpufreq_for_each_entry(pos, table)     \
> +       for (pos = table; pos->frequency != CPUFREQ_TABLE_END; pos++)
> +
> +/*
> + * cpufreq_for_each_valid_entry -     iterate over a cpufreq_frequency_table
> + *     exluding CPUFREQ_ENTRY_INVALID frequencies.
> + * @pos:        the cpufreq_frequency_table * to use as a loop cursor.
> + * @table:      the cpufreq_frequency_table * to iterate over.
> + */
> +
> +#define cpufreq_for_each_valid_entry(pos, table)       \
> +       for (pos = table; validate_entry(pos); pos++)
> +
>  int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
>                                     struct cpufreq_frequency_table *table);

Otherwise looks fine. Please update all drivers as well :)
