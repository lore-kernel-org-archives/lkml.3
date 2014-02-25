Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaBYSfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:35:53 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53690 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaBYSfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:35:51 -0500
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, gf435@gmx.net, bp@alien8.de,
        dirk.brandewie@gmail.com, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH] intel_pstate: Change busy calculation to use fixed point math.
Date: Tue, 25 Feb 2014 10:35:37 -0800
Message-Id: <1393353337-19778-1-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20140219224752.GA370@kroah.com>
References: <20140219224752.GA370@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Commit fcb6a15c2e Take core C0 time into account for core busy calculation.

Introduced a regression on some processor SKUs supported by
intel_pstate. This was caused by the truncation caused by using
integer math to calculate core busy and C0 percentages.

On a i7-4770K processor operating at 800Mhz going to 100% utilization
the percent busy of the CPU using integer math is 22% it actually is
22.85%.  This value scaled to the current frequency returned 97 which
the PID interpreted as no error and did not adjust the P state.

Tested on i7-4770K, i7-2600, i5-3230M

References:
   https://lkml.org/lkml/2014/2/19/626
   https://bugzilla.kernel.org/show_bug.cgi?id=70941

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e908161..2cd36b9 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -39,9 +39,10 @@
 #define BYT_TURBO_RATIOS	0x66c
 
 
-#define FRAC_BITS 8
+#define FRAC_BITS 6
 #define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
 #define fp_toint(X) ((X) >> FRAC_BITS)
+#define FP_ROUNDUP(X) ((X) += 1 << FRAC_BITS)
 
 static inline int32_t mul_fp(int32_t x, int32_t y)
 {
@@ -556,18 +557,20 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 static inline void intel_pstate_calc_busy(struct cpudata *cpu,
 					struct sample *sample)
 {
-	u64 core_pct;
-	u64 c0_pct;
+	int32_t core_pct;
+	int32_t c0_pct;
 
-	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
+	core_pct = div_fp(int_tofp((sample->aperf)),
+			int_tofp((sample->mperf)));
+	core_pct = mul_fp(core_pct, int_tofp(100));
+	FP_ROUNDUP(core_pct);
+
+	c0_pct = div_fp(int_tofp(sample->mperf), int_tofp(sample->tsc));
 
-	c0_pct = div64_u64(sample->mperf * 100, sample->tsc);
 	sample->freq = fp_toint(
-		mul_fp(int_tofp(cpu->pstate.max_pstate),
-			int_tofp(core_pct * 1000)));
+		mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
 
-	sample->core_pct_busy = mul_fp(int_tofp(core_pct),
-				div_fp(int_tofp(c0_pct + 1), int_tofp(100)));
+	sample->core_pct_busy = mul_fp(core_pct, c0_pct);
 }
 
 static inline void intel_pstate_sample(struct cpudata *cpu)
@@ -579,6 +582,10 @@ static inline void intel_pstate_sample(struct cpudata *cpu)
 	rdmsrl(MSR_IA32_MPERF, mperf);
 	tsc = native_read_tsc();
 
+	aperf = aperf >> FRAC_BITS;
+	mperf = mperf >> FRAC_BITS;
+	tsc = tsc >> FRAC_BITS;
+
 	cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
 	cpu->samples[cpu->sample_ptr].aperf = aperf;
 	cpu->samples[cpu->sample_ptr].mperf = mperf;
@@ -610,7 +617,8 @@ static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
 	core_busy = cpu->samples[cpu->sample_ptr].core_pct_busy;
 	max_pstate = int_tofp(cpu->pstate.max_pstate);
 	current_pstate = int_tofp(cpu->pstate.current_pstate);
-	return mul_fp(core_busy, div_fp(max_pstate, current_pstate));
+	core_busy = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
+	return FP_ROUNDUP(core_busy);
 }
 
 static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
-- 
1.8.3.1

