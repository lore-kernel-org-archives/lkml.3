Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaDNRqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:46:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37795 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbaDNRox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:44:53 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: vegard.nossum@oracle.com, penberg@kernel.org
Cc: jamie.iles@oracle.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 3/4] x86/insn: Extract more information about instructions
Date: Mon, 14 Apr 2014 13:44:09 -0400
Message-Id: <1397497450-6440-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com>
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/lib/x86-opcode-map.txt provides us quite a lot of information about
instructions. So far we've discarded information we didn't need to use
elsewhere.

This patch extracts two more bits of information about instructions:

 - Mnemonic. We'd like to refer to instructions by their mnemonic, and not
by their opcode. This both makes code readable, and less confusing and
prone to typos since a single mnemonic may have quite a few different
opcodes representing it.

 - Memory access size. We're currently decoding the size (in bytes) of an
address size, and operand size. kmemcheck would like to know in addition
how many bytes were read/written from/to an address by a given instruction,
so we also keep the size of the memory access.

To sum it up, this patch translates more bits from
arch/x86/lib/x86-opcode-map.txt into C. There's no new additional information
being added to instructions, only what was there before.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/include/asm/inat.h          |  106 +++++++++++++++++-----------------
 arch/x86/include/asm/inat_types.h    |    9 ++-
 arch/x86/include/asm/insn.h          |    2 +
 arch/x86/kernel/kprobes/core.c       |   10 ++--
 arch/x86/lib/inat.c                  |   65 ++++++++++++---------
 arch/x86/lib/insn.c                  |   91 ++++++++++++++++++-----------
 arch/x86/tools/gen-insn-attr-x86.awk |   99 ++++++++++++++++++++++++-------
 arch/x86/tools/insn_sanity.c         |    8 +--
 8 files changed, 248 insertions(+), 142 deletions(-)

diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index 74a2e31..38de08a 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -96,126 +96,128 @@
 #define INAT_MAKE_IMM(imm)	(imm << INAT_IMM_OFFS)
 
 /* Attribute search APIs */
-extern insn_attr_t inat_get_opcode_attribute(insn_byte_t opcode);
+extern const insn_attr_t *inat_get_opcode(insn_byte_t opcode);
 extern int inat_get_last_prefix_id(insn_byte_t last_pfx);
