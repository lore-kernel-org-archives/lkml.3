Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3D0VVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 17:21:07 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18372 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3D0VVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 17:21:05 -0400
Message-ID: <1367097660.1782.16.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 03/13] rwsem: move rwsem_down_failed_common code into
 rwsem_down_{read,write}_failed
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Michel Lespinasse <walken@google.com>, Alex Shi <alex.shi@intel.com>,
        Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 27 Apr 2013 14:21:00 -0700
In-Reply-To: <1364490332.3559.25.camel@thor.lan>
References: <1363344869-15732-1-git-send-email-walken@google.com>
	 <1363344869-15732-4-git-send-email-walken@google.com>
	 <1364490332.3559.25.camel@thor.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, but I just couldn't help myself :)

From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH] rwsem: no need for explicit signed longs

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rwsem.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 4e4c889..50fdd89 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -63,7 +63,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop, adjustment;
+	long oldcount, woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
@@ -144,11 +144,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
  */
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
-	signed long adjustment = -RWSEM_ACTIVE_READ_BIAS;
+	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
-	signed long count;
-
+	
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
 	waiter.type = RWSEM_WAITING_FOR_READ;
@@ -192,10 +191,9 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
  */
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	signed long adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
+	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
-	signed long count;
 
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
-- 
1.7.11.7



