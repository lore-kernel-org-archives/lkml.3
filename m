Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935181Ab3JPSGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:06:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761605Ab3JPRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 68/69] ipc,msg: prevent race with rmid in msgsnd,msgrcv
Date: Wed, 16 Oct 2013 10:45:17 -0700
Message-Id: <20131016174321.223299967@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr@hp.com>

commit 4271b05a227dc6175b66c3d9941aeab09048aeb2 upstream.

This fixes a race in both msgrcv() and msgsnd() between finding the msg
and actually dealing with the queue, as another thread can delete shmid
underneath us if we are preempted before acquiring the
kern_ipc_perm.lock.

Manfred illustrates this nicely:

Assume a preemptible kernel that is preempted just after

    msq = msq_obtain_object_check(ns, msqid)

in do_msgrcv().  The only lock that is held is rcu_read_lock().

Now the other thread processes IPC_RMID.  When the first task is
resumed, then it will happily wait for messages on a deleted queue.

Fix this by checking for if the queue has been deleted after taking the
lock.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reported-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -695,6 +695,12 @@ long do_msgsnd(int msqid, long mtype, vo
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
@@ -901,6 +907,13 @@ long do_msgrcv(int msqid, void __user *b
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


