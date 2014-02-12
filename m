Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaBLSBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:01:39 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51332 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaBLSBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:01:36 -0500
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 1/5] intel_pstate: Remove energy reporting from pstate_sample tracepoint
Date: Wed, 12 Feb 2014 10:01:03 -0800
Message-Id: <1392228067-14817-2-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Remove the reporting of energy since it does not provide any useful
information about the state of the driver and will be a maintainance
headache going forward since the RAPL energy units register is not
architectural and subject to change between micro-architectures

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 9 ---------
 include/trace/events/power.h   | 7 +------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 79606f4..c788abf 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -51,8 +51,6 @@ static inline int32_t div_fp(int32_t x, int32_t y)
 	return div_s64((int64_t)x << FRAC_BITS, (int64_t)y);
 }
 
-static u64 energy_divisor;
-
 struct sample {
 	int32_t core_pct_busy;
 	u64 aperf;
@@ -630,12 +628,10 @@ static void intel_pstate_timer_func(unsigned long __data)
 {
 	struct cpudata *cpu = (struct cpudata *) __data;
 	struct sample *sample;
-	u64 energy;
 
 	intel_pstate_sample(cpu);
 
 	sample = &cpu->samples[cpu->sample_ptr];
-	rdmsrl(MSR_PKG_ENERGY_STATUS, energy);
 
 	intel_pstate_adjust_busy_pstate(cpu);
 
@@ -644,7 +640,6 @@ static void intel_pstate_timer_func(unsigned long __data)
 			cpu->pstate.current_pstate,
 			sample->mperf,
 			sample->aperf,
-			div64_u64(energy, energy_divisor),
 			sample->freq);
 
 	intel_pstate_set_sample_time(cpu);
@@ -926,7 +921,6 @@ static int __init intel_pstate_init(void)
 	int cpu, rc = 0;
 	const struct x86_cpu_id *id;
 	struct cpu_defaults *cpu_info;
-	u64 units;
 
 	if (no_load)
 		return -ENODEV;
@@ -960,9 +954,6 @@ static int __init intel_pstate_init(void)
 	if (rc)
 		goto out;
 
-	rdmsrl(MSR_RAPL_POWER_UNIT, units);
-	energy_divisor = 1 << ((units >> 8) & 0x1f); /* bits{12:8} */
-
 	intel_pstate_debug_expose_params();
 	intel_pstate_sysfs_expose_params();
 
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 9e9475c..e5bf9a7 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -42,7 +42,6 @@ TRACE_EVENT(pstate_sample,
 		u32 state,
 		u64 mperf,
 		u64 aperf,
-		u32 energy,
 		u32 freq
 		),
 
@@ -51,7 +50,6 @@ TRACE_EVENT(pstate_sample,
 		state,
 		mperf,
 		aperf,
-		energy,
 		freq
 		),
 
@@ -61,7 +59,6 @@ TRACE_EVENT(pstate_sample,
 		__field(u32, state)
 		__field(u64, mperf)
 		__field(u64, aperf)
-		__field(u32, energy)
 		__field(u32, freq)
 
 	),
@@ -72,17 +69,15 @@ TRACE_EVENT(pstate_sample,
 		__entry->state = state;
 		__entry->mperf = mperf;
 		__entry->aperf = aperf;
-		__entry->energy = energy;
 		__entry->freq = freq;
 		),
 
-	TP_printk("core_busy=%lu scaled=%lu state=%lu mperf=%llu aperf=%llu energy=%lu freq=%lu ",
+	TP_printk("core_busy=%lu scaled=%lu state=%lu mperf=%llu aperf=%llu freq=%lu ",
 		(unsigned long)__entry->core_busy,
 		(unsigned long)__entry->scaled_busy,
 		(unsigned long)__entry->state,
 		(unsigned long long)__entry->mperf,
 		(unsigned long long)__entry->aperf,
-		(unsigned long)__entry->energy,
 		(unsigned long)__entry->freq
 		)
 
-- 
1.8.3.1

