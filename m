Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaIIWNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:13:21 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46913 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaIIWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:12:40 -0400
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: dirk.j.brandewie@intel.com
Cc: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [PATCH 5/6] PID: Rename counters to make them more generic
Date: Tue,  9 Sep 2014 18:12:07 -0400
Message-Id: <1410300728-26637-6-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aperf/Mperf are very X86 specific names but effectively
count Delivered and Reference Cpu performance values.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
---
 drivers/cpufreq/intel_pid_ctrl.c | 12 ++++++------
 drivers/cpufreq/pid_ctrl.c       | 10 +++++-----
 drivers/cpufreq/pid_ctrl.h       |  8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/intel_pid_ctrl.c b/drivers/cpufreq/intel_pid_ctrl.c
index 73faaf8..e0b007d 100644
--- a/drivers/cpufreq/intel_pid_ctrl.c
+++ b/drivers/cpufreq/intel_pid_ctrl.c
@@ -193,14 +193,14 @@ static void intel_get_sample(struct cpudata *cpu)
 	aperf = aperf >> FRAC_BITS;
 	mperf = mperf >> FRAC_BITS;
 
-	cpu->sample.aperf = aperf;
-	cpu->sample.mperf = mperf;
+	cpu->sample.delivered = aperf;
+	cpu->sample.reference = mperf;
 
-	cpu->sample.aperf -= cpu->prev_aperf;
-	cpu->sample.mperf -= cpu->prev_mperf;
+	cpu->sample.delivered -= cpu->prev_delivered;
+	cpu->sample.reference -= cpu->prev_reference;
 
-	cpu->prev_aperf = aperf;
-	cpu->prev_mperf = mperf;
+	cpu->prev_delivered = aperf;
+	cpu->prev_reference = mperf;
 }
 
 static struct cpu_defaults core_params = {
diff --git a/drivers/cpufreq/pid_ctrl.c b/drivers/cpufreq/pid_ctrl.c
index a011f05..2c197b2 100644
--- a/drivers/cpufreq/pid_ctrl.c
+++ b/drivers/cpufreq/pid_ctrl.c
@@ -321,10 +321,10 @@ static inline void pid_ctrl_calc_busy(struct cpudata *cpu)
 	int64_t core_pct;
 	int32_t rem;
 
-	core_pct = int_tofp(sample->aperf) * int_tofp(100);
-	core_pct = div_u64_rem(core_pct, int_tofp(sample->mperf), &rem);
+	core_pct = int_tofp(sample->delivered) * int_tofp(100);
+	core_pct = div_u64_rem(core_pct, int_tofp(sample->reference), &rem);
 
-	if ((rem << 1) >= int_tofp(sample->mperf))
+	if ((rem << 1) >= int_tofp(sample->reference))
 		core_pct += 1;
 
 	sample->freq = fp_toint(
@@ -410,8 +410,8 @@ static void pid_ctrl_timer_func(unsigned long __data)
 	trace_pstate_sample(fp_toint(sample->core_pct_busy),
 			fp_toint(pid_ctrl_get_scaled_busy(cpu)),
 			cpu->pstate.current_pstate,
-			sample->mperf,
-			sample->aperf,
+			sample->reference,
+			sample->delivered,
 			sample->freq);
 
 	pid_ctrl_set_sample_time(cpu);
diff --git a/drivers/cpufreq/pid_ctrl.h b/drivers/cpufreq/pid_ctrl.h
index 7f732e6..65f08bc 100644
--- a/drivers/cpufreq/pid_ctrl.h
+++ b/drivers/cpufreq/pid_ctrl.h
@@ -24,8 +24,8 @@
 
 struct sample {
 	int32_t core_pct_busy;
-	u64 aperf;
-	u64 mperf;
+	u64 delivered;
+	u64 reference;
 	int freq;
 	ktime_t time;
 };
@@ -65,8 +65,8 @@ struct cpudata {
 	struct _pid pid;
 
 	ktime_t last_sample_time;
-	u64	prev_aperf;
-	u64	prev_mperf;
+	u64	prev_delivered;
+	u64	prev_reference;
 	struct sample sample;
 };
 
-- 
1.9.1

