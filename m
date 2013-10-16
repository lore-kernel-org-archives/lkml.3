Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894Ab3JPRqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934767Ab3JPRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>,
        Jia He <jiakernel@gmail.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 49/50] ipc/sem.c: update sem_otime for all operations
Date: Wed, 16 Oct 2013 10:45:35 -0700
Message-Id: <20131016174404.366753549@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manfred Spraul <manfred@colorfullife.com>

commit 0e8c665699e953fa58dc1b0b0d09e5dce7343cc7 upstream.

In commit 0a2b9d4c7967 ("ipc/sem.c: move wake_up_process out of the
spinlock section"), the update of semaphore's sem_otime(last semop time)
was moved to one central position (do_smart_update).

But since do_smart_update() is only called for operations that modify
the array, this means that wait-for-zero semops do not update sem_otime
anymore.

The fix is simple:
Non-alter operations must update sem_otime.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Jia He <jiakernel@gmail.com>
Tested-by: Jia He <jiakernel@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/sem.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -918,6 +918,24 @@ again:
 }
 
 /**
+ * set_semotime(sma, sops) - set sem_otime
+ * @sma: semaphore array
+ * @sops: operations that modified the array, may be NULL
+ *
+ * sem_otime is replicated to avoid cache line trashing.
+ * This function sets one instance to the current time.
+ */
+static void set_semotime(struct sem_array *sma, struct sembuf *sops)
+{
+	if (sops == NULL) {
+		sma->sem_base[0].sem_otime = get_seconds();
+	} else {
+		sma->sem_base[sops[0].sem_num].sem_otime =
+							get_seconds();
+	}
+}
+
+/**
  * do_smart_update(sma, sops, nsops, otime, pt) - optimized update_queue
  * @sma: semaphore array
  * @sops: operations that were performed
@@ -967,17 +985,10 @@ static void do_smart_update(struct sem_a
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
+	if (otime)
+		set_semotime(sma, sops);
 }
 
-
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
@@ -1839,12 +1850,17 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 
 	error = perform_atomic_semop(sma, sops, nsops, un,
 					task_tgid_vnr(current));
-	if (error <= 0) {
-		if (alter && error == 0)
+	if (error == 0) {
+		/* If the operation was successful, then do
+		 * the required updates.
+		 */
+		if (alter)
 			do_smart_update(sma, sops, nsops, 1, &tasks);
-
-		goto out_unlock_free;
+		else
+			set_semotime(sma, sops);
 	}
+	if (error <= 0)
+		goto out_unlock_free;
 
 	/* We need to sleep on this operation, so we put the current
 	 * task into the pending queue and go to sleep.


