Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbbAGSTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:19:52 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40586 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbbAGSTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/12] rcutorture: Use unsigned for Reader Batch computations
Date: Wed,  7 Jan 2015 10:19:30 -0800
Message-Id: <1420654779-11213-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0013-0000-0000-000007B572AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The counter returned by the various ->completed functions is subject to
overflow, which means that subtracting two such counters might result
in overflow, which invokes undefined behavior in the C standard.  This
commit therefore changes these functions and variables to unsigned to
avoid this undefined behavior.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 4d559baf06e0..f43e3517f5f5 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -244,7 +244,7 @@ struct rcu_torture_ops {
 	int (*readlock)(void);
 	void (*read_delay)(struct torture_random_state *rrsp);
 	void (*readunlock)(int idx);
-	int (*completed)(void);
+	unsigned long (*completed)(void);
 	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
 	void (*exp_sync)(void);
@@ -296,7 +296,7 @@ static void rcu_torture_read_unlock(int idx) __releases(RCU)
 	rcu_read_unlock();
 }
 
-static int rcu_torture_completed(void)
+static unsigned long rcu_torture_completed(void)
 {
 	return rcu_batches_completed();
 }
@@ -356,7 +356,7 @@ rcu_torture_cb(struct rcu_head *p)
 		cur_ops->deferred_free(rp);
 }
 
-static int rcu_no_completed(void)
+static unsigned long rcu_no_completed(void)
 {
 	return 0;
 }
@@ -407,7 +407,7 @@ static void rcu_bh_torture_read_unlock(int idx) __releases(RCU_BH)
 	rcu_read_unlock_bh();
 }
 
-static int rcu_bh_torture_completed(void)
+static unsigned long rcu_bh_torture_completed(void)
 {
 	return rcu_batches_completed_bh();
 }
@@ -510,7 +510,7 @@ static void srcu_torture_read_unlock(int idx) __releases(&srcu_ctl)
 	srcu_read_unlock(&srcu_ctl, idx);
 }
 
-static int srcu_torture_completed(void)
+static unsigned long srcu_torture_completed(void)
 {
 	return srcu_batches_completed(&srcu_ctl);
 }
@@ -1015,8 +1015,8 @@ static void rcutorture_trace_dump(void)
 static void rcu_torture_timer(unsigned long unused)
 {
 	int idx;
-	int completed;
-	int completed_end;
+	unsigned long completed;
+	unsigned long completed_end;
 	static DEFINE_TORTURE_RANDOM(rand);
 	static DEFINE_SPINLOCK(rand_lock);
 	struct rcu_torture *p;
@@ -1073,8 +1073,8 @@ static void rcu_torture_timer(unsigned long unused)
 static int
 rcu_torture_reader(void *arg)
 {
-	int completed;
-	int completed_end;
+	unsigned long completed;
+	unsigned long completed_end;
 	int idx;
 	DEFINE_TORTURE_RANDOM(rand);
 	struct rcu_torture *p;
-- 
1.8.1.5

