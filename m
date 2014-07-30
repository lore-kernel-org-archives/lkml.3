Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaG3QrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:47:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49586 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbaG3QrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:47:09 -0400
Date: Wed, 30 Jul 2014 18:47:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>, linux-crypto@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, crypto: Check if gas supports CRC32
Message-ID: <20140730164701.GA19604@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building current kernel with some old toolchain (gcc 4.1.2 and gas 2.17)
chokes with:

arch/x86/crypto/crc32c-pcl-intel-asm_64.S: Assembler messages:
arch/x86/crypto/crc32c-pcl-intel-asm_64.S:128: Error: no such instruction: `crc32b %bl,%r8d'
arch/x86/crypto/crc32c-pcl-intel-asm_64.S:204: Error: no such instruction: `crc32q -i*8(%rcx),%r8'
...

due to the fact that gas doesn't know the CRC32 instruction. Check that
before building.

Cc: linux-crypto@vger.kernel.org
Signed-off-by: Borislav Petkov <bp@suse.de>
---

So this is one possibility to address this. Code already
has the ifdeffery around crc_pcl() which is implemented in
crc32c-pcl-intel-asm_64.S so we can piggyback on that and not build that
file if gas doesn't know CRC32.

If no CRC32 support, it still builds fine silently, however it would be
better to probably say that due to old toolchain, kernel doesn't include
fast CRC32 stuff in crc32c-intel.ko.

Hmmm.


 arch/x86/crypto/Makefile            |  8 +++++++-
 arch/x86/crypto/crc32c-intel_glue.c |  7 ++++---
 scripts/gas-can-do-crc32.sh         | 12 ++++++++++++
 3 files changed, 23 insertions(+), 4 deletions(-)
 create mode 100755 scripts/gas-can-do-crc32.sh

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 61d6e281898b..707bf7ecb903 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -83,7 +83,13 @@ ifeq ($(avx2_supported),yes)
 sha1-ssse3-y += sha1_avx2_x86_64_asm.o
 endif
 crc32c-intel-y := crc32c-intel_glue.o
-crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
+
+gas_can_crc32 := $(srctree)/scripts/gas-can-do-crc32.sh
+CONFIG_GAS_SUPPORTS_CRC32=$(shell $(CONFIG_SHELL) $(gas_can_crc32) $(AS))
+
+ifdef CONFIG_64BIT
+crc32c-intel-$(CONFIG_GAS_SUPPORTS_CRC32) += crc32c-pcl-intel-asm_64.o
+endif
 crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
 sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
 sha512-ssse3-y := sha512-ssse3-asm.o sha512-avx-asm.o sha512-avx2-asm.o sha512_ssse3_glue.o
diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index 6812ad98355c..4ce8e2db2984 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -46,7 +46,7 @@
 #define REX_PRE
 #endif
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && defined(CONFIG_GAS_SUPPORTS_CRC32)
 /*
  * use carryless multiply version of crc32c when buffer
  * size is >= 512 (when eager fpu is enabled) or
@@ -181,7 +181,7 @@ static int crc32c_intel_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && defined(CONFIG_GAS_SUPPORTS_CRC32)
 static int crc32c_pcl_intel_update(struct shash_desc *desc, const u8 *data,
 			       unsigned int len)
 {
@@ -257,7 +257,8 @@ static int __init crc32c_intel_mod_init(void)
 {
 	if (!x86_match_cpu(crc32c_cpu_id))
 		return -ENODEV;
-#ifdef CONFIG_X86_64
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_GAS_SUPPORTS_CRC32)
 	if (cpu_has_pclmulqdq) {
 		alg.update = crc32c_pcl_intel_update;
 		alg.finup = crc32c_pcl_intel_finup;
diff --git a/scripts/gas-can-do-crc32.sh b/scripts/gas-can-do-crc32.sh
new file mode 100755
index 000000000000..88ff476bd3cc
--- /dev/null
+++ b/scripts/gas-can-do-crc32.sh
@@ -0,0 +1,12 @@
+#!/bin/sh
+
+TMP=$(mktemp)
+
+echo "crc32 %rax,%rbx" | $* --warn - -o $TMP 2>/dev/null
+if [ "$?" -eq "0" ]; then
+	echo y
+else
+	echo n
+fi
+
+rm -f $TMP
-- 
2.0.0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
