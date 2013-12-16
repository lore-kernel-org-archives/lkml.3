Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3LPR2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:28:25 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44730 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab3LPR2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:28:23 -0500
Message-ID: <52AF3833.1070204@gmail.com>
Date: Mon, 16 Dec 2013 09:28:19 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, Joakim Hernberg <jbh@alchemy.lu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Problem: Possible regression in intel_pstate on 3.12
References: <20131208172508.0cacabd0@tor.valhalla.alchemy.lu> <CAKohpom+xmPfpAa6qeNq+mghknrxj03B+-=Vtqj-7iR-OgOv6A@mail.gmail.com>
In-Reply-To: <CAKohpom+xmPfpAa6qeNq+mghknrxj03B+-=Vtqj-7iR-OgOv6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joakim,

Add the following patch to your v3.12 kernel and collect some data with the
command and send the resulting perf.data file:
     perf record -a -c 1 -e power:pstate_sample sleep 10


TIA
--Dirk

commit b3dc2c2a106cea68e4c9c0f4747b15291113c4ae
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Mon Dec 2 09:56:46 2013 -0800

     intel_pstate: Add trace point to report internal state.

     Add perf trace event "power:pstate_sample" to report driver state to
     aid in diagnosing issues reported against intel_pstate.

     Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
  drivers/cpufreq/intel_pstate.c | 22 ++++++++++++++++++
  include/trace/events/power.h   | 53 ++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 75 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 5f1cbae..c4f14d1 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -50,6 +50,8 @@ static inline int32_t div_fp(int32_t x, int32_t y)
  	return div_s64((int64_t)x << FRAC_BITS, (int64_t)y);
  }

+static u64 energy_divisor;
+
  struct sample {
  	int32_t core_pct_busy;
  	u64 aperf;
@@ -512,6 +514,7 @@ static inline void intel_pstate_sample(struct cpudata *cpu)

  	rdmsrl(MSR_IA32_APERF, aperf);
  	rdmsrl(MSR_IA32_MPERF, mperf);
+
  	cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
  	cpu->samples[cpu->sample_ptr].aperf = aperf;
  	cpu->samples[cpu->sample_ptr].mperf = mperf;
@@ -565,10 +568,24 @@ static inline void intel_pstate_adjust_busy_pstate(struct 
cpudata *cpu)
  static void intel_pstate_timer_func(unsigned long __data)
  {
  	struct cpudata *cpu = (struct cpudata *) __data;
+	struct sample *sample;
+	u64 energy;

  	intel_pstate_sample(cpu);
+
+	sample = &cpu->samples[cpu->sample_ptr];
+	rdmsrl(MSR_PKG_ENERGY_STATUS, energy);
+
  	intel_pstate_adjust_busy_pstate(cpu);

+	trace_pstate_sample(fp_toint(sample->core_pct_busy),
+			fp_toint(intel_pstate_get_scaled_busy(cpu)),
+			cpu->pstate.current_pstate,
+			sample->mperf,
+			sample->aperf,
+			energy/energy_divisor,
+			sample->freq);
+
  	if (cpu->pstate.current_pstate == cpu->pstate.min_pstate) {
  		cpu->min_pstate_count++;
  		if (!(cpu->min_pstate_count % 5)) {
@@ -849,6 +866,7 @@ static int __init intel_pstate_init(void)
  	int cpu, rc = 0;
  	const struct x86_cpu_id *id;
  	struct cpu_defaults *cpu_info;
+	u64 units;

  	if (no_load)
  		return -ENODEV;
@@ -882,8 +900,12 @@ static int __init intel_pstate_init(void)
  	if (rc)
  		goto out;

+	rdmsrl(MSR_RAPL_POWER_UNIT, units);
+	energy_divisor = 1 << ((units >> 8) & 0x1f); /* bits{12:8} */
+
  	intel_pstate_debug_expose_params();
  	intel_pstate_sysfs_expose_params();
+
  	return rc;
  out:
  	get_online_cpus();
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index cda100d..9e9475c 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -35,6 +35,59 @@ DEFINE_EVENT(cpu, cpu_idle,
  	TP_ARGS(state, cpu_id)
  );

+TRACE_EVENT(pstate_sample,
+
+	TP_PROTO(u32 core_busy,
+		u32 scaled_busy,
+		u32 state,
+		u64 mperf,
+		u64 aperf,
+		u32 energy,
+		u32 freq
+		),
+
+	TP_ARGS(core_busy,
+		scaled_busy,
+		state,
+		mperf,
+		aperf,
+		energy,
+		freq
+		),
+
+	TP_STRUCT__entry(
+		__field(u32, core_busy)
+		__field(u32, scaled_busy)
+		__field(u32, state)
+		__field(u64, mperf)
+		__field(u64, aperf)
+		__field(u32, energy)
+		__field(u32, freq)
+
+	),
+
