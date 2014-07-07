Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaGGWk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45125 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaGGWia (ORCPT
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
Subject: [PATCH tip/core/rcu 07/17] rcu: Loosen __call_rcu()'s rcu_head alignment constraint
Date: Mon,  7 Jul 2014 15:38:11 -0700
Message-Id: <1404772701-8804-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-7164-0000-0000-000002F47FC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The m68k architecture aligns only to 16-bit boundaries, which can cause
the align-to-32-bits check in __call_rcu() to trigger.  Because there is
currently no known potential need for more than one low-order bit, this
commit loosens the check to 16-bit boundaries.

Reported-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 6bf7daebcc6b..bcd635e42841 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2662,7 +2662,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	unsigned long flags;
 	struct rcu_data *rdp;
 
-	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
+	WARN_ON_ONCE((unsigned long)head & 0x1); /* Misaligned rcu_head! */
 	if (debug_rcu_head_queue(head)) {
 		/* Probable double call_rcu(), so leak the callback. */
 		ACCESS_ONCE(head->func) = rcu_leak_callback;
-- 
1.8.1.5

