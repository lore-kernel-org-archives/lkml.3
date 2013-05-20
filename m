Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3ETO3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:29:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43350 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab3ETO3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:29:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/6] rcu: Apply Dave Jones's NOCB Kconfig help feedback
Date: Mon, 20 May 2013 07:28:49 -0700
Message-Id: <1369060129-28173-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060129-28173-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520142819.GA27123@linux.vnet.ibm.com>
 <1369060129-28173-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5518-0000-0000-00000ED039A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The Kconfig help text for the RCU_NOCB_CPU_NONE, RCU_NOCB_CPU_ZERO,
and RCU_NOCB_CPU_ALL Kconfig options was unclear, so this commit
adds a bit more detail.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 09ab5c2..289bb3f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -681,9 +681,10 @@ choice
 	prompt "Build-forced no-CBs CPUs"
 	default RCU_NOCB_CPU_NONE
 	help
-	  This option allows no-CBs CPUs to be specified at build time.
-	  Additional no-CBs CPUs may be specified by the rcu_nocbs=
-	  boot parameter.
+	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
+	  from kthreads rather than from softirq context) to be specified
+	  at build time.  Additional no-CBs CPUs may be specified by
+	  the rcu_nocbs= boot parameter.
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
@@ -691,25 +692,40 @@ config RCU_NOCB_CPU_NONE
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
-	  no-CBs CPUs.
+	  no-CBs CPUs, whose RCU callbacks will be invoked by per-CPU
+	  kthreads whose names begin with "rcuo".  All other CPUs will
+	  invoke their own RCU callbacks in softirq context.
+
+	  Select this option if you want to choose no-CBs CPUs at
+	  boot time, for example, to allow testing of different no-CBs
+	  configurations without having to rebuild the kernel each time.
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
 	depends on RCU_NOCB_CPU && !NO_HZ_FULL
 	help
-	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
-	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
-	  parameter will be no-CBs CPUs.
+	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
+	  callbacks are invoked by a per-CPU kthread whose name begins
+	  with "rcuo".	Additional CPUs may be designated as no-CBs
+	  CPUs using the rcu_nocbs= boot parameter will be no-CBs CPUs.
+	  All other CPUs will invoke their own RCU callbacks in softirq
+	  context.
 
 	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
-	  or energy-efficiency reasons.
+	  or energy-efficiency reasons, but the real reason it exists
+	  is to ensure that randconfig testing covers mixed systems.
 
 config RCU_NOCB_CPU_ALL
 	bool "All CPUs are build_forced no-CBs CPUs"
 	depends on RCU_NOCB_CPU
 	help
 	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
-	  boot parameter will be ignored.
+	  boot parameter will be ignored.  All CPUs' RCU callbacks will
+	  be executed in the context of per-CPU rcuo kthreads created for
+	  this purpose.  Assuming that the kthreads whose names start with
+	  "rcuo" are bound to "housekeeping" CPUs, this reduces OS jitter
+	  on the remaining CPUs, but might decrease memory locality during
+	  RCU-callback invocation, thus potentially degrading throughput.
 
 	  Select this if all CPUs need to be no-CBs CPUs for real-time
 	  or energy-efficiency reasons.
-- 
1.8.1.5

