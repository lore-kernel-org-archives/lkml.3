Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab3CUWC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:02:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:33037 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3CUVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:00 -0400
Message-Id: <20130321215233.583190032@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:52:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 04/34] idle: Provide a generic entry point for the idle code
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline;
 filename=smpboot-implement-core-idle-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now this calls cpu_idle(), but in the long run we want to move the
cpu bringup code to the core and therefor we add a state argument.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h |    8 ++++++++
 init/main.c         |    2 +-
 kernel/Makefile     |    1 +
 kernel/cpu/Makefile |    1 +
 kernel/cpu/idle.c   |   10 ++++++++++
 5 files changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -212,4 +212,12 @@ static inline int disable_nonboot_cpus(v
 static inline void enable_nonboot_cpus(void) {}
 #endif /* !CONFIG_PM_SLEEP_SMP */
 
+enum cpuhp_state {
+	CPUHP_OFFLINE,
+	CPUHP_ONLINE,
+};
+
+void cpu_startup_entry(enum cpuhp_state state);
+void cpu_idle(void);
+
 #endif /* _LINUX_CPU_H_ */
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -384,7 +384,7 @@ static noinline void __init_refok rest_i
 	init_idle_bootup_task(current);
 	schedule_preempt_disabled();
 	/* Call into cpu_idle with preempt disabled */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Check for early params. */
Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile
+++ linux-2.6/kernel/Makefile
@@ -24,6 +24,7 @@ endif
 
 obj-y += sched/
 obj-y += power/
+obj-y += cpu/
 
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
Index: linux-2.6/kernel/cpu/Makefile
===================================================================
--- /dev/null
+++ linux-2.6/kernel/cpu/Makefile
@@ -0,0 +1 @@
+obj-y	= idle.o
Index: linux-2.6/kernel/cpu/idle.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/cpu/idle.c
@@ -0,0 +1,10 @@
+/*
+ * Generic entry point for the idle threads
+ */
+#include <linux/sched.h>
+#include <linux/cpu.h>
+
+void cpu_startup_entry(enum cpuhp_state state)
+{
+	cpu_idle();
+}


