Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010Ab3E1NDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:03:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50103 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3E1NDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:03:52 -0400
Date: Tue, 28 May 2013 06:03:02 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-1b45adcd9a503428e6de6b39bc6892d86c9c1d41@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jwboyer@redhat.com,
        jacob.shin@amd.com, tglx@linutronix.de, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, jwboyer@redhat.com,
        jacob.shin@amd.com, tglx@linutronix.de, rric@kernel.org
In-Reply-To: <20130521110537.GG26912@twins.programming.kicks-ass.net>
References: <20130521110537.GG26912@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/amd: Rework AMD PMU init code
Git-Commit-ID: 1b45adcd9a503428e6de6b39bc6892d86c9c1d41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b45adcd9a503428e6de6b39bc6892d86c9c1d41
Gitweb:     http://git.kernel.org/tip/1b45adcd9a503428e6de6b39bc6892d86c9c1d41
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 21 May 2013 13:05:37 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:13:55 +0200

perf/x86/amd: Rework AMD PMU init code

Josh reported that his QEMU is a bad hardware emulator and trips a
WARN in the AMD PMU init code. He requested the WARN be turned into a
pr_err() or similar.

While there, rework the code a little.

Reported-by: Josh Boyer <jwboyer@redhat.com>
Acked-by: Robert Richter <rric@kernel.org>
Acked-by: Jacob Shin <jacob.shin@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130521110537.GG26912@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 7e28d94..4cbe032 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -648,48 +648,48 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.cpu_dead		= amd_pmu_cpu_dead,
 };
 
-static int setup_event_constraints(void)
+static int __init amd_core_pmu_init(void)
 {
-	if (boot_cpu_data.x86 == 0x15)
+	if (!cpu_has_perfctr_core)
+		return 0;
+
+	switch (boot_cpu_data.x86) {
+	case 0x15:
+		pr_cont("Fam15h ");
 		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
-	return 0;
-}
+		break;
 
-static int setup_perfctr_core(void)
-{
-	if (!cpu_has_perfctr_core) {
-		WARN(x86_pmu.get_event_constraints == amd_get_event_constraints_f15h,
-		     KERN_ERR "Odd, counter constraints enabled but no core perfctrs detected!");
+	default:
+		pr_err("core perfctr but no constraints; unknown hardware!\n");
 		return -ENODEV;
 	}
 
-	WARN(x86_pmu.get_event_constraints == amd_get_event_constraints,
-	     KERN_ERR "hw perf events core counters need constraints handler!");
-
 	/*
 	 * If core performance counter extensions exists, we must use
 	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
-	 * x86_pmu_addr_offset().
+	 * amd_pmu_addr_offset().
 	 */
 	x86_pmu.eventsel	= MSR_F15H_PERF_CTL;
 	x86_pmu.perfctr		= MSR_F15H_PERF_CTR;
 	x86_pmu.num_counters	= AMD64_NUM_COUNTERS_CORE;
 
-	printk(KERN_INFO "perf: AMD core performance counters detected\n");
-
+	pr_cont("core perfctr, ");
 	return 0;
 }
 
 __init int amd_pmu_init(void)
 {
+	int ret;
+
 	/* Performance-monitoring supported from K7 and later: */
 	if (boot_cpu_data.x86 < 6)
 		return -ENODEV;
 
 	x86_pmu = amd_pmu;
 
-	setup_event_constraints();
-	setup_perfctr_core();
+	ret = amd_core_pmu_init();
+	if (ret)
+		return ret;
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
