Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbaEPSfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:35:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937AbaEPSfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:35:30 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/2] x86: extend insn decoder to understand xop and evex prefixes
Date: Fri, 16 May 2014 20:34:39 +0200
Message-Id: <1400265279-22503-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1400265279-22503-1-git-send-email-dvlasenk@redhat.com>
References: <1400265279-22503-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since xop and evex prefixes are extensions of vex mechanism,
they have similar bit layouts, and they can never be combined
(an instruction can have only one of them),
(ab)use insn->vex_prefix to store data of xop and evex too.

Users will need to conditionalize on insn->vex_prefix.bytes[0]
instead of insn->vex_prefix.nbytes if they want to determine
which of vex(-like) prefixes are there.

Instead of adding more inattr bits for these prefixes, drop
VEX inattr bits and use VEX opcode values directly to detect them.
There is no point in having additional level of indirection here.
(And we are close to running out of inattr bits for prefixes).

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/inat.h          | 14 -----------
 arch/x86/include/asm/insn.h          |  6 +++++
 arch/x86/lib/insn.c                  | 47 +++++++++++++++++++++++++-----------
 arch/x86/lib/x86-opcode-map.txt      |  4 +--
 arch/x86/tools/gen-insn-attr-x86.awk |  2 --
 5 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index 74a2e31..5aa6c05 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -45,9 +45,6 @@
 #define INAT_PFX_ADDRSZ	11	/* 0x67 */
 /* x86-64 REX prefix */
 #define INAT_PFX_REX	12	/* 0x4X */
-/* AVX VEX prefixes */
-#define INAT_PFX_VEX2	13	/* 2-bytes VEX prefix */
-#define INAT_PFX_VEX3	14	/* 3-bytes VEX prefix */
 
 #define INAT_LSTPFX_MAX	3
 #define INAT_LGCPFX_MAX	11
@@ -138,17 +135,6 @@ static inline int inat_last_prefix_id(insn_attr_t attr)
 		return attr & INAT_PFX_MASK;
 }
 
