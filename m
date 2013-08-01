Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3HAAjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:39:54 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51816 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3HAAb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:31:56 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 06/23] context_tracking: Remove full dynticks' hacky dependency on wide context tracking
Date: Thu,  1 Aug 2013 02:31:23 +0200
Message-Id: <1375317100-20651-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the full dynticks subsystem only enables the context tracking
on full dynticks CPUs, lets remove the dependency on CONTEXT_TRACKING_FORCE

This dependency was a hack to enable the context tracking widely for the
full dynticks susbsystem until the latter becomes able to enable it in a
more CPU-finegrained fashion.

Now CONTEXT_TRACKING_FORCE only stands for testing on archs that
work on support for the context tracking while full dynticks can't be
used yet due to unmet dependencies. It simulates a system where all CPUs
are full dynticks so that RCU user extended quiescent states and dynticks
cputime accounting can be tested on the given arch.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
---
 init/Kconfig        |   28 ++++++++++++++++++++++------
 kernel/time/Kconfig |    1 -
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 247084b..ffbf5d7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -527,13 +527,29 @@ config RCU_USER_QS
 config CONTEXT_TRACKING_FORCE
 	bool "Force context tracking"
 	depends on CONTEXT_TRACKING
-	default CONTEXT_TRACKING
+	default y if !NO_HZ_FULL
 	help
-	  Probe on user/kernel boundaries by default in order to
-	  test the features that rely on it such as userspace RCU extended
-	  quiescent states.
-	  This test is there for debugging until we have a real user like the
-	  full dynticks mode.
+	  The major pre-requirement for full dynticks to work is to
+	  support the context tracking subsystem. But there are also
+	  other dependencies to provide in order to make the full
+	  dynticks working.
+
+	  This option stands for testing when an arch implements the
+	  context tracking backend but doesn't yet fullfill all the
+	  requirements to make the full dynticks feature working.
+	  Without the full dynticks, there is no way to test the support
+	  for context tracking and the subsystems that rely on it: RCU
+	  userspace extended quiescent state and tickless cputime
+	  accounting. This option copes with the absence of the full
+	  dynticks subsystem by forcing the context tracking on all
+	  CPUs in the system.
+
+	  Say Y only if you're working on the developpement of an
+	  architecture backend for the context tracking.
+
+	  Say N otherwise, this option brings an overhead that you
+	  don't want in production.
+
 
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 70f27e8..747bbc7 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -105,7 +105,6 @@ config NO_HZ_FULL
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
 	select VIRT_CPU_ACCOUNTING_GEN
-	select CONTEXT_TRACKING_FORCE
 	select IRQ_WORK
 	help
 	 Adaptively try to shutdown the tick whenever possible, even when
-- 
1.7.5.4

