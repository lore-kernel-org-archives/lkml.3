Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbaD1X6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:58:05 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40179 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbaD1X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 19/19] softirq: A single rcu_bh_qs() call per softirq set is enough
Date: Mon, 28 Apr 2014 16:56:32 -0700
Message-Id: <1398729392-15087-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-1542-0000-0000-00000169B42A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Calling rcu_bh_qs() after every softirq action is not really needed.
What RCU needs is at least one rcu_bh_qs() per softirq round to note a
quiescent state was passed for rcu_bh.

Note for Paul and myself : this could be inlined as a single instruction
and avoid smp_processor_id()
(sone this_cpu_write(rcu_bh_data.passed_quiesce, 1))

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/softirq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b50990a5bea0..b9b2d4906848 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -232,7 +232,6 @@ asmlinkage void __do_softirq(void)
 	bool in_hardirq;
 	__u32 pending;
 	int softirq_bit;
-	int cpu;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -247,7 +246,6 @@ asmlinkage void __do_softirq(void)
 	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_OFFSET);
 	in_hardirq = lockdep_softirq_start();
 
-	cpu = smp_processor_id();
 restart:
 	/* Reset the pending bitmask before enabling irqs */
 	set_softirq_pending(0);
@@ -276,11 +274,11 @@ restart:
 			       prev_count, preempt_count());
 			preempt_count_set(prev_count);
 		}
-		rcu_bh_qs(cpu);
 		h++;
 		pending >>= softirq_bit;
 	}
 
+	rcu_bh_qs(smp_processor_id());
 	local_irq_disable();
 
 	pending = local_softirq_pending();
-- 
1.8.1.5

