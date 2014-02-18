Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaBRWqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaBRWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 25/26] intel_pstate: Take core C0 time into account for core busy calculation
Date: Tue, 18 Feb 2014 14:47:21 -0800
Message-Id: <20140218224531.118777881@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224530.398913499@linuxfoundation.org>
References: <20140218224530.398913499@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 upstream.

Take non-idle time into account when calculating core busy time.
This ensures that intel_pstate will notice a decrease in load.

References: https://bugzilla.kernel.org/show_bug.cgi?id=66581
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -51,6 +51,7 @@ struct sample {
 	int32_t core_pct_busy;
 	u64 aperf;
 	u64 mperf;
+	unsigned long long tsc;
 	int freq;
 };
 
@@ -86,6 +87,7 @@ struct cpudata {
 
 	u64	prev_aperf;
 	u64	prev_mperf;
+	unsigned long long prev_tsc;
 	int	sample_ptr;
 	struct sample samples[SAMPLE_COUNT];
 };
@@ -435,11 +437,17 @@ static inline void intel_pstate_calc_bus
 					struct sample *sample)
 {
 	u64 core_pct;
-	core_pct = div64_u64(int_tofp(sample->aperf * 100),
-			     sample->mperf);
-	sample->freq = fp_toint(cpu->pstate.max_pstate * core_pct * 1000);
+	u64 c0_pct;
 
-	sample->core_pct_busy = core_pct;
+	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
+
+	c0_pct = div64_u64(sample->mperf * 100, sample->tsc);
+	sample->freq = fp_toint(
+		mul_fp(int_tofp(cpu->pstate.max_pstate),
+			int_tofp(core_pct * 1000)));
+
+	sample->core_pct_busy = mul_fp(int_tofp(core_pct),
+				div_fp(int_tofp(c0_pct + 1), int_tofp(100)));
 }
 
 static inline void intel_pstate_sample(struct cpudata *cpu)


