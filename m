Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbaDKQRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:17:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759713AbaDKQJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 05/23] futex: avoid race between requeue and wake
Date: Fri, 11 Apr 2014 09:11:54 -0700
Message-Id: <20140411161200.967310128@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411161200.236939691@linuxfoundation.org>
References: <20140411161200.236939691@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 69cd9eba38867a493a043bb13eb9b33cad5f1a9a upstream.

Jan Stancek reported:
 "pthread_cond_broadcast/4-1.c testcase from openposix testsuite (LTP)
  occasionally fails, because some threads fail to wake up.

  Testcase creates 5 threads, which are all waiting on same condition.
  Main thread then calls pthread_cond_broadcast() without holding mutex,
  which calls:

      futex(uaddr1, FUTEX_CMP_REQUEUE_PRIVATE, 1, 2147483647, uaddr2, ..)

  This immediately wakes up single thread A, which unlocks mutex and
  tries to wake up another thread:

      futex(uaddr2, FUTEX_WAKE_PRIVATE, 1)

  If thread A manages to call futex_wake() before any waiters are
  requeued for uaddr2, no other thread is woken up"

The ordering constraints for the hash bucket waiter counting are that
the waiter counts have to be incremented _before_ getting the spinlock
(because the spinlock acts as part of the memory barrier), but the
"requeue" operation didn't honor those rules, and nobody had even
thought about that case.

This fairly simple patch just increments the waiter count for the target
hash bucket (hb2) when requeing a futex before taking the locks.  It
then decrements them again after releasing the lock - the code that
actually moves the futex(es) between hash buckets will do the additional
required waiter count housekeeping.

Reported-and-tested-by: Jan Stancek <jstancek@redhat.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1450,6 +1450,7 @@ retry:
 	hb2 = hash_futex(&key2);
 
 retry_private:
+	hb_waiters_inc(hb2);
 	double_lock_hb(hb1, hb2);
 
 	if (likely(cmpval != NULL)) {
@@ -1459,6 +1460,7 @@ retry_private:
 
 		if (unlikely(ret)) {
 			double_unlock_hb(hb1, hb2);
+			hb_waiters_dec(hb2);
 
 			ret = get_user(curval, uaddr1);
 			if (ret)
@@ -1508,6 +1510,7 @@ retry_private:
 			break;
 		case -EFAULT:
 			double_unlock_hb(hb1, hb2);
+			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
 			ret = fault_in_user_writeable(uaddr2);
@@ -1517,6 +1520,7 @@ retry_private:
 		case -EAGAIN:
 			/* The owner was exiting, try again. */
 			double_unlock_hb(hb1, hb2);
+			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
 			cond_resched();
@@ -1592,6 +1596,7 @@ retry_private:
 
 out_unlock:
 	double_unlock_hb(hb1, hb2);
+	hb_waiters_dec(hb2);
 
 	/*
 	 * drop_futex_key_refs() must be called outside the spinlocks. During


