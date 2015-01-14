Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbbANIJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:09:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbbANHcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:32:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.18 130/150] arm64: Move cpu_resume into the text section
Date: Tue, 13 Jan 2015 23:23:21 -0800
Message-Id: <20150114072101.724676738@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/sleep.S   |   36 ++++++------------------------------
 arch/arm64/kernel/suspend.c |    4 ++--
 2 files changed, 8 insertions(+), 32 deletions(-)

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
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -126,8 +126,8 @@ int __cpu_suspend(unsigned long arg, int
 	return ret;
 }
 
-extern struct sleep_save_sp sleep_save_sp;
-extern phys_addr_t sleep_idmap_phys;
+struct sleep_save_sp sleep_save_sp;
+phys_addr_t sleep_idmap_phys;
 
 static int __init cpu_suspend_init(void)
 {


