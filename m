Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaFMARH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:17:07 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:60361 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaFMARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:17:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] rcu: Only pin GP kthread when full dynticks is actually used
Date: Fri, 13 Jun 2014 02:16:59 +0200
Message-Id: <1402618619-32630-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_NO_HZ_FULL may be enabled widely on distros nowadays but actual
users should be a tiny minority, if actually any.

Also there is a risk that affining the GP kthread to a single CPU could
end up noticeably reducing RCU performances and increasing energy
consumption.

So lets affine the GP kthread only when nohz full is actually used
(ie: when the nohz_full= parameter is filled or CONFIG_NO_HZ_FULL_ALL=y)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/rcu/tree_plugin.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cbc2c45..726f52c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2843,12 +2843,16 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
  */
 static void rcu_bind_gp_kthread(void)
 {
-#ifdef CONFIG_NO_HZ_FULL
-	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
+	int cpu;
+
+	if (!tick_nohz_full_enabled())
+		return;
+
+	cpu = ACCESS_ONCE(tick_do_timer_cpu);
 
 	if (cpu < 0 || cpu >= nr_cpu_ids)
 		return;
+
 	if (raw_smp_processor_id() != cpu)
 		set_cpus_allowed_ptr(current, cpumask_of(cpu));
-#endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
-- 
1.8.3.1

