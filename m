Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbaFTSdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:33:33 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34255 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbaFTSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:33:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Christoph Lameter <cl@gentwo.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH RFC tip/core/rcu 3/5] rcu: Add RCU_COND_RESCHED_QS for large systems
Date: Fri, 20 Jun 2014 11:33:21 -0700
Message-Id: <1403289203-6371-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062018-0928-0000-0000-000002CB4587
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

People with low-latency kernel-intensive workloads object to the
extra test of a per-CPU variable added to cond_resched().  This commit
therefore adds a Kconfig variable RCU_COND_RESCHED_QS that enables this
extra test.  Therefore, people who would like large systems to operate
reliably can enable this Kconfig variable, while people with low-latency
kernel-intensive workloads can leave it disabled.  People setting defaults
for Linux distributions should choose wisely.  ;-)

Suggested-by: Christoph Lameter <cl@gentwo.org>
Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/rcutree.h | 15 +++++++++++++--
 init/Kconfig            | 26 ++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index ca7d34027935..69ccd4163de2 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -56,12 +56,23 @@ static inline bool rcu_should_resched(void)
 }
 
 /* Report quiescent states to RCU if it is time to do so. */
-static inline void rcu_cond_resched(void)
+static inline void __rcu_cond_resched(void)
 {
 	if (unlikely(rcu_should_resched()))
 		rcu_resched();
 }
 
+/*
+ * Report quiescent states to RCU in kernels that are not configured
+ * for low-latency kernel-intensive workloads.
+ */
+static inline void rcu_cond_resched(void)
+{
+#ifdef CONFIG_RCU_COND_RESCHED_QS
+	__rcu_cond_resched();
+#endif /* #ifdef CONFIG_RCU_COND_RESCHED_QS */
+}
+
 /**
  * cond_resched_rcu_qs - Report potential quiescent states to RCU
  *
@@ -71,7 +82,7 @@ static inline void rcu_cond_resched(void)
  */
 #define cond_resched_rcu_qs() \
 do { \
-	rcu_cond_resched(); \
+	__rcu_cond_resched(); \
 	cond_resched(); \
 } while (0)
 
diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99af1b9..6457a7f1f0be 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -781,6 +781,32 @@ config RCU_NOCB_CPU_ALL
 
 endchoice
 
+config RCU_COND_RESCHED_QS
+	bool "Use cond_resched() calls as RCU quiescent states"
+	depends on TREE_RCU || TREE_PREEMPT_RCU
+	default n
+	help
+	  Use this option to allow RCU grace periods to make progress
+	  on large systems that can execute for extended time periods
+	  in the kernel.  Workloads that contain processes with large
+	  numbers of open files, systems with large quantities of
+	  memory, workloads that do mm-related system calls on large
+	  regions, and systems with large numbers of mass-storage
+	  devices are particularly prone to this behavior.  Without
+	  this option set, RCU CPU stall warnings or even OOMs can
+	  result.
+
+	  This option causes cond_resched() to check to see if the
+	  current RCU grace period has been waiting for too long for
+	  this CPU, and to emulate a zero-duration dyntick-idle
+	  period if so.  RCU's grace-period kthreads will then note
+	  this dyntick-idle period and report a quiescent state to
+	  the RCU core on this CPU's behalf, thus avoiding both RCU
+	  CPU stall warnings and OOMs.
+
+	  Say Y here for reliable operation on large systems.
+	  Say N here for kernel-intensive low-latency workloads.
+
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
-- 
1.8.1.5

