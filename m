Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbaLPGCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:02:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaLPGCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:02:45 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, Waiman.Long@hp.com,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH] locking/rwlocks: clean up of qrwlock
Date: Tue, 16 Dec 2014 14:00:40 +0800
Message-Id: <1418709640-5625-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In queue_read_lock_slowpath, when writer count becomes 0, we need
increment the read count and get the lock. Then need call
rspin_until_writer_unlock to check again if an incoming writer
steals the lock in the gap. But in rspin_until_writer_unlock
it only checks the writer count, namely low 8 bit of lock->cnts,
no need to subtract the reader count unit specifically. So remove
that subtraction to make it clearer, rspin_until_writer_unlock
just takes the actual lock->cnts as the 2nd argument.

And also change the code comment in queue_write_lock_slowpath to
make it more exact and explicit.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 kernel/locking/qrwlock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index f956ede..ae66c10 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -76,7 +76,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 	while (atomic_read(&lock->cnts) & _QW_WMASK)
 		cpu_relax_lowlatency();
 
-	cnts = atomic_add_return(_QR_BIAS, &lock->cnts) - _QR_BIAS;
+	cnts = atomic_add_return(_QR_BIAS, &lock->cnts);
 	rspin_until_writer_unlock(lock, cnts);
 
 	/*
@@ -97,14 +97,14 @@ void queue_write_lock_slowpath(struct qrwlock *lock)
 	/* Put the writer into the wait queue */
 	arch_spin_lock(&lock->lock);
 
-	/* Try to acquire the lock directly if no reader is present */
+	/* Try to acquire the lock directly if no reader and writer is present */
 	if (!atomic_read(&lock->cnts) &&
 	    (atomic_cmpxchg(&lock->cnts, 0, _QW_LOCKED) == 0))
 		goto unlock;
 
 	/*
-	 * Set the waiting flag to notify readers that a writer is pending,
-	 * or wait for a previous writer to go away.
+	 * Wait for a previous writer to go away, then set the waiting flag to
+	 * notify readers that a writer is pending.
 	 */
 	for (;;) {
 		cnts = atomic_read(&lock->cnts);
-- 
1.8.5.3

