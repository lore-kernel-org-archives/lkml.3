Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaJXWfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:35:50 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:40950 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026AbaJXWft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:35:49 -0400
Date: Fri, 24 Oct 2014 17:33:41 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 4/7] staging: skein: Adds Loadable Module Support
Message-ID: <929291496f96b0da2a04f16ff45a95816f249b28.1414189566.git.eric.rost@mybabylon.net>
References: <cover.1414189566.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414189566.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds loadable module support to the Skein Hashing Algorithm driver.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/Kconfig         |  2 +-
 drivers/staging/skein/Makefile        | 13 +++++++------
 drivers/staging/skein/skein_generic.c | 19 ++++++++++++++++++-
 3 files changed, 26 insertions(+), 8 deletions(-)

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
diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
index d8177cc..b7f947f 100644
--- a/drivers/staging/skein/Makefile
+++ b/drivers/staging/skein/Makefile
@@ -1,9 +1,10 @@
 #
 # Makefile for the skein secure hash algorithm
 #
-obj-$(CONFIG_CRYPTO_SKEIN) += skein_base.o \
-			      skein_api.o \
-			      skein_block.o \
-			      threefish_block.o \
-			      threefish_api.o \
-			      skein_generic.o
+obj-$(CONFIG_CRYPTO_SKEIN) += skein.o
+skein-y := skein_base.o \
+	   skein_api.o \
+	   skein_block.o \
+	   threefish_block.o \
+	   threefish_api.o \
+	   skein_generic.o
diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index f2d6dfb..60d16b6 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -16,6 +16,7 @@
  */
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <crypto/internal/hash.h>
 #include "skein_base.h"
 
@@ -139,6 +140,7 @@ static struct shash_alg alg256 = {
 		.cra_driver_name	=	"skein",
 		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize		=	SKEIN_256_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
 	}
 };
 
@@ -156,6 +158,7 @@ static struct shash_alg alg512 = {
 		.cra_driver_name	=	"skein",
 		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize		=	SKEIN_512_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
 	}
 };
 
@@ -173,6 +176,7 @@ static struct shash_alg alg1024 = {
 		.cra_driver_name	=	"skein",
 		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize		=	SKEIN_1024_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
 	}
 };
 
@@ -196,4 +200,17 @@ out:
 	return -1;
 }
 
-device_initcall(skein_generic_init);
+static void __exit skein_generic_fini(void)
+{
+	crypto_unregister_shash(&alg256);
+	crypto_unregister_shash(&alg512);
+	crypto_unregister_shash(&alg1024);
+}
+
+module_init(skein_generic_init);
+module_exit(skein_generic_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Skein Hash Algorithm");
+
+MODULE_ALIAS("skein");
-- 
2.1.1

