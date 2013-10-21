Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3JUWn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:43:29 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39985 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3JUWnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:24 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 01/23] crypto: provide single place for hash algo information
Date: Mon, 21 Oct 2013 18:42:46 -0400
Message-Id: <1382395388-8108-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-1344-0000-0000-000002A32407
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

This patch provides a single place for information about hash algorithms,
such as hash sizes and kernel driver names, which will be used by IMA
and the public key code.

Changelog:
- Fix sparse and checkpatch warnings
- Move hash algo enums to uapi for userspace signing functions.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 crypto/Kconfig                 |  3 +++
 crypto/Makefile                |  1 +
 crypto/hash_info.c             | 56 ++++++++++++++++++++++++++++++++++++++++++
 include/crypto/hash_info.h     | 40 ++++++++++++++++++++++++++++++
 include/uapi/linux/hash_info.h | 37 ++++++++++++++++++++++++++++
 5 files changed, 137 insertions(+)
 create mode 100644 crypto/hash_info.c
 create mode 100644 include/crypto/hash_info.h
 create mode 100644 include/uapi/linux/hash_info.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69ce573..ba061b0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1386,6 +1386,9 @@ config CRYPTO_USER_API_SKCIPHER
 	  This option enables the user-spaces interface for symmetric
 	  key cipher algorithms.
 
+config CRYPTO_HASH_INFO
+	bool
+
 source "drivers/crypto/Kconfig"
 source crypto/asymmetric_keys/Kconfig
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 80019ba..b3a7e80 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -104,3 +104,4 @@ obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_XOR_BLOCKS) += xor.o
 obj-$(CONFIG_ASYNC_CORE) += async_tx/
 obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
