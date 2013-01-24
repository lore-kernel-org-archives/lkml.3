Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3AXLSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:18:00 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:42930 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab3AXLL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:11:59 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 56/71] ARC: Support for single cycle Close Coupled Mem (CCM)
Date: Thu, 24 Jan 2013 16:36:20 +0530
Message-ID: <1359025589-22277-37-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Includes mapping of CCMs in address space
* Annotations to move arbitrary code/data into CCM
* Moving some of the critical code/data into CCM
* Runtime detection/reporting

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig               |   27 ++++++++++++++++++++
 arch/arc/include/asm/linkage.h |   33 +++++++++++++++++++++++++
 arch/arc/kernel/entry.S        |    4 +-
 arch/arc/kernel/setup.c        |   53 +++++++++++++++++++++++++++++++++++++++-
 arch/arc/kernel/vmlinux.lds.S  |   21 ++++++++++++++++
 arch/arc/mm/tlbex.S            |    5 +--
 6 files changed, 137 insertions(+), 6 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 03183f6..2611a60 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -198,6 +198,33 @@ config ARC_CACHE_PAGES
 
 endif	#ARC_CACHE
 
+config ARC_HAS_ICCM
+	bool "Use ICCM"
+	help
+	  Single Cycle RAMS to store Fast Path Code
+	default n
+
+config ARC_ICCM_SZ
+	int "ICCM Size in KB"
+	default "64"
+	depends on ARC_HAS_ICCM
+
+config ARC_HAS_DCCM
+	bool "Use DCCM"
+	help
+	  Single Cycle RAMS to store Fast Path Data
+	default n
+
+config ARC_DCCM_SZ
+	int "DCCM Size in KB"
+	default "64"
+	depends on ARC_HAS_DCCM
+
+config ARC_DCCM_BASE
+	hex "DCCM map address"
+	default "0xA0000000"
+	depends on ARC_HAS_DCCM
+
 config ARC_HAS_HW_MPY
 	bool "Use Hardware Multiplier (Normal or Faster XMAC)"
 	default y
diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
index a45d1bb..0283e9e 100644
--- a/arch/arc/include/asm/linkage.h
+++ b/arch/arc/include/asm/linkage.h
@@ -25,6 +25,39 @@
 	.size \ name, ASM_PREV_SYM_ADDR(\name)
 .endm
 
+/* annotation for data we want in DCCM - if enabled in .config */
+.macro ARCFP_DATA nm
+#ifdef CONFIG_ARC_HAS_DCCM
+	.section .data.arcfp
+#else
+	.section .data
+#endif
+	.global \nm
+.endm
+
+/* annotation for data we want in DCCM - if enabled in .config */
+.macro ARCFP_CODE
+#ifdef CONFIG_ARC_HAS_ICCM
+	.section .text.arcfp, "ax",@progbits
+#else
+	.section .text, "ax",@progbits
+#endif
+.endm
+
+#else	/* !__ASSEMBLY__ */
+
+#ifdef CONFIG_ARC_HAS_ICCM
+#define __arcfp_code __attribute__((__section__(".text.arcfp")))
+#else
+#define __arcfp_code __attribute__((__section__(".text")))
+#endif
+
+#ifdef CONFIG_ARC_HAS_DCCM
+#define __arcfp_data __attribute__((__section__(".data.arcfp")))
+#else
+#define __arcfp_data __attribute__((__section__(".data")))
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index f8efade..3f628ca 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -149,7 +149,7 @@ VECTOR   reserved                ; Reserved Exceptions
 
 ;##################### Scratch Mem for IRQ stack switching #############
 
-	.section .data		; NOT .global
+ARCFP_DATA int1_saved_reg
 	.align 32
 	.type   int1_saved_reg, @object
 	.size   int1_saved_reg, 4
@@ -159,7 +159,7 @@ int1_saved_reg:
 /* Each Interrupt level needs it's own scratch */
 #ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS
 
-	.section .data		; NOT .global
+ARCFP_DATA int2_saved_reg
 	.type   int2_saved_reg, @object
 	.size   int2_saved_reg, 4
 int2_saved_reg:
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index e25538e..6cc361c 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -64,6 +64,33 @@ void __init read_arc_build_cfg_regs(void)
 	cpu->extn.ext_arith = read_aux_reg(ARC_REG_EXTARITH_BCR);
 	cpu->extn.crc = read_aux_reg(ARC_REG_CRC_BCR);
 
+	/* Note that we read the CCM BCRs independent of kernel config
+	 * This is to catch the cases where user doesn't know that
+	 * CCMs are present in hardware build
+	 */
+	{
+		struct bcr_iccm iccm;
+		struct bcr_dccm dccm;
+		struct bcr_dccm_base dccm_base;
+		unsigned int bcr_32bit_val;
+
+		bcr_32bit_val = read_aux_reg(ARC_REG_ICCM_BCR);
+		if (bcr_32bit_val) {
+			iccm = *((struct bcr_iccm *)&bcr_32bit_val);
+			cpu->iccm.base_addr = iccm.base << 16;
+			cpu->iccm.sz = 0x2000 << (iccm.sz - 1);
+		}
+
+		bcr_32bit_val = read_aux_reg(ARC_REG_DCCM_BCR);
+		if (bcr_32bit_val) {
+			dccm = *((struct bcr_dccm *)&bcr_32bit_val);
+			cpu->dccm.sz = 0x800 << (dccm.sz);
+
+			READ_BCR(ARC_REG_DCCMBASE_BCR, dccm_base);
+			cpu->dccm.base_addr = dccm_base.addr << 8;
+		}
+	}
+
 	READ_BCR(ARC_REG_XY_MEM_BCR, cpu->extn_xymem);
 
 	read_decode_mmu_bcr();
