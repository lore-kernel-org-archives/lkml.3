Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423411Ab3CVVbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:31:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:32084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423313Ab3CVV3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,893,1355126400"; 
   d="scan'208";a="306274793"
Subject: [PATCH 06/11] Create module providing optimized SHA256 routines
 using SSSE3, AVX or AVX2 instructions.
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
Date: Fri, 22 Mar 2013 14:29:21 -0700
Message-ID: <1363987761.8972.60.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We added glue code and config options to create crypto
module that uses SSE/AVX/AVX2 optimized SHA256 x86_64 assembly routines.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/Makefile            |   2 +
 arch/x86/crypto/sha256_ssse3_glue.c | 269 ++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                      |  11 ++
 3 files changed, 282 insertions(+)
 create mode 100644 arch/x86/crypto/sha256_ssse3_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e0ca7c9..02a664a 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
+obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
 
 aes-i586-y := aes-i586-asm_32.o aes_glue.o
 twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
@@ -52,3 +53,4 @@ ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
 crc32c-intel-y := crc32c-intel_glue.o
 crc32c-intel-$(CONFIG_CRYPTO_CRC32C_X86_64) += crc32c-pcl-intel-asm_64.o
+sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
new file mode 100644
index 0000000..5876a19
--- /dev/null
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -0,0 +1,269 @@
+/*
+ * Cryptographic API.
+ *
+ * Glue code for the SHA256 Secure Hash Algorithm assembler
+ * implementation using supplemental SSE3 / AVX / AVX2 instructions.
+ *
+ * This file is based on sha256_generic.c
+ *
+ * Copyright (C) 2013 Intel Corporation.
+ *
+ * Author:
+ *     Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/cryptohash.h>
+#include <linux/types.h>
+#include <crypto/sha.h>
+#include <asm/byteorder.h>
+#include <asm/i387.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+#include <linux/string.h>
+
+asmlinkage void sha256_transform_ssse3(const char *data, u32 *digest,
+				     u64 rounds);
+#ifdef CONFIG_AS_AVX
+asmlinkage void sha256_transform_avx(const char *data, u32 *digest,
+				     u64 rounds);
+asmlinkage void sha256_transform_rorx(const char *data, u32 *digest,
+				     u64 rounds);
+#endif
+
+asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
+
+
+static int sha256_ssse3_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA256_H0;
+	sctx->state[1] = SHA256_H1;
+	sctx->state[2] = SHA256_H2;
+	sctx->state[3] = SHA256_H3;
+	sctx->state[4] = SHA256_H4;
+	sctx->state[5] = SHA256_H5;
+	sctx->state[6] = SHA256_H6;
+	sctx->state[7] = SHA256_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+
+static int __sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, unsigned int partial)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int done = 0;
+
+	sctx->count += len;
+
+	if (partial) {
+		done = SHA256_BLOCK_SIZE - partial;
+		memcpy(sctx->buf + partial, data, done);
+		sha256_transform_asm(sctx->buf, sctx->state, 1);
+	}
+
+	if (len - done >= SHA256_BLOCK_SIZE) {
+		const unsigned int rounds = (len - done) / SHA256_BLOCK_SIZE;
+
+		sha256_transform_asm(data + done, sctx->state, (u64) rounds);
+
+		done += rounds * SHA256_BLOCK_SIZE;
+	}
+
+	memcpy(sctx->buf, data + done, len - done);
+
+	return 0;
+}
+
+static int sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
+	int res;
+
+	/* Handle the fast case right here */
+	if (partial + len < SHA256_BLOCK_SIZE) {
+		sctx->count += len;
+		memcpy(sctx->buf + partial, data, len);
+
+		return 0;
+	}
+
+	if (!irq_fpu_usable()) {
+		res = crypto_sha256_update(desc, data, len);
+	} else {
+		kernel_fpu_begin();
+		res = __sha256_ssse3_update(desc, data, len, partial);
+		kernel_fpu_end();
+	}
+
+	return res;
+}
+
+
+/* Add padding and return the message digest. */
+static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int i, index, padlen;
+	__be32 *dst = (__be32 *)out;
+	__be64 bits;
+	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
+
+	bits = cpu_to_be64(sctx->count << 3);
+
+	/* Pad out to 56 mod 64 and append length */
+	index = sctx->count % SHA256_BLOCK_SIZE;
+	padlen = (index < 56) ? (56 - index) : ((SHA256_BLOCK_SIZE+56)-index);
+
+	if (!irq_fpu_usable()) {
+		crypto_sha256_update(desc, padding, padlen);
+		crypto_sha256_update(desc, (const u8 *)&bits, sizeof(bits));
+	} else {
+		kernel_fpu_begin();
+		/* We need to fill a whole block for __sha256_ssse3_update() */
+		if (padlen <= 56) {
+			sctx->count += padlen;
+			memcpy(sctx->buf + index, padding, padlen);
+		} else {
+			__sha256_ssse3_update(desc, padding, padlen, index);
+		}
+		__sha256_ssse3_update(desc, (const u8 *)&bits,
+					sizeof(bits), 56);
+		kernel_fpu_end();
+	}
+
+	/* Store state in digest */
+	for (i = 0; i < 8; i++)
+		dst[i] = cpu_to_be32(sctx->state[i]);
+
+	/* Wipe context */
+	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
+
+static int sha256_ssse3_export(struct shash_desc *desc, void *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+
+	return 0;
+}
+
+static int sha256_ssse3_import(struct shash_desc *desc, const void *in)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init		=	sha256_ssse3_init,
+	.update		=	sha256_ssse3_update,
+	.final		=	sha256_ssse3_final,
+	.export		=	sha256_ssse3_export,
+	.import		=	sha256_ssse3_import,
+	.descsize	=	sizeof(struct sha256_state),
+	.statesize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha256",
+		.cra_driver_name =	"sha256-ssse3",
+		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+#ifdef CONFIG_AS_AVX
+static bool __init avx_usable(void)
+{
+	u64 xcr0;
+
+	if (!cpu_has_avx || !cpu_has_osxsave)
+		return false;
+
+	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
+	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) != (XSTATE_SSE | XSTATE_YMM)) {
+		pr_info("AVX detected but unusable.\n");
+
+		return false;
+	}
+
+	return true;
+}
+#endif
+
+static int __init sha256_ssse3_mod_init(void)
+{
+	/* test for SSE3 first */
+	if (cpu_has_xmm3)
+		sha256_transform_asm = sha256_transform_ssse3;
+
+#ifdef CONFIG_AS_AVX
+	/* allow AVX to override SSSE3, it's a little faster */
+	if (avx_usable()) {
+		if (cpu_has_avx2)
+			sha256_transform_asm = sha256_transform_rorx;
+		else
+			sha256_transform_asm = sha256_transform_avx;
+	}
+#endif
+
+	if (sha256_transform_asm) {
+#ifdef CONFIG_AS_AVX
+		if (sha256_transform_asm == sha256_transform_avx)
+			pr_info("Using AVX optimized SHA-256 implementation\n");
+		else if (sha256_transform_asm == sha256_transform_rorx)
+			pr_info("Using AVX2 optimized SHA-256 implementation\n");
+		else
+#endif
+			pr_info("Using SSSE3 optimized SHA-256 implementation\n");
+		return crypto_register_shash(&alg);
+	}
+	pr_info("Neither AVX nor SSSE3 is available/usable.\n");
+
+	return -ENODEV;
+}
+
+static void __exit sha256_ssse3_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(sha256_ssse3_mod_init);
+module_exit(sha256_ssse3_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm, Supplemental SSE3 accelerated");
+
+MODULE_ALIAS("sha256");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4641d95..8a9d1a5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -461,6 +461,17 @@ config CRYPTO_SHA1_SSSE3
 	  using Supplemental SSE3 (SSSE3) instructions or Advanced Vector
 	  Extensions (AVX), when available.
 
+config CRYPTO_SHA256_SSSE3
+	tristate "SHA256 digest algorithm (SSSE3/AVX/AVX2)"
+	depends on X86 && 64BIT
+	select CRYPTO_SHA256
+	select CRYPTO_HASH
+	help
+	  SHA-256 secure hash standard (DFIPS 180-2) implemented
+	  using Supplemental SSE3 (SSSE3) instructions, or Advanced Vector
+	  Extensions version 1 (AVX1), or Advanced Vector Extensions
+	  version 2 (AVX2) instructions, when available.
+
 config CRYPTO_SHA1_SPARC64
 	tristate "SHA1 digest algorithm (SPARC64)"
 	depends on SPARC64
-- 
1.7.11.7



