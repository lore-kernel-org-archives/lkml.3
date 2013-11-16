Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3KPFWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 00:22:37 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:34549 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3KPFWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 00:22:30 -0500
Message-ID: <5287010F.9000508@linaro.org>
Date: Sat, 16 Nov 2013 10:52:23 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Nishanth Menon <nm@ti.com>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ceh@ti.com,
        Tobias Diedrich <ranma+xen@tdiedrich.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] cpufreq: stats: Do not populate stats when policy->cur
 has no exact match
References: <1384561243-30391-1-git-send-email-nm@ti.com> <1423628.uM8DtnYzDe@vostro.rjw.lan>
In-Reply-To: <1423628.uM8DtnYzDe@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 November 2013 06:40 AM, Rafael J. Wysocki wrote:
> On Friday, November 15, 2013 06:20:43 PM Nishanth Menon wrote:

>> So, instead of having a statistics information that never ever
>> reflects valid data in the mentioned case and scratching our heads, we
>> instead, refuse to populate any of the statistics entries and note in
>> kernel log the error condition for developers to fix. The only useable

s/useable/usable

>> information are the available frequencies which is already available
>> in other cpufreq sysfs entries.

> I like this one.  Any objections from anyone?

Well nothing against the patch but I have other thoughts. There are platforms
which might have no choice of fixing this issue as their bootloaders might be
setting boot freq to any value outside of our freq table.

And those might not have a chance to fix that in driver as well in case they are
using something like cpufreq-cpu0..

So, eventually this patch wouldn't do anything except giving a boot time error
and not initializing any stats at all..

Wouldn't it be better to create another frequency in all these tables, which
will be an *Invalid* frequency.. With a value of -1 (i.e. largest value of an
unsigned int) ??

And so nobody will ever miss stats again, even if they are running on invalid
frequencies. We will capture that information too:
- we have moved from/to invalid frequency to/from a valid/invalid frequency this
much times.
- We have stayed at valid/invalid frequencies for this much time.

I have a untested patch for this. If this looks okay, Nishant can you please try
below patch? With some fixups from your side :)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 4cf0d28..0c551a6 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -145,10 +145,12 @@ static struct attribute_group stats_attr_group = {
 static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 {
        int index;
-       for (index = 0; index < stat->max_state; index++)
+       for (index = 0; index < stat->max_state - 1; index++)
                if (stat->freq_table[index] == freq)
                        return index;
-       return -1;
+
+       /* Last state is INVALID, to mark out of table frequency */
+       return stat->max_state - 1;
 }

 /* should be called late in the CPU removal sequence so that the stats
@@ -222,6 +224,9 @@ static int cpufreq_stats_create_table(struct cpufreq_policy
*policy,
                count++;
        }

+       /* An extra entry for Invalid frequencies */
+       count++;
+
        alloc_size = count * sizeof(int) + count * sizeof(u64);

 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
@@ -243,9 +248,13 @@ static int cpufreq_stats_create_table(struct cpufreq_policy
*policy,
                unsigned int freq = table[i].frequency;
                if (freq == CPUFREQ_ENTRY_INVALID)
                        continue;
-               if (freq_table_get_index(stat, freq) == -1)
+               if (freq_table_get_index(stat, freq) == stat->max_state - 1)
                        stat->freq_table[j++] = freq;
        }
+
+       /* Mark Invalid freq as max value to indicate Invalid freq */
+       stat->freq_table[j++] = -1;
+
        stat->state_num = j;
        spin_lock(&cpufreq_stats_lock);
        stat->last_time = get_jiffies_64();
@@ -315,10 +324,6 @@ static int cpufreq_stat_notifier_trans(struct
notifier_block *nb,
        old_index = stat->last_index;
        new_index = freq_table_get_index(stat, freq->new);

-       /* We can't do stat->time_in_state[-1]= .. */
-       if (old_index == -1 || new_index == -1)
-               return 0;
-
        cpufreq_stats_update(freq->cpu);

        if (old_index == new_index)


(@Rafael: Finally I have moved to thunderbird, found a way out, so no more
crappy attachments from me :))
