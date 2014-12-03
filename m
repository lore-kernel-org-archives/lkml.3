Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaLCLnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:43:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaLCL1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pranith Kumar <bobby.prani@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/101] rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads
Date: Wed,  3 Dec 2014 12:26:29 +0100
Message-Id: <4ffc1f8b153b3b0e322fbac381ed4c240d1b7106.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2aa792e6faf1a00f5accf1f69e87e11a390ba2cd upstream.

The rcu_gp_kthread_wake() function checks for three conditions before
waking up grace period kthreads:

*  Is the thread we are trying to wake up the current thread?
*  Are the gp_flags zero? (all threads wait on non-zero gp_flags condition)
*  Is there no thread created for this flavour, hence nothing to wake up?

If any one of these condition is true, we do not call wake_up().
It was found that there are quite a few avoidable wake ups both during
idle time and under stress induced by rcutorture.

Idle:

Total:66000, unnecessary:66000, case1:61827, case2:66000, case3:0
Total:68000, unnecessary:68000, case1:63696, case2:68000, case3:0

rcutorture:

Total:254000, unnecessary:254000, case1:199913, case2:254000, case3:0
Total:256000, unnecessary:256000, case1:201784, case2:256000, case3:0

Here case{1-3} are the cases listed above. We can avoid these wake
ups by using rcu_gp_kthread_wake() to conditionally wake up the grace
period kthreads.

There is a comment about an implied barrier supplied by the wake_up()
logic.  This barrier is necessary for the awakened thread to see the
updated ->gp_flags.  This flag is always being updated with the root node
lock held. Also, the awakened thread tries to acquire the root node lock
before reading ->gp_flags because of which there is proper ordering.

Hence this commit tries to avoid calling wake_up() whenever we can by
using rcu_gp_kthread_wake() function.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/rcutree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ec5848e9d5d9..e27526232b5f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1618,7 +1618,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
@@ -2188,7 +2188,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	}
 	rsp->gp_flags |= RCU_GP_FLAG_FQS;
 	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
-- 
2.1.3

