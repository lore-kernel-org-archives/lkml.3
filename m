Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaDPKdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:33:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbaDPKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:33:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 46/46] crypto: ghash-clmulni-intel - use C implementation for setkey()
Date: Wed, 16 Apr 2014 11:32:02 +0100
Message-Id: <1397644322-13905-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 8ceee72808d1ae3fb191284afc2257a2be964725 upstream.

The GHASH setkey() function uses SSE registers but fails to call
kernel_fpu_begin()/kernel_fpu_end(). Instead of adding these calls, and
then having to deal with the restriction that they cannot be called from
interrupt context, move the setkey() implementation to the C domain.

Note that setkey() does not use any particular SSE features and is not
expected to become a performance bottleneck.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Fixes: 0e1227d356e9b (crypto: ghash - Add PCLMULQDQ accelerated implementation)
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S  | 29 -----------------------------
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 14 +++++++++++---
 2 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 586f41a..185fad4 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -24,10 +24,6 @@
 .align 16
 .Lbswap_mask:
 	.octa 0x000102030405060708090a0b0c0d0e0f
-.Lpoly:
-	.octa 0xc2000000000000000000000000000001
-.Ltwo_one:
-	.octa 0x00000001000000000000000000000001
 
 #define DATA	%xmm0
 #define SHASH	%xmm1
@@ -134,28 +130,3 @@ ENTRY(clmul_ghash_update)
 .Lupdate_just_ret:
 	ret
 ENDPROC(clmul_ghash_update)
-
-/*
- * void clmul_ghash_setkey(be128 *shash, const u8 *key);
- *
- * Calculate hash_key << 1 mod poly
- */
-ENTRY(clmul_ghash_setkey)
-	movaps .Lbswap_mask, BSWAP
-	movups (%rsi), %xmm0
-	PSHUFB_XMM BSWAP %xmm0
-	movaps %xmm0, %xmm1
-	psllq $1, %xmm0
-	psrlq $63, %xmm1
-	movaps %xmm1, %xmm2
-	pslldq $8, %xmm1
-	psrldq $8, %xmm2
-	por %xmm1, %xmm0
-	# reduction
-	pshufd $0b00100100, %xmm2, %xmm1
-	pcmpeqd .Ltwo_one, %xmm1
-	pand .Lpoly, %xmm1
-	pxor %xmm1, %xmm0
-	movups %xmm0, (%rdi)
-	ret
-ENDPROC(clmul_ghash_setkey)
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 6759dd1..d785cf2 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -30,8 +30,6 @@ void clmul_ghash_mul(char *dst, const be128 *shash);
 void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
 			const be128 *shash);
 
-void clmul_ghash_setkey(be128 *shash, const u8 *key);
-
 struct ghash_async_ctx {
 	struct cryptd_ahash *cryptd_tfm;
 };
@@ -58,13 +56,23 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
+	be128 *x = (be128 *)key;
+	u64 a, b;
 
 	if (keylen != GHASH_BLOCK_SIZE) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	clmul_ghash_setkey(&ctx->shash, key);
+	/* perform multiplication by 'x' in GF(2^128) */
+	a = be64_to_cpu(x->a);
+	b = be64_to_cpu(x->b);
+
+	ctx->shash.a = (__be64)((b << 1) | (a >> 63));
+	ctx->shash.b = (__be64)((a << 1) | (b >> 63));
+
+	if (a >> 63)
+		ctx->shash.b ^= cpu_to_be64(0xc2);
 
 	return 0;
 }
-- 
1.9.1

