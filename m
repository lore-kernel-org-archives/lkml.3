Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaG3Um2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:42:28 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:39218 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaG3UmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:42:10 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip v2 2/7] locking/mutex: Document quick lock release when unlocking
Date: Wed, 30 Jul 2014 13:41:51 -0700
Message-Id: <1406752916-3341-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406752916-3341-1-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unlocking, we always want to reach the slowpath with the lock's counter
indicating it is unlocked. -- as returned by the asm fastpath call or by
explicitly setting it. While doing so, at least in theory, we can optimize
and allow faster lock stealing.

When unlocking, we always want to reach the slowpath with the lock's counter
indicating it is unlocked. -- as returned by the asm fastpath call or by
explicitly setting it. While doing so, at least in theory, we can optimize
and allow faster lock stealing.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
Changes from v1:
 - Moved comment about value of the counter below to make sense only if
   the fastpath leaves the counter unlocked.

 kernel/locking/mutex.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index ad0e333..93bec48 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -684,9 +684,16 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
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
+	 * unlock it here - as the lock counter is currently 0 or negative.
 	 */
 	if (__mutex_slowpath_needs_to_unlock())
 		atomic_set(&lock->count, 1);
-- 
1.8.1.4

