Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab3IYBRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:17:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44399 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3IYBRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:17:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: Update stall-warning documentation
Date: Tue, 24 Sep 2013 18:17:21 -0700
Message-Id: <1380071843-30362-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130925011657.GA29958@linux.vnet.ibm.com>
References: <20130925011657.GA29958@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-9332-0000-0000-000001875399
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/stallwarn.txt | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 8e9359d..6f3a005 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -12,12 +12,12 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	This kernel configuration parameter defines the period of time
 	that RCU will wait from the beginning of a grace period until it
 	issues an RCU CPU stall warning.  This time period is normally
-	sixty seconds.
+	21 seconds.
 
 	This configuration parameter may be changed at runtime via the
 	/sys/module/rcutree/parameters/rcu_cpu_stall_timeout, however
 	this parameter is checked only at the beginning of a cycle.
-	So if you are 30 seconds into a 70-second stall, setting this
+	So if you are 10 seconds into a 40-second stall, setting this
 	sysfs parameter to (say) five will shorten the timeout for the
 	-next- stall, or the following warning for the current stall
 	(assuming the stall lasts long enough).  It will not affect the
@@ -32,7 +32,7 @@ CONFIG_RCU_CPU_STALL_VERBOSE
 	also dump the stacks of any tasks that are blocking the current
 	RCU-preempt grace period.
 
-RCU_CPU_STALL_INFO
+CONFIG_RCU_CPU_STALL_INFO
 
 	This kernel configuration parameter causes the stall warning to
 	print out additional per-CPU diagnostic information, including
@@ -43,7 +43,8 @@ RCU_STALL_DELAY_DELTA
 	Although the lockdep facility is extremely useful, it does add
 	some overhead.  Therefore, under CONFIG_PROVE_RCU, the
 	RCU_STALL_DELAY_DELTA macro allows five extra seconds before
-	giving an RCU CPU stall warning message.
+	giving an RCU CPU stall warning message.  (This is a cpp
+	macro, not a kernel configuration parameter.)
 
 RCU_STALL_RAT_DELAY
 
@@ -52,7 +53,8 @@ RCU_STALL_RAT_DELAY
 	However, if the offending CPU does not detect its own stall in
 	the number of jiffies specified by RCU_STALL_RAT_DELAY, then
 	some other CPU will complain.  This delay is normally set to
-	two jiffies.
+	two jiffies.  (This is a cpp macro, not a kernel configuration
+	parameter.)
 
 When a CPU detects that it is stalling, it will print a message similar
 to the following:
@@ -86,7 +88,12 @@ printing, there will be a spurious stall-warning message:
 
 INFO: rcu_bh_state detected stalls on CPUs/tasks: { } (detected by 4, 2502 jiffies)
 
-This is rare, but does happen from time to time in real life.
+This is rare, but does happen from time to time in real life.  It is also
+possible for a zero-jiffy stall to be flagged in this case, depending
+on how the stall warning and the grace-period initialization happen to
+interact.  Please note that it is not possible to entirely eliminate this
+sort of false positive without resorting to things like stop_machine(),
+which is overkill for this sort of problem.
 
 If the CONFIG_RCU_CPU_STALL_INFO kernel configuration parameter is set,
 more information is printed with the stall-warning message, for example:
@@ -216,4 +223,5 @@ that portion of the stack which remains the same from trace to trace.
 If you can reliably trigger the stall, ftrace can be quite helpful.
 
 RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE
-and with RCU's event tracing.
+and with RCU's event tracing.  For information on RCU's event tracing,
+see include/trace/events/rcu.h.
-- 
1.8.1.5

