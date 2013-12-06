Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab3LFXfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:35:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48807 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3LFXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 113/152] ipc: set EFAULT as default error in load_msg()
Date: Fri,  6 Dec 2013 15:10:37 -0800
Message-Id: <1386371476-2477-114-git-send-email-kamal@canonical.com>
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

commit 2b3097a294b6daaf390010de14ca50bfccbc6fb6 upstream.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8 stable prereq for
  4e9b45a ipc, msg: fix message length check for negative values ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

