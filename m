Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaJWC0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:26:09 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57730 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaJWC0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:26:06 -0400
Date: Wed, 22 Oct 2014 21:23:51 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] staging: skein: Add Crypto API support
Message-ID: <e9cb9bb24d2c34a6f6d9459a22c79609ff5cb60e.1414030776.git.eric.rost@mybabylon.net>
References: <cover.1414030776.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414030776.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds crypto API support for the skein module. Also collapses the
threefish module into the skein module.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/Kconfig         |  22 +------
 drivers/staging/skein/Makefile        |  13 ++--
 drivers/staging/skein/skein.c         |   1 +
 drivers/staging/skein/skein.h         |   5 ++
 drivers/staging/skein/skein_generic.c | 109 ++++++++++++++++++++++++++++++++++
 5 files changed, 125 insertions(+), 25 deletions(-)
 create mode 100644 drivers/staging/skein/skein_generic.c

diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
index b9172bf..de8bdd7 100644
--- a/drivers/staging/skein/Kconfig
+++ b/drivers/staging/skein/Kconfig
@@ -1,8 +1,8 @@
 config CRYPTO_SKEIN
 	bool "Skein digest algorithm"
 	depends on (X86 || UML_X86) && 64BIT && CRYPTO
-	select CRYPTO_THREEFISH
 	select CRYPTO_HASH
+	select CRYPTO_ALGAPI
 	help
 	  Skein secure hash algorithm is one of 5 finalists from the NIST SHA3
 	  competition.
@@ -12,21 +12,5 @@ config CRYPTO_SKEIN
 
 	  http://www.skein-hash.info/sites/default/files/skein1.3.pdf
 
-	  for more information.  This module depends on the threefish block
-	  cipher module.
-
-config CRYPTO_THREEFISH
-	bool "Threefish tweakable block cipher"
-	depends on (X86 || UML_X86) && 64BIT && CRYPTO
-	select CRYPTO_ALGAPI
-	help
-	  Threefish cipher algorithm is the tweakable block cipher underneath
-	  the Skein family of secure hash algorithms.  Skein is one of 5
-	  finalists from the NIST SHA3 competition.
-
-	  Skein is optimized for modern, 64bit processors and is highly
-	  customizable.  See:
-
-	  http://www.skein-hash.info/sites/default/files/skein1.3.pdf
-
-	  for more information.
+	  for more information. This module also contains the threefish block
+	  cipher algorithm.
diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
index a14aadd..382b041 100644
--- a/drivers/staging/skein/Makefile
+++ b/drivers/staging/skein/Makefile
@@ -1,9 +1,10 @@
 #
 # Makefile for the skein secure hash algorithm
 #
-obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
-				skein_api.o \
-				skein_block.o
-
-obj-$(CONFIG_CRYPTO_THREEFISH) += threefish_block.o \
-				  threefish_api.o
+obj-$(CONFIG_CRYPTO_SKEIN) += skein_mod.o
+skein_mod-y := skein.o \
+	skein_api.o \
+	skein_block.o \
+	threefish_block.o \
+	threefish_api.o \
+	skein_generic.o
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 8cc8358..1c3933d 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -11,6 +11,7 @@
 #define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
 
 #include <linux/string.h>       /* get the memcpy/memset functions */
+#include <linux/export.h>
 #include "skein.h" /* get the Skein API definitions   */
 #include "skein_iv.h"    /* get precomputed IVs */
 #include "skein_block.h"
diff --git a/drivers/staging/skein/skein.h b/drivers/staging/skein/skein.h
index e6669f1..79fac00 100644
--- a/drivers/staging/skein/skein.h
+++ b/drivers/staging/skein/skein.h
@@ -28,6 +28,11 @@
 **
 ***************************************************************************/
 
+/*Skein digest sizes for crypto api*/
+#define SKEIN256_DIGEST_BIT_SIZE (256)
+#define SKEIN512_DIGEST_BIT_SIZE (512)
+#define SKEIN1024_DIGEST_BIT_SIZE (1024)
+
 #ifndef rotl_64
 #define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
 #endif
diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
new file mode 100644
index 0000000..14cc5bd
--- /dev/null
+++ b/drivers/staging/skein/skein_generic.c
@@ -0,0 +1,109 @@
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
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/cryptohash.h>
+#include <linux/types.h>
+#include "skein.h"
+#include <asm/byteorder.h>
+
+static int skein256_init(struct shash_desc *desc)
+{
+	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
+
+	int ret = skein_256_init(sctx, SKEIN256_DIGEST_BIT_SIZE);
+
+	return ret;
+}
+
+int skein256_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
+	size_t hbl = (size_t) len;
+	int ret = skein_256_update(sctx, data, hbl);
+
+	return ret;
+}
+EXPORT_SYMBOL(skein256_update);
+
+/* Add padding and return the message digest. */
+static int skein256_final(struct shash_desc *desc, u8 *out)
+{
+	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
+	int ret = skein_256_final(sctx, out);
+	return ret;
+}
+
+static int skein512_init(struct shash_desc *desc)
+{
+	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
+
+	int ret = skein_512_init(sctx, SKEIN512_DIGEST_BIT_SIZE);
+
+	return ret;
+}
+
+int skein512_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
+	size_t hbl = (size_t) len;
+	int ret = skein_512_update(sctx, data, hbl);
+
+	return ret;
+}
+EXPORT_SYMBOL(skein512_update);
+
+/* Add padding and return the message digest. */
+static int skein512_final(struct shash_desc *desc, u8 *out)
+{
+	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
+	int ret = skein_512_final(sctx, out);
+	return ret;
+}
+
+static int skein1024_init(struct shash_desc *desc)
+{
+	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
+
+	int ret = skein_1024_init(sctx, SKEIN1024_DIGEST_BIT_SIZE);
+
+	return ret;
+}
+
+int skein1024_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
+	size_t hbl = (size_t) len;
+	int ret = skein_1024_update(sctx, data, hbl);
+
+	return ret;
+}
+EXPORT_SYMBOL(skein1024_update);
+
+/* Add padding and return the message digest. */
+static int skein1024_final(struct shash_desc *desc, u8 *out)
+{
+	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
+	int ret = skein_1024_final(sctx, out);
+	return ret;
+}
+
+
-- 
2.1.1

