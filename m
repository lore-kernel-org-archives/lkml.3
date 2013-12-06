Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162483Ab3LFXjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:39:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48728 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162198Ab3LFXSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 111/152] ipc: separate msg allocation from userspace copy
Date: Fri,  6 Dec 2013 15:10:35 -0800
Message-Id: <1386371476-2477-112-git-send-email-kamal@canonical.com>
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

commit be5f4b335f6e05df1b5c24b7e7d79ff52d7b8dbc upstream.

Separating msg allocation enables single-block vmalloc
allocation instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8 stable prereq for
  4e9b45a ipc, msg: fix message length check for negative values ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

