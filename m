Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3IXVJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:09:40 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:35363 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab3IXVJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:09:38 -0400
Message-ID: <5241FF8D.8000407@colorfullife.com>
Date: Tue, 24 Sep 2013 23:09:33 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jia He <jiakernel@gmail.com>
CC: Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com> <1379837823.5499.34.camel@marge.simpson.net> <1379838364.5499.39.camel@marge.simpson.net> <523EC97D.8020707@colorfullife.com> <523F0953.3070505@gmail.com>
In-Reply-To: <523F0953.3070505@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050909090502070805080603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050909090502070805080603
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/22/2013 05:14 PM, Jia He wrote:
>   Hi Manfred
>
> On Sun, 22 Sep 2013 12:42:05 +0200 from manfred@colorfullife.com wrote:
>> Hi all,
>>
>> On 09/22/2013 10:26 AM, Mike Galbraith wrote:
>>> On Sun, 2013-09-22 at 10:17 +0200, Mike Galbraith wrote:
>>>> On Sun, 2013-09-22 at 10:11 +0800, Jia He wrote:
>>>>> In commit 0a2b9d4c,the update of semaphore's sem_otime(last semop time)
>>>>> was removed because he wanted to move setting sem->sem_otime to one
>>>>> place. But after that, the initial semop() will not set the otime
>>>>> because its sem_op value is 0(in semtimedop,will not change
>>>>> otime if alter == 1).
>>>>>
>>>>> the error case:
>>>>> process_a(server)       process_b(client)
>>>>> semget()
>>>>> semctl(SETVAL)
>>>>> semop()
>>>>>                           semget()
>>>>>                           setctl(IP_STAT)
>>>>>                           for(;;) {               <--not successful here
>>>>>                             check until sem_otime > 0
>>>>>                           }
>> Good catch:
>> Since commit 0a2b9d4c, wait-for-zero semops do not update sem_otime anymore.
>>
>> Let's reverse that part of my commit and move the update of sem_otime back
>> into perform_atomic_semop().
>>
>> Jia: If perform_atomic_semop() updates sem_otime, then the update in
>> do_smart_update() is not necessary anymore.
>> Thus the whole logic with passing arround "semop_completed" can be removed, too.
>> Are you interested in writing that patch?
>>
> Not all perform_atomic_semop() can cover the points of do_smart_update()
> after I move the parts of updating otime.
> Eg. in semctl_setval/exit_sem/etc.    That is, it seems I need to write some
> other codes to update sem_otime outside perform_atomic_semop(). That
> still violate your original goal---let one function do all the update otime
> things.
No. The original goal was an optimization:
The common case is one semop that increases a semaphore value - and that 
allows another semop that is sleeping to proceed.
Before, this caused two get_seconds() calls.
The current (buggy) code avoids the 2nd call.

> IMO, what if just remove the condition alter in sys_semtimedop:
> -        if (alter && error == 0)
> +       if (error == 0)
>              do_smart_update(sma, sops, nsops, 1, &tasks);
> In old codes, it would set the otime even when sem_op == 0
do_smart_update() can be expensive - thus it shouldn't be called if we 
didn't change anything.

Attached is a proposed patch - fully untested. It is intended to be 
applied on top of Jia's patch.

_If_ the performance degradation is too large, then the alternative 
would be to set sem_otime directly in semtimedop() for successfull 
non-alter operations.

--
     Manfred

--------------050909090502070805080603
Content-Type: text/x-patch;
 name="0001-ipc-sem.c-Simplify-sem_otime-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-ipc-sem.c-Simplify-sem_otime-handling.patch"

>From 07da483abc88748a666f655f3e1d81a94df88e38 Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Tue, 24 Sep 2013 22:53:27 +0200
Subject: [PATCH] ipc/sem.c: Simplify sem_otime handling.

The sem_otime handling tries to minimize the number of calls to
get_seconds().
This generates some complexity (i.e.: pass around if any operation
completed) and introduced one bug (See previous commit to ipc/sem.c).

Therefore: Remove the whole logic - this removes 25 lines.

Disadvantages:
- One line of code duplication in exit_sem():
  The function must now update sem_otime, it can't rely on
  do_smart_update_queue() to perform that task.
- Two get_seconds() calls instead of one call for the common
  case of increasing a semaphore and waking up a sleeping task.

TODO:
1) How fast is get_seconds()?
      Is the optimization worth the effort?
2) Test it.

---
 ipc/sem.c | 61 ++++++++++++++++++-------------------------------------------
 1 file changed, 18 insertions(+), 43 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 8e01e76..5e5d7b1 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -713,15 +713,13 @@ static int check_restart(struct sem_array *sma, struct sem_queue *q)
  * semaphore.
  * The tasks that must be woken up are added to @pt. The return code
  * is stored in q->pid.
- * The function returns 1 if at least one operation was completed successfully.
  */
-static int wake_const_ops(struct sem_array *sma, int semnum,
+static void wake_const_ops(struct sem_array *sma, int semnum,
 				struct list_head *pt)
 {
 	struct sem_queue *q;
 	struct list_head *walk;
 	struct list_head *pending_list;
-	int semop_completed = 0;
 
 	if (semnum == -1)
 		pending_list = &sma->pending_const;
@@ -742,13 +740,9 @@ static int wake_const_ops(struct sem_array *sma, int semnum,
 			/* operation completed, remove from queue & wakeup */
 
 			unlink_queue(sma, q);
-
 			wake_up_sem_queue_prepare(pt, q, error);
-			if (error == 0)
-				semop_completed = 1;
 		}
 	}
-	return semop_completed;
 }
 
 /**
@@ -761,13 +755,11 @@ static int wake_const_ops(struct sem_array *sma, int semnum,
  * do_smart_wakeup_zero() checks all required queue for wait-for-zero
  * operations, based on the actual changes that were performed on the
  * semaphore array.
- * The function returns 1 if at least one operation was completed successfully.
  */
