Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879Ab3DHXyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:54:55 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:56079 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935512Ab3DHXyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:54:53 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] thermal: fix frequency table lookup bugs
Date: Mon,  8 Apr 2013 16:54:47 -0700
Message-Id: <1365465287-24530-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loops which are used to perform lookups in CPU frequency tables in
cpu_cooling and the Exynos thermal driver do not update the loop counter
if they encounter an invalid table entry, leading to an infinite loop in
that case.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/thermal/cpu_cooling.c    | 19 ++++++++++---------
 drivers/thermal/exynos_thermal.c |  8 ++++----
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 836828e..e6db441 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -124,14 +124,14 @@ static int is_cpufreq_valid(int cpu)
 static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
 {
 	int ret = 0, i = 0;
-	unsigned long level_index;
+	unsigned long level_index = 0;
 	bool descend = false;
 	struct cpufreq_frequency_table *table =
 					cpufreq_frequency_get_table(cpu);
 	if (!table)
 		return ret;
 
-	while (table[i].frequency != CPUFREQ_TABLE_END) {
+	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
 
@@ -143,24 +143,25 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
 		}
 
 		/*return if level matched and table in descending order*/
-		if (descend && i == level)
+		if (descend && level_index == level)
 			return table[i].frequency;
-		i++;
+		level_index++;
 	}
 	i--;
+	level_index--;
 
-	if (level > i || descend)
+	if (level > level_index || descend)
 		return ret;
-	level_index = i - level;
+	level = level_index - level;
 
 	/*Scan the table in reverse order and match the level*/
-	while (i >= 0) {
+	for (; i >= 0; i--) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
 		/*return if level matched*/
-		if (i == level_index)
+		if (level_index == level)
 			return table[i].frequency;
-		i--;
+		level_index--;
 	}
 	return ret;
 }
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index d5e6267..524b2a0 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -237,7 +237,7 @@ static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
 
 static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
 {
-	int i = 0, ret = -EINVAL;
+	int i, level = 0, ret = -EINVAL;
 	struct cpufreq_frequency_table *table = NULL;
 #ifdef CONFIG_CPU_FREQ
 	table = cpufreq_frequency_get_table(cpu);
@@ -245,12 +245,12 @@ static int exynos_get_frequency_level(unsigned int cpu, unsigned int freq)
 	if (!table)
 		return ret;
 
-	while (table[i].frequency != CPUFREQ_TABLE_END) {
+	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
 		if (table[i].frequency == freq)
-			return i;
-		i++;
+			return level;
+		level++;
 	}
 	return ret;
 }
-- 
1.8.1.3

