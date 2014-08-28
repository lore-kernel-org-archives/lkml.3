Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaH1Skp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:40:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55970 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbaH1Sih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/14] rcu: Check for have_rcu_nocb_mask instead of rcu_nocb_mask
Date: Thu, 28 Aug 2014 11:38:12 -0700
Message-Id: <1409251097-26734-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-1542-0000-0000-0000045F6D9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

If we configure a kernel with CONFIG_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_NONE=y and
CONFIG_CPUMASK_OFFSTACK=n and do not pass in a rcu_nocb= boot parameter, the
cpumask rcu_nocb_mask can be garbage instead of NULL.

Hence this commit replaces checks for rcu_nocb_mask == NULL with a check for
have_rcu_nocb_mask.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index d7a9e252084f..af01133dfd67 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2578,7 +2578,7 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
 	struct rcu_data *rdp_prev = NULL;
 
-	if (rcu_nocb_mask == NULL)
+	if (!have_rcu_nocb_mask)
 		return;
 	if (ls == -1) {
 		ls = int_sqrt(nr_cpu_ids);
@@ -2608,9 +2608,9 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 /* Prevent __call_rcu() from enqueuing callbacks on no-CBs CPUs */
 static bool init_nocb_callback_list(struct rcu_data *rdp)
 {
-	if (rcu_nocb_mask == NULL ||
-	    !cpumask_test_cpu(rdp->cpu, rcu_nocb_mask))
+	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return false;
+
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
 	return true;
 }
-- 
1.8.1.5

