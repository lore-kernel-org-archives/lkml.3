Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaGWCeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:34:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:54513 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbaGWCeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:34:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="363778301"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 26/70] rcu, tree: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:02 -0400
Message-Id: <1406080786-3938-27-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from rcu/tree.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/rcu/tree.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 625d0b0..8518338 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3440,28 +3440,26 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	struct rcu_state *rsp;
 
 	trace_rcu_utilization(TPS("Start CPU hotplug"));
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		rcu_prepare_cpu(cpu);
 		rcu_prepare_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		rcu_boost_kthread_setaffinity(rnp, -1);
+		if (!(action & CPU_TASKS_FROZEN))
+			rcu_boost_kthread_setaffinity(rnp, -1);
 		break;
 	case CPU_DOWN_PREPARE:
-		rcu_boost_kthread_setaffinity(rnp, cpu);
+		if (!(action & CPU_TASKS_FROZEN))
+			rcu_boost_kthread_setaffinity(rnp, cpu);
 		break;
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		for_each_rcu_flavor(rsp)
 			rcu_cleanup_dying_cpu(rsp);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		for_each_rcu_flavor(rsp)
 			rcu_cleanup_dead_cpu(cpu, rsp);
 		break;
-- 
2.0.0.rc2

