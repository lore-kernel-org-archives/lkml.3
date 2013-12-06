Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162516Ab3LFXjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:39:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161567Ab3LFXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 112/152] ipc: tighten msg copy loops
Date: Fri,  6 Dec 2013 15:10:36 -0800
Message-Id: <1386371476-2477-113-git-send-email-kamal@canonical.com>
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

commit da085d4591a6fe11eac2e1f659f25b655e9f2e53 upstream.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8 stable prereq for
  4e9b45a ipc, msg: fix message length check for negative values ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 ipc/msgutil.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 0a5c8a9..b79582d 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -97,18 +97,14 @@ struct msg_msg *load_msg(const void __user *src, int len)
 		goto out_err;
 	}
 
-	len -= alen;
-	src = ((char __user *)src) + alen;
-	seg = msg->next;
-	while (len > 0) {
+	for (seg = msg->next; seg != NULL; seg = seg->next) {
+		len -= alen;
+		src = (char __user *)src + alen;
 		alen = min(len, DATALEN_SEG);
 		if (copy_from_user(seg + 1, src, alen)) {
 			err = -EFAULT;
 			goto out_err;
 		}
-		seg = seg->next;
-		len -= alen;
-		src = ((char __user *)src) + alen;
 	}
 
 	err = security_msg_msg_alloc(msg);
@@ -135,15 +131,13 @@ struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
 	alen = min(len, DATALEN_MSG);
 	memcpy(dst + 1, src + 1, alen);
 
-	len -= alen;
-	dst_pseg = dst->next;
-	src_pseg = src->next;
-	while (len > 0) {
+	for (dst_pseg = dst->next, src_pseg = src->next;
+	     src_pseg != NULL;
+	     dst_pseg = dst_pseg->next, src_pseg = src_pseg->next) {
+
+		len -= alen;
 		alen = min(len, DATALEN_SEG);
 		memcpy(dst_pseg + 1, src_pseg + 1, alen);
-		dst_pseg = dst_pseg->next;
-		len -= alen;
-		src_pseg = src_pseg->next;
 	}
 
 	dst->m_type = src->m_type;
@@ -166,16 +160,12 @@ int store_msg(void __user *dest, struct msg_msg *msg, int len)
 	if (copy_to_user(dest, msg + 1, alen))
 		return -1;
 
-	len -= alen;
-	dest = ((char __user *)dest) + alen;
-	seg = msg->next;
-	while (len > 0) {
+	for (seg = msg->next; seg != NULL; seg = seg->next) {
+		len -= alen;
+		dest = (char __user *)dest + alen;
 		alen = min(len, DATALEN_SEG);
 		if (copy_to_user(dest, seg + 1, alen))
 			return -1;
-		len -= alen;
-		dest = ((char __user *)dest) + alen;
-		seg = seg->next;
 	}
 	return 0;
 }
-- 
1.8.3.2

