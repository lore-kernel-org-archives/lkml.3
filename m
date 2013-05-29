Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012Ab3E2MoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:44:00 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36073 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965690Ab3E2Mn6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 29 May 2013 08:43:58 -0400
Message-Id: <51A6142A02000078000D99D8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 29 May 2013 13:43:54 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <herbert@gondor.hengli.com.au>, <ying.huang@intel.com>,
        <linux-kernel@vger.kernel.org>, <alexander_boyko@xyratex.com>
Subject: [PATCH] x86/crc32-pclmul: fix build with older binutils
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

binutils prior to 2.18 (e.g. the ones found on SLE10) don't support
assembling PEXTRD, so a macro based approach like the one for PCLMULQDQ
in the same file should be used.

This requires making the helper macros capable of recognizing 32-bit
general purpose register operands.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Alexander Boyko <alexander_boyko@xyratex.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/crc32-pclmul_asm.S |    2 +-
 arch/x86/include/asm/inst.h        |   74 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 3 deletions(-)

--- 3.10-rc3/arch/x86/crypto/crc32-pclmul_asm.S
+++ 3.10-rc3-x86-pextrd/arch/x86/crypto/crc32-pclmul_asm.S
@@ -240,7 +240,7 @@ fold_64:
 	pand    %xmm3, %xmm1
 	PCLMULQDQ 0x00, CONSTANT, %xmm1
 	pxor    %xmm2, %xmm1
-	pextrd  $0x01, %xmm1, %eax
+	PEXTRD  0x01, %xmm1, %eax
 
 	ret
 ENDPROC(crc32_pclmul_le_16)
--- 3.10-rc3/arch/x86/include/asm/inst.h
+++ 3.10-rc3-x86-pextrd/arch/x86/include/asm/inst.h
@@ -9,12 +9,68 @@
 
 #define REG_NUM_INVALID		100
 
-#define REG_TYPE_R64		0
-#define REG_TYPE_XMM		1
+#define REG_TYPE_R32		0
+#define REG_TYPE_R64		1
+#define REG_TYPE_XMM		2
 #define REG_TYPE_INVALID	100
 
+	.macro R32_NUM opd r32
+	\opd = REG_NUM_INVALID
+	.ifc \r32,%eax
+	\opd = 0
+	.endif
+	.ifc \r32,%ecx
+	\opd = 1
+	.endif
+	.ifc \r32,%edx
+	\opd = 2
+	.endif
+	.ifc \r32,%ebx
+	\opd = 3
+	.endif
+	.ifc \r32,%esp
+	\opd = 4
+	.endif
+	.ifc \r32,%ebp
+	\opd = 5
+	.endif
+	.ifc \r32,%esi
+	\opd = 6
+	.endif
+	.ifc \r32,%edi
+	\opd = 7
+	.endif
+#ifdef CONFIG_X86_64
+	.ifc \r32,%r8d
+	\opd = 8
+	.endif
+	.ifc \r32,%r9d
+	\opd = 9
+	.endif
+	.ifc \r32,%r10d
+	\opd = 10
+	.endif
+	.ifc \r32,%r11d
+	\opd = 11
+	.endif
+	.ifc \r32,%r12d
+	\opd = 12
+	.endif
+	.ifc \r32,%r13d
+	\opd = 13
+	.endif
+	.ifc \r32,%r14d
+	\opd = 14
+	.endif
+	.ifc \r32,%r15d
+	\opd = 15
+	.endif
+#endif
+	.endm
+
 	.macro R64_NUM opd r64
 	\opd = REG_NUM_INVALID
+#ifdef CONFIG_X86_64
 	.ifc \r64,%rax
 	\opd = 0
 	.endif
@@ -63,6 +119,7 @@
 	.ifc \r64,%r15
 	\opd = 15
 	.endif
+#endif
 	.endm
 
 	.macro XMM_NUM opd xmm
@@ -118,10 +175,13 @@
 	.endm
 
 	.macro REG_TYPE type reg
+	R32_NUM reg_type_r32 \reg
 	R64_NUM reg_type_r64 \reg
 	XMM_NUM reg_type_xmm \reg
 	.if reg_type_r64 <> REG_NUM_INVALID
 	\type = REG_TYPE_R64
+	.elseif reg_type_r32 <> REG_NUM_INVALID
+	\type = REG_TYPE_R32
 	.elseif reg_type_xmm <> REG_NUM_INVALID
 	\type = REG_TYPE_XMM
 	.else
@@ -162,6 +222,16 @@
 	.byte \imm8
 	.endm
 
+	.macro PEXTRD imm8 xmm gpr
+	R32_NUM extrd_opd1 \gpr
+	XMM_NUM extrd_opd2 \xmm
+	PFX_OPD_SIZE
+	PFX_REX extrd_opd1 extrd_opd2
+	.byte 0x0f, 0x3a, 0x16
+	MODRM 0xc0 extrd_opd1 extrd_opd2
+	.byte \imm8
+	.endm
+
 	.macro AESKEYGENASSIST rcon xmm1 xmm2
 	XMM_NUM aeskeygen_opd1 \xmm1
 	XMM_NUM aeskeygen_opd2 \xmm2



