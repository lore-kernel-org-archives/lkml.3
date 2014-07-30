Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaG3Um3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:42:29 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:41469 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaG3UmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:42:10 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip v2 5/7] locking/mutex: Use MUTEX_SPIN_ON_OWNER when appropriate
Date: Wed, 30 Jul 2014 13:41:54 -0700
Message-Id: <1406752916-3341-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406752916-3341-1-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4badad35 (locking/mutex: Disable optimistic spinning on some
architectures) added a ARCH_SUPPORTS_ATOMIC_RMW flag to
disable the mutex optimistic feature on specific archs.

Because CONFIG_MUTEX_SPIN_ON_OWNER only depended on DEBUG and
SMP, it was ok to have the ->owner field conditional a bit
flexible. However by adding a new variable to the matter,
we can waste space with the unused field, ie: CONFIG_SMP &&
(!CONFIG_MUTEX_SPIN_ON_OWNER && !CONFIG_DEBUG_MUTEX).

Acked-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
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
-- 
1.8.1.4

