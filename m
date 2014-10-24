Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbaJXWf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:35:27 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35836 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaJXWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:35:23 -0400
Date: Fri, 24 Oct 2014 17:33:15 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/7] staging: skein: Adds CryptoAPI Support
Message-ID: <4b6293e235bb6ebca0046b644fb18cbc48d1ed4f.1414189566.git.eric.rost@mybabylon.net>
References: <cover.1414189566.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414189566.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds CryptoAPI support to the Skein Hashing Algorithm driver.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/Makefile        |   3 +-
 drivers/staging/skein/skein_base.h    |   5 +
 drivers/staging/skein/skein_generic.c | 199 ++++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/skein/skein_generic.c

diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
index ca746a9..d8177cc 100644
--- a/drivers/staging/skein/Makefile
+++ b/drivers/staging/skein/Makefile
@@ -5,4 +5,5 @@ obj-$(CONFIG_CRYPTO_SKEIN) += skein_base.o \
 			      skein_api.o \
 			      skein_block.o \
 			      threefish_block.o \
-			      threefish_api.o
+			      threefish_api.o \
+			      skein_generic.o
diff --git a/drivers/staging/skein/skein_base.h b/drivers/staging/skein/skein_base.h
index e6669f1..9f10af9 100644
--- a/drivers/staging/skein/skein_base.h
+++ b/drivers/staging/skein/skein_base.h
@@ -28,6 +28,11 @@
 **
 ***************************************************************************/
 
+/*Skein digest sizes for crypto api*/
+#define SKEIN256_DIGEST_BIT_SIZE 256
+#define SKEIN512_DIGEST_BIT_SIZE 512
+#define SKEIN1024_DIGEST_BIT_SIZE 1024
+
 #ifndef rotl_64
 #define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
 #endif
diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
new file mode 100644
index 0000000..f2d6dfb
--- /dev/null
+++ b/drivers/staging/skein/skein_generic.c
@@ -0,0 +1,199 @@
+/*
+ * Cryptographic API.
+ *
+ * Skein256 Hash Algorithm.
+ *
+ * Derived from cryptoapi implementation, adapted for in-place
+ * scatterlist interface.
+ *
+ * Copyright (c) Eric Rost <eric.rost@mybabylon.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#include <linux/types.h>
+#include <linux/init.h>
+#include <crypto/internal/hash.h>
+#include "skein_base.h"
+
+
+static int skein256_init(struct shash_desc *desc)
+{
+	return skein_256_init((struct skein_256_ctx *) shash_desc_ctx(desc),
+			SKEIN256_DIGEST_BIT_SIZE);
+}
+
+int skein256_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	return skein_256_update((struct skein_256_ctx *)shash_desc_ctx(desc),
+				data, len);
+}
+
+static int skein256_final(struct shash_desc *desc, u8 *out)
+{
+	return skein_256_final((struct skein_256_ctx *)shash_desc_ctx(desc),
+				out);
+}
+
+static int skein256_export(struct shash_desc *desc, void *out)
+{
+	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+	return 0;
+}
+
+static int skein256_import(struct shash_desc *desc, const void *in)
+{
+	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+	return 0;
+}
+
+static int skein512_init(struct shash_desc *desc)
+{
+	return skein_512_init((struct skein_512_ctx *)shash_desc_ctx(desc),
+				SKEIN512_DIGEST_BIT_SIZE);
+}
+
+int skein512_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	return skein_512_update((struct skein_512_ctx *)shash_desc_ctx(desc),
+				data, len);
+}
+
+static int skein512_final(struct shash_desc *desc, u8 *out)
+{
+	return skein_512_final((struct skein_512_ctx *)shash_desc_ctx(desc),
+				out);
+}
+
+static int skein512_export(struct shash_desc *desc, void *out)
+{
+	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+	return 0;
+}
+
+static int skein512_import(struct shash_desc *desc, const void *in)
+{
+	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+	return 0;
+}
+
+static int skein1024_init(struct shash_desc *desc)
+{
+	return skein_1024_init((struct skein_1024_ctx *)shash_desc_ctx(desc),
+				SKEIN1024_DIGEST_BIT_SIZE);
+}
+
+int skein1024_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	return skein_1024_update((struct skein_1024_ctx *)shash_desc_ctx(desc),
+				data, len);
+}
+
+static int skein1024_final(struct shash_desc *desc, u8 *out)
+{
+	return skein_1024_final((struct skein_1024_ctx *)shash_desc_ctx(desc),
+			out);
+}
+
+static int skein1024_export(struct shash_desc *desc, void *out)
+{
+	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+	return 0;
+}
+
+static int skein1024_import(struct shash_desc *desc, const void *in)
+{
+	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+	return 0;
+}
+
+static struct shash_alg alg256 = {
+	.digestsize	=	(SKEIN256_DIGEST_BIT_SIZE / 8),
+	.init		=	skein256_init,
+	.update		=	skein256_update,
+	.final		=	skein256_final,
+	.export		=	skein256_export,
+	.import		=	skein256_import,
+	.descsize	=	sizeof(struct skein_256_ctx),
+	.statesize	=	sizeof(struct skein_256_ctx),
+	.base		=	{
+		.cra_name		=	"skein256",
+		.cra_driver_name	=	"skein",
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SKEIN_256_BLOCK_BYTES,
+	}
+};
+
+static struct shash_alg alg512 = {
+	.digestsize	=	(SKEIN512_DIGEST_BIT_SIZE / 8),
+	.init		=	skein512_init,
+	.update		=	skein512_update,
+	.final		=	skein512_final,
+	.export		=	skein512_export,
+	.import		=	skein512_import,
+	.descsize	=	sizeof(struct skein_512_ctx),
+	.statesize	=	sizeof(struct skein_512_ctx),
+	.base		=	{
+		.cra_name		=	"skein512",
+		.cra_driver_name	=	"skein",
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SKEIN_512_BLOCK_BYTES,
+	}
+};
+
+static struct shash_alg alg1024 = {
+	.digestsize	=	(SKEIN1024_DIGEST_BIT_SIZE / 8),
+	.init		=	skein1024_init,
+	.update		=	skein1024_update,
+	.final		=	skein1024_final,
+	.export		=	skein1024_export,
+	.import		=	skein1024_import,
+	.descsize	=	sizeof(struct skein_1024_ctx),
+	.statesize	=	sizeof(struct skein_1024_ctx),
+	.base		=	{
+		.cra_name		=	"skein1024",
+		.cra_driver_name	=	"skein",
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SKEIN_1024_BLOCK_BYTES,
+	}
+};
+
+static int __init skein_generic_init(void)
+{
+	if (crypto_register_shash(&alg256))
+		goto out;
+	if (crypto_register_shash(&alg512))
+		goto unreg256;
+	if (crypto_register_shash(&alg1024))
+		goto unreg512;
+
+	return 0;
+
+		
+unreg512:
+	crypto_unregister_shash(&alg512);
+unreg256:
+	crypto_unregister_shash(&alg256);
+out:
+	return -1;
+}
+
+device_initcall(skein_generic_init);
-- 
2.1.1

