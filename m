Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3DZOxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:53:38 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:59654 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab3DZOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:53:35 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] nohz: Select VIRT_CPU_ACCOUNTING_GEN from full dynticks config
Date: Fri, 26 Apr 2013 16:53:26 +0200
Message-Id: <1366988007-30665-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366988007-30665-1-git-send-email-fweisbec@gmail.com>
References: <1366988007-30665-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn the full dynticks passive dependency on VIRT_CPU_ACCOUNTING_GEN
to an active one.

The full dynticks Kconfig is currently hidden behind the full dynticks
cputime accounting, which is an awkward and counter-intuitive layout:
the user first has to select the dynticks cputime accounting in order
to make the full dynticks feature to be visible.

We definetly want it the other way around. The usual way to perform
this kind of active dependency is use "select" on the depended target.
Now we can't use the Kconfig "select" instruction when the target is
a "choice".

So this patch inspires on how the RCU subsystem Kconfig interact
with its dependencies on SMP and PREEMPT: we make sure that cputime
accounting can't propose another option than VIRT_CPU_ACCOUNTING_GEN
when NO_HZ_FULL is selected by using the right "depends on" instruction
for each cputime accounting choices.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 init/Kconfig        |    8 ++++----
 kernel/time/Kconfig |    4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index edc8132..572db53 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -306,7 +306,7 @@ choice
 # Kind of a stub config for the pure tick based cputime accounting
 config TICK_CPU_ACCOUNTING
 	bool "Simple tick based cputime accounting"
-	depends on !S390
+	depends on !S390 && !NO_HZ_FULL
 	help
 	  This is the basic tick based cputime accounting that maintains
 	  statistics about user, system and idle time spent on per jiffies
@@ -316,7 +316,7 @@ config TICK_CPU_ACCOUNTING
 
 config VIRT_CPU_ACCOUNTING_NATIVE
 	bool "Deterministic task and CPU time accounting"
-	depends on HAVE_VIRT_CPU_ACCOUNTING
+	depends on HAVE_VIRT_CPU_ACCOUNTING && !NO_HZ_FULL
 	select VIRT_CPU_ACCOUNTING
 	help
 	  Select this option to enable more accurate task and CPU time
@@ -329,7 +329,7 @@ config VIRT_CPU_ACCOUNTING_NATIVE
 
 config VIRT_CPU_ACCOUNTING_GEN
 	bool "Full dynticks CPU time accounting"
-	depends on HAVE_CONTEXT_TRACKING && 64BIT
+	depends on HAVE_CONTEXT_TRACKING && 64BIT && NO_HZ_FULL
 	select VIRT_CPU_ACCOUNTING
 	select CONTEXT_TRACKING
 	help
@@ -346,7 +346,7 @@ config VIRT_CPU_ACCOUNTING_GEN
 
 config IRQ_TIME_ACCOUNTING
 	bool "Fine granularity task level IRQ time accounting"
-	depends on HAVE_IRQ_TIME_ACCOUNTING
+	depends on HAVE_IRQ_TIME_ACCOUNTING && !NO_HZ_FULL
 	help
 	  Select this option to enable fine granularity task irq time
 	  accounting. This is done by reading a timestamp on each
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 1ea2bba..a2ddd65 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -104,11 +104,13 @@ config NO_HZ_FULL
 	depends on SMP
 	# RCU_USER_QS dependency
 	depends on HAVE_CONTEXT_TRACKING
-	depends on VIRT_CPU_ACCOUNTING_GEN
+	# VIRT_CPU_ACCOUNTING_GEN dependency
+	depends on 64BIT
 	select NO_HZ_COMMON
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
 	select RCU_NOCB_CPU_ALL
+	select VIRT_CPU_ACCOUNTING_GEN
 	select CONTEXT_TRACKING_FORCE
 	select IRQ_WORK
 	help
-- 
1.7.5.4

