Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422693AbaDPQGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:06:36 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44398 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422635AbaDPQGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:06:32 -0400
Message-ID: <1397664384.4222.124.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATCH] softirq: a single rcu_bh_qs() call is enough
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Apr 2014 09:06:24 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Calling rcu_bh_qs() after every softirq action is not really needed.

What RCU needs is at least one rcu_bh_qs() per softirq round to note a
quiescent state was passed for rcu_bh

Note for Paul and myself : this could be inlined as a single instruction
and avoid smp_processor_id()
(sone this_cpu_write(rcu_bh_data.passed_quiesce, 1))

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 kernel/softirq.c |    4 +---
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


