Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaFXUru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:47:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaFXUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:30:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kim Phillips <kim.phillips@freescale.com>,
        Horia Geanta <horia.geanta@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 03/65] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Tue, 24 Jun 2014 13:29:23 -0700
Message-Id: <1403641825-12825-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geanta <horia.geanta@freescale.com>

commit 27c5fb7a84242b66bf1e0b2fe6bf40d19bcc5c04 upstream.

GFP_ATOMIC memory allocation could fail.
In this case, avoid NULL pointer dereference and notify user.

Cc: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/crypto/caam/error.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 30b8f74..a28c522 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -16,9 +16,13 @@
 	char *tmp;						\
 								\
 	tmp = kmalloc(sizeof(format) + max_alloc, GFP_ATOMIC);	\
-	sprintf(tmp, format, param);				\
-	strcat(str, tmp);					\
-	kfree(tmp);						\
+	if (likely(tmp)) {					\
+		sprintf(tmp, format, param);			\
+		strcat(str, tmp);				\
+		kfree(tmp);					\
+	} else {						\
+		strcat(str, "kmalloc failure in SPRINTFCAT");	\
+	}							\
 }
 
 static void report_jump_idx(u32 status, char *outstr)
-- 
1.9.1

