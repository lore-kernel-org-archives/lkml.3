Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbaHHVQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:16:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbaHHUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 072/259] intel_pstate: don't touch turbo bit if turbo disabled or unavailable.
Date: Fri,  8 Aug 2014 13:38:15 -0700
Message-Id: <1407530482-4483-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit dd5fbf70f96dbfd7ee432096a1f979b2b3267856 upstream.

If turbo is disabled in the BIOS bit 38 should be set in
MSR_IA32_MISC_ENABLE register per section 14.3.2.1 of the SDM Vol 3
document 325384-050US Feb 2014.  If this bit is set do *not* attempt
to disable trubo via the MSR_IA32_PERF_CTL register.  On some systems
trying to disable turbo via MSR_IA32_PERF_CTL will cause subsequent
writes to MSR_IA32_PERF_CTL not take affect, in fact reading
MSR_IA32_PERF_CTL will not show the IDA/Turbo DISENGAGE bit(32) as
set. A write of bit 32 to zero returns to normal operation.

Also deal with the case where the processor does not support
turbo and the BIOS does not report the fact in MSR_IA32_MISC_ENABLE
but does report the max and turbo P states as the same value.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=64251
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 37ef477..fbfdde1 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -132,6 +132,7 @@ static struct pstate_funcs pstate_funcs;
 
 struct perf_limits {
 	int no_turbo;
+	int turbo_disabled;
 	int max_perf_pct;
 	int min_perf_pct;
 	int32_t max_perf;
@@ -291,7 +292,10 @@ static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
 	if (ret != 1)
 		return -EINVAL;
 	limits.no_turbo = clamp_t(int, input, 0 , 1);
-
+	if (limits.turbo_disabled) {
+		pr_warn("Turbo disabled by BIOS or unavailable on processor\n");
+		limits.no_turbo = limits.turbo_disabled;
+	}
 	return count;
 }
 
@@ -385,7 +389,7 @@ static void byt_set_pstate(struct cpudata *cpudata, int pstate)
 	u32 vid;
 
 	val = pstate << 8;
-	if (limits.no_turbo)
+	if (limits.no_turbo && !limits.turbo_disabled)
 		val |= (u64)1 << 32;
 
 	vid_fp = cpudata->vid.min + mul_fp(
@@ -452,7 +456,7 @@ static void core_set_pstate(struct cpudata *cpudata, int pstate)
 	u64 val;
 
 	val = pstate << 8;
-	if (limits.no_turbo)
+	if (limits.no_turbo && !limits.turbo_disabled)
 		val |= (u64)1 << 32;
 
 	wrmsrl(MSR_IA32_PERF_CTL, val);
@@ -732,7 +736,7 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 		limits.min_perf = int_tofp(1);
 		limits.max_perf_pct = 100;
 		limits.max_perf = int_tofp(1);
-		limits.no_turbo = 0;
+		limits.no_turbo = limits.turbo_disabled;
 		return 0;
 	}
 	limits.min_perf_pct = (policy->min * 100) / policy->cpuinfo.max_freq;
@@ -772,6 +776,7 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	struct cpudata *cpu;
 	int rc;
+	u64 misc_en;
 
 	rc = intel_pstate_init_cpu(policy->cpu);
 	if (rc)
@@ -779,8 +784,13 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 
 	cpu = all_cpu_data[policy->cpu];
 
-	if (!limits.no_turbo &&
-		limits.min_perf_pct == 100 && limits.max_perf_pct == 100)
+	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
+	if (misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE ||
+		cpu->pstate.max_pstate == cpu->pstate.turbo_pstate) {
+		limits.turbo_disabled = 1;
+		limits.no_turbo = 1;
+	}
+	if (limits.min_perf_pct == 100 && limits.max_perf_pct == 100)
 		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
 	else
 		policy->policy = CPUFREQ_POLICY_POWERSAVE;
-- 
1.9.1

