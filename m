Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaDUXAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 19:00:38 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:48626 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754569AbaDUXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 19:00:35 -0400
Message-ID: <5355A30D.2020602@semaphore.gr>
Date: Tue, 22 Apr 2014 02:00:29 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-doc@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/8] cpufreq: Introduce macros for cpufreq_frequency_table
 iteration
References: <534E2B44.7090008@semaphore.gr>
In-Reply-To: <534E2B44.7090008@semaphore.gr>
X-Forwarded-Message-Id: <534E2B44.7090008@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many cpufreq drivers need to iterate over the cpufreq_frequency_table
for various tasks.

This patch introduces two macros which can be used for iteration over
cpufreq_frequency_table keeping a common coding style across drivers:

- cpufreq_for_each_entry: iterate over each entry of the table
- cpufreq_for_each_valid_entry: iterate over each entry that contains
a valid frequency.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 Documentation/cpu-freq/cpu-drivers.txt | 19 +++++++++++++++++++
 drivers/cpufreq/cpufreq.c              | 11 +++++++++++
 include/linux/cpufreq.h                | 21 +++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index 48da5fd..b045fe5 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -228,3 +228,22 @@ is the corresponding frequency table helper for the ->target
 stage. Just pass the values to this function, and the unsigned int
 index returns the number of the frequency table entry which contains
 the frequency the CPU shall be set to.
+
+The following macros can be used as iterators over cpufreq_frequency_table:
+
+cpufreq_for_each_entry(pos, table) - iterates over all entries of frequency
+table.
+
+cpufreq-for_each_valid_entry(pos, table) - iterates over all entries,
+excluding CPUFREQ_ENTRY_INVALID frequencies.
+Use arguments "pos" - a cpufreq_frequency_table * as a loop cursor and
+"table" - the cpufreq_frequency_table * you want to iterate over.
+
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
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 5ae5100..77a5fa1 100644
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
+ *	excluding CPUFREQ_ENTRY_INVALID frequencies.
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
