Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab3BZCsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:48:11 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:38434 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3BZCsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:48:08 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 10/10] ipc: Refactor msg list search into separate function
Date: Mon, 25 Feb 2013 21:21:47 -0500
Message-Id: <1361845307-12737-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msg.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index c3867da..daeca13 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -807,6 +807,30 @@ static inline void free_copy(struct msg_msg *copy)
 }
 #endif
 
+struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
+{
+	struct msg_msg *msg;
+	long count = 0;
+
+	list_for_each_entry(msg, &msq->q_messages, m_list) {
+		if (testmsg(msg, *msgtyp, mode) &&
+		    !security_msg_queue_msgrcv(msq, msg, current,
+					       *msgtyp, mode)) {
+			if (mode == SEARCH_LESSEQUAL && msg->m_type != 1) {
+				*msgtyp = msg->m_type - 1;
+			} else if (mode == SEARCH_NUMBER) {
+				if (*msgtyp == count)
+					return msg;
+			} else
+				return msg;
+			count++;
+		}
+	}
+
+	return ERR_PTR(-EAGAIN);
+}
+
+
 long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	       int msgflg,
 	       long (*msg_handler)(void __user *, struct msg_msg *, size_t))
@@ -837,32 +861,13 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 
 	for (;;) {
 		struct msg_receiver msr_d;
-		struct msg_msg *walk_msg;
-		long msg_counter = 0;
 
 		msg = ERR_PTR(-EACCES);
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock;
 
-		msg = ERR_PTR(-EAGAIN);
-		list_for_each_entry(walk_msg, &msq->qmessages, m_list) {
-
-			if (testmsg(walk_msg, msgtyp, mode) &&
-			    !security_msg_queue_msgrcv(msq, walk_msg, current,
-						       msgtyp, mode)) {
-
-				msg = walk_msg;
-				if (mode == SEARCH_LESSEQUAL &&
-						walk_msg->m_type != 1) {
-					msgtyp = walk_msg->m_type - 1;
-				} else if (mode == SEARCH_NUMBER) {
-					if (msgtyp == msg_counter)
-						break;
-				} else
-					break;
-				msg_counter++;
-			}
-		}
+		msg = find_msg(msq, &msgtyp, mode);
+
 		if (!IS_ERR(msg)) {
 			/*
 			 * Found a suitable message.
-- 
1.8.1.2

