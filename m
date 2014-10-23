Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaJWC1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:27:00 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:59912 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbaJWC07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:26:59 -0400
Date: Wed, 22 Oct 2014 21:24:37 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] staging: skein: Add Loadable Module Support
Message-ID: <6465068320badb589bcbd2cf37f4700e2cef0406.1414030776.git.eric.rost@mybabylon.net>
References: <cover.1414030776.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414030776.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds loadable module support for skein_mod, containing skein256,
skein512, and skein1024 algorithms.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/Kconfig         |   2 +-
 drivers/staging/skein/skein_generic.c | 122 ++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
index de8bdd7..012a823 100644
--- a/drivers/staging/skein/Kconfig
+++ b/drivers/staging/skein/Kconfig
@@ -1,5 +1,5 @@
 config CRYPTO_SKEIN
-	bool "Skein digest algorithm"
+	tristate "Skein digest algorithm"
 	depends on (X86 || UML_X86) && 64BIT && CRYPTO
 	select CRYPTO_HASH
 	select CRYPTO_ALGAPI
diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 14cc5bd..43e3cdf 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -16,6 +16,7 @@
  */
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/cryptohash.h>
 #include <linux/types.h>
@@ -50,6 +51,22 @@ static int skein256_final(struct shash_desc *desc, u8 *out)
 	return ret;
 }
 
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
 static int skein512_init(struct shash_desc *desc)
 {
 	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
@@ -78,6 +95,22 @@ static int skein512_final(struct shash_desc *desc, u8 *out)
 	return ret;
 }
 
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
 static int skein1024_init(struct shash_desc *desc)
 {
 	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
@@ -106,4 +139,93 @@ static int skein1024_final(struct shash_desc *desc, u8 *out)
 	return ret;
 }
 
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
+		.cra_driver_name	=	"skein-mod",
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SKEIN_256_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
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
+		.cra_driver_name	=	"skein-mod",
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SKEIN_512_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
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
+		.cra_driver_name	=	"skein-mod",
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SKEIN_1024_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
+	}
+};
+
+static int __init skein_generic_mod_init(void)
+{
+	return crypto_register_shash(&alg256) || crypto_register_shash(&alg512)
+		|| crypto_register_shash(&alg1024);
+}
+
+static void __exit skein_generic_mod_fini(void)
+{
+	crypto_unregister_shash(&alg256);
+	crypto_unregister_shash(&alg512);
+	crypto_unregister_shash(&alg1024);
+}
+
+module_init(skein_generic_mod_init);
+module_exit(skein_generic_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Skein Hash Algorithm");
 
+MODULE_ALIAS("skein");
-- 
2.1.1

