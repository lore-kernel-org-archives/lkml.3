Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaIIWNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:13:36 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49263 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaIIWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:12:35 -0400
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: dirk.j.brandewie@intel.com
Cc: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [PATCH 3/6] PID: Move Baytrail specific accessors into backend driver
Date: Tue,  9 Sep 2014 18:12:05 -0400
Message-Id: <1410300728-26637-4-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Baytrail series uses additional information while
setting a target CPU performance value. To keep the PID governor
generic, move this out into the platform specific backend driver.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
---
 drivers/cpufreq/intel_pid_ctrl.c | 57 ++++++++++++++++++++++++----------------
 drivers/cpufreq/pid_ctrl.c       |  4 ---
 drivers/cpufreq/pid_ctrl.h       |  9 -------
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/cpufreq/intel_pid_ctrl.c b/drivers/cpufreq/intel_pid_ctrl.c
index 9ad7d5e..a858981 100644
--- a/drivers/cpufreq/intel_pid_ctrl.c
+++ b/drivers/cpufreq/intel_pid_ctrl.c
@@ -29,6 +29,15 @@
 #define BYT_TURBO_RATIOS	0x66c
 #define BYT_TURBO_VIDS		0x66d
 
+struct vid_data {
+	int min;
+	int max;
+	int turbo;
+	int32_t ratio;
+};
+
+static struct vid_data vid_data;
+
 struct perf_limits limits = {
 	.no_turbo = 0,
 	.max_perf_pct = 100,
@@ -39,6 +48,21 @@ struct perf_limits limits = {
 	.max_sysfs_pct = 100,
 };
 
+static void byt_get_vid(int max, int min)
+{
+	u64 value;
+
+	rdmsrl(BYT_VIDS, value);
+	vid_data.min = int_tofp((value >> 8) & 0x7f);
+	vid_data.max = int_tofp((value >> 16) & 0x7f);
+	vid_data.ratio = div_fp(
+			vid_data.max - vid_data.min,
+			int_tofp(max - min));
+
+	rdmsrl(BYT_TURBO_VIDS, value);
+	vid_data.turbo = value & 0x7f;
+}
+
 static int byt_get_min_pstate(void)
 {
 	u64 value;
@@ -50,9 +74,15 @@ static int byt_get_min_pstate(void)
 static int byt_get_max_pstate(void)
 {
 	u64 value;
+	int max, min;
 
 	rdmsrl(BYT_RATIOS, value);
-	return (value >> 16) & 0x7F;
+	max = (value >> 16) & 0x7F;
+	min = byt_get_min_pstate();
+
+	byt_get_vid(max, min);
+
+	return max;
 }
 
 static int byt_get_turbo_pstate(void)
@@ -78,37 +108,21 @@ static void byt_set_pstate(struct cpudata *cpudata, int pstate)
 	if (limits.no_turbo && !limits.turbo_disabled)
 		val |= (u64)1 << 32;
 
-	vid_fp = cpudata->vid.min + mul_fp(
+	vid_fp = vid_data.min + mul_fp(
 		int_tofp(pstate - cpudata->pstate.min_pstate),
-		cpudata->vid.ratio);
+		vid_data.ratio);
 
-	vid_fp = clamp_t(int32_t, vid_fp, cpudata->vid.min, cpudata->vid.max);
+	vid_fp = clamp_t(int32_t, vid_fp, vid_data.min, vid_data.max);
 	vid = fp_toint(vid_fp);
 
 	if (pstate > cpudata->pstate.max_pstate)
-		vid = cpudata->vid.turbo;
+		vid = vid_data.turbo;
 
 	val |= vid;
 
 	wrmsrl(MSR_IA32_PERF_CTL, val);
 }
 
-static void byt_get_vid(struct cpudata *cpudata)
-{
-	u64 value;
-
-	rdmsrl(BYT_VIDS, value);
-	cpudata->vid.min = int_tofp((value >> 8) & 0x7f);
-	cpudata->vid.max = int_tofp((value >> 16) & 0x7f);
-	cpudata->vid.ratio = div_fp(
-		cpudata->vid.max - cpudata->vid.min,
-		int_tofp(cpudata->pstate.max_pstate -
-			cpudata->pstate.min_pstate));
-
-	rdmsrl(BYT_TURBO_VIDS, value);
-	cpudata->vid.turbo = value & 0x7f;
-}
-
 static int core_get_min_pstate(void)
 {
 	u64 value;
@@ -188,7 +202,6 @@ static struct cpu_defaults byt_params = {
 		.get_min = byt_get_min_pstate,
 		.get_turbo = byt_get_turbo_pstate,
 		.set = byt_set_pstate,
-		.get_vid = byt_get_vid,
 	},
 };
 
diff --git a/drivers/cpufreq/pid_ctrl.c b/drivers/cpufreq/pid_ctrl.c
index 516b95f..8eb9739 100644
--- a/drivers/cpufreq/pid_ctrl.c
+++ b/drivers/cpufreq/pid_ctrl.c
@@ -319,9 +319,6 @@ static void pid_ctrl_get_cpu_pstates(struct cpudata *cpu)
 	else
 		cpu->pstate.turbo_pstate = cpu->pstate.max_pstate;
 
-	if (pstate_funcs.get_vid)
-		pstate_funcs.get_vid(cpu);
-
 	pid_ctrl_set_pstate(cpu, cpu->pstate.min_pstate);
 }
 
@@ -592,7 +589,6 @@ void register_cpu_funcs(struct pstate_funcs *funcs)
 	pstate_funcs.get_min   = funcs->get_min;
 	pstate_funcs.get_turbo = funcs->get_turbo;
 	pstate_funcs.set       = funcs->set;
-	pstate_funcs.get_vid   = funcs->get_vid;
 }
 EXPORT_SYMBOL_GPL(register_cpu_funcs);
 
diff --git a/drivers/cpufreq/pid_ctrl.h b/drivers/cpufreq/pid_ctrl.h
index ab56415..40b352a 100644
--- a/drivers/cpufreq/pid_ctrl.h
+++ b/drivers/cpufreq/pid_ctrl.h
@@ -30,13 +30,6 @@ struct sample {
 	ktime_t time;
 };
 
-struct vid_data {
-	int min;
-	int max;
-	int turbo;
-	int32_t ratio;
-};
-
 struct _pid {
 	int setpoint;
 	int32_t integral;
@@ -69,7 +62,6 @@ struct cpudata {
 	struct timer_list timer;
 
 	struct pstate_data pstate;
-	struct vid_data vid;
 	struct _pid pid;
 
 	ktime_t last_sample_time;
@@ -83,7 +75,6 @@ struct pstate_funcs {
 	int (*get_min)(void);
 	int (*get_turbo)(void);
 	void (*set)(struct cpudata*, int pstate);
-	void (*get_vid)(struct cpudata *);
 };
 
 struct cpu_defaults {
-- 
1.9.1

