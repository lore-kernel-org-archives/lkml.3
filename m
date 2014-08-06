Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbaHFRWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:22:32 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:31597 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbaHFRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:22:29 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v7 2/2] locking/selftest: Support queued rwlock
Date: Wed,  6 Aug 2014 13:22:02 -0400
Message-Id: <1407345722-61615-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407345722-61615-1-git-send-email-Waiman.Long@hp.com>
References: <1407345722-61615-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The queued rwlock does not support the use of recursive read-lock in
the process context. With changes in the lockdep code to check and
disallow recursive read-lock, it is also necessary for the locking
selftest to be updated to change the process context recursive read
locking results from SUCCESS to FAILURE for rwlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 lib/locking-selftest.c |   56 ++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 872a15a..62af709 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -267,19 +267,46 @@ GENERATE_TESTCASE(AA_rsem)
 #undef E
 
 /*
- * Special-case for read-locking, they are
- * allowed to recurse on the same lock class:
+ * Special-case for read-locking, they are not allowed to
+ * recurse on the same lock class except under interrupt context:
  */
 static void rlock_AA1(void)
 {
 	RL(X1);
-	RL(X1); // this one should NOT fail
+	RL(X1); // this one should fail
 }
 
 static void rlock_AA1B(void)
 {
 	RL(X1);
-	RL(X2); // this one should NOT fail
+	RL(X2); // this one should fail
+}
+
+static void rlock_AHA1(void)
+{
+	RL(X1);
+	HARDIRQ_ENTER();
+	RL(X1);	// this one should NOT fail
+	HARDIRQ_EXIT();
+}
+
+static void rlock_AHA1B(void)
+{
+	RL(X1);
+	HARDIRQ_ENTER();
+	RL(X2);	// this one should NOT fail
+	HARDIRQ_EXIT();
+}
+
+static void rlock_ASAHA1(void)
+{
+	RL(X1);
+	SOFTIRQ_ENTER();
+	RL(X1);	// this one should NOT fail
+	HARDIRQ_ENTER();
+	RL(X1);	// this one should NOT fail
+	HARDIRQ_EXIT();
+	SOFTIRQ_EXIT();
 }
 
 static void rsem_AA1(void)
@@ -1069,7 +1096,7 @@ static inline void print_testname(const char *testname)
 	print_testname(desc);					\
 	dotest(name##_spin, FAILURE, LOCKTYPE_SPIN);		\
 	dotest(name##_wlock, FAILURE, LOCKTYPE_RWLOCK);		\
-	dotest(name##_rlock, SUCCESS, LOCKTYPE_RWLOCK);		\
+	dotest(name##_rlock, FAILURE, LOCKTYPE_RWLOCK);		\
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
@@ -1830,14 +1857,14 @@ void locking_selftest(void)
 	printk("  --------------------------------------------------------------------------\n");
 	print_testname("recursive read-lock");
 	printk("             |");
-	dotest(rlock_AA1, SUCCESS, LOCKTYPE_RWLOCK);
+	dotest(rlock_AA1, FAILURE, LOCKTYPE_RWLOCK);
 	printk("             |");
 	dotest(rsem_AA1, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
 
 	print_testname("recursive read-lock #2");
 	printk("             |");
-	dotest(rlock_AA1B, SUCCESS, LOCKTYPE_RWLOCK);
+	dotest(rlock_AA1B, FAILURE, LOCKTYPE_RWLOCK);
 	printk("             |");
 	dotest(rsem_AA1B, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
@@ -1856,6 +1883,21 @@ void locking_selftest(void)
 	dotest(rsem_AA3, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
 
+	print_testname("recursive rlock with interrupt");
+	printk("             |");
+	dotest(rlock_AHA1, SUCCESS, LOCKTYPE_RWLOCK);
+	printk("\n");
+
+	print_testname("recursive rlock with interrupt #2");
+	printk("             |");
+	dotest(rlock_AHA1B, SUCCESS, LOCKTYPE_RWLOCK);
+	printk("\n");
+
+	print_testname("recursive rlock with interrupt #3");
+	printk("             |");
+	dotest(rlock_ASAHA1, SUCCESS, LOCKTYPE_RWLOCK);
+	printk("\n");
+
 	printk("  --------------------------------------------------------------------------\n");
 
 	/*
-- 
1.7.1

