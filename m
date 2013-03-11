Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3CKUh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:37:29 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:58413 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3CKUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:37:28 -0400
Message-ID: <1363034207.27803.8.camel@thor.lan>
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a
 reader
From: Peter Hurley <peter@hurleysoftware.com>
To: Michel Lespinasse <walken@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 16:36:47 -0400
In-Reply-To: <1362612111-28673-12-git-send-email-walken@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	 <1362612111-28673-12-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2013-03-06 at 15:21 -0800, Michel Lespinasse wrote:
> + retry_reader_grants:
> +	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
> +	if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
> +		/* A writer stole the lock.  Undo our reader grants. */
> +		if (rwsem_atomic_update(-adjustment, sem) < RWSEM_WAITING_BIAS)
> +			goto out;
> +		/* The writer left.  Retry waking readers. */
> +		goto retry_reader_grants;
> +	}

This can be reduced to single looping cmpxchg in the grant reversal
path; then if reversing the grant fails, the count can simply be
re-tested for grant success, rather than trying to atomically re-grant.
For example, with a helper function, rwsem_cmpxchg():

static inline int rwsem_cmpxchg(long *old, long new, struct rw_semaphore *sem)
{
	long tmp = *old;
	*old = cmpxchg(&sem->count, *old, new);
	return tmp == *old;
}

... then above becomes ...

	count = rwsem_atomic_update(adjustment, sem);
	do {
		if (count - adjustment >= RWSEM_WAITING_BIAS)
			break;
		if (rwsem_cmpxchg(&count, count - adjustment, sem))
			goto out;   /* or simply return sem */
	} while (1);

	< wake up readers >


Also, this series and the original rwsem can mistakenly sleep reader(s)
when the lock is transitioned from writer-owned to waiting readers-owned
with no waiting writers. For example,


  CPU 0                               |  CPU 1
                                      |
                                      | down_write()

... CPU 1 has the write lock for the semaphore.
    Meanwhile, 1 or more down_read(s) are attempted and fail;
    these are put on the wait list. Then ...

down_read()                           | up_write()
  local = atomic_update(+read_bias)   |
  local <= 0?                         |   local = atomic_update(-write_bias)
  if (true)                           |   local < 0?
     down_read_failed()               |   if (true)
                                      |      wake()
                                      |         grab wait_lock
        wait for wait_lock            |         wake all readers
                                      |         release wait_lock

... At this point, sem->count > 0 and the wait list is empty,
    but down_read_failed() will sleep the reader.


In this case, CPU 0 has observed the sem count with the write lock (and
the other waiters) and so is detoured to down_read_failed(). But if 
CPU 0 can't grab the wait_lock before the up_write() does (via
rwsem_wake()), then down_read_failed() will wake no one and sleep the
reader.

Unfortunately, this means readers and writers which observe the sem
count after the adjustment is committed by CPU 0 in down_read_failed()
will sleep as well, until the sem count returns to 0.

I think the best solution would be to preserve the observed count when
down_read() fails and pass it to rwsem_down_read_failed() -- of course,
this is also the most disruptive approach as it changes the per-arch
interface (the attached patch does not include the arch changes). The
other alternative is to go through the __rwsem_do_wake() path.

Regards,
Peter Hurley

--- >% ---
Subject: [PATCH] rwsem: Early-out tardy readers


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 lib/rwsem.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index f9a5705..8eb2cdf 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -118,12 +118,11 @@ __rwsem_do_wake(struct rw_semaphore *sem, bool wakewrite)
 /*
  * wait for the read lock to be granted
  */
-struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
+struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem, long count)
 {
 	signed long adjustment = -RWSEM_ACTIVE_READ_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
-	signed long count;
 
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
@@ -131,6 +130,20 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	get_task_struct(tsk);
 
 	raw_spin_lock_irq(&sem->wait_lock);
+
+	/* Try to reverse the lock attempt but if the count has changed
+	 * so that reversing fails, check if there are are no waiters,
+	 * and early-out if not */
+	do {
+		if (rwsem_cmpxchg(&count, count + adjust, sem))
+			break;
+		if (count > 0) {
+			raw_spin_unlock_irq(&sem->wait_lock);
+			put_task_struct(tsk);
+			return sem;
+		}
+	} while (1);
+
 	sem->wait_readers++;
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
-- 
1.8.1.2




