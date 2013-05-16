Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3EPBJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:09:59 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33181 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3EPBIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:16 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 07/11] ipc,msg: introduce lockless functions to obtain the ipc object
Date: Wed, 15 May 2013 18:08:06 -0700
Message-Id: <1368666490-29055-8-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add msq_obtain_object() and msq_obtain_object_check(), which will
allow us to get the ipc object without acquiring the lock. Just
as with semaphores, these functions are basically wrappers around
ipc_obtain_object*().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/ipc/msg.c b/ipc/msg.c
index 20361b5..9ff295b 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -166,6 +166,27 @@ static inline struct msg_queue *msg_lock_check(struct ipc_namespace *ns,
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
+static inline struct msg_queue *msq_obtain_object(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object(&msg_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct msg_queue, q_perm);
+}
+
+static inline struct msg_queue *msq_obtain_object_check(struct ipc_namespace *ns,
+							int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_check(&msg_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct msg_queue, q_perm);
+}
+
 static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
 {
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
-- 
1.7.11.7

