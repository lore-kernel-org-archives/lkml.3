Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaDRJ0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:26:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46058 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbaDRJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 72/72] crypto: ghash-clmulni-intel - use C implementation for setkey()
Date: Fri, 18 Apr 2014 11:22:45 +0200
Message-Id: <a9149a366f5be56e50e9ec52bad0f616293fb640.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S  | 29 -----------------------------
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 14 +++++++++++---
 2 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 586f41aac361..185fad49d86f 100644
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
index 6759dd1135be..d785cf2c529c 100644
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
1.9.2

