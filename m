Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaAPCpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:45:35 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:2255 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaAPCpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:45:33 -0500
Message-ID: <1389840330.2944.104.camel@j-VirtualBox>
Subject: Re: [RFC 3/3] mutex: When there is no owner, stop spinning after
 too many tries
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        aswin@hp.com, scott.norton@hp.com
Date: Wed, 15 Jan 2014 18:45:30 -0800
In-Reply-To: <1389745990-7069-4-git-send-email-jason.low2@hp.com>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
	 <1389745990-7069-4-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 16:33 -0800, Jason Low wrote:
> When running workloads that have high contention in mutexes on an 8 socket
> machine, spinners would often spin for a long time with no lock owner.
> 
> One of the potential reasons for this is because a thread can be preempted
> after clearing lock->owner but before releasing the lock, or preempted after
> acquiring the mutex but before setting lock->owner. In those cases, the
> spinner cannot check if owner is not on_cpu because lock->owner is NULL.

Looks like a bigger source of !owner latency is in
__mutex_unlock_common_slowpath(). If __mutex_slowpath_needs_to_unlock(),
then the owner needs to acquire the wait_lock before setting lock->count
to 1. If the wait_lock is being contended, which is occurring with some
workloads on my box, then this can delay the owner from releasing
the lock by quite a bit.

Any comments on the below change which unlocks the mutex before taking
the lock->wait_lock to wake up a waiter? Thanks.

---
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index b500cc7..38f0eb0 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -723,10 +723,6 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
        struct mutex *lock = container_of(lock_count, struct mutex, count);
        unsigned long flags;
 
-       spin_lock_mutex(&lock->wait_lock, flags);
-       mutex_release(&lock->dep_map, nested, _RET_IP_);
-       debug_mutex_unlock(lock);
-
        /*
         * some architectures leave the lock unlocked in the fastpath failure
         * case, others need to leave it locked. In the later case we have to
@@ -735,6 +731,10 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
        if (__mutex_slowpath_needs_to_unlock())
                atomic_set(&lock->count, 1);
 
+       spin_lock_mutex(&lock->wait_lock, flags);
+       mutex_release(&lock->dep_map, nested, _RET_IP_);
+       debug_mutex_unlock(lock);
+
        if (!list_empty(&lock->wait_list)) {
                /* get the first entry from the wait-list: */
                struct mutex_waiter *waiter =


