Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbbAIMgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:36:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbbAIMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:36:22 -0500
Date: Fri, 9 Jan 2015 04:34:37 -0800
From: tip-bot for Chris Wilson <tipbot@zytor.com>
Message-ID: <tip-a63b03e2d2477586440741677ecac45bcf28d7b1@git.kernel.org>
Cc: hpa@zytor.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: tglx@linutronix.de, mingo@kernel.org, chris@chris-wilson.co.uk,
        daniel.vetter@ffwll.ch, peterz@infradead.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, hpa@zytor.com
In-Reply-To: <1420540175-30204-1-git-send-email-chris@chris-wilson.co.uk>
References: <1420540175-30204-1-git-send-email-chris@chris-wilson.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] mutex:
  Always clear owner field upon mutex_unlock()
Git-Commit-ID: a63b03e2d2477586440741677ecac45bcf28d7b1
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

Commit-ID:  a63b03e2d2477586440741677ecac45bcf28d7b1
Gitweb:     http://git.kernel.org/tip/a63b03e2d2477586440741677ecac45bcf28d7b1
Author:     Chris Wilson <chris@chris-wilson.co.uk>
AuthorDate: Tue, 6 Jan 2015 10:29:35 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:20:39 +0100

mutex: Always clear owner field upon mutex_unlock()

Currently if DEBUG_MUTEXES is enabled, the mutex->owner field is only
cleared iff debug_locks is active. This exposes a race to other users of
the field where the mutex->owner may be still set to a stale value,
potentially upsetting mutex_spin_on_owner() among others.

References: https://bugs.freedesktop.org/show_bug.cgi?id=87955
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1420540175-30204-1-git-send-email-chris@chris-wilson.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex-debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index 5cf6731..3ef3736 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -80,13 +80,13 @@ void debug_mutex_unlock(struct mutex *lock)
 			DEBUG_LOCKS_WARN_ON(lock->owner != current);
 
 		DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-		mutex_clear_owner(lock);
 	}
 
 	/*
 	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
 	 * mutexes so that we can do it here after we've verified state.
 	 */
+	mutex_clear_owner(lock);
 	atomic_set(&lock->count, 1);
 }
 
