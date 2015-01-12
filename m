Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbbALShb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:37:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58425 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbbALSax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laura Abbott <lauraa@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 194/216] arm64: Move cpu_resume into the text section
Date: Mon, 12 Jan 2015 18:29:32 +0000
Message-Id: <1421087394-2712-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laura Abbott <lauraa@codeaurora.org>

commit c3684fbb446501b48dec6677a6a9f61c215053de upstream.

The function cpu_resume currently lives in the .data section.
There's no reason for it to be there since we can use relative
instructions without a problem. Move a few cpu_resume data
structures out of the assembly file so the .data annotation
can be dropped completely and cpu_resume ends up in the read
only text section.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Kees Cook <keescook@chromium.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ luis: 3.16-stable prereq for
  f43c27188a49 "arm64: kernel: fix __cpu_suspend mm switch on warm-boot" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/sleep.S   | 36 ++++++------------------------------
 arch/arm64/kernel/suspend.c |  4 ++--
 2 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index a564b440416a..ede186cdd452 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -147,14 +147,12 @@ cpu_resume_after_mmu:
 	ret
 ENDPROC(cpu_resume_after_mmu)
 
-	.data
 ENTRY(cpu_resume)
 	bl	el2_setup		// if in EL2 drop to EL1 cleanly
 #ifdef CONFIG_SMP
 	mrs	x1, mpidr_el1
-	adr	x4, mpidr_hash_ptr
-	ldr	x5, [x4]
-	add	x8, x4, x5		// x8 = struct mpidr_hash phys address
+	adrp	x8, mpidr_hash
+	add x8, x8, #:lo12:mpidr_hash // x8 = struct mpidr_hash phys address
         /* retrieve mpidr_hash members to compute the hash */
 	ldr	x2, [x8, #MPIDR_HASH_MASK]
 	ldp	w3, w4, [x8, #MPIDR_HASH_SHIFTS]
@@ -164,14 +162,15 @@ ENTRY(cpu_resume)
 #else
 	mov	x7, xzr
 #endif
-	adr	x0, sleep_save_sp
+	adrp	x0, sleep_save_sp
+	add	x0, x0, #:lo12:sleep_save_sp
 	ldr	x0, [x0, #SLEEP_SAVE_SP_PHYS]
 	ldr	x0, [x0, x7, lsl #3]
 	/* load sp from context */
 	ldr	x2, [x0, #CPU_CTX_SP]
-	adr	x1, sleep_idmap_phys
+	adrp	x1, sleep_idmap_phys
 	/* load physical address of identity map page table in x1 */
-	ldr	x1, [x1]
+	ldr	x1, [x1, #:lo12:sleep_idmap_phys]
 	mov	sp, x2
 	/*
 	 * cpu_do_resume expects x0 to contain context physical address
@@ -180,26 +179,3 @@ ENTRY(cpu_resume)
 	bl	cpu_do_resume		// PC relative jump, MMU off
 	b	cpu_resume_mmu		// Resume MMU, never returns
 ENDPROC(cpu_resume)
-
-	.align 3
-mpidr_hash_ptr:
-	/*
-	 * offset of mpidr_hash symbol from current location
-	 * used to obtain run-time mpidr_hash address with MMU off
-         */
-	.quad	mpidr_hash - .
-/*
- * physical address of identity mapped page tables
- */
-	.type	sleep_idmap_phys, #object
-ENTRY(sleep_idmap_phys)
-	.quad	0
-/*
- * struct sleep_save_sp {
- *	phys_addr_t *save_ptr_stash;
- *	phys_addr_t save_ptr_stash_phys;
- * };
- */
-	.type	sleep_save_sp, #object
-ENTRY(sleep_save_sp)
-	.space	SLEEP_SAVE_SP_SZ	// struct sleep_save_sp
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 13ad4dbb1615..3771b72b6569 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -126,8 +126,8 @@ int __cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	return ret;
 }
 
-extern struct sleep_save_sp sleep_save_sp;
-extern phys_addr_t sleep_idmap_phys;
+struct sleep_save_sp sleep_save_sp;
+phys_addr_t sleep_idmap_phys;
 
 static int __init cpu_suspend_init(void)
 {
-- 
2.1.4

