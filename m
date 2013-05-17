Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3EQVlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:41:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3EQViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 084/102] cpufreq / intel_pstate: use lowest requested max performance
Date: Fri, 17 May 2013 14:36:39 -0700
Message-Id: <20130517213253.131450330@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit d8f469e9cff3bc4a6317d923e9506be046aa7bdc upstream.

There are two ways that the maximum p-state can be clamped, via a
policy change and via the sysfs file.

The acpi-thermal driver adjusts the p-state policy in response to
thermal events.  These changes override the users settings at the
moment.

Use the lowest of the two requested values this ensures that we will
not exceed the requested pstate from either mechanism.

Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

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
@@ -295,7 +299,8 @@ static ssize_t store_max_perf_pct(struct
 	if (ret != 1)
 		return -EINVAL;
 
-	limits.max_perf_pct = clamp_t(int, input, 0 , 100);
+	limits.max_sysfs_pct = clamp_t(int, input, 0 , 100);
+	limits.max_perf_pct = min(limits.max_policy_pct, limits.max_sysfs_pct);
 	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));
 	return count;
 }
@@ -641,8 +646,9 @@ static int intel_pstate_set_policy(struc
 	limits.min_perf_pct = clamp_t(int, limits.min_perf_pct, 0 , 100);
 	limits.min_perf = div_fp(int_tofp(limits.min_perf_pct), int_tofp(100));
 
-	limits.max_perf_pct = policy->max * 100 / policy->cpuinfo.max_freq;
-	limits.max_perf_pct = clamp_t(int, limits.max_perf_pct, 0 , 100);
+	limits.max_policy_pct = policy->max * 100 / policy->cpuinfo.max_freq;
+	limits.max_policy_pct = clamp_t(int, limits.max_policy_pct, 0 , 100);
+	limits.max_perf_pct = min(limits.max_policy_pct, limits.max_sysfs_pct);
 	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));
 
 	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {


