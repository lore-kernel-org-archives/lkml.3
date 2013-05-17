Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3EQVn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:43:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3EQVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Lothian <mike@fireburn.co.uk>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 083/102] cpufreq / intel_pstate: remove idle time and duration from sample and calculations
Date: Fri, 17 May 2013 14:36:38 -0700
Message-Id: <20130517213253.040195185@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 1abc4b20b85b42e8573957e54b193385cf48b0d6 upstream.

Idle time is taken into account in the APERF/MPERF ratio calculation
there is no reason for the driver to track it seperately.  This
reduces the work in the driver and makes the code more readable.

Removal of the tracking of sample duration removes the possibility of
the divide by zero exception when the duration is sub 1us

References: https://bugzilla.kernel.org/show_bug.cgi?id=56691
Reported-by: Mike Lothian <mike@fireburn.co.uk>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   43 ++++++-----------------------------------
 1 file changed, 7 insertions(+), 36 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -48,12 +48,7 @@ static inline int32_t div_fp(int32_t x,
 }
 
 struct sample {
-	ktime_t start_time;
-	ktime_t end_time;
 	int core_pct_busy;
-	int pstate_pct_busy;
-	u64 duration_us;
-	u64 idletime_us;
 	u64 aperf;
 	u64 mperf;
 	int freq;
@@ -91,8 +86,6 @@ struct cpudata {
 	int min_pstate_count;
 	int idle_mode;
 
-	ktime_t prev_sample;
-	u64	prev_idle_time_us;
 	u64	prev_aperf;
 	u64	prev_mperf;
 	int	sample_ptr;
@@ -450,48 +443,26 @@ static inline void intel_pstate_calc_bus
 					struct sample *sample)
 {
 	u64 core_pct;
-	sample->pstate_pct_busy = 100 - div64_u64(
-					sample->idletime_us * 100,
-					sample->duration_us);
 	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
 	sample->freq = cpu->pstate.max_pstate * core_pct * 1000;
 
-	sample->core_pct_busy = div_s64((sample->pstate_pct_busy * core_pct),
-					100);
+	sample->core_pct_busy = core_pct;
 }
 
 static inline void intel_pstate_sample(struct cpudata *cpu)
 {
-	ktime_t now;
-	u64 idle_time_us;
 	u64 aperf, mperf;
 
-	now = ktime_get();
-	idle_time_us = get_cpu_idle_time_us(cpu->cpu, NULL);
-
 	rdmsrl(MSR_IA32_APERF, aperf);
 	rdmsrl(MSR_IA32_MPERF, mperf);
-	/* for the first sample, don't actually record a sample, just
-	 * set the baseline */
-	if (cpu->prev_idle_time_us > 0) {
-		cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
-		cpu->samples[cpu->sample_ptr].start_time = cpu->prev_sample;
-		cpu->samples[cpu->sample_ptr].end_time = now;
-		cpu->samples[cpu->sample_ptr].duration_us =
-			ktime_us_delta(now, cpu->prev_sample);
-		cpu->samples[cpu->sample_ptr].idletime_us =
-			idle_time_us - cpu->prev_idle_time_us;
-
-		cpu->samples[cpu->sample_ptr].aperf = aperf;
-		cpu->samples[cpu->sample_ptr].mperf = mperf;
-		cpu->samples[cpu->sample_ptr].aperf -= cpu->prev_aperf;
-		cpu->samples[cpu->sample_ptr].mperf -= cpu->prev_mperf;
+	cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
+	cpu->samples[cpu->sample_ptr].aperf = aperf;
+	cpu->samples[cpu->sample_ptr].mperf = mperf;
+	cpu->samples[cpu->sample_ptr].aperf -= cpu->prev_aperf;
+	cpu->samples[cpu->sample_ptr].mperf -= cpu->prev_mperf;
 
-		intel_pstate_calc_busy(cpu, &cpu->samples[cpu->sample_ptr]);
-	}
+	intel_pstate_calc_busy(cpu, &cpu->samples[cpu->sample_ptr]);
 
-	cpu->prev_sample = now;
-	cpu->prev_idle_time_us = idle_time_us;
 	cpu->prev_aperf = aperf;
 	cpu->prev_mperf = mperf;
 }


