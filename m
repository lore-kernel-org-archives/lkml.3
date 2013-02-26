Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab3BZCXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:23:09 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36932 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab3BZCWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 06/10] ipc: Don't allocate a copy larger than max
Date: Mon, 25 Feb 2013 21:21:43 -0500
Message-Id: <1361845307-12737-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When MSG_COPY is set, a duplicate message must be allocated for
the copy before locking the queue. However, the copy could
not be larger than was sent which is limited to msg_ctlmax.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 950572f..31cd1bf 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -820,15 +820,17 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	struct msg_msg *copy = NULL;
 	unsigned long copy_number = 0;
 
+	ns = current->nsproxy->ipc_ns;
+
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
+		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
+				    msgflg, &msgtyp, &copy_number);
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
 	mode = convert_mode(&msgtyp, msgflg);
-	ns = current->nsproxy->ipc_ns;
 
 	msq = msg_lock_check(ns, msqid);
 	if (IS_ERR(msq)) {
-- 
1.8.1.2

