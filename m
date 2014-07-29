Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaG2Sxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:53:33 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:27816 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaG2Sxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:53:30 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2 v6] locking/selftest: Support queued rwlock
Date: Tue, 29 Jul 2014 14:53:19 -0400
Message-Id: <1406659999-13974-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com>
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The queued rwlock does not support the use of recursive read-lock in
the process context. With changes in the lockdep code to check and
disallow recursive read-lock, it is also necessary for the locking
selftest to be updated to change the process context recursive read
locking results from SUCCESS to FAILURE for rwlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 lib/locking-selftest.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 872a15a..9a33688 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -267,19 +267,19 @@ GENERATE_TESTCASE(AA_rsem)
 #undef E
 
 /*
- * Special-case for read-locking, they are
+ * Special-case for read-locking, they are not
  * allowed to recurse on the same lock class:
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
 }
 
 static void rsem_AA1(void)
@@ -1069,7 +1069,7 @@ static inline void print_testname(const char *testname)
 	print_testname(desc);					\
 	dotest(name##_spin, FAILURE, LOCKTYPE_SPIN);		\
 	dotest(name##_wlock, FAILURE, LOCKTYPE_RWLOCK);		\
-	dotest(name##_rlock, SUCCESS, LOCKTYPE_RWLOCK);		\
+	dotest(name##_rlock, FAILURE, LOCKTYPE_RWLOCK);		\
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
@@ -1830,14 +1830,14 @@ void locking_selftest(void)
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
-- 
1.7.1

