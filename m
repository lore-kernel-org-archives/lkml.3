Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaDNVIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:08:32 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54722 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750993AbaDNVI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:08:26 -0400
Message-ID: <534C4E48.9080601@semaphore.gr>
Date: Tue, 15 Apr 2014 00:08:24 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/20] cpufreq: stats: Use cpufreq_for_each_valid_entry macro
 for iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core supports the cpufreq_for_each_valid_entry macro
helper for iteration over the cpufreq_frequency_table, so use it.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_stats.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index ecaaebf..223078d 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -182,11 +182,11 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 
 static int __cpufreq_stats_create_table(struct cpufreq_policy *policy)
 {
-	unsigned int i, j, count = 0, ret = 0;
+	unsigned int i, count = 0, ret = 0;
 	struct cpufreq_stats *stat;
 	unsigned int alloc_size;
 	unsigned int cpu = policy->cpu;
-	struct cpufreq_frequency_table *table;
+	struct cpufreq_frequency_table *pos, *table;
 
 	table = cpufreq_frequency_get_table(cpu);
 	if (unlikely(!table))
@@ -205,10 +205,7 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy)
 	stat->cpu = cpu;
 	per_cpu(cpufreq_stats_table, cpu) = stat;
 
-	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		unsigned int freq = table[i].frequency;
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, table) {
 		count++;
 	}
 
@@ -228,15 +225,12 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy)
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	stat->trans_table = stat->freq_table + count;
 #endif
-	j = 0;
-	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		unsigned int freq = table[i].frequency;
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
-		if (freq_table_get_index(stat, freq) == -1)
-			stat->freq_table[j++] = freq;
+	i = 0;
+	cpufreq_for_each_valid_entry(pos, table) {
+		if (freq_table_get_index(stat, pos->frequency) == -1)
+			stat->freq_table[i++] = pos->frequency;
 	}
-	stat->state_num = j;
+	stat->state_num = i;
 	spin_lock(&cpufreq_stats_lock);
 	stat->last_time = get_jiffies_64();
 	stat->last_index = freq_table_get_index(stat, policy->cur);
-- 
1.9.0
