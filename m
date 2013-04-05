Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161768Ab3DENmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161548Ab3DENmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:42:19 -0400
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ipc: use list_for_each_entry for list traversing
Date: Fri,  5 Apr 2013 15:42:11 +0200
Message-Id: <63a5135b37c9a45abad27eed9f78d69dd4deba76.1365168828.git.npajkovs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the ipc/msg.c code does all list operations by hand and it open-codes
the accesses, instead of using for_each_entry.

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
---
 ipc/msg.c |   35 ++++++++---------------------------
 1 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index fede1d0..8eca57a 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -237,14 +237,9 @@ static inline void ss_del(struct msg_sender *mss)
 
 static void ss_wakeup(struct list_head *h, int kill)
 {
-	struct list_head *tmp;
+	struct msg_sender *mss, *t;
 
-	tmp = h->next;
-	while (tmp != h) {
-		struct msg_sender *mss;
-
-		mss = list_entry(tmp, struct msg_sender, list);
-		tmp = tmp->next;
+	list_for_each_entry_safe(mss, t, h, list) {
 		if (kill)
 			mss->list.next = NULL;
 		wake_up_process(mss->tsk);
@@ -253,14 +248,9 @@ static void ss_wakeup(struct list_head *h, int kill)
 
 static void expunge_all(struct msg_queue *msq, int res)
 {
-	struct list_head *tmp;
-
-	tmp = msq->q_receivers.next;
-	while (tmp != &msq->q_receivers) {
-		struct msg_receiver *msr;
+	struct msg_receiver *msr, *t;
 
-		msr = list_entry(tmp, struct msg_receiver, r_list);
-		tmp = tmp->next;
+	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
 		msr->r_msg = NULL;
 		wake_up_process(msr->r_tsk);
 		smp_mb();
@@ -278,7 +268,7 @@ static void expunge_all(struct msg_queue *msq, int res)
  */
 static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
-	struct list_head *tmp;
+	struct msg_msg *msg;
 	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
 
 	expunge_all(msq, -EIDRM);
@@ -286,11 +276,7 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	msg_rmid(ns, msq);
 	msg_unlock(msq);
 
-	tmp = msq->q_messages.next;
-	while (tmp != &msq->q_messages) {
-		struct msg_msg *msg = list_entry(tmp, struct msg_msg, m_list);
-
-		tmp = tmp->next;
+	list_for_each_entry(msg, &msq->q_messages, m_list) {
 		atomic_dec(&ns->msg_hdrs);
 		free_msg(msg);
 	}
@@ -602,14 +588,9 @@ static int testmsg(struct msg_msg *msg, long type, int mode)
 
 static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
 {
-	struct list_head *tmp;
-
-	tmp = msq->q_receivers.next;
-	while (tmp != &msq->q_receivers) {
-		struct msg_receiver *msr;
+	struct msg_receiver *msr, *t;
 
-		msr = list_entry(tmp, struct msg_receiver, r_list);
-		tmp = tmp->next;
+	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
 		if (testmsg(msg, msr->r_msgtype, msr->r_mode) &&
 		    !security_msg_queue_msgrcv(msq, msg, msr->r_tsk,
 					       msr->r_msgtype, msr->r_mode)) {
-- 
1.7.1

