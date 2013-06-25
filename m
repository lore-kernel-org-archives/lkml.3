Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3FYVkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:40:13 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54678 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3FYViD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:38:03 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC nohz_full 5/8] nohz_full: Add full-system idle states and variables
Date: Tue, 25 Jun 2013 14:37:48 -0700
Message-Id: <1372196271-20393-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372196271-20393-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130625213721.GA19452@linux.vnet.ibm.com>
 <1372196271-20393-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062521-3620-0000-0000-000003494AC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds control variables and states for full-system idle.
The system will progress through the states in numerical order when
the system is fully idle (other than the timekeeping CPU), and reset
down to the initial state if any non-timekeeping CPU goes non-idle.
The current state is kept in full_sysidle_state.

A RCU_SYSIDLE_SMALL macro is defined, and systems with this number
of CPUs or fewer move through the states more aggressively.  The idea
is that the resulting memory contention is less of a problem on small
systems.  Architectures can adjust this value (which defaults to 8)
using CONFIG_ARCH_RCU_SYSIDLE_SMALL.

One flavor of RCU will be in charge of driving the state machine,
defined by rcu_sysidle_state.  This should be the busiest flavor of RCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree_plugin.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a00d5c9..349f426 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2380,6 +2380,33 @@ static void rcu_kick_nohz_cpu(int cpu)
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 
 /*
+ * Handle small systems specially, accelerating their transition into
+ * full idle state.  Allow arches to override this code's idea of
+ * what constitutes a "small" system.
+ */
+#ifdef CONFIG_ARCH_RCU_SYSIDLE_SMALL
+#define RCU_SYSIDLE_SMALL CONFIG_ARCH_RCU_SYSIDLE_SMALL
+#else /* #ifdef CONFIG_ARCH_RCU_SYSIDLE_SMALL */
+#define RCU_SYSIDLE_SMALL 8
+#endif
+
+/*
+ * Define RCU flavor that holds sysidle state.  This needs to be the
+ * most active flavor of RCU.
+ */
+#ifdef CONFIG_PREEMPT_RCU
+static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_preempt_state;
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_sched_state;
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
+static int __maybe_unused full_sysidle_state; /* Current system-idle state. */
+#define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
+#define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
+#define RCU_SYSIDLE_FULL	2	/* All CPUs idle, ready for sysidle. */
+#define RCU_SYSIDLE_FULL_NOTED	3	/* Actually entered sysidle state. */
+
+/*
  * Invoked to note exit from irq or task transition to idle.  Note that
  * usermode execution does -not- count as idle here!  The caller must
  * have disabled interrupts.
-- 
1.8.1.5

