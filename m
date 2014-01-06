Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaAFIWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:22:40 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48849 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaAFIWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:22:38 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, hpa@zytor.com, ak@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, mingo@redhat.com, nico@linaro.org,
        x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 8/8] arm64: add Crypto Extensions based synchronous core AES cipher
Date: Mon,  6 Jan 2014 09:22:16 +0100
Message-Id: <1388996536-27014-9-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the core AES cipher using the Crypto Extensions,
using only NEON registers q0 and q1.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Makefile               |   1 +
 arch/arm64/crypto/Makefile        |  13 +++++
 arch/arm64/crypto/aes-ce-cipher.c | 112 ++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                    |   6 ++
 4 files changed, 132 insertions(+)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aes-ce-cipher.c

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index e0b75464b7f1..a4b3e253557d 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -46,6 +46,7 @@ core-y		+= arch/arm64/emu/
 core-y		+= arch/arm64/kernel/ arch/arm64/mm/
 core-$(CONFIG_KVM) += arch/arm64/kvm/
 core-$(CONFIG_XEN) += arch/arm64/xen/
+core-$(CONFIG_CRYPTO) += arch/arm64/crypto/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
new file mode 100644
index 000000000000..ac58945c50b3
--- /dev/null
+++ b/arch/arm64/crypto/Makefile
@@ -0,0 +1,13 @@
+#
+# linux/arch/arm64/crypto/Makefile
+#
+# Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+obj-$(CONFIG_CRYPTO_AES_ARM64_CE) += aes-ce-cipher.o
+
+CFLAGS_aes-ce-cipher.o += -march=armv8-a+crypto
diff --git a/arch/arm64/crypto/aes-ce-cipher.c b/arch/arm64/crypto/aes-ce-cipher.c
new file mode 100644
index 000000000000..dd132c2d69ab
--- /dev/null
+++ b/arch/arm64/crypto/aes-ce-cipher.c
@@ -0,0 +1,112 @@
+/*
+ * linux/arch/arm64/crypto/aes-sync.c
+ *
+ * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <crypto/aes.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+
+MODULE_DESCRIPTION("Synchronous AES cipher using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL");
+
+static struct cpu_feature const feat_hwcap_aes[] = {
+	{ CPU_FEATURE_HWCAP(HWCAP_AES) },
+	{ }
+};
+MODULE_DEVICE_TABLE(cpu, feat_hwcap_aes);
+
+static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 rounds = 6 + ctx->key_length / 4;
+
+	kernel_neon_begin_partial(2);
+
+	__asm__("	ld1		{v0.16b}, [%[in]]		;"
+		"	ld1		{v1.16b}, [%[key]], #16		;"
+		"0:	aese		v0.16b, v1.16b			;"
+		"	subs		%[rounds], %[rounds], #1	;"
+		"	ld1		{v1.16b}, [%[key]], #16		;"
+		"	beq		1f				;"
+		"	aesmc		v0.16b, v0.16b			;"
+		"	b		0b				;"
+		"1:	eor		v0.16b, v0.16b, v1.16b		;"
+		"	st1		{v0.16b}, [%[out]]		;"
+	: :
+		[out]		"r"(dst),
+		[in]		"r"(src),
+		[rounds]	"r"(rounds),
+		[key]		"r"(ctx->key_enc)
+	:			"cc");
+
+	kernel_neon_end();
+}
+
+static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 rounds = 6 + ctx->key_length / 4;
+
+	kernel_neon_begin_partial(2);
+
+	__asm__("	ld1		{v0.16b}, [%[in]]		;"
+		"	ld1		{v1.16b}, [%[key]], #16		;"
+		"0:	aesd		v0.16b, v1.16b			;"
+		"	ld1		{v1.16b}, [%[key]], #16		;"
+		"	subs		%[rounds], %[rounds], #1	;"
+		"	beq		1f				;"
+		"	aesimc		v0.16b, v0.16b			;"
+		"	b		0b				;"
+		"1:	eor		v0.16b, v0.16b, v1.16b		;"
+		"	st1		{v0.16b}, [%[out]]		;"
+	: :
+		[out]		"r"(dst),
+		[in]		"r"(src),
+		[rounds]	"r"(rounds),
+		[key]		"r"(ctx->key_dec)
+	:			"cc");
+
+	kernel_neon_end();
+}
+
+static struct crypto_alg aes_alg = {
+	.cra_name		= "aes",
+	.cra_driver_name	= "aes-ce",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_cipher = {
+		.cia_min_keysize	= AES_MIN_KEY_SIZE,
+		.cia_max_keysize	= AES_MAX_KEY_SIZE,
+		.cia_setkey		= crypto_aes_set_key,
+		.cia_encrypt		= aes_cipher_encrypt,
+		.cia_decrypt		= aes_cipher_decrypt
+	}
+};
+
+static int __init aes_mod_init(void)
+{
+	if (!(elf_hwcap & HWCAP_AES))
+		return -ENODEV;
+	return crypto_register_alg(&aes_alg);
+}
+
+static void __exit aes_mod_exit(void)
+{
+	crypto_unregister_alg(&aes_alg);
+}
+
+module_init(aes_mod_init);
+module_exit(aes_mod_exit);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7bcb70d216e1..f1d98bc346b6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -791,6 +791,12 @@ config CRYPTO_AES_ARM_BS
 	  This implementation does not rely on any lookup tables so it is
 	  believed to be invulnerable to cache timing attacks.
 
+config CRYPTO_AES_ARM64_CE
+	tristate "Synchronous AES cipher using ARMv8 Crypto Extensions"
+	depends on ARM64 && KERNEL_MODE_NEON
+	select CRYPTO_ALGAPI
+	select CRYPTO_AES
+
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
1.8.3.2

