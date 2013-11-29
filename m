Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3K2OOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:14:34 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33419 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3K2OOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:14:30 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, ceh@ti.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 2/2] cpufreq: Make sure CPU is running on a freq from freq-table
Date: Fri, 29 Nov 2013 19:44:15 +0530
Message-Id: <f776111b2ebf2a0acc7b6027cedc460e4817092f.1385734305.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <0875dc1b263f39081232c560fc72c15cd42dfc6f.1385734305.git.viresh.kumar@linaro.org>
References: <0875dc1b263f39081232c560fc72c15cd42dfc6f.1385734305.git.viresh.kumar@linaro.org>
In-Reply-To: <0875dc1b263f39081232c560fc72c15cd42dfc6f.1385734305.git.viresh.kumar@linaro.org>
References: <0875dc1b263f39081232c560fc72c15cd42dfc6f.1385734305.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/cpufreq/cpufreq.c    | 40 ++++++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/freq_table.c | 22 ++++++++++++++++++++++
 include/linux/cpufreq.h      |  2 ++
 3 files changed, 64 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 606224a..f13320a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1042,6 +1042,46 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
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
+	if (!(cpufreq_driver->flags & CPUFREQ_SKIP_INITIAL_FREQ_CHECK)
+	    && has_target()) {
+		/* Are we running at unknown frequency ? */
+		ret = cpufreq_frequency_table_get_index(policy, policy->cur);
+		if (ret == -EINVAL) {
+			/* Warn user and fix it */
+			pr_warn("%s: CPU%d: Running at unlisted freq: %u KHz\n",
+				__func__, policy->cpu, policy->cur);
+			ret = __cpufreq_driver_target(policy, policy->cur - 1,
+				CPUFREQ_RELATION_L);
+
+			/*
+			 * Reaching here after boot in a few seconds may not
+			 * mean that system will remain stable at "unknown"
+			 * frequency for longer duration. Hence, a BUG_ON().
+			 */
+			BUG_ON(ret);
+			pr_warn("%s: CPU%d: Unlisted initial frequency changed to: %u KHz\n",
+				__func__, policy->cpu, policy->cur);
+		}
+	}
+
 	/* related cpus should atleast have policy->cpus */
 	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
 
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 3458d27..a8ac042 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -178,7 +178,29 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
 
+int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
+		unsigned int freq)
+{
+	struct cpufreq_frequency_table *table;
+	int i;
+
+	table = cpufreq_frequency_get_table(policy->cpu);
+	if (unlikely(!table)) {
+		pr_debug("%s: Unable to find frequency table\n", __func__);
+		return -ENOENT;
+	}
+
+	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
+		if (table[i].frequency == freq)
+			return i;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_index);
+
 static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
+
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 13b8802..03174ab 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -456,6 +456,8 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int target_freq,
 				   unsigned int relation,
 				   unsigned int *index);
+int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
+		unsigned int freq);
 
 void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);
 ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);
-- 
1.7.12.rc2.18.g61b472e

