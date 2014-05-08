Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaEHT6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:58:17 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62541 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaEHT5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:57:46 -0400
X-Google-Original-From: dirk.j.brandewie@intel.com
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, dirk.brandewie@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 4/5] intel_pstate: Remove C0 tracking
Date: Thu,  8 May 2014 12:57:26 -0700
Message-Id: <1399579047-5792-5-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Commit fcb6a15c intel_pstate: Take core C0 time into account for core busy
introduced a regression referenced below.  The issue with "lockup"
after suspend that this commit was addressing is now dealt with in the
suspend path.

References:
   https://bugzilla.kernel.org/show_bug.cgi?id=66581
   https://bugzilla.kernel.org/show_bug.cgi?id=75121

Reported-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index bb20881..4c26faf 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -59,7 +59,6 @@ struct sample {
 	int32_t core_pct_busy;
 	u64 aperf;
 	u64 mperf;
-	unsigned long long tsc;
 	int freq;
 };
 
@@ -100,7 +99,6 @@ struct cpudata {
 
 	u64	prev_aperf;
 	u64	prev_mperf;
-	unsigned long long prev_tsc;
 	struct sample sample;
 };
 
@@ -561,46 +559,37 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
 					struct sample *sample)
 {
 	int32_t core_pct;
-	int32_t c0_pct;
 
 	core_pct = div_fp(int_tofp((sample->aperf)),
 			int_tofp((sample->mperf)));
 	core_pct = mul_fp(core_pct, int_tofp(100));
 	FP_ROUNDUP(core_pct);
 
-	c0_pct = div_fp(int_tofp(sample->mperf), int_tofp(sample->tsc));
-
 	sample->freq = fp_toint(
 		mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
 
-	sample->core_pct_busy = mul_fp(core_pct, c0_pct);
+	sample->core_pct_busy = core_pct;
 }
 
 static inline void intel_pstate_sample(struct cpudata *cpu)
 {
 	u64 aperf, mperf;
-	unsigned long long tsc;
 
 	rdmsrl(MSR_IA32_APERF, aperf);
 	rdmsrl(MSR_IA32_MPERF, mperf);
-	tsc = native_read_tsc();
 
 	aperf = aperf >> FRAC_BITS;
 	mperf = mperf >> FRAC_BITS;
-	tsc = tsc >> FRAC_BITS;
 
 	cpu->sample.aperf = aperf;
 	cpu->sample.mperf = mperf;
-	cpu->sample.tsc = tsc;
 	cpu->sample.aperf -= cpu->prev_aperf;
 	cpu->sample.mperf -= cpu->prev_mperf;
-	cpu->sample.tsc -= cpu->prev_tsc;
 
 	intel_pstate_calc_busy(cpu, &cpu->sample);
 
 	cpu->prev_aperf = aperf;
 	cpu->prev_mperf = mperf;
-	cpu->prev_tsc = tsc;
 }
 
 static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
-- 
1.9.0

