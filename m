Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab3BZCXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:23:12 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36926 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760104Ab3BZCWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:44 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 05/10] ipc: Set EFAULT as default error in load_msg()
Date: Mon, 25 Feb 2013 21:21:42 -0500
Message-Id: <1361845307-12737-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msgutil.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index b79582d..d33fbb2 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -84,7 +84,7 @@ struct msg_msg *load_msg(const void __user *src, int len)
 {
 	struct msg_msg *msg;
 	struct msg_msgseg *seg;
-	int err;
+	int err = -EFAULT;
 	int alen;
 
 	msg = alloc_msg(len);
@@ -92,19 +92,15 @@ struct msg_msg *load_msg(const void __user *src, int len)
 		return ERR_PTR(-ENOMEM);
 
 	alen = min(len, DATALEN_MSG);
-	if (copy_from_user(msg + 1, src, alen)) {
-		err = -EFAULT;
+	if (copy_from_user(msg + 1, src, alen))
 		goto out_err;
-	}
 
 	for (seg = msg->next; seg != NULL; seg = seg->next) {
 		len -= alen;
 		src = (char __user *)src + alen;
 		alen = min(len, DATALEN_SEG);
-		if (copy_from_user(seg + 1, src, alen)) {
-			err = -EFAULT;
+		if (copy_from_user(seg + 1, src, alen))
 			goto out_err;
-		}
 	}
 
 	err = security_msg_msg_alloc(msg);
-- 
1.8.1.2

