Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423349Ab3CVV3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:29:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:32084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423270Ab3CVV3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,893,1355126400"; 
   d="scan'208";a="306274733"
Subject: [PATCH 02/11] Expose SHA256 generic routine to be callable
 externally.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>
Cc: Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
In-Reply-To: <cover.1363961999.git.tim.c.chen@linux.intel.com>
References: <cover.1363961999.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Mar 2013 14:29:06 -0700
Message-ID: <1363987746.8972.56.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other SHA256 routine may need to use the generic routine when
FPU is not available.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/sha256_generic.c | 11 ++++++-----
 include/crypto/sha.h    |  2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index c3ed4ec..5433667 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -246,7 +246,7 @@ static int sha256_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int sha256_update(struct shash_desc *desc, const u8 *data,
+int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
@@ -277,6 +277,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
 
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha256_update);
 
 static int sha256_final(struct shash_desc *desc, u8 *out)
 {
@@ -293,10 +294,10 @@ static int sha256_final(struct shash_desc *desc, u8 *out)
 	/* Pad out to 56 mod 64. */
 	index = sctx->count & 0x3f;
 	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
-	sha256_update(desc, padding, pad_len);
+	crypto_sha256_update(desc, padding, pad_len);
 
 	/* Append length (before padding) */
-	sha256_update(desc, (const u8 *)&bits, sizeof(bits));
+	crypto_sha256_update(desc, (const u8 *)&bits, sizeof(bits));
 
 	/* Store state in digest */
 	for (i = 0; i < 8; i++)
@@ -339,7 +340,7 @@ static int sha256_import(struct shash_desc *desc, const void *in)
 static struct shash_alg sha256_algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_init,
-	.update		=	sha256_update,
+	.update		=	crypto_sha256_update,
 	.final		=	sha256_final,
 	.export		=	sha256_export,
 	.import		=	sha256_import,
@@ -355,7 +356,7 @@ static struct shash_alg sha256_algs[2] = { {
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_init,
-	.update		=	sha256_update,
+	.update		=	crypto_sha256_update,
 	.final		=	sha224_final,
 	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index c6c9c1f..f46ff61 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -87,4 +87,6 @@ struct shash_desc;
 extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
+extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len);
 #endif
-- 
1.7.11.7



