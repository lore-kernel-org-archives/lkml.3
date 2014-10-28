Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbaJ1WRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:17:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57415 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbaJ1WRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:17:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] signal: Exit RCU read-side critical section on each pass through loop
Date: Tue, 28 Oct 2014 15:13:47 -0700
Message-Id: <1414534428-27918-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20141028221330.GA27479@linux.vnet.ibm.com>
References: <20141028221330.GA27479@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F4FDC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The kill_pid_info() can potentially loop indefinitely if tasks are created
and deleted sufficiently quickly, and if this happens, this function
will remain in a single RCU read-side critical section indefinitely.
This commit therefore exits the RCU read-side critical section on each
pass through the loop.  Because a race must happen to retry the loop,
this should have no performance impact in the common case.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f9f6dd..54820984a872 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1331,23 +1331,21 @@ int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 	int error = -ESRCH;
 	struct task_struct *p;
 
-	rcu_read_lock();
-retry:
-	p = pid_task(pid, PIDTYPE_PID);
-	if (p) {
-		error = group_send_sig_info(sig, info, p);
-		if (unlikely(error == -ESRCH))
-			/*
-			 * The task was unhashed in between, try again.
-			 * If it is dead, pid_task() will return NULL,
-			 * if we race with de_thread() it will find the
-			 * new leader.
-			 */
-			goto retry;
-	}
-	rcu_read_unlock();
+	for (;;) {
+		rcu_read_lock();
+		p = pid_task(pid, PIDTYPE_PID);
+		if (p)
+			error = group_send_sig_info(sig, info, p);
+		rcu_read_unlock();
+		if (likely(!p || error != -ESRCH))
+			return error;
 
-	return error;
+		/*
+		 * The task was unhashed in between, try again.  If it
+		 * is dead, pid_task() will return NULL, if we race with
+		 * de_thread() it will find the new leader.
+		 */
+	}
 }
 
 int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
-- 
1.8.1.5

