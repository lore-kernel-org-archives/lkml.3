Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab3BZCXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:23:05 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36936 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab3BZCWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 07/10] ipc: Remove msg handling from queue scan
Date: Mon, 25 Feb 2013 21:21:44 -0500
Message-Id: <1361845307-12737-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for refactoring the queue scan into a separate
function, relocate msg copying.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msg.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 31cd1bf..e8d3f15 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -862,16 +862,8 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 						walk_msg->m_type != 1) {
 					msgtyp = walk_msg->m_type - 1;
 				} else if (msgflg & MSG_COPY) {
-					if (copy_number == msg_counter) {
-						/*
-						 * Found requested message.
-						 * Copy it.
-						 */
-						msg = copy_msg(msg, copy);
-						if (IS_ERR(msg))
-							goto out_unlock;
+					if (copy_number == msg_counter)
 						break;
-					}
 				} else
 					break;
 				msg_counter++;
@@ -891,8 +883,10 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			 * If we are copying, then do not unlink message and do
 			 * not update queue parameters.
 			 */
-			if (msgflg & MSG_COPY)
+			if (msgflg & MSG_COPY) {
+				msg = copy_msg(msg, copy);
 				goto out_unlock;
+			}
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
-- 
1.8.1.2

