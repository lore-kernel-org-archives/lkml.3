Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3AaV7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:59:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51536 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab3AaV7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:59:00 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <sboyd@codeaurora.org>, <will.deacon@arm.com>,
        <paulmck@linux.vnet.ibm.com>, <nico@linaro.org>,
        <catalin.marinas@arm.com>, <marc.zyngier@arm.com>,
        <linus.walleij@linaro.org>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v4 08/13] ARM: LPAE: factor out T1SZ and TTBR1 computations
Date: Thu, 31 Jan 2013 16:58:27 -0500
Message-ID: <1359669512-31276-9-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359669512-31276-1-git-send-email-cyril@ti.com>
References: <1359669512-31276-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the TTBR1 offset calculation and the T1SZ calculation out
of the TTB setup assembly code.  This should not affect functionality in
any way, but improves code readability as well as readability of subsequent
patches in this series.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/include/asm/pgtable-3level-hwdef.h |   20 ++++++++++++++++++
 arch/arm/mm/proc-v7-3level.S                |   29 ++++++++-------------------
 2 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
index d795282..e9d70a3 100644
--- a/arch/arm/include/asm/pgtable-3level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
@@ -74,4 +74,24 @@
 #define PHYS_MASK_SHIFT		(40)
 #define PHYS_MASK		((1ULL << PHYS_MASK_SHIFT) - 1)
 
+/*
+ * TTBR0/TTBR1 split (PAGE_OFFSET):
+ *   0x40000000: T0SZ = 2, T1SZ = 0 (not used)
+ *   0x80000000: T0SZ = 0, T1SZ = 1
+ *   0xc0000000: T0SZ = 0, T1SZ = 2
+ *
+ * Only use this feature if PHYS_OFFSET <= PAGE_OFFSET, otherwise
+ * booting secondary CPUs would end up using TTBR1 for the identity
+ * mapping set up in TTBR0.
+ */
+#if defined CONFIG_VMSPLIT_2G
+#define TTBR1_OFFSET	16			/* skip two L1 entries */
+#elif defined CONFIG_VMSPLIT_3G
+#define TTBR1_OFFSET	(4096 * (1 + 3))	/* only L2, skip pgd + 3*pmd */
+#else
+#define TTBR1_OFFSET	0
+#endif
+
+#define TTBR1_SIZE	(((PAGE_OFFSET >> 30) - 1) << 16)
+
 #endif
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index e64be21..e6576f5 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -113,7 +113,7 @@ ENDPROC(cpu_v7_set_pte_ext)
 	 */
 	.macro	v7_ttb_setup, zero, ttbr0, ttbr1, tmp
 	ldr	\tmp, =swapper_pg_dir		@ swapper_pg_dir virtual address
-	cmp	\ttbr1, \tmp			@ PHYS_OFFSET > PAGE_OFFSET? (branch below)
+	cmp	\ttbr1, \tmp			@ PHYS_OFFSET > PAGE_OFFSET?
 	mrc	p15, 0, \tmp, c2, c0, 2		@ TTB control register
 	orr	\tmp, \tmp, #TTB_EAE
 	ALT_SMP(orr	\tmp, \tmp, #TTB_FLAGS_SMP)
@@ -121,27 +121,14 @@ ENDPROC(cpu_v7_set_pte_ext)
 	ALT_SMP(orr	\tmp, \tmp, #TTB_FLAGS_SMP << 16)
 	ALT_UP(orr	\tmp, \tmp, #TTB_FLAGS_UP << 16)
 	/*
-	 * TTBR0/TTBR1 split (PAGE_OFFSET):
-	 *   0x40000000: T0SZ = 2, T1SZ = 0 (not used)
-	 *   0x80000000: T0SZ = 0, T1SZ = 1
-	 *   0xc0000000: T0SZ = 0, T1SZ = 2
-	 *
-	 * Only use this feature if PHYS_OFFSET <= PAGE_OFFSET, otherwise
-	 * booting secondary CPUs would end up using TTBR1 for the identity
-	 * mapping set up in TTBR0.
+	 * Only use split TTBRs if PHYS_OFFSET <= PAGE_OFFSET (cmp above),
+	 * otherwise booting secondary CPUs would end up using TTBR1 for the
+	 * identity mapping set up in TTBR0.
 	 */
-	bhi	9001f				@ PHYS_OFFSET > PAGE_OFFSET?
-	orr	\tmp, \tmp, #(((PAGE_OFFSET >> 30) - 1) << 16) @ TTBCR.T1SZ
-#if defined CONFIG_VMSPLIT_2G
-	/* PAGE_OFFSET == 0x80000000, T1SZ == 1 */
-	add	\ttbr1, \ttbr1, #1 << 4		@ skip two L1 entries
-#elif defined CONFIG_VMSPLIT_3G
-	/* PAGE_OFFSET == 0xc0000000, T1SZ == 2 */
-	add	\ttbr1, \ttbr1, #4096 * (1 + 3)	@ only L2 used, skip pgd+3*pmd
-#endif
-	/* CONFIG_VMSPLIT_1G does not need TTBR1 adjustment */
-9001:	mcr	p15, 0, \tmp, c2, c0, 2		@ TTB control register
-	mcrr	p15, 1, \ttbr1, \zero, c2	@ load TTBR1
+	orrls	\tmp, \tmp, #TTBR1_SIZE				@ TTBCR.T1SZ
+	mcr	p15, 0, \tmp, c2, c0, 2				@ TTBCR
+	addls	\ttbr1, \ttbr1, #TTBR1_OFFSET
+	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
 	.endm
 
 	__CPUINIT
-- 
1.7.9.5

