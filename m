Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495Ab3JPSSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:18:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761379Ab3JPRpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 37/69] ipc,msg: make msgctl_nolock lockless
Date: Wed, 16 Oct 2013 10:44:46 -0700
Message-Id: <20131016174317.414138277@linuxfoundation.org>
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

commit ac0ba20ea6f2201a1589d6dc26ad1a4f0f967bb8 upstream.

While the INFO cmd doesn't take the ipc lock, the STAT commands do
acquire it unnecessarily.  We can do the permissions and security checks
only holding the rcu lock.

This function now mimics semctl_nolock().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -545,17 +545,25 @@ static int msgctl_nolock(struct ipc_name
 		if (!buf)
 			return -EFAULT;
 
+		memset(&tbuf, 0, sizeof(tbuf));
+
+		rcu_read_lock();
 		if (cmd == MSG_STAT) {
-			msq = msg_lock(ns, msqid);
-			if (IS_ERR(msq))
-				return PTR_ERR(msq);
+			msq = msq_obtain_object(ns, msqid);
+			if (IS_ERR(msq)) {
+				err = PTR_ERR(msq);
+				goto out_unlock;
+			}
 			success_return = msq->q_perm.id;
 		} else {
-			msq = msg_lock_check(ns, msqid);
-			if (IS_ERR(msq))
-				return PTR_ERR(msq);
+			msq = msq_obtain_object_check(ns, msqid);
+			if (IS_ERR(msq)) {
+				err = PTR_ERR(msq);
+				goto out_unlock;
+			}
 			success_return = 0;
 		}
+
 		err = -EACCES;
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock;
@@ -564,8 +572,6 @@ static int msgctl_nolock(struct ipc_name
 		if (err)
 			goto out_unlock;
 
-		memset(&tbuf, 0, sizeof(tbuf));
-
 		kernel_to_ipc64_perm(&msq->q_perm, &tbuf.msg_perm);
 		tbuf.msg_stime  = msq->q_stime;
 		tbuf.msg_rtime  = msq->q_rtime;
@@ -575,7 +581,8 @@ static int msgctl_nolock(struct ipc_name
 		tbuf.msg_qbytes = msq->q_qbytes;
 		tbuf.msg_lspid  = msq->q_lspid;
 		tbuf.msg_lrpid  = msq->q_lrpid;
-		msg_unlock(msq);
+		rcu_read_unlock();
+
 		if (copy_msqid_to_user(buf, &tbuf, version))
 			return -EFAULT;
 		return success_return;
@@ -587,7 +594,7 @@ static int msgctl_nolock(struct ipc_name
 
 	return err;
 out_unlock:
-	msg_unlock(msq);
+	rcu_read_unlock();
 	return err;
 }
 


