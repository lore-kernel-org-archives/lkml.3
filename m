Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaBLSBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:01:47 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45270 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaBLSBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:01:44 -0500
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 2/5] intel_pstate: remove unneeded sample buffers
Date: Wed, 12 Feb 2014 10:01:04 -0800
Message-Id: <1392228067-14817-3-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Remove unneeded sample buffers, intel_pstate operates on the most
recent sample only.  This save some memory and make the code more
readable.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c788abf..d692b10 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -96,8 +96,7 @@ struct cpudata {
 	u64	prev_aperf;
 	u64	prev_mperf;
 	unsigned long long prev_tsc;
-	int	sample_ptr;
-	struct sample samples[SAMPLE_COUNT];
+	struct sample sample;
 };
 
 static struct cpudata **all_cpu_data;
@@ -570,15 +569,15 @@ static inline void intel_pstate_sample(struct cpudata *cpu)
 	rdmsrl(MSR_IA32_MPERF, mperf);
 	tsc = native_read_tsc();
 
-	cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
-	cpu->samples[cpu->sample_ptr].aperf = aperf;
-	cpu->samples[cpu->sample_ptr].mperf = mperf;
-	cpu->samples[cpu->sample_ptr].tsc = tsc;
-	cpu->samples[cpu->sample_ptr].aperf -= cpu->prev_aperf;
-	cpu->samples[cpu->sample_ptr].mperf -= cpu->prev_mperf;
-	cpu->samples[cpu->sample_ptr].tsc -= cpu->prev_tsc;
 
-	intel_pstate_calc_busy(cpu, &cpu->samples[cpu->sample_ptr]);
+	cpu->sample.aperf = aperf;
+	cpu->sample.mperf = mperf;
+	cpu->sample.tsc = tsc;
+	cpu->sample.aperf -= cpu->prev_aperf;
+	cpu->sample.mperf -= cpu->prev_mperf;
+	cpu->sample.tsc -= cpu->prev_tsc;
+
+	intel_pstate_calc_busy(cpu, &cpu->sample);
 
 	cpu->prev_aperf = aperf;
 	cpu->prev_mperf = mperf;
@@ -598,7 +597,7 @@ static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
 {
 	int32_t core_busy, max_pstate, current_pstate;
 
-	core_busy = cpu->samples[cpu->sample_ptr].core_pct_busy;
+	core_busy = cpu->sample.core_pct_busy;
 	max_pstate = int_tofp(cpu->pstate.max_pstate);
 	current_pstate = int_tofp(cpu->pstate.current_pstate);
 	return mul_fp(core_busy, div_fp(max_pstate, current_pstate));
@@ -631,7 +630,7 @@ static void intel_pstate_timer_func(unsigned long __data)
 
 	intel_pstate_sample(cpu);
 
-	sample = &cpu->samples[cpu->sample_ptr];
+	sample = &cpu->sample;
 
 	intel_pstate_adjust_busy_pstate(cpu);
 
@@ -712,7 +711,7 @@ static unsigned int intel_pstate_get(unsigned int cpu_num)
 	cpu = all_cpu_data[cpu_num];
 	if (!cpu)
 		return 0;
-	sample = &cpu->samples[cpu->sample_ptr];
+	sample = &cpu->sample;
 	return sample->freq;
 }
 
-- 
1.8.3.1

