Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3AaMSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:18:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:55981 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3AaML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:28 -0500
Message-Id: <20130131120742.788886767@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 19/40] sh: perf: Convert the hotplug notifiers to state
 machine callbacks
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=sh-perf-notifier-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sh/kernel/perf_event.c |   22 +++-------------------
 include/linux/cpuhotplug.h  |    1 +
 2 files changed, 4 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -360,28 +360,12 @@ static struct pmu pmu = {
 	.read		= sh_pmu_read,
 };
 
-static void sh_pmu_setup(int cpu)
+static int __cpuinit sh_pmu_prepare_cpu(unsigned int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
 	memset(cpuhw, 0, sizeof(struct cpu_hw_events));
-}
-
-static int __cpuinit
-sh_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (long)hcpu;
-
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		sh_pmu_setup(cpu);
-		break;
-
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
+	return 0;
 }
 
 int __cpuinit register_sh_pmu(struct sh_pmu *_pmu)
@@ -395,6 +379,6 @@ int __cpuinit register_sh_pmu(struct sh_
 	WARN_ON(_pmu->num_events > MAX_HWEVENTS);
 
 	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
-	perf_cpu_notifier(sh_pmu_notifier);
+	cpuhp_setup_state(CPUHP_PERF_SUPERH, sh_pmu_prepare_cpu, NULL);
 	return 0;
 }
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -8,6 +8,7 @@ enum cpuhp_states {
 	CPUHP_PERF_X86_PREPARE,
 	CPUHP_PERF_BFIN,
 	CPUHP_PERF_POWER,
+	CPUHP_PERF_SUPERH,
 	CPUHP_PERF_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,


