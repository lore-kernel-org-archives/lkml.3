Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaHLTnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:43:17 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:35694 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaHLTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:43:15 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/sem.c: [RFC] memory barrier in sem_lock()
Date: Tue, 12 Aug 2014 21:43:06 +0200
Message-Id: <1407872586-2738-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sem_lock right now contains an smp_mb().
I think smp_rmb() would be sufficient - and performance of semop() with rmb()
is up to 10% faster. It would be a pairing of rmb() with spin_unlock().

The race we must protect against is:

sem->lock is free
sma->complex_count = 0
sma->sem_perm.lock held by thread B

thread A:

A: spin_lock(&sem->lock)

			B: sma->complex_count++; (now 1)
			B: spin_unlock(&sma->sem_perm.lock);

A: spin_is_locked(&sma->sem_perm.lock);
A: XXXXX which memory barrier is necessary?
A: if (sma->complex_count == 0)

Thread A must read the increased complex_count value, i.e. the read must
not be reordered with the read of sem_perm.lock done by spin_is_locked().

But that's it, there are no writes that must be ordered.

---
 ipc/sem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 454f6c6..a5c8a77 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -327,7 +327,7 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		/* Then check that the global lock is free */
 		if (!spin_is_locked(&sma->sem_perm.lock)) {
 			/* spin_is_locked() is not a memory barrier */
-			smp_mb();
+			smp_rmb();
 
 			/* Now repeat the test of complex_count:
 			 * It can't change anymore until we drop sem->lock.
-- 
1.9.3

