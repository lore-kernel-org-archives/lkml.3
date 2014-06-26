Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaFZRjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:39:41 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:52531 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843AbaFZRji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:39:38 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v5 2/2] locking-selftest: Support queue rwlock
Date: Thu, 26 Jun 2014 13:39:11 -0400
Message-Id: <1403804351-405-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403804351-405-1-git-send-email-Waiman.Long@hp.com>
References: <1403804351-405-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The queue rwlock does not support the use of recursive read-lock in
the process context. With changes in the lockdep code to check and
disallow recursive read-lock when queue rwlock is configured, it
is also necessary for the locking selftest to be updated to change
the process context recursive read locking results from SUCCESS to
FAILURE for queue rwlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 lib/locking-selftest.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 872a15a..0ba8816 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -940,6 +940,16 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 		init_rwsem(&rwsem_##x);		\
 	} while (0)
 
+/*
+ * If queue rwlock is used, recursive read-lock is not allowed in the
+ * process context. It is allowed in the interrupt context.
+ */
+#ifdef CONFIG_QUEUE_RWLOCK
+#define RRLOCK_RESULT	FAILURE
+#else
+#define RRLOCK_RESULT	SUCCESS
+#endif
+
 static void reset_locks(void)
 {
 	local_irq_disable();
@@ -1069,7 +1079,7 @@ static inline void print_testname(const char *testname)
 	print_testname(desc);					\
 	dotest(name##_spin, FAILURE, LOCKTYPE_SPIN);		\
 	dotest(name##_wlock, FAILURE, LOCKTYPE_RWLOCK);		\
-	dotest(name##_rlock, SUCCESS, LOCKTYPE_RWLOCK);		\
+	dotest(name##_rlock, RRLOCK_RESULT, LOCKTYPE_RWLOCK);	\
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
@@ -1830,14 +1840,14 @@ void locking_selftest(void)
 	printk("  --------------------------------------------------------------------------\n");
 	print_testname("recursive read-lock");
 	printk("             |");
-	dotest(rlock_AA1, SUCCESS, LOCKTYPE_RWLOCK);
+	dotest(rlock_AA1, RRLOCK_RESULT, LOCKTYPE_RWLOCK);
 	printk("             |");
 	dotest(rsem_AA1, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
 
 	print_testname("recursive read-lock #2");
 	printk("             |");
-	dotest(rlock_AA1B, SUCCESS, LOCKTYPE_RWLOCK);
+	dotest(rlock_AA1B, RRLOCK_RESULT, LOCKTYPE_RWLOCK);
 	printk("             |");
 	dotest(rsem_AA1B, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
-- 
1.7.1

