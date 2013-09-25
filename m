Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3IYBnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:43:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48345 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3IYBmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:54 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/10] rcu: Add tracing of normal (non-NOCB) grace-period requests
Date: Tue, 24 Sep 2013 18:42:34 -0700
Message-Id: <1380073359-31959-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-3532-0000-0000-000001ADD0B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds tracing to the normal grace-period request points.
These are rcu_gp_cleanup(), which checks for the need for another
grace period at the end of the previous grace period, and
rcu_start_gp_advanced(), which restarts RCU's state machine after
an idle period.  These trace events are intended to help track down
bugs where RCU remains idle despite there being work for it to do.

Reported-by: Clark Williams <williams@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h | 1 +
 kernel/rcutree.c           | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 60077e1..98466c6 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -45,6 +45,7 @@ TRACE_EVENT(rcu_utilization,
  *
  *	"AccReadyCB": CPU acclerates new callbacks to RCU_NEXT_READY_TAIL.
  *	"AccWaitCB": CPU accelerates new callbacks to RCU_WAIT_TAIL.
+ *	"newreq": Request a new grace period.
  *	"start": Start a grace period.
  *	"cpustart": CPU first notices a grace-period start.
  *	"cpuqs": CPU passes through a quiescent state.
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 78d3715..54dd6d0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1459,8 +1459,12 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	rsp->fqs_state = RCU_GP_IDLE;
 	rdp = this_cpu_ptr(rsp->rda);
 	rcu_advance_cbs(rsp, rnp, rdp);  /* Reduce false positives below. */
-	if (cpu_needs_another_gp(rsp, rdp))
+	if (cpu_needs_another_gp(rsp, rdp)) {
 		rsp->gp_flags = 1;
+		trace_rcu_grace_period(rsp->name,
+				       ACCESS_ONCE(rsp->gpnum),
+				       TPS("newreq"));
+	}
 	raw_spin_unlock_irq(&rnp->lock);
 }
 
@@ -1584,6 +1588,8 @@ rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 		return;
 	}
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
+	trace_rcu_grace_period(rsp->name, ACCESS_ONCE(rsp->gpnum),
+			       TPS("newreq"));
 
 	/*
 	 * We can't do wakeups while holding the rnp->lock, as that
-- 
1.8.1.5

