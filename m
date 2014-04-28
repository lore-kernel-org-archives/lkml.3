Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbaD2ACQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:02:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55898 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaD1X4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 16/19] rcu: Make large and small sysidle systems use same state machine
Date: Mon, 28 Apr 2014 16:56:29 -0700
Message-Id: <1398729392-15087-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-7164-0000-0000-0000015FB500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, small systems move back into RCU_SYSIDLE_NOT from
RCU_SYSIDLE_SHORT and large systems do not.  This works because moving
aggressively to RCU_SYSIDLE_NOT affects only performance, not correctness,
and on small systems, the performance impact should be negligible.  That
said, this difference does make RCU a bit more complex, and RCU does not
seem to be suffering from any lack of complexity.  This commit therefore
adjusts small-system operation to match that of large systems, so that
the state never moves back to RCU_SYSIDLE_NOT from RCU_SYSIDLE_SHORT.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 045c6d04ed3f..f7593c2536b0 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2659,7 +2659,8 @@ static void rcu_sysidle(unsigned long j)
 static void rcu_sysidle_cancel(void)
 {
 	smp_mb();
-	ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_NOT;
+	if (full_sysidle_state > RCU_SYSIDLE_SHORT)
+		ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_NOT;
 }
 
 /*
-- 
1.8.1.5

