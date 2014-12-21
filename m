Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaLUUyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 15:54:53 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:59532 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaLUUyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 15:54:21 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, linux-crypto@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 4/5] MIPS: OCTEON: crypto: add MD5 module
Date: Sun, 21 Dec 2014 22:54:01 +0200
Message-Id: <1419195242-546-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
References: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OCTEON MD5 module.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/cavium-octeon/crypto/Makefile        |   2 +
 arch/mips/cavium-octeon/crypto/octeon-crypto.h |   2 +
 arch/mips/cavium-octeon/crypto/octeon-md5.c    | 216 +++++++++++++++++++++++++
 3 files changed, 220 insertions(+)
 create mode 100644 arch/mips/cavium-octeon/crypto/octeon-md5.c

diff --git a/arch/mips/cavium-octeon/crypto/Makefile b/arch/mips/cavium-octeon/crypto/Makefile
index 739b803..a74f76d 100644
--- a/arch/mips/cavium-octeon/crypto/Makefile
+++ b/arch/mips/cavium-octeon/crypto/Makefile
@@ -3,3 +3,5 @@
 #
 
 obj-y += octeon-crypto.o
+
+obj-$(CONFIG_CRYPTO_MD5_OCTEON) += octeon-md5.o
diff --git a/arch/mips/cavium-octeon/crypto/octeon-crypto.h b/arch/mips/cavium-octeon/crypto/octeon-crypto.h
index 3f65bc6..e2a4aec 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-crypto.h
+++ b/arch/mips/cavium-octeon/crypto/octeon-crypto.h
@@ -14,6 +14,8 @@
 #include <linux/sched.h>
 #include <asm/mipsregs.h>
 
+#define OCTEON_CR_OPCODE_PRIORITY 300
+
 extern unsigned long octeon_crypto_enable(struct octeon_cop2_state *state);
 extern void octeon_crypto_disable(struct octeon_cop2_state *state,
 				  unsigned long flags);
