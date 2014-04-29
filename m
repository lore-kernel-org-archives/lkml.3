Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbaD2A2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:28:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37459 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092AbaD2AZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 38/45] rcutorture: Add missing destroy_timer_on_stack()
Date: Mon, 28 Apr 2014 17:25:26 -0700
Message-Id: <1398731133-18925-38-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-7164-0000-0000-0000015FD300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The rcu_torture_reader() function uses an on-stack timer_list structure
which it initializes with setup_timer_on_stack().  However, it fails to
use destroy_timer_on_stack() before exiting, which results in leaking a
tracking object if DEBUG_OBJECTS is enabled.  This commit therefore
invokes destroy_timer_on_stack() to avoid this leakage.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 576d12263c81..a576583dd81e 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1022,8 +1022,10 @@ rcu_torture_reader(void *arg)
 		cond_resched();
 		stutter_wait("rcu_torture_reader");
 	} while (!torture_must_stop());
-	if (irqreader && cur_ops->irq_capable)
+	if (irqreader && cur_ops->irq_capable) {
 		del_timer_sync(&t);
+		destroy_timer_on_stack(&t);
+	}
 	torture_kthread_stopping("rcu_torture_reader");
 	return 0;
 }
-- 
1.8.1.5