-extern insn_attr_t inat_get_escape_attribute(insn_byte_t opcode,
-					     int lpfx_id,
-					     insn_attr_t esc_attr);
-extern insn_attr_t inat_get_group_attribute(insn_byte_t modrm,
+extern const insn_attr_t *inat_get_escape(insn_byte_t opcode, int lpfx_id,
+						insn_flags_t esc_flags);
+extern insn_flags_t inat_get_group_flags(insn_byte_t modrm,
 					    int lpfx_id,
-					    insn_attr_t esc_attr);
-extern insn_attr_t inat_get_avx_attribute(insn_byte_t opcode,
+					    insn_flags_t esc_flags);
+extern const insn_attr_t *inat_get_group(insn_byte_t modrm,
+						int lpfx_id,
+						insn_flags_t esc_flags);
+extern const insn_attr_t *inat_get_avx(insn_byte_t opcode,
 					  insn_byte_t vex_m,
 					  insn_byte_t vex_pp);
 
 /* Attribute checking functions */
-static inline int inat_is_legacy_prefix(insn_attr_t attr)
+static inline int inat_is_legacy_prefix(insn_flags_t flags)
 {
-	attr &= INAT_PFX_MASK;
-	return attr && attr <= INAT_LGCPFX_MAX;
+	flags &= INAT_PFX_MASK;
+	return flags && flags <= INAT_LGCPFX_MAX;
 }
 
-static inline int inat_is_address_size_prefix(insn_attr_t attr)
+static inline int inat_is_address_size_prefix(insn_flags_t flags)
 {
-	return (attr & INAT_PFX_MASK) == INAT_PFX_ADDRSZ;
+	return (flags & INAT_PFX_MASK) == INAT_PFX_ADDRSZ;
 }
 
-static inline int inat_is_operand_size_prefix(insn_attr_t attr)
+static inline int inat_is_operand_size_prefix(insn_flags_t flags)
 {
-	return (attr & INAT_PFX_MASK) == INAT_PFX_OPNDSZ;
+	return (flags & INAT_PFX_MASK) == INAT_PFX_OPNDSZ;
 }
 
-static inline int inat_is_rex_prefix(insn_attr_t attr)
+static inline int inat_is_rex_prefix(insn_flags_t flags)
 {
-	return (attr & INAT_PFX_MASK) == INAT_PFX_REX;
+	return (flags & INAT_PFX_MASK) == INAT_PFX_REX;
 }
 
-static inline int inat_last_prefix_id(insn_attr_t attr)
+static inline int inat_last_prefix_id(insn_flags_t flags)
 {
-	if ((attr & INAT_PFX_MASK) > INAT_LSTPFX_MAX)
+	if ((flags & INAT_PFX_MASK) > INAT_LSTPFX_MAX)
 		return 0;
 	else
-		return attr & INAT_PFX_MASK;
+		return flags & INAT_PFX_MASK;
 }
 
-static inline int inat_is_vex_prefix(insn_attr_t attr)
+static inline int inat_is_vex_prefix(insn_flags_t flags)
 {
-	attr &= INAT_PFX_MASK;
-	return attr == INAT_PFX_VEX2 || attr == INAT_PFX_VEX3;
+	flags &= INAT_PFX_MASK;
+	return flags == INAT_PFX_VEX2 || flags == INAT_PFX_VEX3;
 }
 
-static inline int inat_is_vex3_prefix(insn_attr_t attr)
+static inline int inat_is_vex3_prefix(insn_flags_t flags)
 {
-	return (attr & INAT_PFX_MASK) == INAT_PFX_VEX3;
+	return (flags & INAT_PFX_MASK) == INAT_PFX_VEX3;
 }
 
-static inline int inat_is_escape(insn_attr_t attr)
+static inline int inat_is_escape(insn_flags_t flags)
 {
-	return attr & INAT_ESC_MASK;
+	return flags & INAT_ESC_MASK;
 }
 
-static inline int inat_escape_id(insn_attr_t attr)
+static inline int inat_escape_id(insn_flags_t flags)
 {
-	return (attr & INAT_ESC_MASK) >> INAT_ESC_OFFS;
+	return (flags & INAT_ESC_MASK) >> INAT_ESC_OFFS;
 }
 
-static inline int inat_is_group(insn_attr_t attr)
+static inline int inat_is_group(insn_flags_t flags)
 {
-	return attr & INAT_GRP_MASK;
+	return flags & INAT_GRP_MASK;
 }
 
-static inline int inat_group_id(insn_attr_t attr)
+static inline int inat_group_id(insn_flags_t flags)
 {
-	return (attr & INAT_GRP_MASK) >> INAT_GRP_OFFS;
+	return (flags & INAT_GRP_MASK) >> INAT_GRP_OFFS;
 }
 
-static inline int inat_group_common_attribute(insn_attr_t attr)
+static inline int inat_group_common_flags(insn_flags_t flags)
 {
-	return attr & ~INAT_GRP_MASK;
+	return flags & ~INAT_GRP_MASK;
 }
 
-static inline int inat_has_immediate(insn_attr_t attr)
+static inline int inat_has_immediate(insn_flags_t flags)
 {
-	return attr & INAT_IMM_MASK;
+	return flags & INAT_IMM_MASK;
 }
 
-static inline int inat_immediate_size(insn_attr_t attr)
+static inline int inat_immediate_size(insn_flags_t flags)
 {
-	return (attr & INAT_IMM_MASK) >> INAT_IMM_OFFS;
+	return (flags & INAT_IMM_MASK) >> INAT_IMM_OFFS;
 }
 
-static inline int inat_has_modrm(insn_attr_t attr)
+static inline int inat_has_modrm(insn_flags_t flags)
 {
-	return attr & INAT_MODRM;
+	return flags & INAT_MODRM;
 }
 
-static inline int inat_is_force64(insn_attr_t attr)
+static inline int inat_is_force64(insn_flags_t flags)
 {
-	return attr & INAT_FORCE64;
+	return flags & INAT_FORCE64;
 }
 
-static inline int inat_has_second_immediate(insn_attr_t attr)
+static inline int inat_has_second_immediate(insn_flags_t flags)
 {
-	return attr & INAT_SCNDIMM;
+	return flags & INAT_SCNDIMM;
 }
 
-static inline int inat_has_moffset(insn_attr_t attr)
+static inline int inat_has_moffset(insn_flags_t flags)
 {
-	return attr & INAT_MOFFSET;
+	return flags & INAT_MOFFSET;
 }
 
-static inline int inat_has_variant(insn_attr_t attr)
+static inline int inat_has_variant(insn_flags_t flags)
 {
-	return attr & INAT_VARIANT;
+	return flags & INAT_VARIANT;
 }
 
-static inline int inat_accept_vex(insn_attr_t attr)
+static inline int inat_accept_vex(insn_flags_t flags)
 {
-	return attr & INAT_VEXOK;
+	return flags & INAT_VEXOK;
 }
 
-static inline int inat_must_vex(insn_attr_t attr)
+static inline int inat_must_vex(insn_flags_t flags)
 {
-	return attr & INAT_VEXONLY;
+	return flags & INAT_VEXONLY;
 }
 #endif
diff --git a/arch/x86/include/asm/inat_types.h b/arch/x86/include/asm/inat_types.h
index cb3c20c..028275a 100644
--- a/arch/x86/include/asm/inat_types.h
+++ b/arch/x86/include/asm/inat_types.h
@@ -22,7 +22,14 @@
  */
 
 /* Instruction attributes */
-typedef unsigned int insn_attr_t;
+typedef unsigned int insn_flags_t;
+
+typedef struct {
+	insn_flags_t	flags;
+	unsigned int	mnemonic;
+	char		mem_bytes;
+} insn_attr_t;
+
 typedef unsigned char insn_byte_t;
 typedef signed int insn_value_t;
 
diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 48eb30a..c4076f8 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -59,8 +59,10 @@ struct insn {
 	};
 
 	insn_attr_t attr;
+	unsigned int mnemonic;
 	unsigned char opnd_bytes;
 	unsigned char addr_bytes;
+	char mem_bytes;
 	unsigned char length;
 	unsigned char x86_64;
 
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 79a3f96..c9102b6 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -141,15 +141,15 @@ void __kprobes synthesize_relcall(void *from, void *to)
  */
 static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
 {
-	insn_attr_t attr;
+	insn_flags_t flags;
 
-	attr = inat_get_opcode_attribute((insn_byte_t)*insn);
-	while (inat_is_legacy_prefix(attr)) {
+	flags = inat_get_opcode((insn_byte_t)*insn)->flags;
+	while (inat_is_legacy_prefix(flags)) {
 		insn++;
-		attr = inat_get_opcode_attribute((insn_byte_t)*insn);
+		flags = inat_get_opcode((insn_byte_t)*insn)->flags;
 	}
 #ifdef CONFIG_X86_64
-	if (inat_is_rex_prefix(attr))
+	if (inat_is_rex_prefix(flags))
 		insn++;
 #endif
 	return insn;
diff --git a/arch/x86/lib/inat.c b/arch/x86/lib/inat.c
index 641a996..dddb9ff 100644
--- a/arch/x86/lib/inat.c
+++ b/arch/x86/lib/inat.c
@@ -19,26 +19,27 @@
  *
  */
 #include <asm/insn.h>
+#include <linux/stddef.h>
 
 /* Attribute tables are generated from opcode map */
 #include <asm/inat-tables.h>
 
 /* Attribute search APIs */
-insn_attr_t inat_get_opcode_attribute(insn_byte_t opcode)
+const insn_attr_t *inat_get_opcode(insn_byte_t opcode)
 {
-	return inat_primary_table[opcode];
+	return &inat_primary_table[opcode];
 }
 
 int inat_get_last_prefix_id(insn_byte_t last_pfx)
 {
-	insn_attr_t lpfx_attr;
+	insn_flags_t lpfx_flags;
 
-	lpfx_attr = inat_get_opcode_attribute(last_pfx);
-	return inat_last_prefix_id(lpfx_attr);
+	lpfx_flags = inat_get_opcode(last_pfx)->flags;
+	return inat_last_prefix_id(lpfx_flags);
 }
 
-insn_attr_t inat_get_escape_attribute(insn_byte_t opcode, int lpfx_id,
-				      insn_attr_t esc_attr)
+const insn_attr_t *inat_get_escape(insn_byte_t opcode, int lpfx_id,
+				      insn_flags_t esc_attr)
 {
 	const insn_attr_t *table;
 	int n;
@@ -47,51 +48,61 @@ insn_attr_t inat_get_escape_attribute(insn_byte_t opcode, int lpfx_id,
 
 	table = inat_escape_tables[n][0];
 	if (!table)
-		return 0;
-	if (inat_has_variant(table[opcode]) && lpfx_id) {
+		return NULL;
+	if (inat_has_variant(table[opcode].flags) && lpfx_id) {
 		table = inat_escape_tables[n][lpfx_id];
 		if (!table)
-			return 0;
+			return NULL;
 	}
-	return table[opcode];
+	return &table[opcode];
 }
 
-insn_attr_t inat_get_group_attribute(insn_byte_t modrm, int lpfx_id,
-				     insn_attr_t grp_attr)
+const insn_attr_t *inat_get_group(insn_byte_t modrm, int lpfx_id,
+				     insn_flags_t grp_flags)
 {
 	const insn_attr_t *table;
 	int n;
 
-	n = inat_group_id(grp_attr);
+	n = inat_group_id(grp_flags);
 
 	table = inat_group_tables[n][0];
 	if (!table)
-		return inat_group_common_attribute(grp_attr);
-	if (inat_has_variant(table[X86_MODRM_REG(modrm)]) && lpfx_id) {
+		return NULL;
+	if (inat_has_variant(table[X86_MODRM_REG(modrm)].flags) && lpfx_id) {
 		table = inat_group_tables[n][lpfx_id];
 		if (!table)
-			return inat_group_common_attribute(grp_attr);
+			return NULL;
 	}
-	return table[X86_MODRM_REG(modrm)] |
-	       inat_group_common_attribute(grp_attr);
+	return &table[X86_MODRM_REG(modrm)];
 }
 
-insn_attr_t inat_get_avx_attribute(insn_byte_t opcode, insn_byte_t vex_m,
-				   insn_byte_t vex_p)
+insn_flags_t inat_get_group_flags(insn_byte_t modrm, int lpfx_id,
+				     insn_flags_t grp_flags)
+{
+	const insn_attr_t *attr = inat_get_group(modrm, lpfx_id, grp_flags);
+	insn_flags_t insn_flags = inat_group_common_flags(grp_flags);
+
+	if (attr)
+		insn_flags |= attr->flags;
+
+	return insn_flags;
+}
+
+const insn_attr_t *inat_get_avx(insn_byte_t opcode, insn_byte_t vex_m,
+				insn_byte_t vex_p)
 {
 	const insn_attr_t *table;
 	if (vex_m > X86_VEX_M_MAX || vex_p > INAT_LSTPFX_MAX)
-		return 0;
+		return NULL;
 	/* At first, this checks the master table */
 	table = inat_avx_tables[vex_m][0];
 	if (!table)
-		return 0;
-	if (!inat_is_group(table[opcode]) && vex_p) {
+		return NULL;
+	if (!inat_is_group(table[opcode].flags) && vex_p) {
 		/* If this is not a group, get attribute directly */
 		table = inat_avx_tables[vex_m][vex_p];
 		if (!table)
-			return 0;
+			return NULL;
 	}
-	return table[opcode];
+	return &table[opcode];
 }
-
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 54fcffe..9005450 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -74,7 +74,7 @@ void insn_init(struct insn *insn, const void *kaddr, int x86_64)
 void insn_get_prefixes(struct insn *insn)
 {
 	struct insn_field *prefixes = &insn->prefixes;
-	insn_attr_t attr;
+	insn_flags_t flags;
 	insn_byte_t b, lb;
 	int i, nb;
 
@@ -84,8 +84,8 @@ void insn_get_prefixes(struct insn *insn)
 	nb = 0;
 	lb = 0;
 	b = peek_next(insn_byte_t, insn);
-	attr = inat_get_opcode_attribute(b);
-	while (inat_is_legacy_prefix(attr)) {
+	flags = inat_get_opcode(b)->flags;
+	while (inat_is_legacy_prefix(flags)) {
 		/* Skip if same prefix */
 		for (i = 0; i < nb; i++)
 			if (prefixes->bytes[i] == b)
@@ -94,13 +94,13 @@ void insn_get_prefixes(struct insn *insn)
 			/* Invalid instruction */
 			break;
 		prefixes->bytes[nb++] = b;
-		if (inat_is_address_size_prefix(attr)) {
+		if (inat_is_address_size_prefix(flags)) {
 			/* address size switches 2/4 or 4/8 */
 			if (insn->x86_64)
 				insn->addr_bytes ^= 12;
 			else
 				insn->addr_bytes ^= 6;
-		} else if (inat_is_operand_size_prefix(attr)) {
+		} else if (inat_is_operand_size_prefix(flags)) {
 			/* oprand size switches 2/4 */
 			insn->opnd_bytes ^= 6;
 		}
@@ -109,7 +109,7 @@ found:
 		insn->next_byte++;
 		lb = b;
 		b = peek_next(insn_byte_t, insn);
-		attr = inat_get_opcode_attribute(b);
+		flags = inat_get_opcode(b)->flags;
 	}
 	/* Set the last prefix */
 	if (lb && lb != insn->prefixes.bytes[3]) {
@@ -126,22 +126,24 @@ found:
 	/* Decode REX prefix */
 	if (insn->x86_64) {
 		b = peek_next(insn_byte_t, insn);
-		attr = inat_get_opcode_attribute(b);
-		if (inat_is_rex_prefix(attr)) {
+		flags = inat_get_opcode(b)->flags;
+		if (inat_is_rex_prefix(flags)) {
 			insn->rex_prefix.value = b;
 			insn->rex_prefix.nbytes = 1;
 			insn->next_byte++;
-			if (X86_REX_W(b))
+			if (X86_REX_W(b)) {
 				/* REX.W overrides opnd_size */
 				insn->opnd_bytes = 8;
+				insn->mem_bytes = 8;
+			}
 		}
 	}
 	insn->rex_prefix.got = 1;
 
 	/* Decode VEX prefix */
 	b = peek_next(insn_byte_t, insn);
-	attr = inat_get_opcode_attribute(b);
-	if (inat_is_vex_prefix(attr)) {
+	flags = inat_get_opcode(b)->flags;
+	if (inat_is_vex_prefix(flags)) {
 		insn_byte_t b2 = peek_nbyte_next(insn_byte_t, insn, 1);
 		if (!insn->x86_64) {
 			/*
@@ -154,14 +156,16 @@ found:
 		}
 		insn->vex_prefix.bytes[0] = b;
 		insn->vex_prefix.bytes[1] = b2;
-		if (inat_is_vex3_prefix(attr)) {
+		if (inat_is_vex3_prefix(flags)) {
 			b2 = peek_nbyte_next(insn_byte_t, insn, 2);
 			insn->vex_prefix.bytes[2] = b2;
 			insn->vex_prefix.nbytes = 3;
 			insn->next_byte += 3;
-			if (insn->x86_64 && X86_VEX_W(b2))
+			if (insn->x86_64 && X86_VEX_W(b2)) {
 				/* VEX.W overrides opnd_size */
 				insn->opnd_bytes = 8;
+				insn->mem_bytes = 8;
+			}
 		} else {
 			insn->vex_prefix.nbytes = 2;
 			insn->next_byte += 2;
@@ -181,7 +185,7 @@ err_out:
  * @insn:	&struct insn containing instruction
  *
  * Populates @insn->opcode, updates @insn->next_byte to point past the
- * opcode byte(s), and set @insn->attr (except for groups).
+ * opcode byte(s), and set @insn->attr.flags (except for groups).
  * If necessary, first collects any preceding (prefix) bytes.
  * Sets @insn->opcode.value = opcode1.  No effect if @insn->opcode.got
  * is already 1.
@@ -206,25 +210,38 @@ void insn_get_opcode(struct insn *insn)
 		insn_byte_t m, p;
 		m = insn_vex_m_bits(insn);
 		p = insn_vex_p_bits(insn);
-		insn->attr = inat_get_avx_attribute(op, m, p);
-		if (!inat_accept_vex(insn->attr) && !inat_is_group(insn->attr))
-			insn->attr = 0;	/* This instruction is bad */
+		insn->attr.flags = inat_get_avx(op, m, p)->flags;
+		insn->mnemonic = inat_get_avx(op, m, p)->mnemonic;
+		if (!insn->mem_bytes)
+			insn->mem_bytes = inat_get_avx(op, m, p)->mem_bytes;
+		if (!inat_accept_vex(insn->attr.flags) &&
+			!inat_is_group(insn->attr.flags))
+			insn->attr.flags = 0;	/* This instruction is bad */
 		goto end;	/* VEX has only 1 byte for opcode */
 	}
 
-	insn->attr = inat_get_opcode_attribute(op);
-	while (inat_is_escape(insn->attr)) {
+	insn->attr.flags = inat_get_opcode(op)->flags;
+	if (!insn->mem_bytes)
+		insn->mem_bytes = inat_get_opcode(op)->mem_bytes;
+	insn->mnemonic = inat_get_opcode(op)->mnemonic;
+	while (inat_is_escape(insn->attr.flags)) {
+		insn_flags_t flags = insn->attr.flags;
 		/* Get escaped opcode */
 		op = get_next(insn_byte_t, insn);
 		opcode->bytes[opcode->nbytes++] = op;
 		pfx_id = insn_last_prefix_id(insn);
-		insn->attr = inat_get_escape_attribute(op, pfx_id, insn->attr);
+		insn->attr.flags =
+			inat_get_escape(op, pfx_id, insn->attr.flags)->flags;
+		insn->mnemonic = inat_get_escape(op, pfx_id, flags)->mnemonic;
+		if (!insn->mem_bytes)
+			insn->mem_bytes = inat_get_escape(op, pfx_id, flags)->mem_bytes;
 	}
-	if (inat_must_vex(insn->attr))
-		insn->attr = 0;	/* This instruction is bad */
+	if (inat_must_vex(insn->attr.flags))
+		insn->attr.flags = 0;	/* This instruction is bad */
 end:
 	opcode->got = 1;
 
+
 err_out:
 	return;
 }
@@ -246,21 +263,27 @@ void insn_get_modrm(struct insn *insn)
 	if (!insn->opcode.got)
 		insn_get_opcode(insn);
 
-	if (inat_has_modrm(insn->attr)) {
+	if (inat_has_modrm(insn->attr.flags)) {
 		mod = get_next(insn_byte_t, insn);
 		modrm->value = mod;
 		modrm->nbytes = 1;
-		if (inat_is_group(insn->attr)) {
+		if (inat_is_group(insn->attr.flags)) {
+			insn_flags_t flags = insn->attr.flags;
 			pfx_id = insn_last_prefix_id(insn);
-			insn->attr = inat_get_group_attribute(mod, pfx_id,
-							      insn->attr);
-			if (insn_is_avx(insn) && !inat_accept_vex(insn->attr))
-				insn->attr = 0;	/* This is bad */
+			insn->attr.flags = inat_get_group(mod, pfx_id, insn->attr.flags)->flags;
+			insn->mnemonic = inat_get_group(mod, pfx_id, flags)->mnemonic;
+			if (!insn->mem_bytes)
+				insn->mem_bytes = inat_get_group(mod, pfx_id, flags)->mem_bytes;
+			if (insn_is_avx(insn) &&
+				!inat_accept_vex(insn->attr.flags))
+				insn->attr.flags = 0;	/* This is bad */
 		}
 	}
 
-	if (insn->x86_64 && inat_is_force64(insn->attr))
+	if (insn->x86_64 && inat_is_force64(insn->attr.flags)) {
 		insn->opnd_bytes = 8;
+		insn->mem_bytes = 8;
+	}
 	modrm->got = 1;
 
 err_out:
@@ -506,17 +529,17 @@ void insn_get_immediate(struct insn *insn)
 	if (!insn->displacement.got)
 		insn_get_displacement(insn);
 
-	if (inat_has_moffset(insn->attr)) {
+	if (inat_has_moffset(insn->attr.flags)) {
 		if (!__get_moffset(insn))
 			goto err_out;
 		goto done;
 	}
 
-	if (!inat_has_immediate(insn->attr))
+	if (!inat_has_immediate(insn->attr.flags))
 		/* no immediates */
 		goto done;
 
-	switch (inat_immediate_size(insn->attr)) {
+	switch (inat_immediate_size(insn->attr.flags)) {
 	case INAT_IMM_BYTE:
 		insn->immediate.value = get_next(char, insn);
 		insn->immediate.nbytes = 1;
@@ -551,7 +574,7 @@ void insn_get_immediate(struct insn *insn)
 		/* Here, insn must have an immediate, but failed */
 		goto err_out;
 	}
-	if (inat_has_second_immediate(insn->attr)) {
+	if (inat_has_second_immediate(insn->attr.flags)) {
 		insn->immediate2.value = get_next(char, insn);
 		insn->immediate2.nbytes = 1;
 	}
@@ -575,6 +598,8 @@ void insn_get_length(struct insn *insn)
 		return;
 	if (!insn->immediate.got)
 		insn_get_immediate(insn);
+	if (insn->mem_bytes == -1)
+		insn->mem_bytes = (insn->opnd_bytes < 4)?insn->opnd_bytes:4;
 	insn->length = (unsigned char)((unsigned long)insn->next_byte
 				     - (unsigned long)insn->kaddr);
 }
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 093a892..aa753ae 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -41,6 +41,8 @@ BEGIN {
 	delete etable
 	delete gtable
 	delete atable
+	delete opcode_list
+	opcode_cnt = 1
 
 	opnd_expr = "^[A-Za-z/]"
 	ext_expr = "^\\("
@@ -61,6 +63,17 @@ BEGIN {
 	imm_flag["Ov"] = "INAT_MOFFSET"
 	imm_flag["Lx"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 
+	mem_expr = "^[EQXY][a-z]"
+	mem_flag["Ev"] = "-1"
+	mem_flag["Eb"] = "1"
+	mem_flag["Ew"] = "2"
+	mem_flag["Ed"] = "4"
+	mem_flag["Yb"] = "1"
+	mem_flag["Xb"] = "1"
+	mem_flag["Yv"] = "-1"
+	mem_flag["Xv"] = "-1"
+	mem_flag["Qd"] = "8"
+
 	modrm_expr = "^([CDEGMNPQRSUVW/][a-z]+|NTA|T[012])"
 	force64_expr = "\\([df]64\\)"
 	rex_expr = "^REX(\\.[XRWB]+)*"
@@ -155,11 +168,22 @@ function array_size(arr,   i,c) {
 
 function print_table(tbl,name,fmt,n)
 {
-	print "const insn_attr_t " name " = {"
+	print "static const insn_attr_t " name " = {"
 	for (i = 0; i < n; i++) {
 		id = sprintf(fmt, i)
-		if (tbl[id])
-			print "	[" id "] = " tbl[id] ","
+		if (!tbl[id,"mnem"] && !tbl[id,"flags"])
+			continue
+		OLD_ORS = ORS
+		ORS = ""
+		print "	[" id "] = { "
+		if (tbl[id,"flags"])
+			print ".flags = " tbl[id,"flags"] ", "
+		if (tbl[id,"mnem"])
+			print ".mnemonic = "  tbl[id,"mnem"] ", "
+		if (tbl[id,"mem"])
+			print ".mem_bytes = " tbl[id,"mem"] ", "
+		ORS = OLD_ORS
+		print "} ,"
 	}
 	print "};"
 }
@@ -232,7 +256,7 @@ function add_flags(old,new) {
 }
 
 # convert operands to flags.
-function convert_operands(count,opnd,       i,j,imm,mod)
+function convert_operands(count,opnd,i,j,imm,mod)
 {
 	imm = null
 	mod = null
@@ -247,12 +271,25 @@ function convert_operands(count,opnd,       i,j,imm,mod)
 				imm = add_flags(imm, "INAT_SCNDIMM")
 			} else
 				imm = imm_flag[i]
-		} else if (match(i, modrm_expr))
+		} else if (match(i, modrm_expr)) {
 			mod = "INAT_MODRM"
+		} else if (match(i, mem_expr)) {
+			mem = mem_flag[i]
+		}
 	}
 	return add_flags(imm, mod)
 }
 
+function get_mem_bytes(count,opnd,i,j,imm,mod)
+{
+	for (j = 1; j <= count; j++) {
+		i = opnd[j]
+                if (match(i, mem_expr))
+                        return mem_flag[i];
+        }
+        return "0"
+}
+
 /^[0-9a-f]+\:/ {
 	if (NR == 1)
 		next
@@ -272,7 +309,7 @@ function convert_operands(count,opnd,       i,j,imm,mod)
 			semantic_error("Redefine escape (" ref ")")
 		escape[ref] = geid
 		geid++
-		table[idx] = "INAT_MAKE_ESCAPE(" escape[ref] ")"
+		table[idx,"flags"] = "INAT_MAKE_ESCAPE(" escape[ref] ")"
 		next
 	}
 
@@ -281,15 +318,23 @@ function convert_operands(count,opnd,       i,j,imm,mod)
 	i = 2
 	while (i <= NF) {
 		opcode = $(i++)
+		if (!(opcode in opcode_list)) {
+			opcode_list[opcode] = opcode
+			gsub(/[^A-Za-z0-9 \t]/, "_", opcode_list[opcode])
+			print "#define INSN_OPC_" opcode_list[opcode] " " opcode_cnt
+			opcode_cnt++
+		}
 		delete opnds
 		ext = null
 		flags = null
 		opnd = null
+		mem_bytes = 0
 		# parse one opcode
 		if (match($i, opnd_expr)) {
 			opnd = $i
 			count = split($(i++), opnds, ",")
 			flags = convert_operands(count, opnds)
+			mem_bytes = get_mem_bytes(count, opnds)
 		}
 		if (match($i, ext_expr))
 			ext = $(i++)
@@ -330,27 +375,41 @@ function convert_operands(count,opnd,       i,j,imm,mod)
 				semantic_error("Unknown prefix: " opcode)
 			flags = add_flags(flags, "INAT_MAKE_PREFIX(" prefix_num[opcode] ")")
 		}
-		if (length(flags) == 0)
-			continue
 		# check if last prefix
 		if (match(ext, lprefix1_expr)) {
-			lptable1[idx] = add_flags(lptable1[idx],flags)
-			variant = "INAT_VARIANT"
+			lptable1[idx,"mnem"] = "INSN_OPC_" opcode_list[opcode]
+			lptable1[idx,"mem"] = mem_bytes
+			if (length(flags)) {
+				lptable1[idx,"flags"] = add_flags(lptable1[idx,"flags"],flags)
+				variant = "INAT_VARIANT"
+			}
 		}
 		if (match(ext, lprefix2_expr)) {
-			lptable2[idx] = add_flags(lptable2[idx],flags)
-			variant = "INAT_VARIANT"
+			lptable2[idx,"mnem"] = "INSN_OPC_" opcode_list[opcode]
+			lptable2[idx,"mem"] = mem_bytes
+			if (length(flags)) {
+				lptable2[idx,"flags"] = add_flags(lptable2[idx,"flags"],flags)
+				variant = "INAT_VARIANT"
+			}
 		}
 		if (match(ext, lprefix3_expr)) {
-			lptable3[idx] = add_flags(lptable3[idx],flags)
-			variant = "INAT_VARIANT"
+			lptable3[idx,"mnem"] = "INSN_OPC_" opcode_list[opcode]
+			lptable3[idx,"mem"] = mem_bytes
+			if (length(flags)) {
+				lptable3[idx,"flags"] = add_flags(lptable3[idx,"flags"],flags)
+				variant	 = "INAT_VARIANT"
+			}
 		}
-		if (!match(ext, lprefix_expr)){
-			table[idx] = add_flags(table[idx],flags)
+		if (!match(ext, lprefix_expr)) {
+			table[idx,"mnem"] = "INSN_OPC_" opcode_list[opcode]
+			table[idx,"mem"] = mem_bytes
+			if (length(flags)) {
+				table[idx,"flags"] = add_flags(table[idx,"flags"],flags)
+			}
 		}
 	}
 	if (variant)
-		table[idx] = add_flags(table[idx],variant)
+		table[idx,"flags"] = add_flags(table[idx,"flags"],variant)
 }
 
 END {
@@ -358,7 +417,7 @@ END {
 		exit 1
 	# print escape opcode map's array
 	print "/* Escape opcode map array */"
-	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1]" \
+	print "static const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1]" \
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < geid; i++)
 		for (j = 0; j < max_lprefix; j++)
@@ -367,7 +426,7 @@ END {
 	print "};\n"
 	# print group opcode map's array
 	print "/* Group opcode map array */"
-	print "const insn_attr_t * const inat_group_tables[INAT_GRP_MAX + 1]"\
+	print "static const insn_attr_t * const inat_group_tables[INAT_GRP_MAX + 1]"\
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < ggid; i++)
 		for (j = 0; j < max_lprefix; j++)
@@ -376,7 +435,7 @@ END {
 	print "};\n"
 	# print AVX opcode map's array
 	print "/* AVX opcode map array */"
-	print "const insn_attr_t * const inat_avx_tables[X86_VEX_M_MAX + 1]"\
+	print "static const insn_attr_t * const inat_avx_tables[X86_VEX_M_MAX + 1]"\
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < gaid; i++)
 		for (j = 0; j < max_lprefix; j++)
diff --git a/arch/x86/tools/insn_sanity.c b/arch/x86/tools/insn_sanity.c
index 872eb60..377d273 100644
--- a/arch/x86/tools/insn_sanity.c
+++ b/arch/x86/tools/insn_sanity.c
@@ -89,10 +89,10 @@ static void dump_insn(FILE *fp, struct insn *insn)
 	dump_field(fp, "displacement", "\t",	&insn->displacement);
 	dump_field(fp, "immediate1", "\t",	&insn->immediate1);
 	dump_field(fp, "immediate2", "\t",	&insn->immediate2);
-	fprintf(fp, "\t.attr = %x, .opnd_bytes = %d, .addr_bytes = %d,\n",
-		insn->attr, insn->opnd_bytes, insn->addr_bytes);
-	fprintf(fp, "\t.length = %d, .x86_64 = %d, .kaddr = %p}\n",
-		insn->length, insn->x86_64, insn->kaddr);
+	fprintf(fp, "\t.attr.flags = %x, .opnd_bytes = %d, .addr_bytes = %d, .mem_bytes = %d,\n",
+		insn->attr.flags, insn->opnd_bytes, insn->addr_bytes, insn->mem_bytes);
+	fprintf(fp, "\t.length = %d, t.mnemonic = %d, .x86_64 = %d, .kaddr = %p}\n",
+		insn->length, insn->mnemonic, insn->x86_64, insn->kaddr);
 }
 
 static void dump_stream(FILE *fp, const char *msg, unsigned long nr_iter,
-- 
1.7.10.4

