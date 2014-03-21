Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605AbaCUAEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965474AbaCUAEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.13 141/149] intel_pstate: Add setting voltage value for baytrail P states.
Date: Thu, 20 Mar 2014 17:05:04 -0700
Message-Id: <20140321000441.842318370@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 007bea098b869945a462420a1f9d442ff169f722 upstream.

Baytrail requires setting P state and voltage pairs when adjusting the
requested P state.  Add function for retrieving the valid voltage
values and modify *_set_pstate() functions to caluclate the
appropriate voltage for the requested P state.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   58 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -35,6 +35,7 @@
 #define SAMPLE_COUNT		3
 
 #define BYT_RATIOS	0x66a
+#define BYT_VIDS        0x66b
 
 #define FRAC_BITS 8
 #define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
@@ -64,6 +65,12 @@ struct pstate_data {
 	int	turbo_pstate;
 };
 
+struct vid_data {
+	int32_t min;
+	int32_t max;
+	int32_t ratio;
+};
+
 struct _pid {
 	int setpoint;
 	int32_t integral;
@@ -82,6 +89,7 @@ struct cpudata {
 	struct timer_list timer;
 
 	struct pstate_data pstate;
+	struct vid_data vid;
 	struct _pid pid;
 
 	int min_pstate_count;
@@ -106,7 +114,8 @@ struct pstate_funcs {
 	int (*get_max)(void);
 	int (*get_min)(void);
 	int (*get_turbo)(void);
-	void (*set)(int pstate);
+	void (*set)(struct cpudata*, int pstate);
+	void (*get_vid)(struct cpudata *);
 };
 
 struct cpu_defaults {
@@ -358,6 +367,42 @@ static int byt_get_max_pstate(void)
 	return (value >> 16) & 0xFF;
 }
 
+static void byt_set_pstate(struct cpudata *cpudata, int pstate)
+{
+	u64 val;
+	int32_t vid_fp;
+	u32 vid;
+
+	val = pstate << 8;
+	if (limits.no_turbo)
+		val |= (u64)1 << 32;
+
+	vid_fp = cpudata->vid.min + mul_fp(
+		int_tofp(pstate - cpudata->pstate.min_pstate),
+		cpudata->vid.ratio);
+
+	vid_fp = clamp_t(int32_t, vid_fp, cpudata->vid.min, cpudata->vid.max);
+	vid = fp_toint(vid_fp);
+
+	val |= vid;
+
+	wrmsrl(MSR_IA32_PERF_CTL, val);
+}
+
+static void byt_get_vid(struct cpudata *cpudata)
+{
+	u64 value;
+
+	rdmsrl(BYT_VIDS, value);
+	cpudata->vid.min = int_tofp((value >> 8) & 0x7f);
+	cpudata->vid.max = int_tofp((value >> 16) & 0x7f);
+	cpudata->vid.ratio = div_fp(
+		cpudata->vid.max - cpudata->vid.min,
+		int_tofp(cpudata->pstate.max_pstate -
+			cpudata->pstate.min_pstate));
+}
+
+
 static int core_get_min_pstate(void)
 {
 	u64 value;
@@ -384,7 +429,7 @@ static int core_get_turbo_pstate(void)
 	return ret;
 }
 
-static void core_set_pstate(int pstate)
+static void core_set_pstate(struct cpudata *cpudata, int pstate)
 {
 	u64 val;
 
@@ -425,7 +470,8 @@ static struct cpu_defaults byt_params =
 		.get_max = byt_get_max_pstate,
 		.get_min = byt_get_min_pstate,
 		.get_turbo = byt_get_max_pstate,
-		.set = core_set_pstate,
+		.set = byt_set_pstate,
+		.get_vid = byt_get_vid,
 	},
 };
 
@@ -462,7 +508,7 @@ static void intel_pstate_set_pstate(stru
 
 	cpu->pstate.current_pstate = pstate;
 
-	pstate_funcs.set(pstate);
+	pstate_funcs.set(cpu, pstate);
 }
 
 static inline void intel_pstate_pstate_increase(struct cpudata *cpu, int steps)
@@ -488,6 +534,9 @@ static void intel_pstate_get_cpu_pstates
 	cpu->pstate.max_pstate = pstate_funcs.get_max();
 	cpu->pstate.turbo_pstate = pstate_funcs.get_turbo();
 
+	if (pstate_funcs.get_vid)
+		pstate_funcs.get_vid(cpu);
+
 	/*
 	 * goto max pstate so we don't slow up boot if we are built-in if we are
 	 * a module we will take care of it during normal operation
@@ -782,6 +831,7 @@ static void copy_cpu_funcs(struct pstate
 	pstate_funcs.get_min   = funcs->get_min;
 	pstate_funcs.get_turbo = funcs->get_turbo;
 	pstate_funcs.set       = funcs->set;
+	pstate_funcs.get_vid   = funcs->get_vid;
 }
 
 #if IS_ENABLED(CONFIG_ACPI)


