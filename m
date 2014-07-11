Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaGKNiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:38:25 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44427 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaGKNiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:38:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: Don't offload callbacks unless specifically requested
Date: Fri, 11 Jul 2014 06:35:03 -0700
Message-Id: <1405085703-14822-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405085703-14822-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707224841.GA10101@linux.vnet.ibm.com>
 <1405085703-14822-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071113-1344-0000-0000-000002C3406F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Enabling NO_HZ_FULL currently has the side effect of enabling callback
offloading on all CPUs.  This results in lots of additional rcuo kthreads,
and can also increase context switching and wakeups, even in cases where
callback offloading is neither needed nor particularly desirable.  This
commit therefore enables callback offloading on a given CPU only if
specifically requested at build time or boot time, or if that CPU has
been specifically designated (again, either at build time or boot time)
as a nohz_full CPU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig             | 4 ++--
 kernel/rcu/tree_plugin.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99af1b9..9332d33346ac 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -737,7 +737,7 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL
+	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -751,7 +751,7 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL
+	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
 	help
 	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
 	  callbacks are invoked by a per-CPU kthread whose name begins
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index b27b86c7bbfa..17eed0856b03 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2473,6 +2473,9 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 
 	if (rcu_nocb_mask == NULL)
 		return;
+#ifdef CONFIG_NO_HZ_FULL
+	cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
 	if (ls == -1) {
 		ls = int_sqrt(nr_cpu_ids);
 		rcu_nocb_leader_stride = ls;
-- 
1.8.1.5

