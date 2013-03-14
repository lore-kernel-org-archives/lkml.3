Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3CNJs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:48:57 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45621 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3CNJsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:48:53 -0400
MIME-Version: 1.0
Date: Thu, 14 Mar 2013 18:48:51 +0900
X-Google-Sender-Auth: SJSCfRLYUTKYvhZdDFid_j-EhGs
Message-ID: <CAOAMb1DsZtgscHMM_-w1o+kDC8bhKF06-ARBE7=szPCvmzd49g@mail.gmail.com>
Subject: [PATCH 2/2] crypto: Add lz4 Cryptographic API
From: Chanho Min <chanho.min@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Yann Collet <yann.collet.73@gmail.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for lz4 and lz4hc compression algorithm
using the lib/lz4/* codebase.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 crypto/Kconfig  |   16 +++++++++
 crypto/Makefile |    2 ++
 crypto/lz4.c    |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/lz4hc.c  |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 228 insertions(+)
 create mode 100644 crypto/lz4.c
 create mode 100644 crypto/lz4hc.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index aed52b2..cad1835 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1236,6 +1236,22 @@ config CRYPTO_842
 	help
 	  This is the 842 algorithm.

+config CRYPTO_LZ4
+	tristate "LZ4 compression algorithm"
+	select CRYPTO_ALGAPI
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
+	help
+	  This is the LZ4 algorithm.
+
+config CRYPTO_LZ4HC
+	tristate "LZ4HC compression algorithm"
+	select CRYPTO_ALGAPI
+	select LZ4HC_COMPRESS
+	select LZ4_DECOMPRESS
+	help
+	  This is the LZ4 high compression mode algorithm.
+
 comment "Random Number Generation"

 config CRYPTO_ANSI_CPRNG
diff --git a/crypto/Makefile b/crypto/Makefile
index be1a1be..af87faa 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -84,6 +84,8 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
+obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
+obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
diff --git a/crypto/lz4.c b/crypto/lz4.c
new file mode 100644
index 0000000..98bfdd7
--- /dev/null
+++ b/crypto/lz4.c
@@ -0,0 +1,105 @@
+/*
+ * Cryptographic API.
+ *
+ * Copyright (c) 2013 Chanho Min <chanho.min@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/vmalloc.h>
+#include <linux/lz4.h>
+
+struct lz4_ctx {
+	void *lz4_comp_mem;
+};
+
+static int lz4_init(struct crypto_tfm *tfm)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->lz4_comp_mem = vmalloc(LZ4_MEM_COMPRESS);
+	if (!ctx->lz4_comp_mem)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void lz4_exit(struct crypto_tfm *tfm)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+	vfree(ctx->lz4_comp_mem);
+}
+
+static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+	size_t tmp_len = *dlen;
+	int err;
+
+	err = lz4_compress(src, slen, dst, &tmp_len, ctx->lz4_comp_mem);
+
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return 0;
+}
+
+static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int err;
+	size_t tmp_len = *dlen;
+
+	err = lz4_decompress(src, &slen, dst, tmp_len);
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return err;
+}
+
+static struct crypto_alg alg_lz4 = {
+	.cra_name		= "lz4",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct lz4_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(alg_lz4.cra_list),
+	.cra_init		= lz4_init,
+	.cra_exit		= lz4_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= lz4_compress_crypto,
+	.coa_decompress		= lz4_decompress_crypto } }
+};
+
+static int __init lz4_mod_init(void)
+{
+	return crypto_register_alg(&alg_lz4);
+}
+
+static void __exit lz4_mod_fini(void)
+{
+	crypto_unregister_alg(&alg_lz4);
+}
+
+module_init(lz4_mod_init);
+module_exit(lz4_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZ4 Compression Algorithm");
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
new file mode 100644
index 0000000..d3c9625
--- /dev/null
+++ b/crypto/lz4hc.c
@@ -0,0 +1,105 @@
+/*
+ * Cryptographic API.
+ *
+ * Copyright (c) 2013 Chanho Min <chanho.min@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/vmalloc.h>
+#include <linux/lz4.h>
+
+struct lz4hc_ctx {
+	void *lz4hc_comp_mem;
+};
+
+static int lz4hc_init(struct crypto_tfm *tfm)
+{
+	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->lz4hc_comp_mem = vmalloc(LZ4HC_MEM_COMPRESS);
+	if (!ctx->lz4hc_comp_mem)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void lz4hc_exit(struct crypto_tfm *tfm)
+{
+	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	vfree(ctx->lz4hc_comp_mem);
+}
+
+static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
+	size_t tmp_len = *dlen;
+	int err;
+
+	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx->lz4hc_comp_mem);
+
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return 0;
+}
+
+static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int err;
+	size_t tmp_len = *dlen;
+
+	err = lz4_decompress(src, &slen, dst, tmp_len);
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return err;
+}
+
+static struct crypto_alg alg_lz4hc = {
+	.cra_name		= "lz4hc",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct lz4hc_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(alg_lz4hc.cra_list),
+	.cra_init		= lz4hc_init,
+	.cra_exit		= lz4hc_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= lz4hc_compress_crypto,
+	.coa_decompress		= lz4hc_decompress_crypto } }
+};
+
+static int __init lz4hc_mod_init(void)
+{
+	return crypto_register_alg(&alg_lz4hc);
+}
+
+static void __exit lz4hc_mod_fini(void)
+{
+	crypto_unregister_alg(&alg_lz4hc);
+}
+
+module_init(lz4hc_mod_init);
+module_exit(lz4hc_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZ4HC Compression Algorithm");
-- 
1.7.9.5