diff --git a/arch/mips/cavium-octeon/crypto/octeon-md5.c b/arch/mips/cavium-octeon/crypto/octeon-md5.c
new file mode 100644
index 0000000..b909881
--- /dev/null
+++ b/arch/mips/cavium-octeon/crypto/octeon-md5.c
@@ -0,0 +1,216 @@
+/*
+ * Cryptographic API.
+ *
+ * MD5 Message Digest Algorithm (RFC1321).
+ *
+ * Adapted for OCTEON by Aaro Koskinen <aaro.koskinen@iki.fi>.
+ *
+ * Based on crypto/md5.c, which is:
+ *
+ * Derived from cryptoapi implementation, originally based on the
+ * public domain implementation written by Colin Plumb in 1993.
+ *
+ * Copyright (c) Cryptoapi developers.
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <crypto/md5.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <asm/byteorder.h>
+#include <linux/cryptohash.h>
+#include <asm/octeon/octeon.h>
+#include <crypto/internal/hash.h>
+
+#include "octeon-crypto.h"
+
+/*
+ * We pass everything as 64-bit. OCTEON can handle misaligned data.
+ */
+
+static void octeon_md5_store_hash(struct md5_state *ctx)
+{
+	u64 *hash = (u64 *)ctx->hash;
+
+	write_octeon_64bit_hash_dword(hash[0], 0);
+	write_octeon_64bit_hash_dword(hash[1], 1);
+}
+
+static void octeon_md5_read_hash(struct md5_state *ctx)
+{
+	u64 *hash = (u64 *)ctx->hash;
+
+	hash[0] = read_octeon_64bit_hash_dword(0);
+	hash[1] = read_octeon_64bit_hash_dword(1);
+}
+
+static void octeon_md5_transform(const void *_block)
+{
+	const u64 *block = _block;
+
+	write_octeon_64bit_block_dword(block[0], 0);
+	write_octeon_64bit_block_dword(block[1], 1);
+	write_octeon_64bit_block_dword(block[2], 2);
+	write_octeon_64bit_block_dword(block[3], 3);
+	write_octeon_64bit_block_dword(block[4], 4);
+	write_octeon_64bit_block_dword(block[5], 5);
+	write_octeon_64bit_block_dword(block[6], 6);
+	octeon_md5_start(block[7]);
+}
+
+static int octeon_md5_init(struct shash_desc *desc)
+{
+	struct md5_state *mctx = shash_desc_ctx(desc);
+
+	mctx->hash[0] = cpu_to_le32(0x67452301);
+	mctx->hash[1] = cpu_to_le32(0xefcdab89);
+	mctx->hash[2] = cpu_to_le32(0x98badcfe);
+	mctx->hash[3] = cpu_to_le32(0x10325476);
+	mctx->byte_count = 0;
+
+	return 0;
+}
+
+static int octeon_md5_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
+{
+	struct md5_state *mctx = shash_desc_ctx(desc);
+	const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
+	struct octeon_cop2_state state;
+	unsigned long flags;
+
+	mctx->byte_count += len;
+
+	if (avail > len) {
+		memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
+		       data, len);
+		return 0;
+	}
+
+	memcpy((char *)mctx->block + (sizeof(mctx->block) - avail), data,
+	       avail);
+
+	local_bh_disable();
+	preempt_disable();
+	flags = octeon_crypto_enable(&state);
+	octeon_md5_store_hash(mctx);
+
+	octeon_md5_transform(mctx->block);
+	data += avail;
+	len -= avail;
+
+	while (len >= sizeof(mctx->block)) {
+		octeon_md5_transform(data);
+		data += sizeof(mctx->block);
+		len -= sizeof(mctx->block);
+	}
+
+	octeon_md5_read_hash(mctx);
+	octeon_crypto_disable(&state, flags);
+	preempt_enable();
+	local_bh_enable();
+
+	memcpy(mctx->block, data, len);
+
+	return 0;
+}
+
+static int octeon_md5_final(struct shash_desc *desc, u8 *out)
+{
+	struct md5_state *mctx = shash_desc_ctx(desc);
+	const unsigned int offset = mctx->byte_count & 0x3f;
+	char *p = (char *)mctx->block + offset;
+	int padding = 56 - (offset + 1);
+	struct octeon_cop2_state state;
+	unsigned long flags;
+
+	*p++ = 0x80;
+
+	local_bh_disable();
+	preempt_disable();
+	flags = octeon_crypto_enable(&state);
+	octeon_md5_store_hash(mctx);
+
+	if (padding < 0) {
+		memset(p, 0x00, padding + sizeof(u64));
+		octeon_md5_transform(mctx->block);
+		p = (char *)mctx->block;
+		padding = 56;
+	}
+
+	memset(p, 0, padding);
+	mctx->block[14] = cpu_to_le32(mctx->byte_count << 3);
+	mctx->block[15] = cpu_to_le32(mctx->byte_count >> 29);
+	octeon_md5_transform(mctx->block);
+
+	octeon_md5_read_hash(mctx);
+	octeon_crypto_disable(&state, flags);
+	preempt_enable();
+	local_bh_enable();
+
+	memcpy(out, mctx->hash, sizeof(mctx->hash));
+	memset(mctx, 0, sizeof(*mctx));
+
+	return 0;
+}
+
+static int octeon_md5_export(struct shash_desc *desc, void *out)
+{
+	struct md5_state *ctx = shash_desc_ctx(desc);
+
+	memcpy(out, ctx, sizeof(*ctx));
+	return 0;
+}
+
+static int octeon_md5_import(struct shash_desc *desc, const void *in)
+{
+	struct md5_state *ctx = shash_desc_ctx(desc);
+
+	memcpy(ctx, in, sizeof(*ctx));
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	=	MD5_DIGEST_SIZE,
+	.init		=	octeon_md5_init,
+	.update		=	octeon_md5_update,
+	.final		=	octeon_md5_final,
+	.export		=	octeon_md5_export,
+	.import		=	octeon_md5_import,
+	.descsize	=	sizeof(struct md5_state),
+	.statesize	=	sizeof(struct md5_state),
+	.base		=	{
+		.cra_name	=	"md5",
+		.cra_driver_name=	"octeon-md5",
+		.cra_priority	=	OCTEON_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static int __init md5_mod_init(void)
+{
+	if (!octeon_has_crypto())
+		return -ENOTSUPP;
+	return crypto_register_shash(&alg);
+}
+
+static void __exit md5_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(md5_mod_init);
+module_exit(md5_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MD5 Message Digest Algorithm (OCTEON)");
+MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
-- 
2.2.0

