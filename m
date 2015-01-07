Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbbAGRyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:54:03 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52675 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbAGRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:59 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/10] rcu: Initialize tiny RCU stall-warning timeouts at boot
Date: Wed,  7 Jan 2015 09:52:48 -0800
Message-Id: <1420653168-6434-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
 <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0009-0000-0000-000007C65C66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current tiny RCU stall-warning code assumes that the jiffies counter
starts at zero, however, it is sometimes initialized to other values,
for example, -30,000.  This commit therefore changes rcu_init() to
invoke reset_cpu_stall_ticks() for both flavors of RCU to initialize
the stall-warning times properly at boot.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tiny.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index 0db5649f8817..fc0f2c07af3a 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -383,6 +383,8 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
 void __init rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	RCU_TRACE(reset_cpu_stall_ticks(&rcu_sched_ctrlblk));
+	RCU_TRACE(reset_cpu_stall_ticks(&rcu_bh_ctrlblk));
 
 	rcu_early_boot_tests();
 }
-- 
1.8.1.5

