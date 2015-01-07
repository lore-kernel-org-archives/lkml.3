Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbbAGSVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:21:36 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46783 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbbAGSTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/12] rcutorture: Drop rcu_torture_completed() and friends
Date: Wed,  7 Jan 2015 10:19:32 -0800
Message-Id: <1420654779-11213-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0017-0000-0000-000007BDE465
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that the return type of rcu_batches_completed() and friends matches
that of the rcu_torture_ops structure's ->completed field, the wrapper
functions can be deleted.  This commit carries out that deletion, while
also wiring "sched"'s ->completed field to rcu_batches_completed_sched().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index f43e3517f5f5..aadbc072ccf4 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -296,11 +296,6 @@ static void rcu_torture_read_unlock(int idx) __releases(RCU)
 	rcu_read_unlock();
 }
 
-static unsigned long rcu_torture_completed(void)
-{
-	return rcu_batches_completed();
-}
-
 /*
  * Update callback in the pipe.  This should be invoked after a grace period.
  */
@@ -377,7 +372,7 @@ static struct rcu_torture_ops rcu_ops = {
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
-	.completed	= rcu_torture_completed,
+	.completed	= rcu_batches_completed,
 	.deferred_free	= rcu_torture_deferred_free,
 	.sync		= synchronize_rcu,
 	.exp_sync	= synchronize_rcu_expedited,
@@ -407,11 +402,6 @@ static void rcu_bh_torture_read_unlock(int idx) __releases(RCU_BH)
 	rcu_read_unlock_bh();
 }
 
-static unsigned long rcu_bh_torture_completed(void)
-{
-	return rcu_batches_completed_bh();
-}
-
 static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 {
 	call_rcu_bh(&p->rtort_rcu, rcu_torture_cb);
@@ -423,7 +413,7 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
-	.completed	= rcu_bh_torture_completed,
+	.completed	= rcu_batches_completed_bh,
 	.deferred_free	= rcu_bh_torture_deferred_free,
 	.sync		= synchronize_rcu_bh,
 	.exp_sync	= synchronize_rcu_bh_expedited,
@@ -600,7 +590,7 @@ static struct rcu_torture_ops sched_ops = {
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
-	.completed	= rcu_no_completed,
+	.completed	= rcu_batches_completed_sched,
 	.deferred_free	= rcu_sched_torture_deferred_free,
 	.sync		= synchronize_sched,
 	.exp_sync	= synchronize_sched_expedited,
-- 
1.8.1.5

