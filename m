Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934564AbaFIW7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:59:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934028AbaFIWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 63/78] intel_pstate: remove unneeded sample buffers
Date: Mon,  9 Jun 2014 15:48:43 -0700
Message-Id: <20140609224815.368972577@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit d37e2b764499e092ebc493d6f980827feb952e23 upstream.

Remove unneeded sample buffers, intel_pstate operates on the most
recent sample only.  This save some memory and make the code more
readable.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -101,8 +101,7 @@ struct cpudata {
 	u64	prev_aperf;
 	u64	prev_mperf;
 	unsigned long long prev_tsc;
-	int	sample_ptr;
-	struct sample samples[SAMPLE_COUNT];
+	struct sample sample;
 };
 
 static struct cpudata **all_cpu_data;
@@ -590,15 +589,14 @@ static inline void intel_pstate_sample(s
 	mperf = mperf >> FRAC_BITS;
 	tsc = tsc >> FRAC_BITS;
 
-	cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
-	cpu->samples[cpu->sample_ptr].aperf = aperf;
-	cpu->samples[cpu->sample_ptr].mperf = mperf;
-	cpu->samples[cpu->sample_ptr].tsc = tsc;
-	cpu->samples[cpu->sample_ptr].aperf -= cpu->prev_aperf;
-	cpu->samples[cpu->sample_ptr].mperf -= cpu->prev_mperf;
-	cpu->samples[cpu->sample_ptr].tsc -= cpu->prev_tsc;
+	cpu->sample.aperf = aperf;
+	cpu->sample.mperf = mperf;
+	cpu->sample.tsc = tsc;
+	cpu->sample.aperf -= cpu->prev_aperf;
+	cpu->sample.mperf -= cpu->prev_mperf;
+	cpu->sample.tsc -= cpu->prev_tsc;
 
-	intel_pstate_calc_busy(cpu, &cpu->samples[cpu->sample_ptr]);
+	intel_pstate_calc_busy(cpu, &cpu->sample);
 
 	cpu->prev_aperf = aperf;
 	cpu->prev_mperf = mperf;
@@ -618,7 +616,7 @@ static inline int32_t intel_pstate_get_s
 {
 	int32_t core_busy, max_pstate, current_pstate;
 
-	core_busy = cpu->samples[cpu->sample_ptr].core_pct_busy;
+	core_busy = cpu->sample.core_pct_busy;
 	max_pstate = int_tofp(cpu->pstate.max_pstate);
 	current_pstate = int_tofp(cpu->pstate.current_pstate);
 	core_busy = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
@@ -652,7 +650,7 @@ static void intel_pstate_timer_func(unsi
 
 	intel_pstate_sample(cpu);
 
-	sample = &cpu->samples[cpu->sample_ptr];
+	sample = &cpu->sample;
 
 	intel_pstate_adjust_busy_pstate(cpu);
 
@@ -727,7 +725,7 @@ static unsigned int intel_pstate_get(uns
 	cpu = all_cpu_data[cpu_num];
 	if (!cpu)
 		return 0;
-	sample = &cpu->samples[cpu->sample_ptr];
+	sample = &cpu->sample;
 	return sample->freq;
 }
 


