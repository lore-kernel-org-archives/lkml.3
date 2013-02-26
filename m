Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab3BZCW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:22:58 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36913 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760055Ab3BZCWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:40 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 03/10] ipc: Separate msg allocation from userspace copy
Date: Mon, 25 Feb 2013 21:21:40 -0500
Message-Id: <1361845307-12737-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating msg allocation enables single-block vmalloc
allocation instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msgutil.c | 52 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 98b1c2b..0a5c8a9 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -44,21 +44,54 @@ struct msg_msgseg {
 #define DATALEN_MSG	(int)(PAGE_SIZE-sizeof(struct msg_msg))
 #define DATALEN_SEG	(int)(PAGE_SIZE-sizeof(struct msg_msgseg))
 
-struct msg_msg *load_msg(const void __user *src, int len)
+
+static struct msg_msg *alloc_msg(int len)
 {
 	struct msg_msg *msg;
 	struct msg_msgseg **pseg;
-	int err;
 	int alen;
 
 	alen = min(len, DATALEN_MSG);
 	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
 	if (msg == NULL)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	msg->next = NULL;
 	msg->security = NULL;
 
+	len -= alen;
+	pseg = &msg->next;
+	while (len > 0) {
+		struct msg_msgseg *seg;
+		alen = min(len, DATALEN_SEG);
+		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL);
+		if (seg == NULL)
+			goto out_err;
+		*pseg = seg;
+		seg->next = NULL;
+		pseg = &seg->next;
+		len -= alen;
+	}
+
+	return msg;
+
+out_err:
+	free_msg(msg);
+	return NULL;
+}
+
+struct msg_msg *load_msg(const void __user *src, int len)
+{
+	struct msg_msg *msg;
+	struct msg_msgseg *seg;
+	int err;
+	int alen;
+
+	msg = alloc_msg(len);
+	if (msg == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	alen = min(len, DATALEN_MSG);
 	if (copy_from_user(msg + 1, src, alen)) {
 		err = -EFAULT;
 		goto out_err;
@@ -66,23 +99,14 @@ struct msg_msg *load_msg(const void __user *src, int len)
 
 	len -= alen;
 	src = ((char __user *)src) + alen;
-	pseg = &msg->next;
+	seg = msg->next;
 	while (len > 0) {
-		struct msg_msgseg *seg;
 		alen = min(len, DATALEN_SEG);
-		seg = kmalloc(sizeof(*seg) + alen,
-						 GFP_KERNEL);
-		if (seg == NULL) {
-			err = -ENOMEM;
-			goto out_err;
-		}
-		*pseg = seg;
-		seg->next = NULL;
 		if (copy_from_user(seg + 1, src, alen)) {
 			err = -EFAULT;
 			goto out_err;
 		}
-		pseg = &seg->next;
+		seg = seg->next;
 		len -= alen;
 		src = ((char __user *)src) + alen;
 	}
-- 
1.8.1.2

