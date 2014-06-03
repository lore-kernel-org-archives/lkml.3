Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaFCMJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:09:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43479 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaFCLlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kim Phillips <kim.phillips@freescale.com>,
        Horia Geanta <horia.geanta@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 054/138] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Tue,  3 Jun 2014 12:38:20 +0100
Message-Id: <1401795584-22664-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geanta <horia.geanta@freescale.com>

commit 27c5fb7a84242b66bf1e0b2fe6bf40d19bcc5c04 upstream.

GFP_ATOMIC memory allocation could fail.
In this case, avoid NULL pointer dereference and notify user.

Cc: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/crypto/caam/error.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 9f25f5296029..0eabd81e1a90 100644
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

