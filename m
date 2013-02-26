Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188Ab3BZCXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:23:15 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36942 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab3BZCWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:50 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 08/10] ipc: Implement MSG_COPY as a new receive mode
Date: Mon, 25 Feb 2013 21:21:45 -0500
Message-Id: <1361845307-12737-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach the helper routines about MSG_COPY so that
msgtyp is preserved as the message number to copy.

The security functions affected by this change were audited
and no additional changes are necessary.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msg.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index e8d3f15..418c5a5 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -66,6 +66,7 @@ struct msg_sender {
 #define SEARCH_EQUAL		2
 #define SEARCH_NOTEQUAL		3
 #define SEARCH_LESSEQUAL	4
+#define SEARCH_NUMBER		5
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
@@ -583,6 +584,7 @@ static int testmsg(struct msg_msg *msg, long type, int mode)
 	switch(mode)
 	{
 		case SEARCH_ANY:
+		case SEARCH_NUMBER:
 			return 1;
 		case SEARCH_LESSEQUAL:
 			if (msg->m_type <=type)
@@ -738,6 +740,8 @@ SYSCALL_DEFINE4(msgsnd, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 
 static inline int convert_mode(long *msgtyp, int msgflg)
 {
+	if (msgflg & MSG_COPY)
+		return SEARCH_NUMBER;
 	/*
 	 *  find message of correct type.
 	 *  msgtyp = 0 => get first.
@@ -774,14 +778,10 @@ static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
  * This function creates new kernel message structure, large enough to store
  * bufsz message bytes.
  */
-static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
-					   int msgflg, long *msgtyp,
-					   unsigned long *copy_number)
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz)
 {
 	struct msg_msg *copy;
 
-	*copy_number = *msgtyp;
-	*msgtyp = 0;
 	/*
 	 * Create dummy message to copy real message to.
 	 */
@@ -797,9 +797,7 @@ static inline void free_copy(struct msg_msg *copy)
 		free_msg(copy);
 }
 #else
-static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
-					   int msgflg, long *msgtyp,
-					   unsigned long *copy_number)
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz)
 {
 	return ERR_PTR(-ENOSYS);
 }
@@ -818,18 +816,17 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	int mode;
 	struct ipc_namespace *ns;
 	struct msg_msg *copy = NULL;
-	unsigned long copy_number = 0;
 
 	ns = current->nsproxy->ipc_ns;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
-				    msgflg, &msgtyp, &copy_number);
+		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax));
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
+
 	mode = convert_mode(&msgtyp, msgflg);
 
 	msq = msg_lock_check(ns, msqid);
@@ -861,8 +858,8 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 				if (mode == SEARCH_LESSEQUAL &&
 						walk_msg->m_type != 1) {
 					msgtyp = walk_msg->m_type - 1;
-				} else if (msgflg & MSG_COPY) {
-					if (copy_number == msg_counter)
+				} else if (mode == SEARCH_NUMBER) {
+					if (msgtyp == msg_counter)
 						break;
 				} else
 					break;
-- 
1.8.1.2

