Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3LSMBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:01:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45429 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab3LSMAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:00:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 205/208] intel_pstate: Fix type mismatch warning
Date: Thu, 19 Dec 2013 11:55:03 +0000
Message-Id: <1387454106-19326-206-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 09c87e2f79eb336bd313090be8113ae29345b8f5 upstream.

The expression in line 398 of intel_pstate.c causes the following
warning to be emitted:

drivers/cpufreq/intel_pstate.c:398:3: warning: left shift count >= width of type

which happens because unsigned long is 32-bit on some architectures.

Fix that by using a helper u64 variable and simplify the code
slightly.

Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index f112f7d..315c6f9 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -383,6 +383,7 @@ static void intel_pstate_get_min_max(struct cpudata *cpu, int *min, int *max)
 static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 {
 	int max_perf, min_perf;
+	u64 val;
 
 	intel_pstate_get_min_max(cpu, &min_perf, &max_perf);
 
@@ -394,11 +395,11 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 	trace_cpu_frequency(pstate * 100000, cpu->cpu);
 
 	cpu->pstate.current_pstate = pstate;
+	val = pstate << 8;
 	if (limits.no_turbo)
-		wrmsrl(MSR_IA32_PERF_CTL, BIT(32) | (pstate << 8));
-	else
-		wrmsrl(MSR_IA32_PERF_CTL, pstate << 8);
+		val |= (u64)1 << 32;
 
+	wrmsrl(MSR_IA32_PERF_CTL, val);
 }
 
 static inline void intel_pstate_pstate_increase(struct cpudata *cpu, int steps)
-- 
1.8.3.2

