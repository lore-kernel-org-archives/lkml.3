Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbbAFKr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:47:28 -0500
Received: from hostedrelay.fireflyinternet.com ([109.228.30.76]:56983 "EHLO
	relay.fireflyinternet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbAFKr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:47:27 -0500
X-Greylist: delayed 989 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 05:47:27 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] mutex: Always clear owner field upon mutex_unlock()
Date: Tue,  6 Jan 2015 10:29:35 +0000
Message-Id: <1420540175-30204-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.1.4
X-Authenticated-User: chris.alporthouse@surfanytime.net 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if DEBUG_MUTEXES is enabled, the mutex->owner field is only
cleared iff debug_locks is active. This exposes a race to other users of
the field where the mutex->owner may be still set to a stale value,
potentially upsetting mutex_spin_on_owner() among others.

References: https://bugs.freedesktop.org/show_bug.cgi?id=87955
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 kernel/locking/mutex-debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index 5cf6731b98e9..3ef3736002d8 100644
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
 
-- 
2.1.4

