Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaKKL7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:59:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57305 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaKKLJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 043/170] cpufreq: intel_pstate: Reflect current no_turbo state correctly
Date: Tue, 11 Nov 2014 11:06:42 +0000
Message-Id: <1415704129-12709-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Mazzotta <gabriele.mzt@gmail.com>

commit 4521e1a0ce173daa23dfef8312d09051e057ff8e upstream.

Some BIOSes modify the state of MSR_IA32_MISC_ENABLE_TURBO_DISABLE
based on the current power source for the system battery AC vs
battery. Reflect the correct current state and ability to modify the
no_turbo sysfs file based on current state of
MSR_IA32_MISC_ENABLE_TURBO_DISABLE.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=83151
Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 49 +++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 738f5c85b5ca..41bbeae458a1 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -139,6 +139,7 @@ struct perf_limits {
 
 static struct perf_limits limits = {
 	.no_turbo = 0,
+	.turbo_disabled = 0,
 	.max_perf_pct = 100,
 	.max_perf = int_tofp(1),
 	.min_perf_pct = 0,
@@ -223,6 +224,18 @@ static inline void intel_pstate_reset_all_pid(void)
 	}
 }
 
+static inline void update_turbo_state(void)
+{
+	u64 misc_en;
+	struct cpudata *cpu;
+
+	cpu = all_cpu_data[0];
+	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
+	limits.turbo_disabled =
+		(misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE ||
+		 cpu->pstate.max_pstate == cpu->pstate.turbo_pstate);
+}
+
 /************************** debugfs begin ************************/
 static int pid_param_set(void *data, u64 val)
 {
@@ -279,6 +292,20 @@ static void intel_pstate_debug_expose_params(void)
 		return sprintf(buf, "%u\n", limits.object);		\
 	}
 
+static ssize_t show_no_turbo(struct kobject *kobj,
+			     struct attribute *attr, char *buf)
+{
+	ssize_t ret;
+
+	update_turbo_state();
+	if (limits.turbo_disabled)
+		ret = sprintf(buf, "%u\n", limits.turbo_disabled);
+	else
+		ret = sprintf(buf, "%u\n", limits.no_turbo);
+
+	return ret;
+}
+
 static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
 				const char *buf, size_t count)
 {
@@ -287,11 +314,14 @@ static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
 	ret = sscanf(buf, "%u", &input);
 	if (ret != 1)
 		return -EINVAL;
-	limits.no_turbo = clamp_t(int, input, 0 , 1);
+
+	update_turbo_state();
 	if (limits.turbo_disabled) {
 		pr_warn("Turbo disabled by BIOS or unavailable on processor\n");
-		limits.no_turbo = limits.turbo_disabled;
+		return -EPERM;
 	}
+	limits.no_turbo = clamp_t(int, input, 0, 1);
+
 	return count;
 }
 
@@ -324,7 +354,6 @@ static ssize_t store_min_perf_pct(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-show_one(no_turbo, no_turbo);
 show_one(max_perf_pct, max_perf_pct);
 show_one(min_perf_pct, min_perf_pct);
 
@@ -499,7 +528,8 @@ static void intel_pstate_get_min_max(struct cpudata *cpu, int *min, int *max)
 	int max_perf = cpu->pstate.turbo_pstate;
 	int max_perf_adj;
 	int min_perf;
-	if (limits.no_turbo)
+
+	if (limits.no_turbo || limits.turbo_disabled)
 		max_perf = cpu->pstate.max_pstate;
 
 	max_perf_adj = fp_toint(mul_fp(int_tofp(max_perf), limits.max_perf));
@@ -515,6 +545,8 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 {
 	int max_perf, min_perf;
 
+	update_turbo_state();
+
 	intel_pstate_get_min_max(cpu, &min_perf, &max_perf);
 
 	pstate = clamp_t(int, pstate, min_perf, max_perf);
@@ -745,7 +777,7 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 		limits.max_policy_pct = 100;
 		limits.max_perf_pct = 100;
 		limits.max_perf = int_tofp(1);
-		limits.no_turbo = limits.turbo_disabled;
+		limits.no_turbo = 0;
 		return 0;
 	}
 	limits.min_perf_pct = (policy->min * 100) / policy->cpuinfo.max_freq;
@@ -788,7 +820,6 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	struct cpudata *cpu;
 	int rc;
-	u64 misc_en;
 
 	rc = intel_pstate_init_cpu(policy->cpu);
 	if (rc)
@@ -796,12 +827,6 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 
 	cpu = all_cpu_data[policy->cpu];
 
-	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
-	if (misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE ||
-		cpu->pstate.max_pstate == cpu->pstate.turbo_pstate) {
-		limits.turbo_disabled = 1;
-		limits.no_turbo = 1;
-	}
 	if (limits.min_perf_pct == 100 && limits.max_perf_pct == 100)
 		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
 	else
-- 
2.1.0

