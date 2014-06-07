Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaFGBci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36125 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kim Phillips" <kim.phillips@freescale.com>,
        "Horia Geanta" <horia.geanta@freescale.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.620662234@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 33/92] crypto: caam - add allocation failure handling
 in SPRINTFCAT macro
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geanta <horia.geanta@freescale.com>

commit 27c5fb7a84242b66bf1e0b2fe6bf40d19bcc5c04 upstream.

GFP_ATOMIC memory allocation could fail.
In this case, avoid NULL pointer dereference and notify user.

Cc: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/crypto/caam/error.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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

