Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3G3Jo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:44:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53236 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3G3JdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olivier DANET <odanet@caramail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 065/106] [PATCH] sparc32: vm_area_struct access for old Sun SPARCs.
Date: Tue, 30 Jul 2013 10:31:24 +0100
Message-Id: <1375176725-5825-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier DANET <odanet@caramail.com>

commit 961246b4ed8da3bcf4ee1eb9147f341013553e3c upstream.

Commit e4c6bfd2d79d063017ab19a18915f0bc759f32d9 ("mm: rearrange
vm_area_struct for fewer cache misses") changed the layout of the
vm_area_struct structure, it broke several SPARC32 assembly routines
which used numerical constants for accessing the vm_mm field.

This patch defines the VMA_VM_MM constant to replace the immediate values.

Signed-off-by: Olivier DANET <odanet@caramail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/kernel/asm-offsets.c |  2 ++
 arch/sparc/mm/hypersparc.S      |  8 ++++----
 arch/sparc/mm/swift.S           |  8 ++++----
 arch/sparc/mm/tsunami.S         |  6 +++---
 arch/sparc/mm/viking.S          | 10 +++++-----
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/kernel/asm-offsets.c b/arch/sparc/kernel/asm-offsets.c
index 68f7e11..ce48203 100644
--- a/arch/sparc/kernel/asm-offsets.c
+++ b/arch/sparc/kernel/asm-offsets.c
@@ -34,6 +34,8 @@ int foo(void)
 	DEFINE(AOFF_task_thread, offsetof(struct task_struct, thread));
 	BLANK();
 	DEFINE(AOFF_mm_context, offsetof(struct mm_struct, context));
+	BLANK();
+	DEFINE(VMA_VM_MM,    offsetof(struct vm_area_struct, vm_mm));
 
 	/* DEFINE(NUM_USER_SEGMENTS, TASK_SIZE>>28); */
 	return 0;
diff --git a/arch/sparc/mm/hypersparc.S b/arch/sparc/mm/hypersparc.S
index 44aad32..969f964 100644
--- a/arch/sparc/mm/hypersparc.S
+++ b/arch/sparc/mm/hypersparc.S
@@ -74,7 +74,7 @@ hypersparc_flush_cache_mm_out:
 
 	/* The things we do for performance... */
 hypersparc_flush_cache_range:
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 #ifndef CONFIG_SMP
 	ld	[%o0 + AOFF_mm_context], %g1
 	cmp	%g1, -1
@@ -163,7 +163,7 @@ hypersparc_flush_cache_range_out:
 	 */
 	/* Verified, my ass... */
 hypersparc_flush_cache_page:
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	ld	[%o0 + AOFF_mm_context], %g2
 #ifndef CONFIG_SMP
 	cmp	%g2, -1
@@ -284,7 +284,7 @@ hypersparc_flush_tlb_mm_out:
 	 sta	%g5, [%g1] ASI_M_MMUREGS
 
 hypersparc_flush_tlb_range:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
@@ -307,7 +307,7 @@ hypersparc_flush_tlb_range_out:
 	 sta	%g5, [%g1] ASI_M_MMUREGS
 
 hypersparc_flush_tlb_page:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	andn	%o1, (PAGE_SIZE - 1), %o1
diff --git a/arch/sparc/mm/swift.S b/arch/sparc/mm/swift.S
index c801c39..5d2b88d 100644
--- a/arch/sparc/mm/swift.S
+++ b/arch/sparc/mm/swift.S
@@ -105,7 +105,7 @@ swift_flush_cache_mm_out:
 
 	.globl	swift_flush_cache_range
 swift_flush_cache_range:
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	sub	%o2, %o1, %o2
 	sethi	%hi(4096), %o3
 	cmp	%o2, %o3
@@ -116,7 +116,7 @@ swift_flush_cache_range:
 
 	.globl	swift_flush_cache_page
 swift_flush_cache_page:
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 70:
 	ld	[%o0 + AOFF_mm_context], %g2
 	cmp	%g2, -1
@@ -219,7 +219,7 @@ swift_flush_sig_insns:
 	.globl	swift_flush_tlb_range
 	.globl	swift_flush_tlb_all
 swift_flush_tlb_range:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 swift_flush_tlb_mm:
 	ld	[%o0 + AOFF_mm_context], %g2
 	cmp	%g2, -1
@@ -233,7 +233,7 @@ swift_flush_tlb_all_out:
 
 	.globl	swift_flush_tlb_page
 swift_flush_tlb_page:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	andn	%o1, (PAGE_SIZE - 1), %o1
diff --git a/arch/sparc/mm/tsunami.S b/arch/sparc/mm/tsunami.S
index 4e55e8f..bf10a34 100644
--- a/arch/sparc/mm/tsunami.S
+++ b/arch/sparc/mm/tsunami.S
@@ -24,7 +24,7 @@
 	/* Sliiick... */
 tsunami_flush_cache_page:
 tsunami_flush_cache_range:
-	ld	[%o0 + 0x0], %o0	/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 tsunami_flush_cache_mm:
 	ld	[%o0 + AOFF_mm_context], %g2
 	cmp	%g2, -1
@@ -46,7 +46,7 @@ tsunami_flush_sig_insns:
 
 	/* More slick stuff... */
 tsunami_flush_tlb_range:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 tsunami_flush_tlb_mm:
 	ld	[%o0 + AOFF_mm_context], %g2
 	cmp	%g2, -1
@@ -65,7 +65,7 @@ tsunami_flush_tlb_out:
 
 	/* This one can be done in a fine grained manner... */
 tsunami_flush_tlb_page:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	andn	%o1, (PAGE_SIZE - 1), %o1
diff --git a/arch/sparc/mm/viking.S b/arch/sparc/mm/viking.S
index bf8ee06..852257f 100644
--- a/arch/sparc/mm/viking.S
+++ b/arch/sparc/mm/viking.S
@@ -108,7 +108,7 @@ viking_mxcc_flush_page:
 viking_flush_cache_page:
 viking_flush_cache_range:
 #ifndef CONFIG_SMP
-	ld	[%o0 + 0x0], %o0		/* XXX vma->vm_mm, GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 #endif
 viking_flush_cache_mm:
 #ifndef CONFIG_SMP
@@ -148,7 +148,7 @@ viking_flush_tlb_mm:
 #endif
 
 viking_flush_tlb_range:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
@@ -173,7 +173,7 @@ viking_flush_tlb_range:
 #endif
 
 viking_flush_tlb_page:
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	mov	SRMMU_CTX_REG, %g1
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
@@ -239,7 +239,7 @@ sun4dsmp_flush_tlb_range:
 	tst	%g5
 	bne	3f
 	 mov	SRMMU_CTX_REG, %g1
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
 	sethi	%hi(~((1 << SRMMU_PGDIR_SHIFT) - 1)), %o4
@@ -265,7 +265,7 @@ sun4dsmp_flush_tlb_page:
 	tst	%g5
 	bne	2f
 	 mov	SRMMU_CTX_REG, %g1
-	ld	[%o0 + 0x00], %o0	/* XXX vma->vm_mm GROSS XXX */
+	ld	[%o0 + VMA_VM_MM], %o0
 	ld	[%o0 + AOFF_mm_context], %o3
 	lda	[%g1] ASI_M_MMUREGS, %g5
 	and	%o1, PAGE_MASK, %o1
-- 
1.8.3.2

