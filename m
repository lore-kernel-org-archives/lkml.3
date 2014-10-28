Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaJ1WOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:14:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56014 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823AbaJ1WN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:13:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/9] rcu: Optimize cond_resched_rcu_qs()
Date: Tue, 28 Oct 2014 15:09:59 -0700
Message-Id: <1414534202-27312-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F4FA25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current implementation of cond_resched_rcu_qs() can invoke
rcu_note_voluntary_context_switch() twice in the should_resched()
case, once via the call to __schedule() and once directly.  However, as
noted by Joe Lawrence in a patch to the team subsystem, cond_resched()
returns an indication as to whether or not the call to __schedule()
actually happened.  This commit therefore changes cond_resched_rcu_qs()
so as to invoke rcu_note_voluntary_context_switch() only when __schedule()
was not called.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a033d8b55773..36ea3ba5c516 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -348,8 +348,8 @@ extern struct srcu_struct tasks_rcu_exit_srcu;
  */
 #define cond_resched_rcu_qs() \
 do { \
-	rcu_note_voluntary_context_switch(current); \
-	cond_resched(); \
+	if (!cond_resched()) \
+		rcu_note_voluntary_context_switch(current); \
 } while (0)
 
 #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
-- 
1.8.1.5

