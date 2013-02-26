Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3BZCXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:23:00 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36921 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057Ab3BZCWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:41 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 04/10] ipc: Tighten msg copy loops
Date: Mon, 25 Feb 2013 21:21:41 -0500
Message-Id: <1361845307-12737-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
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
1.8.1.2

