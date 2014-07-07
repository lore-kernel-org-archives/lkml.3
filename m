Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaGGWkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38216 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaGGWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/17] signal: Explain local_irq_save() call
Date: Mon,  7 Jul 2014 15:38:07 -0700
Message-Id: <1404772701-8804-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-3532-0000-0000-000002FA8B81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The explicit local_irq_save() in __lock_task_sighand() is needed to avoid
a potential deadlock condition, as noted in a841796f11c90d53 (signal:
align __lock_task_sighand() irq disabling and RCU).  However, someone
reading the code might be forgiven for concluding that this separate
local_irq_save() was completely unnecessary.  This commit therefore adds
a comment referencing the shiny new block comment on rcu_read_unlock().

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index a4077e90f19f..46161e744760 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1263,6 +1263,10 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 	struct sighand_struct *sighand;
 
 	for (;;) {
+		/*
+		 * Disable interrupts early to avoid deadlocks.
+		 * See rcu_read_unlock comment header for details.
+		 */
 		local_irq_save(*flags);
 		rcu_read_lock();
 		sighand = rcu_dereference(tsk->sighand);
-- 
1.8.1.5

