Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423417Ab3CVVa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:30:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:32084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423270Ab3CVV3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:29:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,893,1355126400"; 
   d="scan'208";a="306274808"
Subject: [PATCH 07/11] Expose generic sha512 routine to be callable from
 other modules
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
Date: Fri, 22 Mar 2013 14:29:25 -0700
Message-ID: <1363987765.8972.61.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other SHA512 routines may need to use the generic routine when
FPU is not available.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/sha512_generic.c | 13 +++++++------
 include/crypto/sha.h    |  3 +++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 71fcf36..4c58620 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -163,8 +163,8 @@ sha384_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int
-sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
+int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
 
@@ -197,6 +197,7 @@ sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha512_update);
 
 static int
 sha512_final(struct shash_desc *desc, u8 *hash)
@@ -215,10 +216,10 @@ sha512_final(struct shash_desc *desc, u8 *hash)
 	/* Pad out to 112 mod 128. */
 	index = sctx->count[0] & 0x7f;
 	pad_len = (index < 112) ? (112 - index) : ((128+112) - index);
-	sha512_update(desc, padding, pad_len);
+	crypto_sha512_update(desc, padding, pad_len);
 
 	/* Append length (before padding) */
-	sha512_update(desc, (const u8 *)bits, sizeof(bits));
+	crypto_sha512_update(desc, (const u8 *)bits, sizeof(bits));
 
 	/* Store state in digest */
 	for (i = 0; i < 8; i++)
@@ -245,7 +246,7 @@ static int sha384_final(struct shash_desc *desc, u8 *hash)
 static struct shash_alg sha512_algs[2] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_init,
-	.update		=	sha512_update,
+	.update		=	crypto_sha512_update,
 	.final		=	sha512_final,
 	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
@@ -257,7 +258,7 @@ static struct shash_alg sha512_algs[2] = { {
 }, {
 	.digestsize	=	SHA384_DIGEST_SIZE,
 	.init		=	sha384_init,
-	.update		=	sha512_update,
+	.update		=	crypto_sha512_update,
 	.final		=	sha384_final,
 	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index f46ff61..190f8a0 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -89,4 +89,7 @@ extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 
 extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
+
+extern int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len);
 #endif
-- 
1.7.11.7



