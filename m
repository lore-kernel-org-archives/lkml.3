Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaFIJgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:36:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932816AbaFIJ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Horia Geanta <horia.geanta@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 133/146] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Mon,  9 Jun 2014 10:51:08 +0200
Message-Id: <966fa6afcbcadacda826cafc0eb043cd235b1f05.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Horia Geanta <horia.geanta@freescale.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 27c5fb7a84242b66bf1e0b2fe6bf40d19bcc5c04 upstream.

GFP_ATOMIC memory allocation could fail.
In this case, avoid NULL pointer dereference and notify user.

Cc: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
1.9.3

