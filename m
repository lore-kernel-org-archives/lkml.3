Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaG1FS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:18:59 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:11208 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaG1FSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:18:54 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip/master 2/7] locking/mutex: Document quick lock release when unlocking
Date: Sun, 27 Jul 2014 22:18:39 -0700
Message-Id: <1406524724-17946-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unlocking, we always want to reach the slowpath with the lock's counter
indicating it is unlocked. -- as returned by the asm fastpath call or by
explicitly setting it. While doing so, at least in theory, we can optimize
and allow faster lock stealing.

This is not immediately obvious and deserves to be documented.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/locking/mutex.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index ad0e333..7a9be39 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -676,7 +676,8 @@ EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
 #endif
 
 /*
- * Release the lock, slowpath:
+ * Release the lock, slowpath.
+ *  At this point, the lock counter is 0 or negative.
  */
 static inline void
 __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
@@ -684,9 +685,16 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
 	unsigned long flags;
 
 	/*
-	 * some architectures leave the lock unlocked in the fastpath failure
+	 * As a performance measurement, release the lock before doing other
+	 * wakeup related duties to follow. This allows other tasks to acquire
+	 * the lock sooner, while still handling cleanups in past unlock calls.
+	 * This can be done as we do not enforce strict equivalence between the
+	 * mutex counter and wait_list.
+	 *
+	 *
+	 * Some architectures leave the lock unlocked in the fastpath failure
 	 * case, others need to leave it locked. In the later case we have to
-	 * unlock it here
+	 * unlock it here.
 	 */
 	if (__mutex_slowpath_needs_to_unlock())
 		atomic_set(&lock->count, 1);
-- 
1.8.1.4

