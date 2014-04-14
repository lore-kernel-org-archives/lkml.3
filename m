Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaDNVH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:07:59 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54711 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755124AbaDNVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:07:57 -0400
Message-ID: <534C4E29.2020605@semaphore.gr>
Date: Tue, 15 Apr 2014 00:07:53 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: [PATCH 01/20] cpufreq: Introduce macros for cpufreq_frequency_table
 iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most cpufreq drivers need to iterate over the cpufreq_frequency_table
for various tasks.

This patch introduces two macros which can be used for iteration over
cpufreq_frequency_table keeping a common coding style across drivers:

- cpufreq_for_each_entry: iterate over each entry of the table
- cpufreq_for_each_valid_entry: iterate over each entry that contains
a valid frequency.

Also, make changes in frequency table helper functions to use these
macros.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 Documentation/cpu-freq/cpu-drivers.txt | 16 ++++++++++
 drivers/cpufreq/cpufreq.c              | 11 +++++++
 drivers/cpufreq/freq_table.c           | 55 ++++++++++++++++------------------
 include/linux/cpufreq.h                | 21 +++++++++++++
 4 files changed, 73 insertions(+), 30 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index 48da5fd..f769f4c 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -228,3 +228,19 @@ is the corresponding frequency table helper for the ->target
 stage. Just pass the values to this function, and the unsigned int
 index returns the number of the frequency table entry which contains
 the frequency the CPU shall be set to.
+
+The following macros can be used as iterators over cpufreq_frequency_table:
+cpufreq_for_each_entry(pos, table) - iterates over all entries of frequency
+table.
+cpufreq-for_each_valid_entry(pos, table) - iterates over all entries,
+excluding CPUFREQ_ENTRY_INVALID frequencies.
+Use arguments "pos" - a cpufreq_frequency_table * as a loop cursor and
+"table" - the cpufreq_frequency_table * you want to iterate over.
+For example:
+
+	struct cpufreq_frequency_table *pos, *driver_freq_table;
+
+	cpufreq_for_each_entry(pos, driver_freq_table) {
+		/* Do something with pos */
+		pos->frequency = ...
+	}
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index abda660..a517da9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -237,6 +237,17 @@ void cpufreq_cpu_put(struct cpufreq_policy *policy)
 }
 EXPORT_SYMBOL_GPL(cpufreq_cpu_put);
 
