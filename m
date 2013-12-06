Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab3LFX2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:28:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161643Ab3LFXUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 110/152] ipc: clamp with min()
Date: Fri,  6 Dec 2013 15:10:34 -0800
Message-Id: <1386371476-2477-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 3d8fa456d5ed22ce8db085a89a037b87568b2b64 upstream.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8 stable prereq for
  4e9b45a ipc, msg: fix message length check for negative values ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

