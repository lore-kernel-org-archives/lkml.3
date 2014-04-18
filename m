Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaDRNJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:09:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaDRNJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:09:04 -0400
Date: Fri, 18 Apr 2014 06:08:07 -0700
From: tip-bot for Venkatesh Srinivas <tipbot@zytor.com>
Message-ID: <tip-24223657806a0ebd0ae5c9caaf7b021091889cf2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, venkateshs@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, venkateshs@google.com
In-Reply-To: <1394739386-22260-1-git-send-email-venkateshs@google.com>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Use rdmsrl_safe()
  when initializing RAPL PMU
Git-Commit-ID: 24223657806a0ebd0ae5c9caaf7b021091889cf2
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

Commit-ID:  24223657806a0ebd0ae5c9caaf7b021091889cf2
Gitweb:     http://git.kernel.org/tip/24223657806a0ebd0ae5c9caaf7b021091889cf2
Author:     Venkatesh Srinivas <venkateshs@google.com>
AuthorDate: Thu, 13 Mar 2014 12:36:26 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:14:26 +0200

perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU

CPUs which should support the RAPL counters according to
Family/Model/Stepping may still issue #GP when attempting to access
the RAPL MSRs. This may happen when Linux is running under KVM and
we are passing-through host F/M/S data, for example. Use rdmsrl_safe
to first access the RAPL_POWER_UNIT MSR; if this fails, do not
attempt to use this PMU.

Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1394739386-22260-1-git-send-email-venkateshs@google.com
Cc: zheng.z.yan@intel.com
Cc: eranian@google.com
Cc: ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
[ The patch also silently fixes another bug: rapl_pmu_init() didn't handle the memory alloc failure case previously. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 4b9a9e9..7c87424 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -535,6 +535,7 @@ static int rapl_cpu_prepare(int cpu)
 	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
 	int phys_id = topology_physical_package_id(cpu);
 	u64 ms;
+	u64 msr_rapl_power_unit_bits;
 
 	if (pmu)
 		return 0;
@@ -542,6 +543,9 @@ static int rapl_cpu_prepare(int cpu)
 	if (phys_id < 0)
 		return -1;
 
+	if (!rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
+		return -1;
+
 	pmu = kzalloc_node(sizeof(*pmu), GFP_KERNEL, cpu_to_node(cpu));
 	if (!pmu)
 		return -1;
@@ -555,8 +559,7 @@ static int rapl_cpu_prepare(int cpu)
 	 *
 	 * we cache in local PMU instance
 	 */
-	rdmsrl(MSR_RAPL_POWER_UNIT, pmu->hw_unit);
-	pmu->hw_unit = (pmu->hw_unit >> 8) & 0x1FULL;
+	pmu->hw_unit = (msr_rapl_power_unit_bits >> 8) & 0x1FULL;
 	pmu->pmu = &rapl_pmu_class;
 
 	/*
@@ -677,7 +680,9 @@ static int __init rapl_pmu_init(void)
 	cpu_notifier_register_begin();
 
 	for_each_online_cpu(cpu) {
-		rapl_cpu_prepare(cpu);
+		ret = rapl_cpu_prepare(cpu);
+		if (ret)
+			goto out;
 		rapl_cpu_init(cpu);
 	}
 
@@ -700,6 +705,7 @@ static int __init rapl_pmu_init(void)
 		hweight32(rapl_cntr_mask),
 		ktime_to_ms(pmu->timer_interval));
 
+out:
 	cpu_notifier_register_done();
 
 	return 0;
