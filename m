Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab3IPDFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:05:09 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:10966 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab3IPDE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:04:57 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>, stable@vger.kernel.org,
        #@domain.invalid, for@domain.invalid, 3.11@domain.invalid
Subject: [PATCH 4/4] ipc,msg: prevent race with rmid in msgsnd,msgrcv
Date: Sun, 15 Sep 2013 20:04:37 -0700
Message-Id: <1379300677-24188-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a race in both msgrcv() and msgsnd() between finding the msg and
actually dealing with the queue, as another thread can delete shmid
underneath us if we are preempted before acquiring the kern_ipc_perm.lock.

Manfred illustrates this nicely:

Assume a preemptible kernel that is preempted just after
> msq = msq_obtain_object_check(ns, msqid)
in do_msgrcv().
The only lock that is held is rcu_read_lock().

Now the other thread processes IPC_RMID.
When the first task is resumed, then it will happily wait for messages on a
deleted queue.

Fix this by checking for if the queue has been deleted after taking the lock.

Reported-by: Manfred Spraul <manfred@colorfullife.com>
Cc: stable@vger.kernel.org # for 3.11
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/ipc/msg.c b/ipc/msg.c
index 06e8aae..4e7d95a 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -690,6 +690,12 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		if (ipcperms(ns, &msq->q_perm, S_IWUGO))
 			goto out_unlock0;
 
+		/* raced with RMID? */
+		if (msq->q_perm.deleted) {
+			err = -EIDRM;
+			goto out_unlock0;
+		}
+
 		err = security_msg_queue_msgsnd(msq, msg, msgflg);
 		if (err)
 			goto out_unlock0;
@@ -896,6 +902,13 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
 			goto out_unlock1;
 
 		ipc_lock_object(&msq->q_perm);
+
+		/* raced with RMID? */
+		if (msq->q_perm.deleted) {
+			msg = ERR_PTR(-EIDRM);
+			goto out_unlock0;
+		}
+
 		msg = find_msg(msq, &msgtyp, mode);
 		if (!IS_ERR(msg)) {
 			/*
-- 
1.7.11.7

