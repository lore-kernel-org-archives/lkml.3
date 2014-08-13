Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaHMKz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:55:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHMKzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:55:55 -0400
Date: Wed, 13 Aug 2014 03:54:53 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-242489cfe97d44290e7f88b12591fab6c0819045@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1406752916-3341-1-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-1-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutexes: Standardize arguments in lock
 /unlock slowpaths
Git-Commit-ID: 242489cfe97d44290e7f88b12591fab6c0819045
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

Commit-ID:  242489cfe97d44290e7f88b12591fab6c0819045
Gitweb:     http://git.kernel.org/tip/242489cfe97d44290e7f88b12591fab6c0819045
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Wed, 30 Jul 2014 13:41:50 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:31:58 +0200

locking/mutexes: Standardize arguments in lock/unlock slowpaths

Just how the locking-end behaves, when unlocking, go ahead and
obtain the proper data structure immediately after the previous
(asm-end) call exits and there are (probably) pending waiters.
This simplifies a bit some of the layering.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: jason.low2@hp.com
Cc: aswin@hp.com
Cc: mingo@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/1406752916-3341-1-git-send-email-davidlohr@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
