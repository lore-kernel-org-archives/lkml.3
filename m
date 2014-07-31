Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaGaAj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:39:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57566 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaGaAjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:39:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 09/10] documentation: Add verbiage on RCU-tasks stall warning messages
Date: Wed, 30 Jul 2014 17:39:41 -0700
Message-Id: <1406767182-4356-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073100-1542-0000-0000-000003A82F96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit documents RCU-tasks stall warning messages and also describes
when to use the new cond_resched_rcu_qs() API.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/stallwarn.txt | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 68fe3ad27015..ef5a2fd4ff70 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -56,8 +56,20 @@ RCU_STALL_RAT_DELAY
 	two jiffies.  (This is a cpp macro, not a kernel configuration
 	parameter.)
 
-When a CPU detects that it is stalling, it will print a message similar
-to the following:
+rcupdate.rcu_task_stall_timeout
+
+	This boot/sysfs parameter controls the RCU-tasks stall warning
+	interval.  A value of zero or less suppresses RCU-tasks stall
+	warnings.  A positive value sets the stall-warning interval
+	in jiffies.  An RCU-tasks stall warning starts wtih the line:
+
+		INFO: rcu_tasks detected stalls on tasks:
+
+	And continues with the output of sched_show_task() for each
+	task stalling the current RCU-tasks grace period.
+
+For non-RCU-tasks flavors of RCU, when a CPU detects that it is stalling,
+it will print a message similar to the following:
 
 INFO: rcu_sched_state detected stall on CPU 5 (t=2500 jiffies)
 
@@ -174,8 +186,12 @@ o	A CPU looping with preemption disabled.  This condition can
 o	A CPU looping with bottom halves disabled.  This condition can
 	result in RCU-sched and RCU-bh stalls.
 
-o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
-	without invoking schedule().
+o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the
+	kernel without invoking schedule().  Note that cond_resched()
+	does not necessarily prevent RCU CPU stall warnings.  Therefore,
+	if the looping in the kernel is really expected and desirable
+	behavior, you might need to replace some of the cond_resched()
+	calls with calls to cond_resched_rcu_qs().
 
 o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
 	happen to preempt a low-priority task in the middle of an RCU
@@ -208,11 +224,10 @@ o	A hardware failure.  This is quite unlikely, but has occurred
 	This resulted in a series of RCU CPU stall warnings, eventually
 	leading the realization that the CPU had failed.
 
-The RCU, RCU-sched, and RCU-bh implementations have CPU stall warning.
-SRCU does not have its own CPU stall warnings, but its calls to
-synchronize_sched() will result in RCU-sched detecting RCU-sched-related
-CPU stalls.  Please note that RCU only detects CPU stalls when there is
-a grace period in progress.  No grace period, no CPU stall warnings.
+The RCU, RCU-sched, RCU-bh, and RCU-tasks implementations have CPU stall
+warning.  Note that SRCU does -not- have CPU stall warnings.  Please note
+that RCU only detects CPU stalls when there is a grace period in progress.
+No grace period, no CPU stall warnings.
 
 To diagnose the cause of the stall, inspect the stack traces.
 The offending function will usually be near the top of the stack.
-- 
1.8.1.5

