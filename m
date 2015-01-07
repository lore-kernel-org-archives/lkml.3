Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbbAGRyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:54:06 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52668 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbbAGRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:59 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, Miroslav Benes <mbenes@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/10] rcu: Fix RCU CPU stall detection in tiny implementation
Date: Wed,  7 Jan 2015 09:52:47 -0800
Message-Id: <1420653168-6434-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
 <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0009-0000-0000-000007C65C65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

The tiny RCU CPU stall detection depends on *rcp->curtail not being
NULL. It is however a tail pointer and thus NULL by definition. Instead we
should check rcp->rcucblist for the presence of pending callbacks which
need to be processed. With this fix INFO about the stall is printed and
jiffies_stall (jiffies at next stall) correctly updated.

Note that the check for pending callback is necessary to avoid spurious
warnings if there are no pendings callbacks.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
[ paulmck: Fused identical "if" statements, ported to -rcu. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tiny_plugin.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tiny_plugin.h b/kernel/rcu/tiny_plugin.h
index 858c56569127..80f908afe348 100644
--- a/kernel/rcu/tiny_plugin.h
+++ b/kernel/rcu/tiny_plugin.h
@@ -145,17 +145,16 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 	rcp->ticks_this_gp++;
 	j = jiffies;
 	js = ACCESS_ONCE(rcp->jiffies_stall);
-	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
+	if (rcp->rcucblist && ULONG_CMP_GE(j, js)) {
 		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
 		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
 		       jiffies - rcp->gp_start, rcp->qlen);
 		dump_stack();
-	}
-	if (*rcp->curtail && ULONG_CMP_GE(j, js))
 		ACCESS_ONCE(rcp->jiffies_stall) = jiffies +
 			3 * rcu_jiffies_till_stall_check() + 3;
-	else if (ULONG_CMP_GE(j, js))
+	} else if (ULONG_CMP_GE(j, js)) {
 		ACCESS_ONCE(rcp->jiffies_stall) = jiffies + rcu_jiffies_till_stall_check();
+	}
 }
 
 static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
-- 
1.8.1.5

