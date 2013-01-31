Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3AaMQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:16:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:56092 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3AaMLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:37 -0500
Message-Id: <20130131120743.453821790@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 29/40] s390: Convert vtime to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=s390-vtime-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/kernel/vtime.c   |   18 +++++-------------
 include/linux/cpuhotplug.h |    1 +
 2 files changed, 6 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/s390/kernel/vtime.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/vtime.c
+++ linux-2.6/arch/s390/kernel/vtime.c
@@ -382,25 +382,17 @@ void __cpuinit init_cpu_vtimer(void)
 	set_vtimer(VTIMER_MAX_SLICE);
 }
 
-static int __cpuinit s390_nohz_notify(struct notifier_block *self,
-				      unsigned long action, void *hcpu)
+static int __cpuinit s390_vtime_dying_cpu(unsigned int cpu)
 {
-	struct s390_idle_data *idle;
-	long cpu = (long) hcpu;
+	struct s390_idle_data *idle = &per_cpu(s390_idle, cpu);
 
-	idle = &per_cpu(s390_idle, cpu);
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_DYING:
-		idle->nohz_delay = 0;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
+	idle->nohz_delay = 0;
+	return 0;
 }
 
 void __init vtime_init(void)
 {
 	/* Enable cpu timer interrupts on the boot cpu. */
 	init_cpu_vtimer();
-	cpu_notifier(s390_nohz_notify, 0);
+	cpuhp_setup_state(CPUHP_AP_S390_VTIME_DYING, NULL, s390_vtime_dying_cpu);
 }
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -27,6 +27,7 @@ enum cpuhp_states {
 	CPUHP_AP_ARM64_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
+	CPUHP_AP_S390_VTIME_DYING,
 	CPUHP_AP_SCHED_MIGRATE_DYING,
 	CPUHP_AP_MAX,
 	CPUHP_TEARDOWN_CPU,


