Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab3EGPWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:22:14 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:63954 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3EGPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:20:51 -0400
From: dirk.brandewie@gmail.com
To: rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/6] cpufreq/intel_pstate: use lowest requested max performance
Date: Tue,  7 May 2013 08:20:26 -0700
Message-Id: <1367940030-19311-3-git-send-email-dirk.j.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
References: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

There are two ways that the maximum p-state can be clamped, via a
policy change and via the sysfs file.

The acpi-thermal driver adjusts the p-state policy in response to
thermal events.  These changes override the users settings ATM.

Use the lowest of the two requested values this ensures that we will
not exceed the requested pstate from either mechanism.

Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 5370b8d..c0c98c2 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -117,6 +117,8 @@ struct perf_limits {
 	int min_perf_pct;
 	int32_t max_perf;
 	int32_t min_perf;
+	int max_policy_pct;
+	int max_sysfs_pct;
 };
 
 static struct perf_limits limits = {
@@ -125,6 +127,8 @@ static struct perf_limits limits = {
 	.max_perf = int_tofp(1),
 	.min_perf_pct = 0,
 	.min_perf = 0,
+	.max_policy_pct = 100,
+	.max_sysfs_pct = 100,
 };
 
 static inline void pid_reset(struct _pid *pid, int setpoint, int busy,
@@ -295,7 +299,8 @@ static ssize_t store_max_perf_pct(struct kobject *a, struct attribute *b,
 	if (ret != 1)
 		return -EINVAL;
 
-	limits.max_perf_pct = clamp_t(int, input, 0 , 100);
+	limits.max_sysfs_pct = clamp_t(int, input, 0 , 100);
+	limits.max_perf_pct = min(limits.max_policy_pct, limits.max_sysfs_pct);
 	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));
 	return count;
 }
@@ -642,8 +647,9 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 	limits.min_perf_pct = clamp_t(int, limits.min_perf_pct, 0 , 100);
 	limits.min_perf = div_fp(int_tofp(limits.min_perf_pct), int_tofp(100));
 
-	limits.max_perf_pct = policy->max * 100 / policy->cpuinfo.max_freq;
-	limits.max_perf_pct = clamp_t(int, limits.max_perf_pct, 0 , 100);
+	limits.max_policy_pct = policy->max * 100 / policy->cpuinfo.max_freq;
+	limits.max_policy_pct = clamp_t(int, limits.max_policy_pct, 0 , 100);
+	limits.max_perf_pct = min(limits.max_policy_pct, limits.max_sysfs_pct);
 	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));
 
 	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {
-- 
1.7.7.6

