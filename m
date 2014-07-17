Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbaGQV3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:29:46 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:40980 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaGQV3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:29:44 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 1/1] rcu: Check for have_rcu_nocb_mask instead of rcu_nocb_mask
Date: Thu, 17 Jul 2014 17:30:11 -0400
Message-Id: <1405632611-29872-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

This is something similar to what you found yesterday with tick_nohz_full mask.

--
Pranith

If we configure a kernel with CONFIG_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_NONE=y and
CONFIG_CPUMASK_OFFSTACK=n and do not pass in a rcu_nocb= boot parameter, the
cpumask rcu_nocb_mask can be garbage instead of NULL.

Hence this commit replaces checks for rcu_nocb_mask == NULL with a check for
have_rcu_nocb_mask.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cedb020..15c00b5 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2542,7 +2542,7 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
 	struct rcu_data *rdp_prev = NULL;
 
-	if (rcu_nocb_mask == NULL)
+	if (!have_rcu_nocb_mask)
 		return;
 #ifdef CONFIG_NO_HZ_FULL
 	cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
@@ -2575,7 +2575,7 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 /* Prevent __call_rcu() from enqueuing callbacks on no-CBs CPUs */
 static bool init_nocb_callback_list(struct rcu_data *rdp)
 {
-	if (rcu_nocb_mask == NULL ||
+	if (have_rcu_nocb_mask == false ||
 	    !cpumask_test_cpu(rdp->cpu, rcu_nocb_mask))
 		return false;
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
-- 
1.9.1

