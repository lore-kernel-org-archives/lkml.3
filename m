Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab3DCMql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:46:41 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:46150 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3DCMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:46:38 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/4] nohz: Unhide full dynticks feature from its dependencies
Date: Wed,  3 Apr 2013 14:46:27 +0200
Message-Id: <1364993190-13784-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The full dynticks feature only shows up when all its
Kconfig dependencies are met (RCU nocbs, RCU user mode, ...)

This is far from being user friendly as those who want to
activate this feature need to look into the Kconfig files
and iterate through each dependency then activate these
by hand in order to show and select the full dynticks
Kconfig option.

So process the other way around: show up the Kconfig option
if the minimal low level dependencies are met and activate
the high level ones when we enable the feature.

Note there is one exception in the picture:
CONFIG_VIRT_CPU_ACCOUNTING_GEN is part of a Kconfig choice
menu and it appears we can't select it from another Kconfig
selection when it's under such layout. So for now this
particular item stays as a passive dependency.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/Kconfig |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 5a87c03..726c33e 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -80,11 +80,20 @@ config NO_HZ
 	  busy and when the system is idle.
 
 config NO_HZ_EXTENDED
-       bool "Full dynticks system"
-       depends on NO_HZ && RCU_USER_QS && VIRT_CPU_ACCOUNTING_GEN && RCU_NOCB_CPU && SMP
-       select CONTEXT_TRACKING_FORCE
-       help
-         Adaptively try to shutdown the tick whenever possible, even when
+	bool "Full dynticks system"
+	# NO_HZ dependency
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+	# RCU_USER_QS
+	depends on HAVE_CONTEXT_TRACKING && SMP
+	# RCU_NOCB_CPU dependency
+	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on VIRT_CPU_ACCOUNTING_GEN
+	select NO_HZ
+	select RCU_USER_QS
+	select RCU_NOCB_CPU
+	select CONTEXT_TRACKING_FORCE
+	help
+	 Adaptively try to shutdown the tick whenever possible, even when
 	 the CPU is running tasks. Typically this requires running a single
 	 task on the CPU. Chances for running tickless are maximized when
 	 the task mostly runs in userspace and has few kernel activity.
-- 
1.7.5.4

