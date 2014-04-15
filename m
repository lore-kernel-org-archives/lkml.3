Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaDOW0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:26:44 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:57994 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751040AbaDOW0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:26:41 -0400
Message-ID: <534DB21F.4070005@semaphore.gr>
Date: Wed, 16 Apr 2014 01:26:39 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH v2 6/8] thermal: cpu_cooling: Use cpufreq_for_each_valid_entry
 macro for iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core now supports the cpufreq_for_each_valid_entry macro
helper for iteration over the cpufreq_frequency_table, so use it.

Also remove the redundant !! operator.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/thermal/cpu_cooling.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 4246262..84a75f8 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -144,11 +144,11 @@ static int get_property(unsigned int cpu, unsigned long input,
 			unsigned int *output,
 			enum cpufreq_cooling_property property)
 {
-	int i, j;
+	int i;
 	unsigned long max_level = 0, level = 0;
 	unsigned int freq = CPUFREQ_ENTRY_INVALID;
 	int descend = -1;
-	struct cpufreq_frequency_table *table =
+	struct cpufreq_frequency_table *pos, *table =
 					cpufreq_frequency_get_table(cpu);
 
 	if (!output)
@@ -157,20 +157,16 @@ static int get_property(unsigned int cpu, unsigned long input,
 	if (!table)
 		return -EINVAL;
 
-	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		/* ignore invalid entries */
-		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
-			continue;
-
+	cpufreq_for_each_valid_entry(pos, table) {
 		/* ignore duplicate entry */
-		if (freq == table[i].frequency)
+		if (freq == pos->frequency)
 			continue;
 
 		/* get the frequency order */
 		if (freq != CPUFREQ_ENTRY_INVALID && descend == -1)
-			descend = !!(freq > table[i].frequency);
+			descend = freq > pos->frequency;
 
-		freq = table[i].frequency;
+		freq = pos->frequency;
 		max_level++;
 	}
 
@@ -190,29 +186,26 @@ static int get_property(unsigned int cpu, unsigned long input,
 	if (property == GET_FREQ)
 		level = descend ? input : (max_level - input);
 
-	for (i = 0, j = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		/* ignore invalid entry */
-		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
-			continue;
-
+	i = 0;
+	cpufreq_for_each_valid_entry(pos, table) {
 		/* ignore duplicate entry */
-		if (freq == table[i].frequency)
+		if (freq == pos->frequency)
 			continue;
 
 		/* now we have a valid frequency entry */
-		freq = table[i].frequency;
+		freq = pos->frequency;
 
 		if (property == GET_LEVEL && (unsigned int)input == freq) {
 			/* get level by frequency */
-			*output = descend ? j : (max_level - j);
+			*output = descend ? i : (max_level - i);
 			return 0;
 		}
-		if (property == GET_FREQ && level == j) {
+		if (property == GET_FREQ && level == i) {
 			/* get frequency by level */
 			*output = freq;
 			return 0;
 		}
-		j++;
+		i++;
 	}
 
 	return -EINVAL;
-- 
1.9.0