-static inline int inat_is_vex_prefix(insn_attr_t attr)
-{
-	attr &= INAT_PFX_MASK;
-	return attr == INAT_PFX_VEX2 || attr == INAT_PFX_VEX3;
-}
-
-static inline int inat_is_vex3_prefix(insn_attr_t attr)
-{
-	return (attr & INAT_PFX_MASK) == INAT_PFX_VEX3;
-}
-
 static inline int inat_is_escape(insn_attr_t attr)
 {
 	return attr & INAT_ESC_MASK;
diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 48eb30a..e098fec 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -83,6 +83,12 @@ struct insn {
 #define X86_REX_X(rex) ((rex) & 2)
 #define X86_REX_B(rex) ((rex) & 1)
 
+/* VEX and VEX-like multi-byte prefixes */
+#define X86_BYTE_VEX3  0xc4
+#define X86_BYTE_VEX2  0xc5
+#define X86_BYTE_XOP   0x8f
+#define X86_BYTE_EVEX  0x62
+
 /* VEX bit flags  */
 #define X86_VEX_W(vex)	((vex) & 0x80)	/* VEX3 Byte2 */
 #define X86_VEX_R(vex)	((vex) & 0x80)	/* VEX2/3 Byte1 */
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 829ca4c..2351977 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -138,31 +138,34 @@ found:
 	}
 	insn->rex_prefix.got = 1;
 
-	/* Decode VEX prefix */
+	/* Decode VEX prefixes et al. Layouts are:
+	 * vex2:     c5    rvvvvLpp
+	 * vex3/xop: c4/8f rxbmmmmm wvvvvLpp
+	 * evex:     62    rxbR00mm wvvvv1pp zllBVaaa
+	 */
 	b = peek_next(insn_byte_t, insn);
-	attr = inat_get_opcode_attribute(b);
-	if (inat_is_vex_prefix(attr)) {
+	if (b == X86_BYTE_VEX2 || b == X86_BYTE_VEX3 ||
+	    b == X86_BYTE_EVEX ||
+	    b == X86_BYTE_XOP) {
 		insn_byte_t b2 = peek_nbyte_next(insn_byte_t, insn, 1);
-		if (!insn->x86_64) {
+		/*
+		 * XOP: If the modrm.reg bits are 000, it's POP reg/mem.
+		 */
+		if (b == X86_BYTE_XOP && X86_MODRM_REG(b2) == 0) {
+			goto vex_end;
+		}
+		else if (!insn->x86_64) {
 			/*
 			 * In 32-bits mode, if the [7:6] bits (mod bits of
 			 * ModRM) on the second byte are not 11b, it is
-			 * LDS or LES.
+			 * LDS, LES or BOUND.
 			 */
 			if (X86_MODRM_MOD(b2) != 3)
 				goto vex_end;
 		}
 		insn->vex_prefix.bytes[0] = b;
 		insn->vex_prefix.bytes[1] = b2;
-		if (inat_is_vex3_prefix(attr)) {
-			b2 = peek_nbyte_next(insn_byte_t, insn, 2);
-			insn->vex_prefix.bytes[2] = b2;
-			insn->vex_prefix.nbytes = 3;
-			insn->next_byte += 3;
-			if (insn->x86_64 && X86_VEX_W(b2))
-				/* VEX.W overrides opnd_size */
-				insn->opnd_bytes = 8;
-		} else {
+		if (b == X86_BYTE_VEX2) {
 			/*
 			 * For VEX2, fake VEX3-like byte#2.
 			 * Makes it easier to decode vex.W, vex.vvvv,
@@ -171,7 +174,23 @@ found:
 			insn->vex_prefix.bytes[2] = b2 & 0x7f;
 			insn->vex_prefix.nbytes = 2;
 			insn->next_byte += 2;
+			goto vex_end;
+		}
+		b2 = peek_nbyte_next(insn_byte_t, insn, 2);
+		insn->vex_prefix.bytes[2] = b2;
+		if (insn->x86_64 && X86_VEX_W(b2)) {
+			/* VEX.W overrides opnd_size */
+			insn->opnd_bytes = 8;
+		}
+		if (b == X86_BYTE_VEX3 || b == X86_BYTE_XOP) {
+			insn->vex_prefix.nbytes = 3;
+			insn->next_byte += 3;
+			goto vex_end;
 		}
+		b2 = peek_nbyte_next(insn_byte_t, insn, 3);
+		insn->vex_prefix.bytes[3] = b2;
+		insn->vex_prefix.nbytes = 4;
+		insn->next_byte += 4;
 	}
 vex_end:
 	insn->vex_prefix.got = 1;
diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 1a2be7c..9d8a964 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -137,7 +137,7 @@ AVXcode:
 # 0x60 - 0x6f
 60: PUSHA/PUSHAD (i64)
 61: POPA/POPAD (i64)
-62: BOUND Gv,Ma (i64)
+62: BOUND Gv,Ma (i64) | EVEX+3byte (Prefix)
 63: ARPL Ew,Gw (i64) | MOVSXD Gv,Ev (o64)
 64: SEG=FS (Prefix)
 65: SEG=GS (Prefix)
@@ -184,7 +184,7 @@ AVXcode:
 8c: MOV Ev,Sw
 8d: LEA Gv,M
 8e: MOV Sw,Ew
-8f: Grp1A (1A) | POP Ev (d64)
+8f: Grp1A (1A) | POP Ev (d64) | XOP+2byte (Prefix)
 # 0x90 - 0x9f
 90: NOP | PAUSE (F3) | XCHG r8,rAX
 91: XCHG rCX/r9,rAX
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 093a892..b2db5ad 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -93,8 +93,6 @@ BEGIN {
 	prefix_num["SEG=GS"] = "INAT_PFX_GS"
 	prefix_num["SEG=SS"] = "INAT_PFX_SS"
 	prefix_num["Address-Size"] = "INAT_PFX_ADDRSZ"
-	prefix_num["VEX+1byte"] = "INAT_PFX_VEX2"
-	prefix_num["VEX+2byte"] = "INAT_PFX_VEX3"
 
 	clear_vars()
 }
-- 
1.8.1.4

