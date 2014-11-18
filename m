Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaKROOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:14:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbaKROK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 204/206] ARC: Disable caches in early boot if so configured
Date: Tue, 18 Nov 2014 15:09:19 +0100
Message-Id: <d4023bb346873d9f367e174b3e8cc860959296b0.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

Requested-by: Noam Camus <noamc@ezchip.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arc/include/asm/cache.h |  27 +++++++++++
 arch/arc/kernel/head.S       |  38 ++++++++++++++--
 arch/arc/mm/cache_arc700.c   | 106 ++++++++++---------------------------------
 3 files changed, 87 insertions(+), 84 deletions(-)

diff --git a/arch/arc/include/asm/cache.h b/arch/arc/include/asm/cache.h
index e4abdaac6f9f..b7d4dab219b1 100644
--- a/arch/arc/include/asm/cache.h
+++ b/arch/arc/include/asm/cache.h
@@ -61,4 +61,31 @@ extern void read_decode_cache_bcr(void);
 
 #endif	/* !__ASSEMBLY__ */
 
+/* Instruction cache related Auxiliary registers */
+#define ARC_REG_IC_BCR		0x77	/* Build Config reg */
+#define ARC_REG_IC_IVIC		0x10
+#define ARC_REG_IC_CTRL		0x11
+#define ARC_REG_IC_IVIL		0x19
+#if defined(CONFIG_ARC_MMU_V3) || defined (CONFIG_ARC_MMU_V4)
+#define ARC_REG_IC_PTAG		0x1E
+#endif
+
+/* Bit val in IC_CTRL */
+#define IC_CTRL_CACHE_DISABLE   0x1
+
+/* Data cache related Auxiliary registers */
+#define ARC_REG_DC_BCR		0x72	/* Build Config reg */
+#define ARC_REG_DC_IVDC		0x47
+#define ARC_REG_DC_CTRL		0x48
+#define ARC_REG_DC_IVDL		0x4A
+#define ARC_REG_DC_FLSH		0x4B
+#define ARC_REG_DC_FLDL		0x4C
+#if defined(CONFIG_ARC_MMU_V3) || defined (CONFIG_ARC_MMU_V4)
+#define ARC_REG_DC_PTAG		0x5C
+#endif
+
+/* Bit val in DC_CTRL */
+#define DC_CTRL_INV_MODE_FLUSH  0x40
+#define DC_CTRL_FLUSH_STATUS    0x100
+
 #endif /* _ASM_CACHE_H */
diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
index fda7e4a7e361..a2bca37ef4dd 100644
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -12,10 +12,42 @@
  *      to skip certain things during boot on simulator
  */
 
+#include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include <asm/entry.h>
-#include <linux/linkage.h>
 #include <asm/arcregs.h>
