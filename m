Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaFEOjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:39:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFEOjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:39:44 -0400
Date: Thu, 5 Jun 2014 07:38:33 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-edcb4d3c36a6429caa03ddfeab4cbb153c7002b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, grant.likely@linaro.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        will.deacon@arm.com, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, linux@arm.linux.org.uk, robh+dt@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        paulus@samba.org, linux-kernel@vger.kernel.org, will.deacon@arm.com,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, robh+dt@kernel.org, linux@arm.linux.org.uk,
        tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1405161712190.11099@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405161712190.11099@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/ARM: Use common PMU interrupt disabled code
Git-Commit-ID: edcb4d3c36a6429caa03ddfeab4cbb153c7002b2
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

Commit-ID:  edcb4d3c36a6429caa03ddfeab4cbb153c7002b2
Gitweb:     http://git.kernel.org/tip/edcb4d3c36a6429caa03ddfeab4cbb153c7002b2
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 16 May 2014 17:15:49 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:30:00 +0200

perf/ARM: Use common PMU interrupt disabled code

Make the ARM perf code use the new common PMU interrupt disabled code.

This allows perf to work on ARM machines without a working PMU
interrupt (for example, raspberry pi).

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
[peterz: applied changes suggested by Will]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1405161712190.11099@vincent-weaver-1.umelst.maine.edu
[ Small readability tweaks to the code. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/kernel/perf_event.c     | 2 +-
 arch/arm/kernel/perf_event_cpu.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index a6bc431..4238bcb 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -410,7 +410,7 @@ __hw_perf_event_init(struct perf_event *event)
 	 */
 	hwc->config_base	    |= (unsigned long)mapping;
 
-	if (!hwc->sample_period) {
+	if (!is_sampling_event(event)) {
 		/*
 		 * For non-sampling runs, limit the sample_period to half
 		 * of the counter width. That way, the new counter value
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 51798d7..bbdbffd 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -126,8 +126,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
 	if (irqs < 1) {
-		pr_err("no irqs for PMUs defined\n");
-		return -ENODEV;
+		printk_once("perf/ARM: No irqs for PMU defined, sampling events not supported\n");
+		return 0;
 	}
 
 	irq = platform_get_irq(pmu_device, 0);
@@ -191,6 +191,10 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
 	/* Ensure the PMU has sane values out of reset. */
 	if (cpu_pmu->reset)
 		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
+
+	/* If no interrupts available, set the corresponding capability flag */
+	if (!platform_get_irq(cpu_pmu->plat_device, 0))
+		cpu_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
 }
 
 /*
