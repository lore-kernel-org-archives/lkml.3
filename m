Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936548Ab3DIV5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:57:04 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:38235 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761010Ab3DIV5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:57:02 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] thermal: cpu_cooling: fix handling of invalid frequency table entries
Date: Tue,  9 Apr 2013 14:56:56 -0700
Message-Id: <1365544616-10003-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_cpu_frequency() goes into an infinite loop if any of the entries
in the CPU frequency table are invalid.  This patch fixes that case
and, with a separate counter for frequency levels, ensures that the
n-th valid frequency level is returned.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/thermal/cpu_cooling.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

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
-- 
1.8.1.3

