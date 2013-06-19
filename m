Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039Ab3FSBTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:19:08 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5626 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:19:05 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 10/11] ipc,msg: drop msg_unlock
Date: Tue, 18 Jun 2013 18:18:35 -0700
Message-Id: <1371604716-3439-11-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
References: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one user left, drop this function and just call
ipc_unlock_object() and rcu_read_unlock().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 80d8aa7..091fa2b 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -70,8 +70,6 @@ struct msg_sender {
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
-#define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-
 static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
 static int newque(struct ipc_namespace *, struct ipc_params *);
 #ifdef CONFIG_PROC_FS
@@ -270,7 +268,8 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	expunge_all(msq, -EIDRM);
 	ss_wakeup(&msq->q_senders, 1);
 	msg_rmid(ns, msq);
-	msg_unlock(msq);
+	ipc_unlock_object(&msq->q_perm);
+	rcu_read_unlock();
 
 	list_for_each_entry_safe(msg, t, &msq->q_messages, m_list) {
 		atomic_dec(&ns->msg_hdrs);
-- 
1.7.11.7

