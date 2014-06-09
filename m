Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaFIVAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:00:30 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:55380 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932218AbaFIVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:00:26 -0400
Message-ID: <53962067.4060504@semaphore.gr>
Date: Tue, 10 Jun 2014 00:00:23 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] cpufreq: intel_pstate: Avoid duplicate call of intel_pstate_get_scaled_busy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store busy_scaled value to avoid to duplicate call of
intel_pstate_get_scaled_busy on every sampling interval.

Also, rename the function to intel_pstate_calc_scaled_busy.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/intel_pstate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 4e7f492..31e2ae5 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -55,6 +55,7 @@ static inline int32_t div_fp(int32_t x, int32_t y)
 
 struct sample {
 	int32_t core_pct_busy;
+	int32_t busy_scaled;
 	u64 aperf;
 	u64 mperf;
 	int freq;
@@ -604,7 +605,7 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
 	mod_timer_pinned(&cpu->timer, jiffies + delay);
 }
 
-static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
+static inline void intel_pstate_calc_scaled_busy(struct cpudata *cpu)
 {
 	int32_t core_busy, max_pstate, current_pstate, sample_ratio;
 	u32 duration_us;
@@ -624,20 +625,19 @@ static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
 		core_busy = mul_fp(core_busy, sample_ratio);
 	}
 
-	return core_busy;
+	cpu->sample.busy_scaled = core_busy;
 }
 
 static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
 {
-	int32_t busy_scaled;
 	struct _pid *pid;
 	signed int ctl = 0;
 	int steps;
 
 	pid = &cpu->pid;
-	busy_scaled = intel_pstate_get_scaled_busy(cpu);
+	intel_pstate_calc_scaled_busy(cpu);
 
-	ctl = pid_calc(pid, busy_scaled);
+	ctl = pid_calc(pid, cpu->sample.busy_scaled);
 
 	steps = abs(ctl);
 
@@ -659,7 +659,7 @@ static void intel_pstate_timer_func(unsigned long __data)
 	intel_pstate_adjust_busy_pstate(cpu);
 
 	trace_pstate_sample(fp_toint(sample->core_pct_busy),
-			fp_toint(intel_pstate_get_scaled_busy(cpu)),
+			fp_toint(sample->busy_scaled),
 			cpu->pstate.current_pstate,
 			sample->mperf,
 			sample->aperf,
-- 
1.9.3
