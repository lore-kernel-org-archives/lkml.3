Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbaJCWVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:21:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbaJCWQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:16:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Peter Zijlstra <peterz@infradead.org>, zheng.z.yan@intel.com,
        eranian@google.com, ak@linux.intel.com, Ingo Molnar <mingo@kernel.org>,
        Thomas D <whissi@whissi.de>
Subject: [PATCH 3.14 233/238] perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU
Date: Fri,  3 Oct 2014 14:32:28 -0700
Message-Id: <20141003212921.121289341@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkatesh Srinivas <venkateshs@google.com>

commit 24223657806a0ebd0ae5c9caaf7b021091889cf2 upstream.

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
[backport by whissi]
Cc: Thomas D <whissi@whissi.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -511,6 +511,7 @@ static int rapl_cpu_prepare(int cpu)
 	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
 	int phys_id = topology_physical_package_id(cpu);
 	u64 ms;
+	u64 msr_rapl_power_unit_bits;
 
 	if (pmu)
 		return 0;
@@ -518,6 +519,9 @@ static int rapl_cpu_prepare(int cpu)
 	if (phys_id < 0)
 		return -1;
 
+	if (!rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
+		return -1;
+
 	pmu = kzalloc_node(sizeof(*pmu), GFP_KERNEL, cpu_to_node(cpu));
 	if (!pmu)
 		return -1;
@@ -531,8 +535,7 @@ static int rapl_cpu_prepare(int cpu)
 	 *
 	 * we cache in local PMU instance
 	 */
-	rdmsrl(MSR_RAPL_POWER_UNIT, pmu->hw_unit);
-	pmu->hw_unit = (pmu->hw_unit >> 8) & 0x1FULL;
+	pmu->hw_unit = (msr_rapl_power_unit_bits >> 8) & 0x1FULL;
 	pmu->pmu = &rapl_pmu_class;
 
 	/*
@@ -649,7 +652,9 @@ static int __init rapl_pmu_init(void)
 	get_online_cpus();
 
 	for_each_online_cpu(cpu) {
-		rapl_cpu_prepare(cpu);
+		ret = rapl_cpu_prepare(cpu);
+		if (ret)
+			goto out;
 		rapl_cpu_init(cpu);
 	}
 
@@ -672,6 +677,7 @@ static int __init rapl_pmu_init(void)
 		hweight32(rapl_cntr_mask),
 		ktime_to_ms(pmu->timer_interval));
 
+out:
 	put_online_cpus();
 
 	return 0;


