Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935034AbaFIXCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:02:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920AbaFIWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 66/78] intel_pstate: add sample time scaling
Date: Mon,  9 Jun 2014 15:48:46 -0700
Message-Id: <20140609224815.459190112@linuxfoundation.org>
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

commit c4ee841f602e5eef8eab673295c49c5b49d7732b upstream.

The PID assumes that samples are of equal time, which for a deferable
timers this is not true when the system goes idle.  This causes the
PID to take a long time to converge to the min P state and depending
on the pattern of the idle load can make the P state appear stuck.

The hold-off value of three sample times before using the scaling is
to give a grace period for applications that have high performance
requirements and spend a lot of time idle,  The poster child for this
behavior is the ffmpeg benchmark in the Phoronix test suite.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -60,6 +60,7 @@ struct sample {
 	u64 aperf;
 	u64 mperf;
 	int freq;
+	ktime_t time;
 };
 
 struct pstate_data {
@@ -97,6 +98,7 @@ struct cpudata {
 	struct vid_data vid;
 	struct _pid pid;
 
+	ktime_t last_sample_time;
 	u64	prev_aperf;
 	u64	prev_mperf;
 	struct sample sample;
@@ -583,6 +585,8 @@ static inline void intel_pstate_sample(s
 	aperf = aperf >> FRAC_BITS;
 	mperf = mperf >> FRAC_BITS;
 
+	cpu->last_sample_time = cpu->sample.time;
+	cpu->sample.time = ktime_get();
 	cpu->sample.aperf = aperf;
 	cpu->sample.mperf = mperf;
 	cpu->sample.aperf -= cpu->prev_aperf;
@@ -605,12 +609,24 @@ static inline void intel_pstate_set_samp
 
 static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
 {
-	int32_t core_busy, max_pstate, current_pstate;
+	int32_t core_busy, max_pstate, current_pstate, sample_ratio;
+	u32 duration_us;
+	u32 sample_time;
 
 	core_busy = cpu->sample.core_pct_busy;
 	max_pstate = int_tofp(cpu->pstate.max_pstate);
 	current_pstate = int_tofp(cpu->pstate.current_pstate);
 	core_busy = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
+
+	sample_time = (pid_params.sample_rate_ms  * USEC_PER_MSEC);
+	duration_us = (u32) ktime_us_delta(cpu->sample.time,
+					cpu->last_sample_time);
+	if (duration_us > sample_time * 3) {
+		sample_ratio = div_fp(int_tofp(sample_time),
+				int_tofp(duration_us));
+		core_busy = mul_fp(core_busy, sample_ratio);
+	}
+
 	return core_busy;
 }
 


