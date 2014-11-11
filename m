Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaKKLJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaKKLJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 045/170] intel_pstate: Fix BYT frequency reporting
Date: Tue, 11 Nov 2014 11:06:44 +0000
Message-Id: <1415704129-12709-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit b27580b05e6f5253228debc60b8ff4a786ff573a upstream.

BYT has a different conversion from P state to frequency than the core
processors.  This causes the min/max and current frequency to be
misreported on some BYT SKUs. Tested on BYT N2820, Ivybridge and
Haswell processors.

Link: https://bugzilla.yoctoproject.org/show_bug.cgi?id=6663
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 7e408bde89be..72c90a1ebb5f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -65,6 +65,7 @@ struct pstate_data {
 	int	current_pstate;
 	int	min_pstate;
 	int	max_pstate;
+	int	scaling;
 	int	turbo_pstate;
 };
 
@@ -114,6 +115,7 @@ struct pstate_funcs {
 	int (*get_max)(void);
 	int (*get_min)(void);
 	int (*get_turbo)(void);
+	int (*get_scaling)(void);
 	void (*set)(struct cpudata*, int pstate);
 	void (*get_vid)(struct cpudata *);
 };
@@ -432,6 +434,22 @@ static void byt_set_pstate(struct cpudata *cpudata, int pstate)
 	wrmsrl(MSR_IA32_PERF_CTL, val);
 }
 
+#define BYT_BCLK_FREQS 5
+static int byt_freq_table[BYT_BCLK_FREQS] = { 833, 1000, 1333, 1167, 800};
+
+static int byt_get_scaling(void)
+{
+	u64 value;
+	int i;
+
+	rdmsrl(MSR_FSB_FREQ, value);
+	i = value & 0x3;
+
+	BUG_ON(i > BYT_BCLK_FREQS);
+
+	return byt_freq_table[i] * 100;
+}
+
 static void byt_get_vid(struct cpudata *cpudata)
 {
 	u64 value;
@@ -476,6 +494,11 @@ static int core_get_turbo_pstate(void)
 	return ret;
 }
 
+static inline int core_get_scaling(void)
+{
+	return 100000;
+}
+
 static void core_set_pstate(struct cpudata *cpudata, int pstate)
 {
 	u64 val;
@@ -500,6 +523,7 @@ static struct cpu_defaults core_params = {
 		.get_max = core_get_max_pstate,
 		.get_min = core_get_min_pstate,
 		.get_turbo = core_get_turbo_pstate,
+		.get_scaling = core_get_scaling,
 		.set = core_set_pstate,
 	},
 };
@@ -518,6 +542,7 @@ static struct cpu_defaults byt_params = {
 		.get_min = byt_get_min_pstate,
 		.get_turbo = byt_get_turbo_pstate,
 		.set = byt_set_pstate,
+		.get_scaling = byt_get_scaling,
 		.get_vid = byt_get_vid,
 	},
 };
@@ -554,7 +579,7 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 	if (pstate == cpu->pstate.current_pstate)
 		return;
 
-	trace_cpu_frequency(pstate * 100000, cpu->cpu);
+	trace_cpu_frequency(pstate * cpu->pstate.scaling, cpu->cpu);
 
 	cpu->pstate.current_pstate = pstate;
 
@@ -581,6 +606,7 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 	cpu->pstate.min_pstate = pstate_funcs.get_min();
 	cpu->pstate.max_pstate = pstate_funcs.get_max();
 	cpu->pstate.turbo_pstate = pstate_funcs.get_turbo();
+	cpu->pstate.scaling = pstate_funcs.get_scaling();
 
 	if (pstate_funcs.get_vid)
 		pstate_funcs.get_vid(cpu);
@@ -600,7 +626,9 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu)
 		core_pct += 1;
 
 	sample->freq = fp_toint(
-		mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
+		mul_fp(int_tofp(
+			cpu->pstate.max_pstate * cpu->pstate.scaling / 100),
+			core_pct));
 
 	sample->core_pct_busy = (int32_t)core_pct;
 }
@@ -832,12 +860,13 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 	else
 		policy->policy = CPUFREQ_POLICY_POWERSAVE;
 
-	policy->min = cpu->pstate.min_pstate * 100000;
-	policy->max = cpu->pstate.turbo_pstate * 100000;
+	policy->min = cpu->pstate.min_pstate * cpu->pstate.scaling;
+	policy->max = cpu->pstate.turbo_pstate * cpu->pstate.scaling;
 
 	/* cpuinfo and default policy values */
-	policy->cpuinfo.min_freq = cpu->pstate.min_pstate * 100000;
-	policy->cpuinfo.max_freq = cpu->pstate.turbo_pstate * 100000;
+	policy->cpuinfo.min_freq = cpu->pstate.min_pstate * cpu->pstate.scaling;
+	policy->cpuinfo.max_freq =
+		cpu->pstate.turbo_pstate * cpu->pstate.scaling;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	cpumask_set_cpu(policy->cpu, policy->cpus);
 
@@ -895,6 +924,7 @@ static void copy_cpu_funcs(struct pstate_funcs *funcs)
 	pstate_funcs.get_max   = funcs->get_max;
 	pstate_funcs.get_min   = funcs->get_min;
 	pstate_funcs.get_turbo = funcs->get_turbo;
+	pstate_funcs.get_scaling = funcs->get_scaling;
 	pstate_funcs.set       = funcs->set;
 	pstate_funcs.get_vid   = funcs->get_vid;
 }
-- 
2.1.0

