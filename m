Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3B1Fi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:38:29 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60138 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3B1FiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:38:09 -0500
X-AuditID: 9c930197-b7c43ae0000006e1-df-512eed3d0044
From: Namhyung Kim <namhyung@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH -next 2/3] cpufreq: conservative: Break out earlier on the lowest frequency
Date: Thu, 28 Feb 2013 14:38:01 +0900
Message-Id: <1362029882-28993-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362029882-28993-1-git-send-email-namhyung@kernel.org>
References: <1362029882-28993-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If we're on the lowest frequency, no need to calculate new freq.
Break out even earlier in this case.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 4fd0006b1291..dd2fd9094819 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -93,18 +93,18 @@ static void cs_check_cpu(int cpu, unsigned int load)
 	 * safe, we focus 10 points under the threshold.
 	 */
 	if (load < (cs_tuners.down_threshold - 10)) {
-		freq_target = (cs_tuners.freq_step * policy->max) / 100;
-
-		dbs_info->requested_freq -= freq_target;
-		if (dbs_info->requested_freq < policy->min)
-			dbs_info->requested_freq = policy->min;
-
 		/*
 		 * if we cannot reduce the frequency anymore, break out early
 		 */
 		if (policy->cur == policy->min)
 			return;
 
+		freq_target = (cs_tuners.freq_step * policy->max) / 100;
+
+		dbs_info->requested_freq -= freq_target;
+		if (dbs_info->requested_freq < policy->min)
+			dbs_info->requested_freq = policy->min;
+
 		__cpufreq_driver_target(policy, dbs_info->requested_freq,
 				CPUFREQ_RELATION_H);
 		return;
-- 
1.7.11.7

