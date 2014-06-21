Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaFUM10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:27:26 -0400
Received: from mail.eperm.de ([89.247.134.16]:33349 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaFUM1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:27:25 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: kbuild test robot <fengguang.wu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild@01.org, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Potential NULL pointer deference in drbg_ctr_df
Date: Sat, 21 Jun 2014 14:26:29 +0200
Message-ID: <4892293.kf6KiPx6BS@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140620202418.GZ5015@mwanda>
References: <20140620202418.GZ5015@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The handling of additional input data / personalization string data may
be subject to a NULL pointer deference for the CTR DRBG. The
caller-provided data may be NULL which must be caught by the DRBG.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index faaa2ce..8e7c302 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -513,17 +513,20 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	drbg_string_fill(&S2, L_N, sizeof(L_N));
 	drbg_string_fill(&S4, pad, padlen);
 	S1.next = &S2;
-	S2.next = addtl;
 
-	/*
-	 * splice in addtl between S2 and S4 -- we place S4 at the end of the
-	 * input data chain
-	 */
-	tempstr = addtl;
-	for (; NULL != tempstr; tempstr = tempstr->next)
-		if (NULL == tempstr->next)
-			break;
-	tempstr->next = &S4;
+	if (NULL == addtl) {
+		S2.next = &S4;
+	} else {
+		/*
+		 * splice in addtl between S2 and S4 -- we place S4 at the end
+		 * of the input data chain
+		 */
+		S2.next = addtl;
+		tempstr = addtl;
+		while (tempstr->next)
+			tempstr = tempstr->next;
+		tempstr->next = &S4;
+	}
 
 	/* 10.4.2 step 9 */
 	while (templen < (drbg_keylen(drbg) + (drbg_blocklen(drbg)))) {
-- 
1.9.3


