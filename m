Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaF1UIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:08:13 -0400
Received: from mail.eperm.de ([89.247.134.16]:50040 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbaF1UIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:08:12 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] DRBG: Call CTR DRBG DF function only once
Date: Sat, 28 Jun 2014 22:04:25 +0200
Message-ID: <3742446.V1bYQC64FA@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <4927386.WYHrRe3NJm@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CTR DRBG requires the update function to be called twice when
generating a random number. In both cases, update function must process
the additional information string by using the DF function. As the DF
produces the same result in both cases, we can save one invocation of
the DF function when the first DF function result is reused.

The result of the DF function is stored in the scratchpad storage. The
patch ensures that the scratchpad is not cleared when we want to reuse
the DF result. For achieving this, the CTR DRBG update function must
know by whom and in which scenario it is called. This information is
provided with the reseed parameter to the update function.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 4593b3c..53ff20d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -565,7 +565,21 @@ out:
 	return ret;
 }
 
-/* update function of CTR DRBG as defined in 10.2.1.2 */
+/*
+ * update function of CTR DRBG as defined in 10.2.1.2
+ *
+ * The reseed variable has an enhanced meaning compared to the update
+ * functions of the other DRBGs as follows:
+ * 0 => initial seed from initialization
+ * 1 => reseed via drbg_seed
+ * 2 => first invocation from drbg_ctr_update when addtl is present. In
+ *      this case, the df_data scratchpad is not deleted so that it is
+ *      available for another calls to prevent calling the DF function
+ *      again.
+ * 3 => second invocation from drbg_ctr_update. When the update function
+ *      was called with addtl, the df_data memory already contains the
+ *      DFed addtl information and we do not need to call DF again.
+ */
 static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 			   int reseed)
 {
@@ -580,7 +594,8 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 	unsigned char prefix = DRBG_PREFIX1;
 
 	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
-	memset(df_data, 0, drbg_statelen(drbg));
+	if (3 > reseed)
+		memset(df_data, 0, drbg_statelen(drbg));
 
 	/* 10.2.1.3.2 step 2 and 10.2.1.4.2 step 2 */
 	if (seed) {
@@ -622,7 +637,8 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 
 out:
 	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
-	memset(df_data, 0, drbg_statelen(drbg));
+	if (2 != reseed)
+		memset(df_data, 0, drbg_statelen(drbg));
 	return ret;
 }
 
@@ -647,7 +663,7 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 		LIST_HEAD(addtllist);
 
 		list_add_tail(&addtl->list, &addtllist);
-		ret = drbg_ctr_update(drbg, &addtllist, 1);
+		ret = drbg_ctr_update(drbg, &addtllist, 2);
 		if (ret)
 			return 0;
 	}
@@ -678,21 +694,8 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 			drbg_add_buf(drbg->V, drbg_blocklen(drbg), &prefix, 1);
 	}
 
-	/*
-	 * 10.2.1.5.2 step 6
-	 * The following call invokes the DF function again which could be
-	 * optimized. In step 2, the "additional_input" after step 2 is the
-	 * output of the DF function. If this result would be saved, the DF
-	 * function would not need to be invoked again at this point.
-	 */
-	if (addtl && 0 < addtl->len) {
-		LIST_HEAD(addtllist);
-
-		list_add_tail(&addtl->list, &addtllist);
-		ret = drbg_ctr_update(drbg, &addtllist, 1);
-	} else {
-		ret = drbg_ctr_update(drbg, NULL, 1);
-	}
+	/* 10.2.1.5.2 step 6 */
+	ret = drbg_ctr_update(drbg, NULL, 3);
 	if (ret)
 		len = ret;
 
-- 
1.9.3