@@ -211,6 +238,30 @@ char *arc_extn_mumbojumbo(int cpu_id, char *buf, int len)
 	return buf;
 }
 
+void __init arc_chk_ccms(void)
+{
+#if defined(CONFIG_ARC_HAS_DCCM) || defined(CONFIG_ARC_HAS_ICCM)
+	struct cpuinfo_arc *cpu = &cpuinfo_arc700[smp_processor_id()];
+
+#ifdef CONFIG_ARC_HAS_DCCM
+	/*
+	 * DCCM can be arbit placed in hardware.
+	 * Make sure it's placement/sz matches what Linux is built with
+	 */
+	if ((unsigned int)__arc_dccm_base != cpu->dccm.base_addr)
+		panic("Linux built with incorrect DCCM Base address\n");
+
+	if (CONFIG_ARC_DCCM_SZ != cpu->dccm.sz)
+		panic("Linux built with incorrect DCCM Size\n");
+#endif
+
+#ifdef CONFIG_ARC_HAS_ICCM
+	if (CONFIG_ARC_ICCM_SZ != cpu->iccm.sz)
+		panic("Linux built with incorrect ICCM Size\n");
+#endif
+#endif
+}
+
 /*
  * Ensure that FP hardware and kernel config match
  * -If hardware contains DPFP, kernel needs to save/restore FPU state
@@ -255,7 +306,7 @@ void __init setup_processor(void)
 
 	arc_mmu_init();
 	arc_cache_init();
-
+	arc_chk_ccms();
 
 	printk(arc_extn_mumbojumbo(cpu_id, str, sizeof(str)));
 
diff --git a/arch/arc/kernel/vmlinux.lds.S b/arch/arc/kernel/vmlinux.lds.S
index 303ea01..8d3b0d4 100644
--- a/arch/arc/kernel/vmlinux.lds.S
+++ b/arch/arc/kernel/vmlinux.lds.S
@@ -23,6 +23,12 @@ jiffies = jiffies_64;
 
 SECTIONS
 {
+	/*
+	 * ICCM starts at 0x8000_0000. So if kernel is relocated to some other
+	 * address, make sure peripheral at 0x8z doesn't clash with ICCM
+	 * Essentially vector is also in ICCM.
+	 */
+
 	. = CONFIG_LINUX_LINK_BASE;
 
 	_int_vec_base_lds = .;
@@ -31,6 +37,13 @@ SECTIONS
 		. = ALIGN(PAGE_SIZE);
 	}
 
+#ifdef CONFIG_ARC_HAS_ICCM
+	.text.arcfp : {
+		*(.text.arcfp)
+		. = ALIGN(CONFIG_ARC_ICCM_SZ * 1024);
+	}
+#endif
+
 	/*
 	 * The reason for having a seperate subsection .init.ramfs is to
 	 * prevent objump from including it in kernel dumps
@@ -134,4 +147,12 @@ SECTIONS
 	.debug_loc 0 : { *(.debug_loc) }
 	.debug_macinfo 0 : { *(.debug_macinfo) }
 
+#ifdef CONFIG_ARC_HAS_DCCM
+	. = CONFIG_ARC_DCCM_BASE;
+	__arc_dccm_base = .;
+	.data.arcfp : {
+		*(.data.arcfp)
+	}
+	. = ALIGN(CONFIG_ARC_DCCM_SZ * 1024);
+#endif
 }
diff --git a/arch/arc/mm/tlbex.S b/arch/arc/mm/tlbex.S
index 4b1ad2d..9df765d 100644
--- a/arch/arc/mm/tlbex.S
+++ b/arch/arc/mm/tlbex.S
@@ -53,8 +53,7 @@
 ; For details refer to comments before TLBMISS_FREEUP_REGS below
 ;--------------------------------------------------------------------------
 
-	.section .data
-	.global ex_saved_reg1
+ARCFP_DATA ex_saved_reg1
 	.align 1 << L1_CACHE_SHIFT	; IMP: Must be Cache Line aligned
 	.type   ex_saved_reg1, @object
 #ifdef CONFIG_SMP
@@ -255,7 +254,7 @@ ex_saved_reg1:
 #endif
 .endm
 
-.section .text, "ax",@progbits	;Fast Path Code, candidate for ICCM
+ARCFP_CODE	;Fast Path Code, candidate for ICCM
 
 ;-----------------------------------------------------------------------------
 ; I-TLB Miss Exception Handler
-- 
1.7.4.1

