Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3IYBoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:44:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41778 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab3IYBm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:58 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/10] rcu: Distinguish between NOCB and non-NOCB rcu_callback trace events
Date: Tue, 24 Sep 2013 18:42:36 -0700
Message-Id: <1380073359-31959-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0320-0000-0000-0000011DA9B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

One way to distinguish between NOCB and non-NOCB rcu_callback trace
events is that the former always print zero for the lazy and non-lazy
queue lengths.  Unfortunately, this also means that we cannot see the NOCB
queue lengths.  This commit therefore accesses the NOCB queue lengths,
but negates them.  NOCB rcu_callback trace events should therefore have
negative queue lengths.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
[ paulmck: Match operand size per kbuild test robot's advice. ]
---
 kernel/rcutree_plugin.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f4ed24b..24b01b6 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2147,10 +2147,12 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
 		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
 					 (unsigned long)rhp->func,
-					 rdp->qlen_lazy, rdp->qlen);
+					 -atomic_long_read(&rdp->nocb_q_count_lazy),
+					 -atomic_long_read(&rdp->nocb_q_count));
 	else
 		trace_rcu_callback(rdp->rsp->name, rhp,
-				   rdp->qlen_lazy, rdp->qlen);
+				   -atomic_long_read(&rdp->nocb_q_count_lazy),
+				   -atomic_long_read(&rdp->nocb_q_count));
 	return 1;
 }
 
-- 
1.8.1.5

