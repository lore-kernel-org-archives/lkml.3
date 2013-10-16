Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861Ab3JPSTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:19:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761372Ab3JPRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 36/69] ipc,msg: introduce lockless functions to obtain the ipc object
Date: Wed, 16 Oct 2013 10:44:45 -0700
Message-Id: <20131016174317.287427785@linuxfoundation.org>
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

commit a5001a0d9768568de5d613c3b3a5b9c7721299da upstream.

Add msq_obtain_object() and msq_obtain_object_check(), which will allow
us to get the ipc object without acquiring the lock.  Just as with
semaphores, these functions are basically wrappers around
ipc_obtain_object*().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -166,6 +166,27 @@ static inline struct msg_queue *msg_lock
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


