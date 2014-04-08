Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbaDHIrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaDHIrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:47:33 -0400
From: Jan Stancek <jstancek@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jstancek@redhat.com, srikar@linux.vnet.ibm.com, davidlohr@hp.com,
        torvalds@linux-foundation.org, mingo@kernel.org, lwoodman@redhat.com
Subject: [PATCH] futex: avoid race between requeue and wake
Date: Tue,  8 Apr 2014 10:47:15 +0200
Message-Id: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pthread_cond_broadcast/4-1.c testcase from openposix testsuite (LTP)
occasionally fails, because some threads fail to wake up.

Testcase creates 5 threads, which are all waiting on same condition.
Main thread then calls pthread_cond_broadcast() without holding mutex,
which calls:
  futex(uaddr1, FUTEX_CMP_REQUEUE_PRIVATE, 1, 2147483647, uaddr2, ..)
This immediately wakes up single thread A, which unlocks mutex and
tries to wake up another thread:
  futex(uaddr2, FUTEX_WAKE_PRIVATE, 1)
If thread A manages to call futex_wake() before any waiters are requeued
for uaddr2, no other thread is woken up.

This patch is re-introducing check removed by:
  commit 11d4616bd07f38d496bd489ed8fad1dc4d928823
  futex: revert back to the explicit waiter counting code

Taking hb->lock in this situation will ensure that thread A needs to wait
in futex_wake() until main thread finishes requeue operation.

Signed-off-by: Jan Stancek <jstancek@redhat.com>
---
 kernel/futex.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 67dacaf..5163899 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -284,7 +284,10 @@ static inline void hb_waiters_dec(struct futex_hash_bucket *hb)
 static inline int hb_waiters_pending(struct futex_hash_bucket *hb)
 {
 #ifdef CONFIG_SMP
-	return atomic_read(&hb->waiters);
+	if (spin_is_locked(&hb->lock))
+		return 1;
+	else
+		return atomic_read(&hb->waiters);
 #else
 	return 1;
 #endif
-- 
1.7.1

