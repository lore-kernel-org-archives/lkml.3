Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaHMK4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:56:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53315 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaHMK4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:56:47 -0400
Date: Wed, 13 Aug 2014 03:55:45 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-7608a43d8f2e02f8b532f8e11481d7ecf8b5d3f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        paulmck@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        paulmck@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1406752916-3341-5-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-5-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutexes:
  Use MUTEX_SPIN_ON_OWNER when appropriate
Git-Commit-ID: 7608a43d8f2e02f8b532f8e11481d7ecf8b5d3f9
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

Commit-ID:  7608a43d8f2e02f8b532f8e11481d7ecf8b5d3f9
Gitweb:     http://git.kernel.org/tip/7608a43d8f2e02f8b532f8e11481d7ecf8b5d3f9
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Wed, 30 Jul 2014 13:41:54 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:32:02 +0200

locking/mutexes: Use MUTEX_SPIN_ON_OWNER when appropriate

4badad35 ("locking/mutex: Disable optimistic spinning on some
architectures") added a ARCH_SUPPORTS_ATOMIC_RMW flag to
disable the mutex optimistic feature on specific archs.

Because CONFIG_MUTEX_SPIN_ON_OWNER only depended on DEBUG and
SMP, it was ok to have the ->owner field conditional a bit
flexible. However by adding a new variable to the matter,
we can waste space with the unused field, ie: CONFIG_SMP &&
(!CONFIG_MUTEX_SPIN_ON_OWNER && !CONFIG_DEBUG_MUTEX).

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: aswin@hp.com
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1406752916-3341-5-git-send-email-davidlohr@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mutex.h  | 2 +-
 kernel/locking/mutex.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 8d5535c..e4c2941 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -52,7 +52,7 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_MUTEX_SPIN_ON_OWNER)
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
diff --git a/kernel/locking/mutex.h b/kernel/locking/mutex.h
index 4115fbf..5cda397 100644
--- a/kernel/locking/mutex.h
+++ b/kernel/locking/mutex.h
@@ -16,7 +16,7 @@
 #define mutex_remove_waiter(lock, waiter, ti) \
 		__list_del((waiter)->list.prev, (waiter)->list.next)
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 static inline void mutex_set_owner(struct mutex *lock)
 {
 	lock->owner = current;
