Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3AaV66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:58:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44492 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab3AaV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:58:54 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <sboyd@codeaurora.org>, <will.deacon@arm.com>,
        <paulmck@linux.vnet.ibm.com>, <nico@linaro.org>,
        <catalin.marinas@arm.com>, <marc.zyngier@arm.com>,
        <linus.walleij@linaro.org>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v4 05/13] ARM: LPAE: use phys_addr_t in switch_mm()
Date: Thu, 31 Jan 2013 16:58:24 -0500
Message-ID: <1359669512-31276-6-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359669512-31276-1-git-send-email-cyril@ti.com>
References: <1359669512-31276-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the switch_mm() processor functions to use phys_addr_t.
On LPAE systems, we now honor the upper 32-bits of the physical address that
is being passed in, and program these into TTBR as expected.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/include/asm/proc-fns.h |    4 ++--
 arch/arm/mm/proc-v7-3level.S    |   16 ++++++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index f3628fb..75b5f14 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -60,7 +60,7 @@ extern struct processor {
 	/*
 	 * Set the page table
 	 */
-	void (*switch_mm)(unsigned long pgd_phys, struct mm_struct *mm);
+	void (*switch_mm)(phys_addr_t pgd_phys, struct mm_struct *mm);
 	/*
 	 * Set a possibly extended PTE.  Non-extended PTEs should
 	 * ignore 'ext'.
@@ -82,7 +82,7 @@ extern void cpu_proc_init(void);
 extern void cpu_proc_fin(void);
 extern int cpu_do_idle(void);
 extern void cpu_dcache_clean_area(void *, int);
-extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
+extern void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
 #ifdef CONFIG_ARM_LPAE
 extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte);
 #else
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index 7b56386..e64be21 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -39,6 +39,14 @@
 #define TTB_FLAGS_SMP	(TTB_IRGN_WBWA|TTB_S|TTB_RGN_OC_WBWA)
 #define PMD_FLAGS_SMP	(PMD_SECT_WBWA|PMD_SECT_S)
 
+#ifndef __ARMEB__
+#  define rpgdl	r0
+#  define rpgdh	r1
+#else
+#  define rpgdl	r1
+#  define rpgdh	r0
+#endif
+
 /*
  * cpu_v7_switch_mm(pgd_phys, tsk)
  *
@@ -47,10 +55,10 @@
  */
 ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
-	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
-	and	r3, r1, #0xff
-	mov	r3, r3, lsl #(48 - 32)		@ ASID
-	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
+	ldr	r2, [r2, #MM_CONTEXT_ID]		@ get mm->context.id
+	and	r2, r2, #0xff				@ ASID
+	orr	rpgdh, rpgdh, r2, lsl #(48 - 32)	@ upper 32-bits of pgd
+	mcrr	p15, 0, rpgdl, rpgdh, c2		@ set TTB 0
 	isb
 #endif
 	mov	pc, lr
-- 
1.7.9.5

