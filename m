Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3IYBa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:30:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49351 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab3IYB3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Kirill Tkhai <tkhai@yandex.ru>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/11] rcu: Fix CONFIG_RCU_NOCB_CPU_ALL panic on machines with sparse CPU mask
Date: Tue, 24 Sep 2013 18:29:21 -0700
Message-Id: <1380072561-31134-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-1344-0000-0000-000001EAFF0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <tkhai@yandex.ru>

Some architectures have sparse cpu mask. UltraSparc's cpuinfo for example:

CPU0: online
CPU2: online

So, set only possible CPUs when CONFIG_RCU_NOCB_CPU_ALL is enabled.

Also, check that user passes right 'rcu_nocbs=' option.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Dipankar Sarma <dipankar@in.ibm.com>
[ paulmck: Fix pr_info() issue noted by scripts/checkpatch.pl. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c684f7a..1855d66 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -96,10 +96,15 @@ static void __init rcu_bootup_announce_oddness(void)
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
 #ifdef CONFIG_RCU_NOCB_CPU_ALL
 	pr_info("\tOffload RCU callbacks from all CPUs\n");
-	cpumask_setall(rcu_nocb_mask);
+	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
 	if (have_rcu_nocb_mask) {
+		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
+			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
+			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
+				    rcu_nocb_mask);
+		}
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
 		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
 		if (rcu_nocb_poll)
-- 
1.8.1.5

