Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaJ1W17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:27:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60979 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbaJ1W1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:27:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/7] rcu: Kick rcuo kthreads after their CPU goes offline
Date: Tue, 28 Oct 2014 15:23:01 -0700
Message-Id: <1414534982-29203-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F50640
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If a no-CBs CPU were to post an RCU callback with interrupts disabled
after it entered the idle loop for the last time, there might be no
deferred wakeup for the corresponding rcuo kthreads.  This commit
therefore adds a set of calls to do_nocb_deferred_wakeup() after the
CPU has gone completely offline.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9e3c20f117cd..07bf4aa68d50 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3497,8 +3497,10 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		for_each_rcu_flavor(rsp)
+		for_each_rcu_flavor(rsp) {
 			rcu_cleanup_dead_cpu(cpu, rsp);
+			do_nocb_deferred_wakeup(per_cpu_ptr(rsp->rda, cpu));
+		}
 		break;
 	default:
 		break;
-- 
1.8.1.5

