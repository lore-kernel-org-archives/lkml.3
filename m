Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaHMK4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:56:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaHMK4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:56:02 -0400
Date: Wed, 13 Aug 2014 03:55:06 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-42fa566bd74aa7b95413fb00611ec983b488222d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1406752916-3341-2-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-2-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutexes:
  Document quick lock release when unlocking
Git-Commit-ID: 42fa566bd74aa7b95413fb00611ec983b488222d
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

Commit-ID:  42fa566bd74aa7b95413fb00611ec983b488222d
Gitweb:     http://git.kernel.org/tip/42fa566bd74aa7b95413fb00611ec983b488222d
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Wed, 30 Jul 2014 13:41:51 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:31:59 +0200

locking/mutexes: Document quick lock release when unlocking

When unlocking, we always want to reach the slowpath with the lock's counter
indicating it is unlocked. -- as returned by the asm fastpath call or by
explicitly setting it. While doing so, at least in theory, we can optimize
and allow faster lock stealing.

When unlocking, we always want to reach the slowpath with the lock's counter
indicating it is unlocked. -- as returned by the asm fastpath call or by
explicitly setting it. While doing so, at least in theory, we can optimize
and allow faster lock stealing.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: jason.low2@hp.com
Cc: aswin@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1406752916-3341-2-git-send-email-davidlohr@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
