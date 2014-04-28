Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbaD1X6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:58:11 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55916 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaD1X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Himangi Saraogi <himangi774@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/19] rcu: Protect uses of ->jiffies_stall with ACCESS_ONCE()
Date: Mon, 28 Apr 2014 16:56:22 -0700
Message-Id: <1398729392-15087-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-7164-0000-0000-0000015FB4FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>

Some of the accesses to the rcu_state structure's ->jiffies_stall
field are unprotected. This patch protects them with ACCESS_ONCE().
The following coccinelle script was used to acheive this:
/* coccinelle script to protect uses of ->jiffies_stall with ACCESS_ONCE() */
@@
identifier a;
@@
(
	ACCESS_ONCE(a->jiffies_stall)
|
-	a->jiffies_stall
+	ACCESS_ONCE(a->jiffies_stall)
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tiny_plugin.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tiny_plugin.h b/kernel/rcu/tiny_plugin.h
index 431528520562..858c56569127 100644
--- a/kernel/rcu/tiny_plugin.h
+++ b/kernel/rcu/tiny_plugin.h
@@ -144,7 +144,7 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 		return;
 	rcp->ticks_this_gp++;
 	j = jiffies;
-	js = rcp->jiffies_stall;
+	js = ACCESS_ONCE(rcp->jiffies_stall);
 	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
 		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
 		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
@@ -152,17 +152,17 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 		dump_stack();
 	}
 	if (*rcp->curtail && ULONG_CMP_GE(j, js))
-		rcp->jiffies_stall = jiffies +
+		ACCESS_ONCE(rcp->jiffies_stall) = jiffies +
 			3 * rcu_jiffies_till_stall_check() + 3;
 	else if (ULONG_CMP_GE(j, js))
-		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+		ACCESS_ONCE(rcp->jiffies_stall) = jiffies + rcu_jiffies_till_stall_check();
 }
 
 static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
 {
 	rcp->ticks_this_gp = 0;
 	rcp->gp_start = jiffies;
-	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+	ACCESS_ONCE(rcp->jiffies_stall) = jiffies + rcu_jiffies_till_stall_check();
 }
 
 static void check_cpu_stalls(void)
-- 
1.8.1.5

