Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab3ICOAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:00:31 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:33416 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab3ICOA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:00:29 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dave.bueso@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Jonathan Gonzalez" <jgonzalez@linets.cl>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/msg.c: Fix lost wakeup in msgsnd().
Date: Tue,  3 Sep 2013 16:00:08 +0200
Message-Id: <1378216808-2564-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check if the queue is full and adding current to the wait queue of pending
msgsnd() operations (ss_add()) must be atomic.

Otherwise:
- the thread that performs msgsnd() finds a full queue and decides to sleep.
- the thread that performs msgrcv() calls first reads all messages from the
  queue and then sleep, because the queue is empty.
- the msgrcv() calls do not perform any wakeups, because the msgsnd() task
  has not yet called ss_add().
- then the msgsnd()-thread first calls ss_add() and then sleeps.
Net result: msgsnd() and msgrcv() both sleep forever.

Observed with msgctl08 from ltp with a preemptible kernel.

Fix: Call ipc_lock_object() before performing the check.

The patch also moves security_msg_queue_msgsnd() under ipc_lock_object:
- msgctl(IPC_SET) explicitely mentions that it tries to expunge any pending
  operations that are not allowed anymore with the new permissions.
  If security_msg_queue_msgsnd() is called without locks, then there might be
  races.
- it makes the patch much simpler.

Reported-by: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/msg.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 9f29d9e..b65fdf1 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -680,16 +680,18 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		goto out_unlock1;
 	}
 
+	ipc_lock_object(&msq->q_perm);
+
 	for (;;) {
 		struct msg_sender s;
 
 		err = -EACCES;
 		if (ipcperms(ns, &msq->q_perm, S_IWUGO))
-			goto out_unlock1;
+			goto out_unlock0;
 
 		err = security_msg_queue_msgsnd(msq, msg, msgflg);
 		if (err)
-			goto out_unlock1;
+			goto out_unlock0;
 
 		if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
 				1 + msq->q_qnum <= msq->q_qbytes) {
@@ -699,10 +701,9 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
 			err = -EAGAIN;
-			goto out_unlock1;
+			goto out_unlock0;
 		}
 
-		ipc_lock_object(&msq->q_perm);
 		ss_add(msq, &s);
 
 		if (!ipc_rcu_getref(msq)) {
@@ -730,10 +731,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 			goto out_unlock0;
 		}
 
-		ipc_unlock_object(&msq->q_perm);
 	}
-
-	ipc_lock_object(&msq->q_perm);
 	msq->q_lspid = task_tgid_vnr(current);
 	msq->q_stime = get_seconds();
 
-- 
1.8.3.1

