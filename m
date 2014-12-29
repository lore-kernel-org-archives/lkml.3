Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaL2BQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:16:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33154 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Ard Biesheuvel" <ard.biesheuvel@linaro.org>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.146188502@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 18/27] crypto: ghash-clmulni-intel - use C
 implementation for setkey()
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S  | 29 -----------------------------
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 14 +++++++++++---
 2 files changed, 11 insertions(+), 32 deletions(-)

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
@@ -131,27 +127,3 @@ ENTRY(clmul_ghash_update)
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	ret
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
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -29,8 +29,6 @@ void clmul_ghash_mul(char *dst, const be
 void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
 			const be128 *shash);
 
-void clmul_ghash_setkey(be128 *shash, const u8 *key);
-
 struct ghash_async_ctx {
 	struct cryptd_ahash *cryptd_tfm;
 };
@@ -57,13 +55,23 @@ static int ghash_setkey(struct crypto_sh
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

