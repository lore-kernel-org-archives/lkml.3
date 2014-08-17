Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaHQPo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:44:58 -0400
Received: from mail.eperm.de ([89.247.134.16]:53650 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbaHQPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:44:56 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 3/8] DRBG: remove superflowous checks
Date: Sun, 17 Aug 2014 17:38:29 +0200
Message-ID: <2680437.d0CEplkviS@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The crypto_init and crypto_fini functions are always implemented. Thus,
there is no need for a protecting check.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 8a95ca8..89d732b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1381,11 +1381,9 @@ static int drbg_generate(struct drbg_state *drbg,
 		shadow->seeded = false;
 
 	/* allocate cipher handle */
-	if (shadow->d_ops->crypto_init) {
-		len = shadow->d_ops->crypto_init(shadow);
-		if (len)
-			goto err;
-	}
+	len = shadow->d_ops->crypto_init(shadow);
+	if (len)
+		goto err;
 
 	if (shadow->pr || !shadow->seeded) {
 		pr_devel("DRBG: reseeding before generation (prediction "
@@ -1467,8 +1465,7 @@ static int drbg_generate(struct drbg_state *drbg,
 #endif
 
 err:
-	if (shadow->d_ops->crypto_fini)
-		shadow->d_ops->crypto_fini(shadow);
+	shadow->d_ops->crypto_fini(shadow);
 	drbg_restore_shadow(drbg, &shadow);
 	return len;
 }
@@ -1562,11 +1559,10 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		return ret;
 
 	ret = -EFAULT;
-	if (drbg->d_ops->crypto_init && drbg->d_ops->crypto_init(drbg))
+	if (drbg->d_ops->crypto_init(drbg))
 		goto err;
 	ret = drbg_seed(drbg, pers, false);
-	if (drbg->d_ops->crypto_fini)
-		drbg->d_ops->crypto_fini(drbg);
+	drbg->d_ops->crypto_fini(drbg);
 	if (ret)
 		goto err;
 
-- 
1.9.3


