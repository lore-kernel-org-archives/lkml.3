Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3KPA0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:26:16 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43663 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3KPAXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:47 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/16] rcu: Allow task-level idle entry/exit nesting
Date: Fri, 15 Nov 2013 16:23:26 -0800
Message-Id: <1384561418-30575-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-8236-0000-0000-000003D80E2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current task-level idle entry/exit code forces an entry/exit on
each call, regardless of the nesting level.  This commit therefore
properly accounts for nesting.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcu/tree.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c01213b19dee..acbfead2eb82 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -418,11 +418,12 @@ static void rcu_eqs_enter(bool user)
 	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
-	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
+	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE) {
 		rdtp->dynticks_nesting = 0;
-	else
+		rcu_eqs_enter_common(rdtp, oldval, user);
+	} else {
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
-	rcu_eqs_enter_common(rdtp, oldval, user);
+	}
 }
 
 /**
@@ -540,11 +541,12 @@ static void rcu_eqs_exit(bool user)
 	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
-	if (oldval & DYNTICK_TASK_NEST_MASK)
+	if (oldval & DYNTICK_TASK_NEST_MASK) {
 		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
-	else
+	} else {
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
-	rcu_eqs_exit_common(rdtp, oldval, user);
+		rcu_eqs_exit_common(rdtp, oldval, user);
+	}
 }
 
 /**
-- 
1.8.1.5

