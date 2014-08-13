Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaHMK6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:58:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHMK6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:58:09 -0400
Date: Wed, 13 Aug 2014 03:57:11 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-ae17ea0ec7d8fa64fbb773a52b2df5ba4766bcb8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, fengguang.wu@intel.com,
        scott.norton@hp.com, maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, scott.norton@hp.com,
        fengguang.wu@intel.com, maarten.lankhorst@canonical.com
In-Reply-To: <1407345722-61615-3-git-send-email-Waiman.Long@hp.com>
References: <1407345722-61615-3-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/selftest: Support queued rwlock
Git-Commit-ID: ae17ea0ec7d8fa64fbb773a52b2df5ba4766bcb8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae17ea0ec7d8fa64fbb773a52b2df5ba4766bcb8
Gitweb:     http://git.kernel.org/tip/ae17ea0ec7d8fa64fbb773a52b2df5ba4766bcb8
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Wed, 6 Aug 2014 13:22:02 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:33:35 +0200

locking/selftest: Support queued rwlock

The queued rwlock does not support the use of recursive read-lock in
the process context. With changes in the lockdep code to check and
disallow recursive read-lock, it is also necessary for the locking
selftest to be updated to change the process context recursive read
locking results from SUCCESS to FAILURE for rwlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1407345722-61615-3-git-send-email-Waiman.Long@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/locking-selftest.c | 56 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 7 deletions(-)

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