+obj-$(CONFIG_CRYPTO_HASH_INFO) += hash_info.o
diff --git a/crypto/hash_info.c b/crypto/hash_info.c
new file mode 100644
index 0000000..3e7ff46
--- /dev/null
+++ b/crypto/hash_info.c
@@ -0,0 +1,56 @@
+/*
+ * Hash Info: Hash algorithms information
+ *
+ * Copyright (c) 2013 Dmitry Kasatkin <d.kasatkin@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <linux/export.h>
+#include <crypto/hash_info.h>
+
+const char *const hash_algo_name[HASH_ALGO__LAST] = {
+	[HASH_ALGO_MD4]		= "md4",
+	[HASH_ALGO_MD5]		= "md5",
+	[HASH_ALGO_SHA1]	= "sha1",
+	[HASH_ALGO_RIPE_MD_160]	= "rmd160",
+	[HASH_ALGO_SHA256]	= "sha256",
+	[HASH_ALGO_SHA384]	= "sha384",
+	[HASH_ALGO_SHA512]	= "sha512",
+	[HASH_ALGO_SHA224]	= "sha224",
+	[HASH_ALGO_RIPE_MD_128]	= "rmd128",
+	[HASH_ALGO_RIPE_MD_256]	= "rmd256",
+	[HASH_ALGO_RIPE_MD_320]	= "rmd320",
+	[HASH_ALGO_WP_256]	= "wp256",
+	[HASH_ALGO_WP_384]	= "wp384",
+	[HASH_ALGO_WP_512]	= "wp512",
+	[HASH_ALGO_TGR_128]	= "tgr128",
+	[HASH_ALGO_TGR_160]	= "tgr160",
+	[HASH_ALGO_TGR_192]	= "tgr192",
+};
+EXPORT_SYMBOL_GPL(hash_algo_name);
+
+const int hash_digest_size[HASH_ALGO__LAST] = {
+	[HASH_ALGO_MD4]		= MD5_DIGEST_SIZE,
+	[HASH_ALGO_MD5]		= MD5_DIGEST_SIZE,
+	[HASH_ALGO_SHA1]	= SHA1_DIGEST_SIZE,
+	[HASH_ALGO_RIPE_MD_160]	= RMD160_DIGEST_SIZE,
+	[HASH_ALGO_SHA256]	= SHA256_DIGEST_SIZE,
+	[HASH_ALGO_SHA384]	= SHA384_DIGEST_SIZE,
+	[HASH_ALGO_SHA512]	= SHA512_DIGEST_SIZE,
+	[HASH_ALGO_SHA224]	= SHA224_DIGEST_SIZE,
+	[HASH_ALGO_RIPE_MD_128]	= RMD128_DIGEST_SIZE,
+	[HASH_ALGO_RIPE_MD_256]	= RMD256_DIGEST_SIZE,
+	[HASH_ALGO_RIPE_MD_320]	= RMD320_DIGEST_SIZE,
+	[HASH_ALGO_WP_256]	= WP256_DIGEST_SIZE,
+	[HASH_ALGO_WP_384]	= WP384_DIGEST_SIZE,
+	[HASH_ALGO_WP_512]	= WP512_DIGEST_SIZE,
+	[HASH_ALGO_TGR_128]	= TGR128_DIGEST_SIZE,
+	[HASH_ALGO_TGR_160]	= TGR160_DIGEST_SIZE,
+	[HASH_ALGO_TGR_192]	= TGR192_DIGEST_SIZE,
+};
+EXPORT_SYMBOL_GPL(hash_digest_size);
diff --git a/include/crypto/hash_info.h b/include/crypto/hash_info.h
new file mode 100644
index 0000000..e1e5a3e
--- /dev/null
+++ b/include/crypto/hash_info.h
@@ -0,0 +1,40 @@
+/*
+ * Hash Info: Hash algorithms information
+ *
+ * Copyright (c) 2013 Dmitry Kasatkin <d.kasatkin@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_HASH_INFO_H
+#define _CRYPTO_HASH_INFO_H
+
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+
+#include <uapi/linux/hash_info.h>
+
+/* not defined in include/crypto/ */
+#define RMD128_DIGEST_SIZE      16
+#define RMD160_DIGEST_SIZE	20
+#define RMD256_DIGEST_SIZE      32
+#define RMD320_DIGEST_SIZE      40
+
+/* not defined in include/crypto/ */
+#define WP512_DIGEST_SIZE	64
+#define WP384_DIGEST_SIZE	48
+#define WP256_DIGEST_SIZE	32
+
+/* not defined in include/crypto/ */
+#define TGR128_DIGEST_SIZE 16
+#define TGR160_DIGEST_SIZE 20
+#define TGR192_DIGEST_SIZE 24
+
+extern const char *const hash_algo_name[HASH_ALGO__LAST];
+extern const int hash_digest_size[HASH_ALGO__LAST];
+
+#endif /* _CRYPTO_HASH_INFO_H */
diff --git a/include/uapi/linux/hash_info.h b/include/uapi/linux/hash_info.h
new file mode 100644
index 0000000..ca18c45
--- /dev/null
+++ b/include/uapi/linux/hash_info.h
@@ -0,0 +1,37 @@
+/*
+ * Hash Info: Hash algorithms information
+ *
+ * Copyright (c) 2013 Dmitry Kasatkin <d.kasatkin@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#ifndef _UAPI_LINUX_HASH_INFO_H
+#define _UAPI_LINUX_HASH_INFO_H
+
+enum hash_algo {
+	HASH_ALGO_MD4,
+	HASH_ALGO_MD5,
+	HASH_ALGO_SHA1,
+	HASH_ALGO_RIPE_MD_160,
+	HASH_ALGO_SHA256,
+	HASH_ALGO_SHA384,
+	HASH_ALGO_SHA512,
+	HASH_ALGO_SHA224,
+	HASH_ALGO_RIPE_MD_128,
+	HASH_ALGO_RIPE_MD_256,
+	HASH_ALGO_RIPE_MD_320,
+	HASH_ALGO_WP_256,
+	HASH_ALGO_WP_384,
+	HASH_ALGO_WP_512,
+	HASH_ALGO_TGR_128,
+	HASH_ALGO_TGR_160,
+	HASH_ALGO_TGR_192,
+	HASH_ALGO__LAST
+};
+
+#endif /* _UAPI_LINUX_HASH_INFO_H */
-- 
1.8.1.4

