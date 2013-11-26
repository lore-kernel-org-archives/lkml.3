Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3KZGO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:14:56 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:58875 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3KZGOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:14:52 -0500
Message-ID: <52943C55.5010503@linaro.org>
Date: Tue, 26 Nov 2013 11:44:45 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH V2] cpufreq: Make sure CPU is running on a freq from freq-table
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org>	<CAKohpok0QJ2xP5uoSaAsX76KwD5yi9Z54pgNyQ7CW3c4Fkbq2A@mail.gmail.com>	<52938C5F.7000307@gmail.com>	<2997050.eogEtPXZyL@vostro.rjw.lan> <CAKohpon22PxGdTFcaOqzpLpVZd75OPP470Wyy95GjBhG2gViyQ@mail.gmail.com>
In-Reply-To: <CAKohpon22PxGdTFcaOqzpLpVZd75OPP470Wyy95GjBhG2gViyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 November 2013 07:31 AM, Viresh Kumar wrote:
> Probably just throw an print message that CPU found to be running on
> out of table frequency, and that got fixed..

And here is the patch to test:

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 18 Nov 2013 10:15:50 +0530
Subject: [PATCH] cpufreq: Make sure CPU is running on a freq from freq-table

Sometimes boot loaders set CPU frequency to a value outside of frequency table
present with cpufreq core. In such cases CPU might be unstable if it has to run
on that frequency for long duration of time and so its better to set it to a
frequency which is specified in freq-table. This also makes cpufreq stats
inconsistent as cpufreq-stats would fail to register because current frequency
of CPU isn't found in freq-table.

Because we don't want this change to effect boot process badly, we go for the
next freq which is >= policy->cur ('cur' must be set by now, otherwise we will
end up setting freq to lowest of the table as 'cur' is initialized to zero).

In case current frequency doesn't match any frequency from freq-table, we throw
warnings to user, so that user can get this fixed in their bootloaders or
freq-tables.

Reported-by: Carlos Hernandez <ceh@ti.com>
Reported-and-tested-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c    | 37 +++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/freq_table.c | 24 ++++++++++++++++++++++++
 include/linux/cpufreq.h      |  2 ++
 3 files changed, 63 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 02d534d..5beb16d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1038,6 +1038,43 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		}
 	}

+	/*
+	 * Sometimes boot loaders set CPU frequency to a value outside of
+	 * frequency table present with cpufreq core. In such cases CPU might be
+	 * unstable if it has to run on that frequency for long duration of time
+	 * and so its better to set it to a frequency which is specified in
+	 * freq-table. This also makes cpufreq stats inconsistent as
+	 * cpufreq-stats would fail to register because current frequency of CPU
+	 * isn't found in freq-table.
+	 *
+	 * Because we don't want this change to effect boot process badly, we go
+	 * for the next freq which is >= policy->cur ('cur' must be set by now,
+	 * otherwise we will end up setting freq to lowest of the table as 'cur'
+	 * is initialized to zero).
+	 *
+	 * We are passing target-freq as "policy->cur - 1" otherwise
+	 * __cpufreq_driver_target() would simply fail, as policy->cur will be
+	 * equal to target-freq.
+	 */
+	if (has_target()) {
+		/* Are we running at unknown frequency ? */
+		ret = cpufreq_frequency_table_get_index(policy, policy->cur);
+		if (ret == -EINVAL) {
+			/* Warn user and fix it */
+			pr_warn("%s: CPU%d: running at invalid freq: %u KHz\n",
+					__func__, policy->cpu, policy->cur);
+			ret = __cpufreq_driver_target(policy, policy->cur - 1,
+					CPUFREQ_RELATION_L);
+			if (ret) {
+				pr_err("%s: Unable to set frequency from table: %d\n",
+						__func__, ret);
+				goto err_out_unregister;
+			}
+			pr_warn("%s: CPU%d: frequency changed to: %u KHz\n",
+					__func__, policy->cpu, policy->cur);
+		}
+	}
+
 	/* related cpus should atleast have policy->cpus */
 	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 3458d27..0d6cc0e 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -178,7 +178,31 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);

+int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
+		unsigned int freq)
+{
+	struct cpufreq_frequency_table *table;
+	int index = -EINVAL, i = 0;
+
+	table = cpufreq_frequency_get_table(policy->cpu);
+	if (unlikely(!table)) {
+		pr_debug("%s: Unable to find freq_table\n", __func__);
+		return -ENOENT;
+	}
+
+	for (; table[i].frequency != CPUFREQ_TABLE_END; i++) {
+		if (table[i].frequency == freq) {
+			index = i;
+			break;
+		}
+	}
+
+	return index;
+}
+EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_index);
+
 static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
+
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index dc196bb..71646ce 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -439,6 +439,8 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int target_freq,
 				   unsigned int relation,
 				   unsigned int *index);
+int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
+		unsigned int freq);

 void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);
 ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);
-- 
1.7.12.rc2.18.g61b472e