+#include <asm/cache.h>
+
+.macro CPU_EARLY_SETUP
+
+	; Setting up Vectror Table (in case exception happens in early boot
+	sr	@_int_vec_base_lds, [AUX_INTR_VEC_BASE]
+
+	; Disable I-cache/D-cache if kernel so configured
+	lr	r5, [ARC_REG_IC_BCR]
+	breq    r5, 0, 1f		; I$ doesn't exist
+	lr	r5, [ARC_REG_IC_CTRL]
+#ifdef CONFIG_ARC_HAS_ICACHE
+	bclr	r5, r5, 0		; 0 - Enable, 1 is Disable
+#else
+	bset	r5, r5, 0		; I$ exists, but is not used
+#endif
+	sr	r5, [ARC_REG_IC_CTRL]
+
+1:
+	lr	r5, [ARC_REG_DC_BCR]
+	breq    r5, 0, 1f		; D$ doesn't exist
+	lr	r5, [ARC_REG_DC_CTRL]
+	bclr	r5, r5, 6		; Invalidate (discard w/o wback)
+#ifdef CONFIG_ARC_HAS_DCACHE
+	bclr	r5, r5, 0		; Enable (+Inv)
+#else
+	bset	r5, r5, 0		; Disable (+Inv)
+#endif
+	sr	r5, [ARC_REG_DC_CTRL]
+
+1:
+.endm
 
 	.cpu A7
 
@@ -27,7 +59,7 @@ stext:
 	; Don't clobber r0-r2 yet. It might have bootloader provided info
 	;-------------------------------------------------------------------
 
-	sr	@_int_vec_base_lds, [AUX_INTR_VEC_BASE]
+	CPU_EARLY_SETUP
 
 #ifdef CONFIG_SMP
 	; Ensure Boot (Master) proceeds. Others wait in platform dependent way
@@ -102,7 +134,7 @@ stext:
 
 first_lines_of_secondary:
 
-	sr	@_int_vec_base_lds, [AUX_INTR_VEC_BASE]
+	CPU_EARLY_SETUP
 
 	; setup per-cpu idle task as "current" on this CPU
 	ld	r0, [@secondary_idle_tsk]
diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
index fd9350fa5e6b..780103417a84 100644
--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -73,33 +73,6 @@
 #include <asm/cachectl.h>
 #include <asm/setup.h>
 
-/* Instruction cache related Auxiliary registers */
-#define ARC_REG_IC_BCR		0x77	/* Build Config reg */
-#define ARC_REG_IC_IVIC		0x10
-#define ARC_REG_IC_CTRL		0x11
-#define ARC_REG_IC_IVIL		0x19
-#if (CONFIG_ARC_MMU_VER > 2)
-#define ARC_REG_IC_PTAG		0x1E
-#endif
-
-/* Bit val in IC_CTRL */
-#define IC_CTRL_CACHE_DISABLE   0x1
-
-/* Data cache related Auxiliary registers */
-#define ARC_REG_DC_BCR		0x72	/* Build Config reg */
-#define ARC_REG_DC_IVDC		0x47
-#define ARC_REG_DC_CTRL		0x48
-#define ARC_REG_DC_IVDL		0x4A
-#define ARC_REG_DC_FLSH		0x4B
-#define ARC_REG_DC_FLDL		0x4C
-#if (CONFIG_ARC_MMU_VER > 2)
-#define ARC_REG_DC_PTAG		0x5C
-#endif
-
-/* Bit val in DC_CTRL */
-#define DC_CTRL_INV_MODE_FLUSH  0x40
-#define DC_CTRL_FLUSH_STATUS    0x100
-
 char *arc_cache_mumbojumbo(int c, char *buf, int len)
 {
 	int n = 0;
@@ -168,72 +141,43 @@ void read_decode_cache_bcr(void)
  */
 void arc_cache_init(void)
 {
-	unsigned int cpu = smp_processor_id();
-	struct cpuinfo_arc_cache *ic = &cpuinfo_arc700[cpu].icache;
-	struct cpuinfo_arc_cache *dc = &cpuinfo_arc700[cpu].dcache;
-	unsigned int dcache_does_alias, temp;
+	unsigned int __maybe_unused cpu = smp_processor_id();
+	struct cpuinfo_arc_cache __maybe_unused *ic, __maybe_unused *dc;
 	char str[256];
 
 	printk(arc_cache_mumbojumbo(0, str, sizeof(str)));
 
-	if (!ic->ver)
-		goto chk_dc;
-
 #ifdef CONFIG_ARC_HAS_ICACHE
-	/* 1. Confirm some of I-cache params which Linux assumes */
-	if (ic->line_len != ARC_ICACHE_LINE_LEN)
-		panic("Cache H/W doesn't match kernel Config");
-
-	if (ic->ver != CONFIG_ARC_MMU_VER)
-		panic("Cache ver doesn't match MMU ver\n");
-#endif
-
-	/* Enable/disable I-Cache */
-	temp = read_aux_reg(ARC_REG_IC_CTRL);
-
-#ifdef CONFIG_ARC_HAS_ICACHE
-	temp &= ~IC_CTRL_CACHE_DISABLE;
-#else
-	temp |= IC_CTRL_CACHE_DISABLE;
+	ic = &cpuinfo_arc700[cpu].icache;
+	if (ic->ver) {
+		if (ic->line_len != ARC_ICACHE_LINE_LEN)
+			panic("ICache line [%d] != kernel Config [%d]",
+			      ic->line_len, ARC_ICACHE_LINE_LEN);
+
+		if (ic->ver != CONFIG_ARC_MMU_VER)
+			panic("Cache ver [%d] doesn't match MMU ver [%d]\n",
+			      ic->ver, CONFIG_ARC_MMU_VER);
+	}
 #endif
 
-	write_aux_reg(ARC_REG_IC_CTRL, temp);
-
-chk_dc:
-	if (!dc->ver)
-		return;
-
 #ifdef CONFIG_ARC_HAS_DCACHE
-	if (dc->line_len != ARC_DCACHE_LINE_LEN)
-		panic("Cache H/W doesn't match kernel Config");
+	dc = &cpuinfo_arc700[cpu].dcache;
+	if (dc->ver) {
+		unsigned int dcache_does_alias;
 
-	/* check for D-Cache aliasing */
-	dcache_does_alias = (dc->sz / dc->assoc) > PAGE_SIZE;
+		if (dc->line_len != ARC_DCACHE_LINE_LEN)
+			panic("DCache line [%d] != kernel Config [%d]",
+			      dc->line_len, ARC_DCACHE_LINE_LEN);
 
-	if (dcache_does_alias && !cache_is_vipt_aliasing())
-		panic("Enable CONFIG_ARC_CACHE_VIPT_ALIASING\n");
-	else if (!dcache_does_alias && cache_is_vipt_aliasing())
-		panic("Don't need CONFIG_ARC_CACHE_VIPT_ALIASING\n");
-#endif
+		/* check for D-Cache aliasing */
+		dcache_does_alias = (dc->sz / dc->assoc) > PAGE_SIZE;
 
-	/* Set the default Invalidate Mode to "simpy discard dirty lines"
-	 *  as this is more frequent then flush before invalidate
-	 * Ofcourse we toggle this default behviour when desired
-	 */
-	temp = read_aux_reg(ARC_REG_DC_CTRL);
-	temp &= ~DC_CTRL_INV_MODE_FLUSH;
-
-#ifdef CONFIG_ARC_HAS_DCACHE
-	/* Enable D-Cache: Clear Bit 0 */
-	write_aux_reg(ARC_REG_DC_CTRL, temp & ~IC_CTRL_CACHE_DISABLE);
-#else
-	/* Flush D cache */
-	write_aux_reg(ARC_REG_DC_FLSH, 0x1);
-	/* Disable D cache */
-	write_aux_reg(ARC_REG_DC_CTRL, temp | IC_CTRL_CACHE_DISABLE);
+		if (dcache_does_alias && !cache_is_vipt_aliasing())
+			panic("Enable CONFIG_ARC_CACHE_VIPT_ALIASING\n");
+		else if (!dcache_does_alias && cache_is_vipt_aliasing())
+			panic("Don't need CONFIG_ARC_CACHE_VIPT_ALIASING\n");
+	}
 #endif
-
-	return;
 }
 
 #define OP_INV		0x1
-- 
2.1.3

