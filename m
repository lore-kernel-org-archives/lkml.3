Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaCaOju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:39:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41238 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaCaOjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:39:48 -0400
Date: Mon, 31 Mar 2014 16:39:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/hash changes for v3.15
Message-ID: <20140331143944.GA11793@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-hash-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-hash-for-linus

   # HEAD: 7a5917e9787dd73284f04e35c3cfdb39a67bf0d5 x86, hash: Simplify switch, add __init annotation

Small fixes and cleanups to the librarized arch_fast_hash() methods, 
used by the net/openvswitch code.

 Thanks,

	Ingo

------------------>
Jan Beulich (3):
      x86, hash: Fix build failure with older binutils
      x86, hash: Swap arguments passed to crc32_u32()
      x86, hash: Simplify switch, add __init annotation


 arch/x86/Makefile   |  1 +
 arch/x86/lib/hash.c | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eeda43a..f8842c4 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -152,6 +152,7 @@ cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTI
 
 # does binutils support specific instructions?
 asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
+asinstr += $(call as-instr,crc32l %eax$(comma)%eax,-DCONFIG_AS_CRC32=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
 avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
 
diff --git a/arch/x86/lib/hash.c b/arch/x86/lib/hash.c
index 3056702..ff4fa51 100644
--- a/arch/x86/lib/hash.c
+++ b/arch/x86/lib/hash.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/hash.h>
+#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
@@ -39,7 +40,11 @@
 
 static inline u32 crc32_u32(u32 crc, u32 val)
 {
+#ifdef CONFIG_AS_CRC32
 	asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));
+#else
+	asm (".byte 0xf2, 0x0f, 0x38, 0xf1, 0xc1" : "+a" (crc) : "c" (val));
+#endif
 	return crc;
 }
 
@@ -49,19 +54,18 @@ static u32 intel_crc4_2_hash(const void *data, u32 len, u32 seed)
 	u32 i, tmp = 0;
 
 	for (i = 0; i < len / 4; i++)
-		seed = crc32_u32(*p32++, seed);
+		seed = crc32_u32(seed, *p32++);
 
-	switch (3 - (len & 0x03)) {
-	case 0:
+	switch (len & 3) {
+	case 3:
 		tmp |= *((const u8 *) p32 + 2) << 16;
 		/* fallthrough */
-	case 1:
+	case 2:
 		tmp |= *((const u8 *) p32 + 1) << 8;
 		/* fallthrough */
-	case 2:
+	case 1:
 		tmp |= *((const u8 *) p32);
-		seed = crc32_u32(tmp, seed);
-	default:
+		seed = crc32_u32(seed, tmp);
 		break;
 	}
 
@@ -74,12 +78,12 @@ static u32 intel_crc4_2_hash2(const u32 *data, u32 len, u32 seed)
 	u32 i;
 
 	for (i = 0; i < len; i++)
-		seed = crc32_u32(*p32++, seed);
+		seed = crc32_u32(seed, *p32++);
 
 	return seed;
 }
 
-void setup_arch_fast_hash(struct fast_hash_ops *ops)
+void __init setup_arch_fast_hash(struct fast_hash_ops *ops)
 {
 	if (cpu_has_xmm4_2) {
 		ops->hash  = intel_crc4_2_hash;
