Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab3JPUxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:53:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62466 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760800Ab3JPUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:53:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        dirk.brandewie@gmail.com, Dirk Brandewie <dirk.j.brandewie@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Resend][PATCH] intel_pstate: Fix type mismatch warning
Date: Wed, 16 Oct 2013 23:05:03 +0200
Message-ID: <1581193.8IWGTM6KOa@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <525ECBDE.5000801@linux.intel.com>
References: <9494730.EGV2mTSpNl@vostro.rjw.lan> <2582369.lNhAMrrx8s@vostro.rjw.lan> <525ECBDE.5000801@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The expression in line 398 of intel_pstate.c causes the following
warning to be emitted:

drivers/cpufreq/intel_pstate.c:398:3: warning: left shift count >= width of type

which happens because unsigned long is 32-bit on some architectures.

Fix that by using a helper u64 variable and simplify the code
slightly.

Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpufreq/intel_pstate.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/cpufreq/intel_pstate.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/intel_pstate.c
+++ linux-pm/drivers/cpufreq/intel_pstate.c
@@ -383,6 +383,7 @@ static void intel_pstate_get_min_max(str
 static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 {
 	int max_perf, min_perf;
+	u64 val;
 
 	intel_pstate_get_min_max(cpu, &min_perf, &max_perf);
 
@@ -394,11 +395,11 @@ static void intel_pstate_set_pstate(stru
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

