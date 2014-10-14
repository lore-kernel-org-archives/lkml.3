Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaJNT6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:58:25 -0400
Received: from mail.eperm.de ([89.247.134.16]:54060 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbaJNT6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:58:24 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: drbg - use crypto_inc
Date: Tue, 14 Oct 2014 21:50:13 +0200
Message-ID: <1838543.MpsGos9GAS@myon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.16.4-200.fc20.x86_64; KDE/4.14.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DRBG internal buffer addition function is replaced with crypto_inc when
a buffer is to be incremented by one.

The function drbg_add_buf is moved to the CONFIG_CRYPTO_DRBG_HASH ifdef
area as it is now only needed for the Hash DRBG.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 79 ++++++++++++++++++++++++++++-------------------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 54cfd48..8c0a742 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -283,38 +283,6 @@ static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
 
 	conversion->conv = cpu_to_be32(val);
 }
-
-/*
- * Increment buffer
- *
- * @dst buffer to increment
- * @add value to add
- */
-static inline void drbg_add_buf(unsigned char *dst, size_t dstlen,
-				const unsigned char *add, size_t addlen)
-{
-	/* implied: dstlen > addlen */
-	unsigned char *dstptr;
-	const unsigned char *addptr;
-	unsigned int remainder = 0;
-	size_t len = addlen;
-
-	dstptr = dst + (dstlen-1);
-	addptr = add + (addlen-1);
-	while (len) {
-		remainder += *dstptr + *addptr;
-		*dstptr = remainder & 0xff;
-		remainder >>= 8;
-		len--; dstptr--; addptr--;
-	}
-	len = dstlen - addlen;
-	while (len && remainder > 0) {
-		remainder = *dstptr + 1;
-		*dstptr = remainder & 0xff;
-		remainder >>= 8;
-		len--; dstptr--;
-	}
-}
 #endif /* defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_CTR) */
 
 /******************************************************************
@@ -554,7 +522,6 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 	unsigned char *temp_p, *df_data_p; /* pointer to iterate over buffers */
 	unsigned int len = 0;
 	struct drbg_string cipherin;
-	unsigned char prefix = DRBG_PREFIX1;
 
 	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
 	if (3 > reseed)
@@ -574,7 +541,7 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 	 */
 	while (len < (drbg_statelen(drbg))) {
 		/* 10.2.1.2 step 2.1 */
-		drbg_add_buf(drbg->V, drbg_blocklen(drbg), &prefix, 1);
+		crypto_inc(drbg->V, drbg_blocklen(drbg));
 		/*
 		 * 10.2.1.2 step 2.2 */
 		ret = drbg_kcapi_sym(drbg, drbg->C, temp + len, &cipherin);
@@ -617,7 +584,6 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 	int len = 0;
 	int ret = 0;
 	struct drbg_string data;
-	unsigned char prefix = DRBG_PREFIX1;
 
 	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
 
@@ -629,7 +595,7 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 	}
 
 	/* 10.2.1.5.2 step 4.1 */
-	drbg_add_buf(drbg->V, drbg_blocklen(drbg), &prefix, 1);
+	crypto_inc(drbg->V, drbg_blocklen(drbg));
 	drbg_string_fill(&data, drbg->V, drbg_blocklen(drbg));
 	while (len < buflen) {
 		int outlen = 0;
@@ -643,7 +609,7 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 			  drbg_blocklen(drbg) : (buflen - len);
 		if (!drbg_fips_continuous_test(drbg, drbg->scratchpad)) {
 			/* 10.2.1.5.2 step 6 */
-			drbg_add_buf(drbg->V, drbg_blocklen(drbg), &prefix, 1);
+			crypto_inc(drbg->V, drbg_blocklen(drbg));
 			continue;
 		}
 		/* 10.2.1.5.2 step 4.3 */
@@ -651,7 +617,7 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 		len += outlen;
 		/* 10.2.1.5.2 step 6 */
 		if (len < buflen)
-			drbg_add_buf(drbg->V, drbg_blocklen(drbg), &prefix, 1);
+			crypto_inc(drbg->V, drbg_blocklen(drbg));
 	}
 
 	/* 10.2.1.5.2 step 6 */
@@ -797,6 +763,38 @@ static struct drbg_state_ops drbg_hmac_ops = {
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 #define CRYPTO_DRBG_HASH_STRING "HASH "
 /*
+ * Increment buffer
+ *
+ * @dst buffer to increment
+ * @add value to add
+ */
+static inline void drbg_add_buf(unsigned char *dst, size_t dstlen,
+				const unsigned char *add, size_t addlen)
+{
+	/* implied: dstlen > addlen */
+	unsigned char *dstptr;
+	const unsigned char *addptr;
+	unsigned int remainder = 0;
+	size_t len = addlen;
+
+	dstptr = dst + (dstlen-1);
+	addptr = add + (addlen-1);
+	while (len) {
+		remainder += *dstptr + *addptr;
+		*dstptr = remainder & 0xff;
+		remainder >>= 8;
+		len--; dstptr--; addptr--;
+	}
+	len = dstlen - addlen;
+	while (len && remainder > 0) {
+		remainder = *dstptr + 1;
+		*dstptr = remainder & 0xff;
+		remainder >>= 8;
+		len--; dstptr--;
+	}
+}
+
+/*
  * scratchpad usage: as drbg_hash_update and drbg_hash_df are used
  * interlinked, the scratchpad is used as follows:
  * drbg_hash_update
@@ -942,7 +940,6 @@ static int drbg_hash_hashgen(struct drbg_state *drbg,
 	unsigned char *dst = drbg->scratchpad + drbg_statelen(drbg);
 	struct drbg_string data;
 	LIST_HEAD(datalist);
-	unsigned char prefix = DRBG_PREFIX1;
 
 	memset(src, 0, drbg_statelen(drbg));
 	memset(dst, 0, drbg_blocklen(drbg));
@@ -963,7 +960,7 @@ static int drbg_hash_hashgen(struct drbg_state *drbg,
 		outlen = (drbg_blocklen(drbg) < (buflen - len)) ?
 			  drbg_blocklen(drbg) : (buflen - len);
 		if (!drbg_fips_continuous_test(drbg, dst)) {
-			drbg_add_buf(src, drbg_statelen(drbg), &prefix, 1);
+			crypto_inc(src, drbg_statelen(drbg));
 			continue;
 		}
 		/* 10.1.1.4 step hashgen 4.2 */
@@ -971,7 +968,7 @@ static int drbg_hash_hashgen(struct drbg_state *drbg,
 		len += outlen;
 		/* 10.1.1.4 hashgen step 4.3 */
 		if (len < buflen)
-			drbg_add_buf(src, drbg_statelen(drbg), &prefix, 1);
+			crypto_inc(src, drbg_statelen(drbg));
 	}
 
 out:
-- 
1.9.3


