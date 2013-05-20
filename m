Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab3ETOvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:51:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46306 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3ETOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:51:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] nohz_full: Document additional restrictions
Date: Mon, 20 May 2013 07:50:01 -0700
Message-Id: <1369061402-31334-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061402-31334-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520144934.GA29947@linux.vnet.ibm.com>
 <1369061402-31334-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-4834-0000-0000-0000072850B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit calls out the potential for slowing the tick even when there
are multiple runnable processes per CPU,  It also points out that current
mainlined version keeps the tick going on at least one CPU even when all
CPUs are otherwise idle.  Finally, it notes the need for a 1-HZ tick in
order to calculate CPU load, maintain sched average, compute CFS entity
vruntime, compute avenrun, and carry out load balancing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/timers/NO_HZ.txt | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/Documentation/timers/NO_HZ.txt b/Documentation/timers/NO_HZ.txt
index d5323e0..8869758 100644
--- a/Documentation/timers/NO_HZ.txt
+++ b/Documentation/timers/NO_HZ.txt
@@ -278,6 +278,11 @@ o	Adaptive-ticks does not do anything unless there is only one
 	single runnable SCHED_FIFO task and multiple runnable SCHED_OTHER
 	tasks, even though these interrupts are unnecessary.
 
+	And even when there are multiple runnable tasks on a given CPU,
+	there is little point in interrupting that CPU until the current
+	running task's timeslice expires, which is almost always way
+	longer than the time of the next scheduling-clock interrupt.
+
 	Better handling of these sorts of situations is future work.
 
 o	A reboot is required to reconfigure both adaptive idle and RCU
@@ -308,6 +313,16 @@ o	Unless all CPUs are idle, at least one CPU must keep the
 	scheduling-clock interrupt going in order to support accurate
 	timekeeping.
 
-o	If there are adaptive-ticks CPUs, there will be at least one
-	CPU keeping the scheduling-clock interrupt going, even if all
-	CPUs are otherwise idle.
+o	If there might potentially be some adaptive-ticks CPUs, there
+	will be at least one CPU keeping the scheduling-clock interrupt
+	going, even if all CPUs are otherwise idle.
+
+	Better handling of this situation is ongoing work.
+
+o	Some process-handling operations still require the occasional
+	scheduling-clock tick.	These operations include calculating CPU
+	load, maintaining sched average, computing CFS entity vruntime,
+	computing avenrun, and carrying out load balancing.  They are
+	currently accommodated by scheduling-clock tick every second
+	or so.	On-going work will eliminate the need even for these
+	infrequent scheduling-clock ticks.
-- 
1.8.1.5

