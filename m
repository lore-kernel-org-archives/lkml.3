Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbbAGRgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:36:05 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56858 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbbAGRcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:32:47 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/14] rcu: Remove redundant callback-list initialization
Date: Wed,  7 Jan 2015 09:32:33 -0800
Message-Id: <1420651953-2651-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0029-0000-0000-00000703EEFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The RCU callback lists are initialized in both rcu_boot_init_percpu_data()
and rcu_init_percpu_data().  The former is intended for initializing
immutable data, so this commit removes the initialization from
rcu_boot_init_percpu_data() and leaves it in rcu_init_percpu_data().
This change prepares for permitting callbacks to be queued very early
in boot.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4ed2c2842103..febd0f72a3c9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3419,9 +3419,6 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
-	init_callback_list(rdp);
-	rdp->qlen_lazy = 0;
-	ACCESS_ONCE(rdp->qlen) = 0;
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
-- 
1.8.1.5

