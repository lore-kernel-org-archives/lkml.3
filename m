Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3ESWdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 18:33:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3ESWdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 18:33:04 -0400
Date: Sun, 19 May 2013 18:32:50 -0400
From: Rik van Riel <riel@redhat.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com
Subject: [PATCH] ipc,sem: move restart loop to do_smart_update
Message-ID: <20130519183250.2a82d642@annuminas.surriel.com>
In-Reply-To: <51978696.6040705@colorfullife.com>
References: <51978696.6040705@colorfullife.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 May 2013 15:48:06 +0200
Manfred Spraul <manfred@colorfullife.com> wrote:

> Hi Rik,
> 
> I like your change to the ipc/sem locking:
> A scheme with a per-semaphore lock and without the overhead of always 
> acquiring both the global and the per-semaphore lock.
> 
> But:
> 1) I found one bug with your sem locking changes:
> If
> - a complex operation is sleeping [would be woken up by update_queue(,-1)]
> - a simple op is sleeping
> - the success of the simple op would allow the complex op to complete
>      [i.e.: update_queue(,sem_num) changes the semaphore value to the 
> value that the complex op waits on]
> - an operation wakes up the simple op.

Are you referring to eg. a complex operation that waits for
several semaphores to turn 0, and a simple op that subtracts
1 from a semaphore, turning it into 0?

> then the complex op is not woken up.
> 
> One fix would be a loop in do_smart_update():
> - first check the global queue
> - then the per-semaphore queues
> - if one of the per-semaphore queues made progress: check the global 
> queue again
> - if the global queue made progress: check the per semaphore queues again
> ...

Would that be as simple as making do_smart_update() loop back to
the top if update_queue on a single semaphore's queue returns
a non-zero value (something was changed), and there are complex
operations pending?

I implemented that in the patch below.

> 2) Your patches remove FIFO ordering of the wakeups:
> As far as I can see complex ops are now preferred over simple ops.
> It's not a bug, noone exept linux implements FIFO.
> But the comment it line 28 should be updated
> 
> Should I write a patch, do you want to fix it yourself?

You seem to have looked at this problem more closely than I have,
so I would appreciate it if you could review this patch :)

---8<---

Subject: ipc,sem: move restart loop to do_smart_update

A complex operation may be sleeping on a semaphore to become
a certain value. A sleeping simple operation may turn the
semaphore into that value.

Having the restart loop inside update_queue means we may be
missing the complex operation (which lives on a different
queue), and result in a semaphore lockup.

The lockup can be avoided by moving the restart loop into
do_smart_update, so the list of pending complex operations
will also be checked if required.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index a7e40ed..3d71c3c 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -25,8 +25,6 @@
  * This file implements System V semaphores.
  *
  * User space visible behavior:
- * - FIFO ordering for semop() operations (just FIFO, not starvation
- *   protection)
  * - multiple semaphore operations that alter the same semaphore in
  *   one semop() are handled.
  * - sem_ctime (time of last semctl()) is updated in the IPC_SET, SETVAL and
@@ -51,8 +49,7 @@
  *   count_semzcnt()
  * - the task that performs a successful semop() scans the list of all
  *   sleeping tasks and completes any pending operations that can be fulfilled.
- *   Semaphores are actively given to waiting tasks (necessary for FIFO).
- *   (see update_queue())
+ *   Semaphores are actively given to waiting tasks (see update_queue()).
  * - To improve the scalability, the actual wake-up calls are performed after
  *   dropping all locks. (see wake_up_sem_queue_prepare(),
  *   wake_up_sem_queue_do())
@@ -68,9 +65,9 @@
  *   modes for the UNDO variables are supported (per process, per thread)
  *   (see copy_semundo, CLONE_SYSVSEM)
  * - There are two lists of the pending operations: a per-array list
- *   and per-semaphore list (stored in the array). This allows to achieve FIFO
- *   ordering without always scanning all pending operations.
- *   The worst-case behavior is nevertheless O(N^2) for N wakeups.
+ *   and per-semaphore list (stored in the array). The per-array list is
+ *   used for calls that do multiple semaphore operations in one semop call.
+ *   The worst-case behavior is O(N^2) for N wakeups.
  */
 
 #include <linux/slab.h>
@@ -606,7 +603,7 @@ static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
  * @sma: semaphore array
  * @q: the operation that just completed
  *
- * update_queue is O(N^2) when it restarts scanning the whole queue of
+ * do_smart_update is O(N^2) when it restarts scanning the whole queue of
  * waiting operations. Therefore this function checks if the restart is
  * really necessary. It is called after a previously waiting operation
  * was completed.
@@ -671,6 +668,7 @@ static int check_restart(struct sem_array *sma, struct sem_queue *q)
  * @sma: semaphore array.
  * @semnum: semaphore that was modified.
  * @pt: list head for the tasks that must be woken up.
+ * @restart: did a semop change something that may require a restart?
  *
  * update_queue must be called after a semaphore in a semaphore array
  * was modified. If multiple semaphores were modified, update_queue must
@@ -680,7 +678,8 @@ static int check_restart(struct sem_array *sma, struct sem_queue *q)
  * is stored in q->pid.
  * The function return 1 if at least one semop was completed successfully.
  */
-static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
+static int update_queue(struct sem_array *sma, int semnum,
+			struct list_head *pt, int *restart)
 {
 	struct sem_queue *q;
 	struct list_head *walk;
@@ -692,10 +691,9 @@ static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 	else
 		pending_list = &sma->sem_base[semnum].sem_pending;
 
-again:
 	walk = pending_list->next;
 	while (walk != pending_list) {
-		int error, restart;
+		int error;
 
 		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
@@ -720,16 +718,11 @@ static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 
 		unlink_queue(sma, q);
 
-		if (error) {
-			restart = 0;
-		} else {
-			semop_completed = 1;
-			restart = check_restart(sma, q);
-		}
+		semop_completed = 1;
+		if (check_restart(sma, q))
+			*restart = 1;
 
 		wake_up_sem_queue_prepare(pt, q, error);
-		if (restart)
-			goto again;
 	}
 	return semop_completed;
 }
@@ -751,17 +744,19 @@ static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops,
 			int otime, struct list_head *pt)
 {
-	int i;
+	int i, restart;
 
+ again:
+	restart = 0;
 	if (sma->complex_count || sops == NULL) {
-		if (update_queue(sma, -1, pt))
+		if (update_queue(sma, -1, pt, &restart))
 			otime = 1;
 	}
 
 	if (!sops) {
 		/* No semops; something special is going on. */
 		for (i = 0; i < sma->sem_nsems; i++) {
-			if (update_queue(sma, i, pt))
+			if (update_queue(sma, i, pt, &restart))
 				otime = 1;
 		}
 		goto done;
@@ -772,9 +767,12 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 		if (sops[i].sem_op > 0 ||
 			(sops[i].sem_op < 0 &&
 				sma->sem_base[sops[i].sem_num].semval == 0))
-			if (update_queue(sma, sops[i].sem_num, pt))
+			if (update_queue(sma, sops[i].sem_num, pt, &restart))
 				otime = 1;
 	}
+
+	if (restart)
+		goto again;
 done:
 	if (otime)
 		sma->sem_otime = get_seconds();

