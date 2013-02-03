Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3BCT0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:26:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3BCT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:26:23 -0500
Date: Sun, 3 Feb 2013 11:26:09 -0800
From: tip-bot for Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Message-ID: <tip-c1043fcda1b9e8e5144cfdaee7be262c50dbdead@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, hiraku.toyooka.gu@hitachi.com, tglx@linutronix.de,
        rob@landley.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hiraku.toyooka.gu@hitachi.com, rostedt@goodmis.org, tglx@linutronix.de,
        rob@landley.net
In-Reply-To: <20121226025309.3252.150.stgit@liselsia>
References: <20121226025309.3252.150.stgit@liselsia>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Add documentation of snapshot utility
Git-Commit-ID: c1043fcda1b9e8e5144cfdaee7be262c50dbdead
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:26:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1043fcda1b9e8e5144cfdaee7be262c50dbdead
Gitweb:     http://git.kernel.org/tip/c1043fcda1b9e8e5144cfdaee7be262c50dbdead
Author:     Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
AuthorDate: Wed, 26 Dec 2012 11:53:09 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 30 Jan 2013 11:02:07 -0500

tracing: Add documentation of snapshot utility

This patch adds snapshot description in ftrace documentation.
This description includes what the snapshot is and how to use it.

Link: http://lkml.kernel.org/r/20121226025309.3252.150.stgit@liselsia

Cc: Rob Landley <rob@landley.net>
Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt | 83 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 6f51fed..53d6a3c 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1842,6 +1842,89 @@ an error.
  # cat buffer_size_kb
 85
 
+Snapshot
+--------
+CONFIG_TRACER_SNAPSHOT makes a generic snapshot feature
+available to all non latency tracers. (Latency tracers which
+record max latency, such as "irqsoff" or "wakeup", can't use
+this feature, since those are already using the snapshot
+mechanism internally.)
+
+Snapshot preserves a current trace buffer at a particular point
+in time without stopping tracing. Ftrace swaps the current
+buffer with a spare buffer, and tracing continues in the new
+current (=previous spare) buffer.
+
+The following debugfs files in "tracing" are related to this
+feature:
+
+  snapshot:
+
+	This is used to take a snapshot and to read the output
+	of the snapshot. Echo 1 into this file to allocate a
+	spare buffer and to take a snapshot (swap), then read
+	the snapshot from this file in the same format as
+	"trace" (described above in the section "The File
+	System"). Both reads snapshot and tracing are executable
+	in parallel. When the spare buffer is allocated, echoing
+	0 frees it, and echoing else (positive) values clear the
+	snapshot contents.
+	More details are shown in the table below.
+
+	status\input  |     0      |     1      |    else    |
+	--------------+------------+------------+------------+
+	not allocated |(do nothing)| alloc+swap |   EINVAL   |
+	--------------+------------+------------+------------+
+	allocated     |    free    |    swap    |   clear    |
+	--------------+------------+------------+------------+
+
+Here is an example of using the snapshot feature.
+
+ # echo 1 > events/sched/enable
+ # echo 1 > snapshot
+ # cat snapshot
+# tracer: nop
+#
+# entries-in-buffer/entries-written: 71/71   #P:8
+#
+#                              _-----=> irqs-off
+#                             / _----=> need-resched
+#                            | / _---=> hardirq/softirq
+#                            || / _--=> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+          <idle>-0     [005] d...  2440.603828: sched_switch: prev_comm=swapper/5 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2242 next_prio=120
+           sleep-2242  [005] d...  2440.603846: sched_switch: prev_comm=snapshot-test-2 prev_pid=2242 prev_prio=120 prev_state=R ==> next_comm=kworker/5:1 next_pid=60 next_prio=120
+[...]
+          <idle>-0     [002] d...  2440.707230: sched_switch: prev_comm=swapper/2 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2229 next_prio=120
+
+ # cat trace
+# tracer: nop
+#
+# entries-in-buffer/entries-written: 77/77   #P:8
+#
+#                              _-----=> irqs-off
+#                             / _----=> need-resched
+#                            | / _---=> hardirq/softirq
+#                            || / _--=> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+          <idle>-0     [007] d...  2440.707395: sched_switch: prev_comm=swapper/7 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=snapshot-test-2 next_pid=2243 next_prio=120
+ snapshot-test-2-2229  [002] d...  2440.707438: sched_switch: prev_comm=snapshot-test-2 prev_pid=2229 prev_prio=120 prev_state=S ==> next_comm=swapper/2 next_pid=0 next_prio=120
+[...]
+
+
+If you try to use this snapshot feature when current tracer is
+one of the latency tracers, you will get the following results.
+
+ # echo wakeup > current_tracer
+ # echo 1 > snapshot
+bash: echo: write error: Device or resource busy
+ # cat snapshot
+cat: snapshot: Device or resource busy
+
 -----------
 
 More details can be found in the source code, in the
