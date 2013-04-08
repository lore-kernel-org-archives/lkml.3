Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935986Ab3DHUOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:14:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935951Ab3DHUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:14:47 -0400
Date: Mon, 8 Apr 2013 13:12:52 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a1a04ec3c7c27a682473fd9beb2c996316a64649@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215233.583190032@linutronix.de>
References: <20130321215233.583190032@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] idle:
  Provide a generic entry point for the idle code
Git-Commit-ID: a1a04ec3c7c27a682473fd9beb2c996316a64649
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:12:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1a04ec3c7c27a682473fd9beb2c996316a64649
Gitweb:     http://git.kernel.org/tip/a1a04ec3c7c27a682473fd9beb2c996316a64649
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:34 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:23 +0200

idle: Provide a generic entry point for the idle code

For now this calls cpu_idle(), but in the long run we want to move the
cpu bringup code to the core and therefor we add a state argument.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130321215233.583190032@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h |  8 ++++++++
 init/main.c         |  2 +-
 kernel/Makefile     |  1 +
 kernel/cpu/Makefile |  1 +
 kernel/cpu/idle.c   | 10 ++++++++++
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..7419e30 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -212,4 +212,12 @@ static inline int disable_nonboot_cpus(void) { return 0; }
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
diff --git a/init/main.c b/init/main.c
index 63534a1..adb179d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -384,7 +384,7 @@ static noinline void __init_refok rest_init(void)
 	init_idle_bootup_task(current);
 	schedule_preempt_disabled();
 	/* Call into cpu_idle with preempt disabled */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Check for early params. */
diff --git a/kernel/Makefile b/kernel/Makefile
index bbde5f1..d1574d4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -24,6 +24,7 @@ endif
 
 obj-y += sched/
 obj-y += power/
+obj-y += cpu/
 
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
diff --git a/kernel/cpu/Makefile b/kernel/cpu/Makefile
new file mode 100644
index 0000000..59ab052
--- /dev/null
+++ b/kernel/cpu/Makefile
@@ -0,0 +1 @@
+obj-y	= idle.o
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
new file mode 100644
index 0000000..1908f00
--- /dev/null
+++ b/kernel/cpu/idle.c
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
