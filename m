Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab3CRVhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:37:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58285 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108Ab3CRVhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:00 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/15] rcu: Rearrange locking in rcu_start_gp()
Date: Mon, 18 Mar 2013 14:36:45 -0700
Message-Id: <1363642610-21390-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-9360-0000-0000-000011602006
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

If CPUs are to give prior notice of needed grace periods, it will be
necessary to invoke rcu_start_gp() without dropping the root rcu_node
structure's ->lock.  This commit takes a first step in this direction
by moving the release of this lock to the end of rcu_start_gp().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7b1d776..2c6a931 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1521,16 +1521,14 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
-	raw_spin_unlock(&rnp->lock); /* Interrupts remain disabled. */
 
 	/* Ensure that CPU is aware of completion of last grace period. */
-	rcu_process_gp_end(rsp, rdp);
-	local_irq_restore(flags);
+	__rcu_process_gp_end(rsp, rdp->mynode, rdp);
 
 	/* Wake up rcu_gp_kthread() to start the grace period. */
 	wake_up(&rsp->gp_wq);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
-- 
1.8.1.5

