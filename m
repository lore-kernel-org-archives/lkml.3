Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbaD2Rxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:53:54 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:41999 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932491AbaD2Rxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:53:53 -0400
Message-ID: <535FE72D.2020402@semaphore.gr>
Date: Tue, 29 Apr 2014 20:53:49 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: intel_pstate: Remove sample parameter in intel_pstate_calc_busy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit d37e2b7644 ("intel_pstate: remove unneeded sample buffers")
we use only one sample. So, there is no need to pass the sample
pointer to intel_pstate_calc_busy. Instead, get the pointer from
cpudata. Also, remove the unused SAMPLE_COUNT macro.

While at it, reformat the first line in this function.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/intel_pstate.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 95b3958..8192ff1 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -32,8 +32,6 @@
 #include <asm/msr.h>
 #include <asm/cpu_device_id.h>
 
-#define SAMPLE_COUNT		3
-
 #define BYT_RATIOS		0x66a
 #define BYT_VIDS		0x66b
 #define BYT_TURBO_RATIOS	0x66c
@@ -553,14 +551,13 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
 }
 
-static inline void intel_pstate_calc_busy(struct cpudata *cpu,
-					struct sample *sample)
+static inline void intel_pstate_calc_busy(struct cpudata *cpu)
 {
+	struct sample *sample = &cpu->sample;
 	int32_t core_pct;
 	int32_t c0_pct;
 
-	core_pct = div_fp(int_tofp((sample->aperf)),
-			int_tofp((sample->mperf)));
+	core_pct = div_fp(int_tofp(sample->aperf), int_tofp(sample->mperf));
 	core_pct = mul_fp(core_pct, int_tofp(100));
 	FP_ROUNDUP(core_pct);
 
@@ -595,7 +592,7 @@ static inline void intel_pstate_sample(struct cpudata *cpu)
 	cpu->sample.mperf -= cpu->prev_mperf;
 	cpu->sample.tsc -= cpu->prev_tsc;
 
-	intel_pstate_calc_busy(cpu, &cpu->sample);
+	intel_pstate_calc_busy(cpu);
 
 	cpu->prev_aperf = aperf;
 	cpu->prev_mperf = mperf;
-- 
1.9.0
