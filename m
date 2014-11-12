Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaKLB2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:28:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbaKLB2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.17 173/319] cpufreq: intel_pstate: Reflect current no_turbo state correctly
Date: Wed, 12 Nov 2014 10:15:11 +0900
Message-Id: <20141112011021.333520901@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   48 ++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 12 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -138,6 +138,7 @@ struct perf_limits {
 
 static struct perf_limits limits = {
 	.no_turbo = 0,
+	.turbo_disabled = 0,
 	.max_perf_pct = 100,
 	.max_perf = int_tofp(1),
 	.min_perf_pct = 0,
@@ -218,6 +219,18 @@ static inline void intel_pstate_reset_al
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
@@ -274,6 +287,20 @@ static void __init intel_pstate_debug_ex
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
@@ -283,11 +310,14 @@ static ssize_t store_no_turbo(struct kob
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
 
@@ -323,7 +353,6 @@ static ssize_t store_min_perf_pct(struct
 	return count;
 }
 
-show_one(no_turbo, no_turbo);
 show_one(max_perf_pct, max_perf_pct);
 show_one(min_perf_pct, min_perf_pct);
 
@@ -501,7 +530,7 @@ static void intel_pstate_get_min_max(str
 	int max_perf_adj;
 	int min_perf;
 
-	if (limits.no_turbo)
+	if (limits.no_turbo || limits.turbo_disabled)
 		max_perf = cpu->pstate.max_pstate;
 
 	max_perf_adj = fp_toint(mul_fp(int_tofp(max_perf), limits.max_perf));
@@ -516,6 +545,8 @@ static void intel_pstate_set_pstate(stru
 {
 	int max_perf, min_perf;
 
+	update_turbo_state();
+
 	intel_pstate_get_min_max(cpu, &min_perf, &max_perf);
 
 	pstate = clamp_t(int, pstate, min_perf, max_perf);
@@ -716,7 +747,7 @@ static int intel_pstate_set_policy(struc
 		limits.min_perf = int_tofp(1);
 		limits.max_perf_pct = 100;
 		limits.max_perf = int_tofp(1);
-		limits.no_turbo = limits.turbo_disabled;
+		limits.no_turbo = 0;
 		return 0;
 	}
 	limits.min_perf_pct = (policy->min * 100) / policy->cpuinfo.max_freq;
@@ -759,7 +790,6 @@ static int intel_pstate_cpu_init(struct
 {
 	struct cpudata *cpu;
 	int rc;
-	u64 misc_en;
 
 	rc = intel_pstate_init_cpu(policy->cpu);
 	if (rc)
@@ -767,12 +797,6 @@ static int intel_pstate_cpu_init(struct
 
 	cpu = all_cpu_data[policy->cpu];
 
-	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
-	if (misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE ||
-	    cpu->pstate.max_pstate == cpu->pstate.turbo_pstate) {
-		limits.turbo_disabled = 1;
-		limits.no_turbo = 1;
-	}
 	if (limits.min_perf_pct == 100 && limits.max_perf_pct == 100)
 		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
 	else


