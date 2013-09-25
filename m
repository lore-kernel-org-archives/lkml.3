Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3IYBoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:44:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57794 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab3IYBm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/10] rcu: Avoid sparse warnings in rcu_nocb_wake trace event
Date: Tue, 24 Sep 2013 18:42:38 -0700
Message-Id: <1380073359-31959-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0928-0000-0000-000001FEF00D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The event-tracing macros do not like bool tracing arguments, so this
commit makes them be of type char.  This change has the knock-on effect
of making it illegal to pass a pointer into one of these arguments, so
also change rcutiny's first call to trace_rcu_batch_end() to convert
from pointer to boolean, prefixing with "!!".

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h | 10 +++++-----
 kernel/rcutiny.c           |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index a087d82..aca3822 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -591,17 +591,17 @@ TRACE_EVENT(rcu_invoke_kfree_callback,
 TRACE_EVENT(rcu_batch_end,
 
 	TP_PROTO(const char *rcuname, int callbacks_invoked,
-		 bool cb, bool nr, bool iit, bool risk),
+		 char cb, char nr, char iit, char risk),
 
 	TP_ARGS(rcuname, callbacks_invoked, cb, nr, iit, risk),
 
 	TP_STRUCT__entry(
 		__field(const char *, rcuname)
 		__field(int, callbacks_invoked)
-		__field(bool, cb)
-		__field(bool, nr)
-		__field(bool, iit)
-		__field(bool, risk)
+		__field(char, cb)
+		__field(char, nr)
+		__field(char, iit)
+		__field(char, risk)
 	),
 
 	TP_fast_assign(
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 9ed6075..80b6e27 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -273,7 +273,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	if (&rcp->rcucblist == rcp->donetail) {
 		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, 0, -1));
 		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0,
-					      ACCESS_ONCE(rcp->rcucblist),
+					      !!ACCESS_ONCE(rcp->rcucblist),
 					      need_resched(),
 					      is_idle_task(current),
 					      false));
-- 
1.8.1.5

