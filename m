Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084AbaG1FSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:18:53 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:54078 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaG1FSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:18:52 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip/master 1/7] locking/mutex: Unify arguments in lock/unlock slowpaths
Date: Sun, 27 Jul 2014 22:18:38 -0700
Message-Id: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just how the locking-end behaves, when unlocking, go ahead and
obtain the proper data structure immediately after the previous
(asm-end) call exits and there are (probably) pending waiters.
This simplifies a bit some of the layering.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/locking/mutex.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index ae712b2..ad0e333 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -679,9 +679,8 @@ EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
  * Release the lock, slowpath:
  */
 static inline void
-__mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
+__mutex_unlock_common_slowpath(struct mutex *lock, int nested)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
 
 	/*
@@ -716,7 +715,9 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 __visible void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
-	__mutex_unlock_common_slowpath(lock_count, 1);
+	struct mutex *lock = container_of(lock_count, struct mutex, count);
+
+	__mutex_unlock_common_slowpath(lock, 1);
 }
 
 #ifndef CONFIG_DEBUG_LOCK_ALLOC
-- 
1.8.1.4