+bool cpufreq_next_valid(struct cpufreq_frequency_table **pos)
+{
+	while ((*pos)->frequency != CPUFREQ_TABLE_END)
+		if ((*pos)->frequency != CPUFREQ_ENTRY_INVALID)
+			return true;
+		else
+			(*pos)++;
+	return false;
+}
+EXPORT_SYMBOL_GPL(cpufreq_next_valid);
+
 /*********************************************************************
  *            EXTERNALLY AFFECTING FREQUENCY CHANGES                 *
  *********************************************************************/
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 08e7bbc..47e0201 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -21,22 +21,19 @@
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 				    struct cpufreq_frequency_table *table)
 {
+	struct cpufreq_frequency_table *pos;
 	unsigned int min_freq = ~0;
 	unsigned int max_freq = 0;
-	unsigned int i;
+	unsigned int freq;
 
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		unsigned int freq = table[i].frequency;
-		if (freq == CPUFREQ_ENTRY_INVALID) {
-			pr_debug("table entry %u is invalid, skipping\n", i);
+	cpufreq_for_each_valid_entry(pos, table) {
+		freq = pos->frequency;
 
-			continue;
-		}
 		if (!cpufreq_boost_enabled()
-		    && (table[i].flags & CPUFREQ_BOOST_FREQ))
+		    && (pos->flags & CPUFREQ_BOOST_FREQ))
 			continue;
 
-		pr_debug("table entry %u: %u kHz\n", i, freq);
+		pr_debug("table entry %lu: %u kHz\n", pos - table, freq);
 		if (freq < min_freq)
 			min_freq = freq;
 		if (freq > max_freq)
@@ -57,7 +54,8 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_cpuinfo);
 int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 				   struct cpufreq_frequency_table *table)
 {
-	unsigned int next_larger = ~0, freq, i = 0;
+	struct cpufreq_frequency_table *pos;
+	unsigned int freq, next_larger = ~0;
 	bool found = false;
 
 	pr_debug("request for verification of policy (%u - %u kHz) for cpu %u\n",
@@ -65,9 +63,9 @@ int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 
 	cpufreq_verify_within_cpu_limits(policy);
 
-	for (; freq = table[i].frequency, freq != CPUFREQ_TABLE_END; i++) {
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, table) {
+		freq = pos->frequency;
+
 		if ((freq >= policy->min) && (freq <= policy->max)) {
 			found = true;
 			break;
@@ -118,7 +116,8 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		.driver_data = ~0,
 		.frequency = 0,
 	};
-	unsigned int i;
+	struct cpufreq_frequency_table *pos;
+	unsigned int freq, i = 0;
 
 	pr_debug("request for target %u kHz (relation: %u) for cpu %u\n",
 					target_freq, relation, policy->cpu);
@@ -132,10 +131,10 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		break;
 	}
 
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		unsigned int freq = table[i].frequency;
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, table) {
+		freq = pos->frequency;
+
+		i = pos - table;
 		if ((freq < policy->min) || (freq > policy->max))
 			continue;
 		switch (relation) {
@@ -184,8 +183,7 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
 int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
 		unsigned int freq)
 {
-	struct cpufreq_frequency_table *table;
-	int i;
+	struct cpufreq_frequency_table *pos, *table;
 
 	table = cpufreq_frequency_get_table(policy->cpu);
 	if (unlikely(!table)) {
@@ -193,9 +191,9 @@ int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
 		return -ENOENT;
 	}
 
-	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		if (table[i].frequency == freq)
-			return i;
+	cpufreq_for_each_entry(pos, table) {
+		if (pos->frequency == freq)
+			return pos - table;
 	}
 
 	return -EINVAL;
@@ -208,16 +206,13 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_index);
 static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
 				    bool show_boost)
 {
-	unsigned int i = 0;
 	ssize_t count = 0;
-	struct cpufreq_frequency_table *table = policy->freq_table;
+	struct cpufreq_frequency_table *pos, *table = policy->freq_table;
 
 	if (!table)
 		return -ENODEV;
 
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, table) {
 		/*
 		 * show_boost = true and driver_data = BOOST freq
 		 * display BOOST freqs
@@ -229,10 +224,10 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
 		 * show_boost = false and driver_data != BOOST freq
 		 * display NON BOOST freqs
 		 */
-		if (show_boost ^ (table[i].flags & CPUFREQ_BOOST_FREQ))
+		if (show_boost ^ (pos->flags & CPUFREQ_BOOST_FREQ))
 			continue;
 
-		count += sprintf(&buf[count], "%d ", table[i].frequency);
+		count += sprintf(&buf[count], "%d ", pos->frequency);
 	}
 	count += sprintf(&buf[count], "\n");
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 5ae5100..4f913b5 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -468,6 +468,27 @@ struct cpufreq_frequency_table {
 				    * order */
 };
 
+bool cpufreq_next_valid(struct cpufreq_frequency_table **pos);
+
+/*
+ * cpufreq_for_each_entry -	iterate over a cpufreq_frequency_table
+ * @pos:	the cpufreq_frequency_table * to use as a loop cursor.
+ * @table:	the cpufreq_frequency_table * to iterate over.
+ */
+
+#define cpufreq_for_each_entry(pos, table)	\
+	for (pos = table; pos->frequency != CPUFREQ_TABLE_END; pos++)
+
+/*
+ * cpufreq_for_each_valid_entry -     iterate over a cpufreq_frequency_table
+ *	exluding CPUFREQ_ENTRY_INVALID frequencies.
+ * @pos:        the cpufreq_frequency_table * to use as a loop cursor.
+ * @table:      the cpufreq_frequency_table * to iterate over.
+ */
+
+#define cpufreq_for_each_valid_entry(pos, table)	\
+	for (pos = table; cpufreq_next_valid(&pos); pos++)
+
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 				    struct cpufreq_frequency_table *table);
 
-- 
1.9.0