-static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
+static void do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
 					int nsops, struct list_head *pt)
 {
 	int i;
-	int semop_completed = 0;
 	int got_zero = 0;
 
 	/* first: the per-semaphore queues, if known */
@@ -777,7 +769,7 @@ static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
 
 			if (sma->sem_base[num].semval == 0) {
 				got_zero = 1;
-				semop_completed |= wake_const_ops(sma, num, pt);
+				wake_const_ops(sma, num, pt);
 			}
 		}
 	} else {
@@ -788,7 +780,7 @@ static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
 		for (i = 0; i < sma->sem_nsems; i++) {
 			if (sma->sem_base[i].semval == 0) {
 				got_zero = 1;
-				semop_completed |= wake_const_ops(sma, i, pt);
+				wake_const_ops(sma, i, pt);
 			}
 		}
 	}
@@ -797,9 +789,7 @@ static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
 	 * then check the global queue, too.
 	 */
 	if (got_zero)
-		semop_completed |= wake_const_ops(sma, -1, pt);
-
-	return semop_completed;
+		wake_const_ops(sma, -1, pt);
 }
 
 
@@ -816,15 +806,12 @@ static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
  * The tasks that must be woken up are added to @pt. The return code
  * is stored in q->pid.
  * The function internally checks if const operations can now succeed.
- *
- * The function return 1 if at least one semop was completed successfully.
  */
-static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
+static void update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 {
 	struct sem_queue *q;
 	struct list_head *walk;
 	struct list_head *pending_list;
-	int semop_completed = 0;
 
 	if (semnum == -1)
 		pending_list = &sma->pending_alter;
@@ -861,7 +848,6 @@ again:
 		if (error) {
 			restart = 0;
 		} else {
-			semop_completed = 1;
 			do_smart_wakeup_zero(sma, q->sops, q->nsops, pt);
 			restart = check_restart(sma, q);
 		}
@@ -870,15 +856,13 @@ again:
 		if (restart)
 			goto again;
 	}
-	return semop_completed;
 }
 
 /**
- * do_smart_update(sma, sops, nsops, otime, pt) - optimized update_queue
+ * do_smart_update(sma, sops, nsops, pt) - optimized update_queue
  * @sma: semaphore array
  * @sops: operations that were performed
  * @nsops: number of operations
- * @otime: force setting otime
  * @pt: list head of the tasks that must be woken up.
  *
  * do_smart_update() does the required calls to update_queue and wakeup_zero,
@@ -888,15 +872,15 @@ again:
  * It is safe to perform this call after dropping all locks.
  */
 static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops,
-			int otime, struct list_head *pt)
+			struct list_head *pt)
 {
 	int i;
 
-	otime |= do_smart_wakeup_zero(sma, sops, nsops, pt);
+	do_smart_wakeup_zero(sma, sops, nsops, pt);
 
 	if (!list_empty(&sma->pending_alter)) {
 		/* semaphore array uses the global queue - just process it. */
-		otime |= update_queue(sma, -1, pt);
+		update_queue(sma, -1, pt);
 	} else {
 		if (!sops) {
 			/*
@@ -904,7 +888,7 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 			 * known. Check all.
 			 */
 			for (i = 0; i < sma->sem_nsems; i++)
-				otime |= update_queue(sma, i, pt);
+				update_queue(sma, i, pt);
 		} else {
 			/*
 			 * Check the semaphores that were increased:
@@ -916,21 +900,11 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 			 *   value will be too small, too.
 			 */
 			for (i = 0; i < nsops; i++) {
-				if (sops[i].sem_op > 0) {
-					otime |= update_queue(sma,
-							sops[i].sem_num, pt);
-				}
+				if (sops[i].sem_op > 0)
+					update_queue(sma, sops[i].sem_num, pt);
 			}
 		}
 	}
-	if (otime) {
-		if (sops == NULL) {
-			sma->sem_base[0].sem_otime = get_seconds();
-		} else {
-			sma->sem_base[sops[0].sem_num].sem_otime =
-								get_seconds();
-		}
-	}
 }
 
 
@@ -1238,7 +1212,7 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 	curr->sempid = task_tgid_vnr(current);
 	sma->sem_ctime = get_seconds();
 	/* maybe some queued-up processes were waiting for this */
-	do_smart_update(sma, NULL, 0, 0, &tasks);
+	do_smart_update(sma, NULL, 0, &tasks);
 	sem_unlock(sma, -1);
 	rcu_read_unlock();
 	wake_up_sem_queue_do(&tasks);
@@ -1366,7 +1340,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		do_smart_update(sma, NULL, 0, 0, &tasks);
+		do_smart_update(sma, NULL, 0, &tasks);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1798,7 +1772,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 					task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
-			do_smart_update(sma, sops, nsops, 1, &tasks);
+			do_smart_update(sma, sops, nsops, &tasks);
 
 		goto out_unlock_free;
 	}
@@ -2043,7 +2017,8 @@ void exit_sem(struct task_struct *tsk)
 		}
 		/* maybe some queued-up processes were waiting for this */
 		INIT_LIST_HEAD(&tasks);
-		do_smart_update(sma, NULL, 0, 1, &tasks);
+		sma->sem_base[0].sem_otime = get_seconds();
+		do_smart_update(sma, NULL, 0, &tasks);
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
 		wake_up_sem_queue_do(&tasks);
-- 
1.8.3.1


--------------050909090502070805080603--
