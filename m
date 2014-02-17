Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaBQVjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:39:16 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57923 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaBQVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [PATCH tip/core/rcu 08/12] rcu: Move SRCU grace period work to power efficient workqueue
Date: Mon, 17 Feb 2014 13:35:55 -0800
Message-Id: <1392672959-6386-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-7164-0000-0000-00000626759F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaibal Dutta <shaibal.dutta@broadcom.com>

For better use of CPU idle time, allow the scheduler to select the CPU
on which the SRCU grace period work would be scheduled. This improves
idle residency time and conserves power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Rebased to latest kernel version. Added commit
message. Fixed code alignment.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/srcu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 5db7e9272d37..2359779e1daa 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -398,7 +398,7 @@ void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
 	rcu_batch_queue(&sp->batch_queue, head);
 	if (!sp->running) {
 		sp->running = true;
-		schedule_delayed_work(&sp->work, 0);
+		queue_delayed_work(system_power_efficient_wq, &sp->work, 0);
 	}
 	spin_unlock_irqrestore(&sp->queue_lock, flags);
 }
@@ -674,7 +674,8 @@ static void srcu_reschedule(struct srcu_struct *sp)
 	}
 
 	if (pending)
-		schedule_delayed_work(&sp->work, SRCU_INTERVAL);
+		queue_delayed_work(system_power_efficient_wq,
+				   &sp->work, SRCU_INTERVAL);
 }
 
 /*
-- 
1.8.1.5

