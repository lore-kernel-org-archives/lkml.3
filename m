Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbbAGRVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:21:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40834 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbbAGRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:21:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/10] rcupdate: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Wed,  7 Jan 2015 09:20:52 -0800
Message-Id: <1420651257-553-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107172030.GA31571@linux.vnet.ibm.com>
 <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0021-0000-0000-000007937767
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ed4f5939a452..386ba288084a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -582,11 +582,11 @@ static inline void rcu_preempt_sleep_check(void)
 })
 #define __rcu_dereference_check(p, c, space) \
 ({ \
-	typeof(*p) *_________p1 = (typeof(*p) *__force)ACCESS_ONCE(p); \
+	/* Dependency order vs. p above. */ \
+	typeof(*p) *________p1 = (typeof(*p) *__force)lockless_dereference(p); \
 	rcu_lockdep_assert(c, "suspicious rcu_dereference_check() usage"); \
 	rcu_dereference_sparse(p, space); \
-	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
-	((typeof(*p) __force __kernel *)(_________p1)); \
+	((typeof(*p) __force __kernel *)(________p1)); \
 })
 #define __rcu_dereference_protected(p, c, space) \
 ({ \
@@ -603,10 +603,10 @@ static inline void rcu_preempt_sleep_check(void)
 })
 #define __rcu_dereference_index_check(p, c) \
 ({ \
-	typeof(p) _________p1 = ACCESS_ONCE(p); \
+	/* Dependency order vs. p above. */ \
+	typeof(p) _________p1 = lockless_dereference(p); \
 	rcu_lockdep_assert(c, \
 			   "suspicious rcu_dereference_index_check() usage"); \
-	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
 	(_________p1); \
 })
 
-- 
1.8.1.5

