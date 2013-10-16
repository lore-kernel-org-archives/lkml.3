Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110Ab3JPSTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:19:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761350Ab3JPRpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 34/69] ipc,msg: shorten critical region in msgctl_down
Date: Wed, 16 Oct 2013 10:44:43 -0700
Message-Id: <20131016174317.053439413@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 15724ecb7e9bab35fc694c666ad563adba820cc3 upstream.

Instead of holding the ipc lock for the entire function, use the
ipcctl_pre_down_nolock and only acquire the lock for specific commands:
RMID and SET.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -410,11 +410,10 @@ static int msgctl_down(struct ipc_namesp
 	down_write(&msg_ids(ns).rw_mutex);
 	rcu_read_lock();
 
-	ipcp = ipcctl_pre_down(ns, &msg_ids(ns), msqid, cmd,
-			       &msqid64.msg_perm, msqid64.msg_qbytes);
+	ipcp = ipcctl_pre_down_nolock(ns, &msg_ids(ns), msqid, cmd,
+				      &msqid64.msg_perm, msqid64.msg_qbytes);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
-		/* the ipc lock is not held upon failure */
 		goto out_unlock1;
 	}
 
@@ -422,10 +421,11 @@ static int msgctl_down(struct ipc_namesp
 
 	err = security_msg_queue_msgctl(msq, cmd);
 	if (err)
-		goto out_unlock0;
+		goto out_unlock1;
 
 	switch (cmd) {
 	case IPC_RMID:
+		ipc_lock_object(&msq->q_perm);
 		/* freeque unlocks the ipc object and rcu */
 		freeque(ns, ipcp);
 		goto out_up;
@@ -433,9 +433,10 @@ static int msgctl_down(struct ipc_namesp
 		if (msqid64.msg_qbytes > ns->msg_ctlmnb &&
 		    !capable(CAP_SYS_RESOURCE)) {
 			err = -EPERM;
-			goto out_unlock0;
+			goto out_unlock1;
 		}
 
+		ipc_lock_object(&msq->q_perm);
 		err = ipc_update_perm(&msqid64.msg_perm, ipcp);
 		if (err)
 			goto out_unlock0;
@@ -454,6 +455,7 @@ static int msgctl_down(struct ipc_namesp
 		break;
 	default:
 		err = -EINVAL;
+		goto out_unlock1;
 	}
 
 out_unlock0:


