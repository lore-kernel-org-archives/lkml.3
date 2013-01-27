Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3A0FQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 00:16:50 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39497 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab3A0FQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 00:16:32 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: Trace callback acceleration
Date: Sat, 26 Jan 2013 16:18:21 -0800
Message-Id: <1359245901-4432-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359245901-4432-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127001804.GA4122@linux.vnet.ibm.com>
 <1359245901-4432-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012705-9360-0000-0000-00000FC0B97B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds event tracing for callback acceleration to allow better
tracking of callbacks through the system.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |    6 ++++--
 kernel/rcutree.c           |    6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index d4f559b..5678114 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -44,8 +44,10 @@ TRACE_EVENT(rcu_utilization,
  * of a new grace period or the end of an old grace period ("cpustart"
  * and "cpuend", respectively), a CPU passing through a quiescent
  * state ("cpuqs"), a CPU coming online or going offline ("cpuonl"
- * and "cpuofl", respectively), and a CPU being kicked for being too
- * long in dyntick-idle mode ("kick").
+ * and "cpuofl", respectively), a CPU being kicked for being too
+ * long in dyntick-idle mode ("kick"), a CPU accelerating its new
+ * callbacks to RCU_NEXT_READY_TAIL ("AccReadyCB"), and a CPU
+ * accelerating its new callbacks to RCU_WAIT_TAIL ("AccWaitCB").
  */
 TRACE_EVENT(rcu_grace_period,
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ac6a75d..e9dce4f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1168,6 +1168,12 @@ static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 		rdp->nxttail[i] = rdp->nxttail[RCU_NEXT_TAIL];
 		rdp->nxtcompleted[i] = c;
 	}
+
+	/* Trace depending on how much we were able to accelerate. */
+	if (!*rdp->nxttail[RCU_WAIT_TAIL])
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "AccWaitCB");
+	else
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "AccReadyCB");
 }
 
 /*
-- 
1.7.8

