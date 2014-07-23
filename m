Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbaGWFLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:11:12 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:64649 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbaGWFLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:11:06 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 13/16] rcu: Spawn nocb kthreads from rcu_prepare_kthreads()
Date: Wed, 23 Jul 2014 01:09:50 -0400
Message-Id: <1406092194-13004-14-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_prepare_kthreads() is called when a CPU hotplug event happens. We can also
spawn the nocb kthreads from this function. This is preparation for the next
patch which remove the redundant check for rcu_scheduler_fully_active. This
commit moves the spawning of nocb kthreads to rcu_prepare_kthreads().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c        | 1 -
 kernel/rcu/tree_plugin.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index afd54e2..4dc449c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3453,7 +3453,6 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_prepare_cpu(cpu);
 		rcu_prepare_kthreads(cpu);
-		rcu_spawn_all_nocb_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 4d42791..9a50e1d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1488,6 +1488,8 @@ static void rcu_prepare_kthreads(int cpu)
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
 	if (rcu_scheduler_fully_active)
 		rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
+
+	rcu_spawn_all_nocb_kthreads(cpu);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
-- 
2.0.0.rc2

