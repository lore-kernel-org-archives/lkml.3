Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaL1QuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:50:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25799 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaL1QuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:50:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] rcu: don't use __this_cpu_* from preemptible context
Date: Sun, 28 Dec 2014 11:49:40 -0500
Message-Id: <1419785381-26133-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "rcu: Make cond_resched_rcu_qs() apply to normal RCU flavors" has added
debug code which tries to read from __this_cpu in a preemptible code, which
doesn't work too well.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/rcu/tree_trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
index a9b79ca..fbb6240 100644
--- a/kernel/rcu/tree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -122,7 +122,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   ulong2long(rdp->completed), ulong2long(rdp->gpnum),
 		   rdp->passed_quiesce,
-		   rdp->rcu_qs_ctr_snap == __this_cpu_read(rcu_qs_ctr),
+		   rdp->rcu_qs_ctr_snap == per_cpu(rcu_qs_ctr, rdp->cpu),
 		   rdp->qs_pending);
 	seq_printf(m, " dt=%d/%llx/%d df=%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
-- 
1.7.10.4

