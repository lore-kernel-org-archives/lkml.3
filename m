Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525Ab3BNR7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:59:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54833 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab3BNR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:59:53 -0500
Date: Thu, 14 Feb 2013 09:58:41 -0800
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-d751f38c002c3fd9334b0a2622da149c73bee979@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yong.zhang0@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, yong.zhang0@gmail.com
In-Reply-To: <1334559716-18447-2-git-send-email-yong.zhang0@gmail.com>
References: <1334559716-18447-2-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Selftest:
  convert spinlock to raw spinlock
Git-Commit-ID: d751f38c002c3fd9334b0a2622da149c73bee979
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 14 Feb 2013 09:58:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d751f38c002c3fd9334b0a2622da149c73bee979
Gitweb:     http://git.kernel.org/tip/d751f38c002c3fd9334b0a2622da149c73bee979
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Mon, 16 Apr 2012 15:01:55 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 14 Feb 2013 18:39:07 +0100

lockdep: Selftest: convert spinlock to raw spinlock

To make the lockdep selftest working on RT we need to convert the
spinlock tests to a raw spinlock. Otherwise we cannot run the irq
context checks. For mainline this is just annotational as spinlocks
are mapped to raw_spinlocks anyway.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Link: http://lkml.kernel.org/r/1334559716-18447-2-git-send-email-yong.zhang0@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 lib/locking-selftest.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 7aae0f2..c3eb261 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -47,10 +47,10 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
  * Normal standalone locks, for the circular and irq-context
  * dependency tests:
  */
-static DEFINE_SPINLOCK(lock_A);
-static DEFINE_SPINLOCK(lock_B);
-static DEFINE_SPINLOCK(lock_C);
-static DEFINE_SPINLOCK(lock_D);
+static DEFINE_RAW_SPINLOCK(lock_A);
+static DEFINE_RAW_SPINLOCK(lock_B);
+static DEFINE_RAW_SPINLOCK(lock_C);
+static DEFINE_RAW_SPINLOCK(lock_D);
 
 static DEFINE_RWLOCK(rwlock_A);
 static DEFINE_RWLOCK(rwlock_B);
@@ -73,12 +73,12 @@ static DECLARE_RWSEM(rwsem_D);
  * but X* and Y* are different classes. We do this so that
  * we do not trigger a real lockup:
  */
-static DEFINE_SPINLOCK(lock_X1);
-static DEFINE_SPINLOCK(lock_X2);
-static DEFINE_SPINLOCK(lock_Y1);
-static DEFINE_SPINLOCK(lock_Y2);
-static DEFINE_SPINLOCK(lock_Z1);
-static DEFINE_SPINLOCK(lock_Z2);
+static DEFINE_RAW_SPINLOCK(lock_X1);
+static DEFINE_RAW_SPINLOCK(lock_X2);
+static DEFINE_RAW_SPINLOCK(lock_Y1);
+static DEFINE_RAW_SPINLOCK(lock_Y2);
+static DEFINE_RAW_SPINLOCK(lock_Z1);
+static DEFINE_RAW_SPINLOCK(lock_Z2);
 
 static DEFINE_RWLOCK(rwlock_X1);
 static DEFINE_RWLOCK(rwlock_X2);
@@ -107,10 +107,10 @@ static DECLARE_RWSEM(rwsem_Z2);
  */
 #define INIT_CLASS_FUNC(class) 				\
 static noinline void					\
-init_class_##class(spinlock_t *lock, rwlock_t *rwlock, struct mutex *mutex, \
-		 struct rw_semaphore *rwsem)		\
+init_class_##class(raw_spinlock_t *lock, rwlock_t *rwlock, \
+	struct mutex *mutex, struct rw_semaphore *rwsem)\
 {							\
-	spin_lock_init(lock);				\
+	raw_spin_lock_init(lock);			\
 	rwlock_init(rwlock);				\
 	mutex_init(mutex);				\
 	init_rwsem(rwsem);				\
@@ -168,10 +168,10 @@ static void init_shared_classes(void)
  * Shortcuts for lock/unlock API variants, to keep
  * the testcases compact:
  */
-#define L(x)			spin_lock(&lock_##x)
-#define U(x)			spin_unlock(&lock_##x)
+#define L(x)			raw_spin_lock(&lock_##x)
+#define U(x)			raw_spin_unlock(&lock_##x)
 #define LU(x)			L(x); U(x)
-#define SI(x)			spin_lock_init(&lock_##x)
+#define SI(x)			raw_spin_lock_init(&lock_##x)
 
 #define WL(x)			write_lock(&rwlock_##x)
 #define WU(x)			write_unlock(&rwlock_##x)
@@ -911,7 +911,7 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 
 #define I2(x)					\
 	do {					\
-		spin_lock_init(&lock_##x);	\
+		raw_spin_lock_init(&lock_##x);	\
 		rwlock_init(&rwlock_##x);	\
 		mutex_init(&mutex_##x);		\
 		init_rwsem(&rwsem_##x);		\
