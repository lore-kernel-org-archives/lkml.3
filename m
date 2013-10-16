Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934958Ab3JPRsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:48:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934782Ab3JPRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 41/50] ipc,msg: drop msg_unlock
Date: Wed, 16 Oct 2013 10:45:27 -0700
Message-Id: <20131016174403.369183035@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 4718787d1f626f45ddb239912bc07266b9880044 upstream.

There is only one user left, drop this function and just call
ipc_unlock_object() and rcu_read_unlock().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -70,8 +70,6 @@ struct msg_sender {
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
-#define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-
 static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
 static int newque(struct ipc_namespace *, struct ipc_params *);
 #ifdef CONFIG_PROC_FS
@@ -278,7 +276,8 @@ static void freeque(struct ipc_namespace
 	expunge_all(msq, -EIDRM);
 	ss_wakeup(&msq->q_senders, 1);
 	msg_rmid(ns, msq);
-	msg_unlock(msq);
+	ipc_unlock_object(&msq->q_perm);
+	rcu_read_unlock();
 
 	list_for_each_entry_safe(msg, t, &msq->q_messages, m_list) {
 		atomic_dec(&ns->msg_hdrs);


