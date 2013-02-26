Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab3BZCW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:22:56 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36906 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034Ab3BZCWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:37 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 02/10] ipc: Clamp with min()
Date: Mon, 25 Feb 2013 21:21:39 -0500
Message-Id: <1361845307-12737-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msgutil.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 5df8e4b..98b1c2b 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -41,8 +41,8 @@ struct msg_msgseg {
 	/* the next part of the message follows immediately */
 };
 
-#define DATALEN_MSG	(PAGE_SIZE-sizeof(struct msg_msg))
-#define DATALEN_SEG	(PAGE_SIZE-sizeof(struct msg_msgseg))
+#define DATALEN_MSG	(int)(PAGE_SIZE-sizeof(struct msg_msg))
+#define DATALEN_SEG	(int)(PAGE_SIZE-sizeof(struct msg_msgseg))
 
 struct msg_msg *load_msg(const void __user *src, int len)
 {
@@ -51,10 +51,7 @@ struct msg_msg *load_msg(const void __user *src, int len)
 	int err;
 	int alen;
 
-	alen = len;
-	if (alen > DATALEN_MSG)
-		alen = DATALEN_MSG;
-
+	alen = min(len, DATALEN_MSG);
 	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
 	if (msg == NULL)
 		return ERR_PTR(-ENOMEM);
@@ -72,9 +69,7 @@ struct msg_msg *load_msg(const void __user *src, int len)
 	pseg = &msg->next;
 	while (len > 0) {
 		struct msg_msgseg *seg;
-		alen = len;
-		if (alen > DATALEN_SEG)
-			alen = DATALEN_SEG;
+		alen = min(len, DATALEN_SEG);
 		seg = kmalloc(sizeof(*seg) + alen,
 						 GFP_KERNEL);
 		if (seg == NULL) {
@@ -113,19 +108,14 @@ struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
 	if (src->m_ts > dst->m_ts)
 		return ERR_PTR(-EINVAL);
 
-	alen = len;
-	if (alen > DATALEN_MSG)
-		alen = DATALEN_MSG;
-
+	alen = min(len, DATALEN_MSG);
 	memcpy(dst + 1, src + 1, alen);
 
 	len -= alen;
 	dst_pseg = dst->next;
 	src_pseg = src->next;
 	while (len > 0) {
-		alen = len;
-		if (alen > DATALEN_SEG)
-			alen = DATALEN_SEG;
+		alen = min(len, DATALEN_SEG);
 		memcpy(dst_pseg + 1, src_pseg + 1, alen);
 		dst_pseg = dst_pseg->next;
 		len -= alen;
@@ -148,9 +138,7 @@ int store_msg(void __user *dest, struct msg_msg *msg, int len)
 	int alen;
 	struct msg_msgseg *seg;
 
-	alen = len;
-	if (alen > DATALEN_MSG)
-		alen = DATALEN_MSG;
+	alen = min(len, DATALEN_MSG);
 	if (copy_to_user(dest, msg + 1, alen))
 		return -1;
 
@@ -158,9 +146,7 @@ int store_msg(void __user *dest, struct msg_msg *msg, int len)
 	dest = ((char __user *)dest) + alen;
 	seg = msg->next;
 	while (len > 0) {
-		alen = len;
-		if (alen > DATALEN_SEG)
-			alen = DATALEN_SEG;
+		alen = min(len, DATALEN_SEG);
 		if (copy_to_user(dest, seg + 1, alen))
 			return -1;
 		len -= alen;
-- 
1.8.1.2

