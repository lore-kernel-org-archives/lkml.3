Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaJFSdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:33:31 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48664 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaJFSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:33:29 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        1vier1@web.de, Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/3] ipc/sem.c: Chance memory barrier in sem_lock() to smp_rmb()
Date: Mon,  6 Oct 2014 20:32:41 +0200
Message-Id: <1412620363-2759-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412620363-2759-1-git-send-email-manfred@colorfullife.com>
References: <1412620363-2759-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I fixed bugs in the sem_lock() logic, I was more conservative than
necessary.
Therefore it is safe to replace the smp_mb() with smp_rmb().
And: With smp_rmb(), semop() syscalls are up to 10% faster.

The race we must protect against is:

	sem->lock is free
	sma->complex_count = 0
	sma->sem_perm.lock held by thread B

thread A:

A: spin_lock(&sem->lock)

			B: sma->complex_count++; (now 1)
			B: spin_unlock(&sma->sem_perm.lock);

A: spin_is_locked(&sma->sem_perm.lock);
A: XXXXX memory barrier
A: if (sma->complex_count == 0)

Thread A must read the increased complex_count value, i.e. the read must
not be reordered with the read of sem_perm.lock done by spin_is_locked().

Since it's about ordering of reads, smp_rmb() is sufficient.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 454f6c6..ffc71de 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -326,10 +326,16 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 
 		/* Then check that the global lock is free */
 		if (!spin_is_locked(&sma->sem_perm.lock)) {
-			/* spin_is_locked() is not a memory barrier */
-			smp_mb();
+			/*
+			 * The next test must happen after the test for
+			 * sem_perm.lock, otherwise we can race with another
+			 * thread that does
+			 *	complex_count++;spin_unlock(sem_perm.lock);
+			 */
+			smp_rmb();
 
-			/* Now repeat the test of complex_count:
+			/*
+			 * Now repeat the test of complex_count:
 			 * It can't change anymore until we drop sem->lock.
 			 * Thus: if is now 0, then it will stay 0.
 			 */
-- 
1.9.3

