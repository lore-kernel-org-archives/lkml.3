Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891Ab3IDOk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:40:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762792Ab3IDOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:05 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=aWgvI_vTb_YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BjXSyJKKwoUA:10 a=oGMlB6cnAAAA:8 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=BWCg7S580bOAsAZHxxEA:9 a=jeBq3FmKZ4MA:10 a=CY6gl2JlH4YA:10 a=dGJ0OcVc7YAA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143703.098712210@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:36:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [for-next][PATCH 17/18] ftrace/cpuidle/x86: Mark functions that are RCU unsafe
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0016-ftrace-cpuidle-x86-Mark-functions-that-are-RCU-unsaf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Some callbacks of the function tracer use rcu_read_lock(). This means that
there's places that can not be traced because RCU is not tracking the CPU
for various reasons (like NO_HZ_FULL and coming back from userspace).

These functions need to be marked so that callbacks that use RCU do not
trace them.

Acked-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/process.c |    2 ++
 drivers/cpuidle/cpuidle.c |    2 ++
 kernel/cpu/idle.c         |    2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 83369e5..18739cd 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -17,6 +17,7 @@
 #include <linux/stackprotector.h>
 #include <linux/tick.h>
 #include <linux/cpuidle.h>
+#include <linux/ftrace.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/cpu.h>
@@ -316,6 +317,7 @@ void default_idle(void)
 #ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(default_idle);
 #endif
+FTRACE_UNSAFE_RCU(default_idle);
 
 #ifdef CONFIG_XEN
 bool xen_set_default_idle(void)
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index fdc432f..9515457 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -19,6 +19,7 @@
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
+#include <linux/ftrace.h>
 #include <trace/events/power.h>
 
 #include "cpuidle.h"
@@ -168,6 +169,7 @@ int cpuidle_idle_call(void)
 
 	return 0;
 }
+FTRACE_UNSAFE_RCU(cpuidle_idle_call);
 
 /**
  * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index e695c0a..d9d290f 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -5,6 +5,7 @@
 #include <linux/cpu.h>
 #include <linux/tick.h>
 #include <linux/mm.h>
+#include <linux/ftrace.h>
 #include <linux/stackprotector.h>
 
 #include <asm/tlb.h>
@@ -61,6 +62,7 @@ void __weak arch_cpu_idle(void)
 	cpu_idle_force_poll = 1;
 	local_irq_enable();
 }
+FTRACE_UNSAFE_RCU(arch_cpu_idle);
 
 /*
  * Generic idle loop implementation
-- 
1.7.10.4


