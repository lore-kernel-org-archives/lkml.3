Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3KPAZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:25:37 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57552 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3KPAXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/16] rcu: Fix CONFIG_RCU_FANOUT_EXACT for odd fanout/leaf values
Date: Fri, 15 Nov 2013 16:23:30 -0800
Message-Id: <1384561418-30575-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-7164-0000-0000-0000035AF092
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Each element of the rcu_state structure's ->levelspread[] array
is intended to contain the per-level fanout, where the zero-th
element corresponds to the root of the rcu_node tree, and the last
element corresponds to the leaves.  In the CONFIG_RCU_FANOUT_EXACT
case, this means that the last element should be filled in
from CONFIG_RCU_FANOUT_LEAF (or from the rcu_fanout_leaf boot
parameter, if provided) and that the remaining elements should
be filled in from CONFIG_RCU_FANOUT.  Unfortunately, the current
code in rcu_init_levelspread() takes the opposite approach, placing
CONFIG_RCU_FANOUT_LEAF in the zero-th element and CONFIG_RCU_FANOUT in
the remaining elements.

For typical power-of-two values, this generates odd but functional
rcu_node trees.  However, other values, for example CONFIG_RCU_FANOUT=3
and CONFIG_RCU_FANOUT_LEAF=2, generate trees that can leave some CPUs
out of the grace-period computation, resulting in too-short grace periods
and therefore a broken RCU implementation.

This commit therefore fixes rcu_init_levelspread() to set the last
->levelspread[] array element from CONFIG_RCU_FANOUT_LEAF and the
remaining elements from CONFIG_RCU_FANOUT, thus generating the
intended rcu_node trees.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e0a58eca0092..13d1a1a0d60a 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3246,9 +3246,9 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 {
 	int i;
 
-	for (i = rcu_num_lvls - 1; i > 0; i--)
+	rsp->levelspread[rcu_num_lvls - 1] = rcu_fanout_leaf;
+	for (i = rcu_num_lvls - 2; i >= 0; i--)
 		rsp->levelspread[i] = CONFIG_RCU_FANOUT;
-	rsp->levelspread[0] = rcu_fanout_leaf;
 }
 #else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
 static void __init rcu_init_levelspread(struct rcu_state *rsp)
-- 
1.8.1.5

