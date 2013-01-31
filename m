Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3AaMTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:19:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:55948 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3AaML0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:26 -0500
Message-Id: <20130131120742.576474467@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 16/40] blackfin: perf: Convert hotplug notifier to state
 machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=blackfin-convert-perf-notifier.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/blackfin/kernel/perf_event.c |   25 ++++---------------------
 include/linux/cpuhotplug.h        |    1 +
 2 files changed, 5 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/blackfin/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/perf_event.c
+++ linux-2.6/arch/blackfin/kernel/perf_event.c
@@ -461,29 +461,13 @@ static struct pmu pmu = {
 	.read        = bfin_pmu_read,
 };
 
-static void bfin_pmu_setup(int cpu)
+int __cpuinit bfin_pmu_prepare_cpu(unsigned int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
+	bfin_write_PFCTL(0);
 	memset(cpuhw, 0, sizeof(struct cpu_hw_events));
-}
-
-static int __cpuinit
-bfin_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (long)hcpu;
-
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		bfin_write_PFCTL(0);
-		bfin_pmu_setup(cpu);
-		break;
-
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
+	return 0;
 }
 
 static int __init bfin_pmu_init(void)
@@ -492,8 +476,7 @@ static int __init bfin_pmu_init(void)
 
 	ret = perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	if (!ret)
-		perf_cpu_notifier(bfin_pmu_notifier);
-
+		cpuhp_setup_state(CPUHP_PERF_BFIN, bfin_pmu_prepare_cpu, NULL);
 	return ret;
 }
 early_initcall(bfin_pmu_init);
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -6,6 +6,7 @@ enum cpuhp_states {
 	CPUHP_CREATE_THREADS,
 	CPUHP_PERF_X86_UNCORE_PREP,
 	CPUHP_PERF_X86_PREPARE,
+	CPUHP_PERF_BFIN,
 	CPUHP_PERF_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,


