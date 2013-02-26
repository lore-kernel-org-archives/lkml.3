Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab3BZCXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:23:19 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36945 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab3BZCWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:51 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 09/10] ipc: Simplify msg list search
Date: Mon, 25 Feb 2013 21:21:46 -0500
Message-Id: <1361845307-12737-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msg.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 418c5a5..c3867da 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -837,7 +837,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 
 	for (;;) {
 		struct msg_receiver msr_d;
-		struct list_head *tmp;
+		struct msg_msg *walk_msg;
 		long msg_counter = 0;
 
 		msg = ERR_PTR(-EACCES);
@@ -845,11 +845,8 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			goto out_unlock;
 
 		msg = ERR_PTR(-EAGAIN);
-		tmp = msq->q_messages.next;
-		while (tmp != &msq->q_messages) {
-			struct msg_msg *walk_msg;
+		list_for_each_entry(walk_msg, &msq->qmessages, m_list) {
 
-			walk_msg = list_entry(tmp, struct msg_msg, m_list);
 			if (testmsg(walk_msg, msgtyp, mode) &&
 			    !security_msg_queue_msgrcv(msq, walk_msg, current,
 						       msgtyp, mode)) {
@@ -865,7 +862,6 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 					break;
 				msg_counter++;
 			}
-			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
 			/*
-- 
1.8.1.2

