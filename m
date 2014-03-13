Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaCMRgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:36:46 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65162 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaCMRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:36:25 -0400
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rjw@rjwysocki.net, patrick.marlier@gmail.com,
        dirk.brandewie@gmail.com, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 2/2] intel_pstate: Set core to min P state during core offline
Date: Thu, 13 Mar 2014 10:36:08 -0700
Message-Id: <1394732168-12638-3-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Change to use ->exit_prepare() callback to do clean up during CPU
hotplug. The requested P state for an offline core will be used by the
hardware coordination function to select the package P state. If the
core is under load when it is offlined it will fix the package P state
floor to the requested P state of offline core.

Reported-by: Patrick Marlier <patrick.marlier@gmail.com>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 2cd36b9..fe32a8c 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -447,7 +447,7 @@ static void core_set_pstate(struct cpudata *cpudata, int pstate)
 	if (limits.no_turbo)
 		val |= (u64)1 << 32;
 
-	wrmsrl(MSR_IA32_PERF_CTL, val);
+	wrmsrl_on_cpu(cpudata->cpu, MSR_IA32_PERF_CTL, val);
 }
 
 static struct cpu_defaults core_params = {
@@ -773,16 +773,22 @@ static int intel_pstate_verify_policy(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static int intel_pstate_cpu_exit(struct cpufreq_policy *policy)
+static int intel_pstate_cpu_exit_prepare(struct cpufreq_policy *policy)
 {
-	int cpu = policy->cpu;
+	int cpu_num = policy->cpu;
+	struct cpudata *cpu = all_cpu_data[cpu_num];
+
+	pr_info("intel_pstate CPU %d exiting\n", cpu_num);
+
+	del_timer(&all_cpu_data[cpu_num]->timer);	
+	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
+	kfree(all_cpu_data[cpu_num]);
+	all_cpu_data[cpu_num] = NULL;
 
-	del_timer(&all_cpu_data[cpu]->timer);
-	kfree(all_cpu_data[cpu]);
-	all_cpu_data[cpu] = NULL;
 	return 0;
 }
 
+
 static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	struct cpudata *cpu;
@@ -818,7 +824,7 @@ static struct cpufreq_driver intel_pstate_driver = {
 	.setpolicy	= intel_pstate_set_policy,
 	.get		= intel_pstate_get,
 	.init		= intel_pstate_cpu_init,
-	.exit		= intel_pstate_cpu_exit,
+	.exit_prepare	= intel_pstate_cpu_exit_prepare,
 	.name		= "intel_pstate",
 };
 
-- 
1.8.3.1

