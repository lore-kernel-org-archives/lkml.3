Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab3CYBcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:32:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49707 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab3CYBcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:32:01 -0400
X-Spam-Score: -100.7
Message-ID: <514FA8F3.1030102@asianux.com>
Date: Mon, 25 Mar 2013 09:31:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, sfr@canb.auug.org.au,
        "paulus@samba.org" <paulus@samba.org>, matt@ozlabs.org,
        imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] PowerPC:kernel: make additional room in exception vector
 area
References: <51428C81.6000204@asianux.com> <25841.1363323174@ale.ozlabs.ibm.com> <5142AE27.7060003@asianux.com> <514AA0D9.1090509@asianux.com> <10123.1363906486@ale.ozlabs.ibm.com> <514C0061.8080004@asianux.com> <29457.1364169818@ale.ozlabs.ibm.com>
In-Reply-To: <29457.1364169818@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  The FWNMI region is fixed at 0x7000 and the vector are now overflowing
  that with allmodconfig. Fix that by moving slb_miss_realmode code out
  of that region as it doesn't need to be that close to the call sites
  (it is a _GLOBAL function)

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/powerpc/kernel/exceptions-64s.S |  144 +++++++++++++++++-----------------
 1 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 200afa5..56bd923 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1066,78 +1066,6 @@ unrecov_user_slb:
 #endif /* __DISABLED__ */
 
 
-/*
- * r13 points to the PACA, r9 contains the saved CR,
- * r12 contain the saved SRR1, SRR0 is still ready for return
- * r3 has the faulting address
- * r9 - r13 are saved in paca->exslb.
- * r3 is saved in paca->slb_r3
- * We assume we aren't going to take any exceptions during this procedure.
- */
-_GLOBAL(slb_miss_realmode)
-	mflr	r10
-#ifdef CONFIG_RELOCATABLE
-	mtctr	r11
-#endif
-
-	stw	r9,PACA_EXSLB+EX_CCR(r13)	/* save CR in exc. frame */
-	std	r10,PACA_EXSLB+EX_LR(r13)	/* save LR */
-
-	bl	.slb_allocate_realmode
-
-	/* All done -- return from exception. */
-
-	ld	r10,PACA_EXSLB+EX_LR(r13)
-	ld	r3,PACA_EXSLB+EX_R3(r13)
-	lwz	r9,PACA_EXSLB+EX_CCR(r13)	/* get saved CR */
-
-	mtlr	r10
-
-	andi.	r10,r12,MSR_RI	/* check for unrecoverable exception */
-	beq-	2f
-
-.machine	push
-.machine	"power4"
-	mtcrf	0x80,r9
-	mtcrf	0x01,r9		/* slb_allocate uses cr0 and cr7 */
-.machine	pop
-
-	RESTORE_PPR_PACA(PACA_EXSLB, r9)
-	ld	r9,PACA_EXSLB+EX_R9(r13)
-	ld	r10,PACA_EXSLB+EX_R10(r13)
-	ld	r11,PACA_EXSLB+EX_R11(r13)
-	ld	r12,PACA_EXSLB+EX_R12(r13)
-	ld	r13,PACA_EXSLB+EX_R13(r13)
-	rfid
-	b	.	/* prevent speculative execution */
-
-2:	mfspr	r11,SPRN_SRR0
-	ld	r10,PACAKBASE(r13)
-	LOAD_HANDLER(r10,unrecov_slb)
-	mtspr	SPRN_SRR0,r10
-	ld	r10,PACAKMSR(r13)
-	mtspr	SPRN_SRR1,r10
-	rfid
-	b	.
-
-unrecov_slb:
-	EXCEPTION_PROLOG_COMMON(0x4100, PACA_EXSLB)
-	DISABLE_INTS
-	bl	.save_nvgprs
-1:	addi	r3,r1,STACK_FRAME_OVERHEAD
-	bl	.unrecoverable_exception
-	b	1b
-
-
-#ifdef CONFIG_PPC_970_NAP
-power4_fixup_nap:
-	andc	r9,r9,r10
-	std	r9,TI_LOCAL_FLAGS(r11)
-	ld	r10,_LINK(r1)		/* make idle task do the */
-	std	r10,_NIP(r1)		/* equivalent of a blr */
-	blr
-#endif
-
 	.align	7
 	.globl alignment_common
 alignment_common:
@@ -1336,6 +1264,78 @@ _GLOBAL(opal_mc_secondary_handler)
 
 
 /*
+ * r13 points to the PACA, r9 contains the saved CR,
+ * r12 contain the saved SRR1, SRR0 is still ready for return
+ * r3 has the faulting address
+ * r9 - r13 are saved in paca->exslb.
+ * r3 is saved in paca->slb_r3
+ * We assume we aren't going to take any exceptions during this procedure.
+ */
+_GLOBAL(slb_miss_realmode)
+	mflr	r10
+#ifdef CONFIG_RELOCATABLE
+	mtctr	r11
+#endif
+
+	stw	r9,PACA_EXSLB+EX_CCR(r13)	/* save CR in exc. frame */
+	std	r10,PACA_EXSLB+EX_LR(r13)	/* save LR */
+
+	bl	.slb_allocate_realmode
+
+	/* All done -- return from exception. */
+
+	ld	r10,PACA_EXSLB+EX_LR(r13)
+	ld	r3,PACA_EXSLB+EX_R3(r13)
+	lwz	r9,PACA_EXSLB+EX_CCR(r13)	/* get saved CR */
+
+	mtlr	r10
+
+	andi.	r10,r12,MSR_RI	/* check for unrecoverable exception */
+	beq-	2f
+
+.machine	push
+.machine	"power4"
+	mtcrf	0x80,r9
+	mtcrf	0x01,r9		/* slb_allocate uses cr0 and cr7 */
+.machine	pop
+
+	RESTORE_PPR_PACA(PACA_EXSLB, r9)
+	ld	r9,PACA_EXSLB+EX_R9(r13)
+	ld	r10,PACA_EXSLB+EX_R10(r13)
+	ld	r11,PACA_EXSLB+EX_R11(r13)
+	ld	r12,PACA_EXSLB+EX_R12(r13)
+	ld	r13,PACA_EXSLB+EX_R13(r13)
+	rfid
+	b	.	/* prevent speculative execution */
+
+2:	mfspr	r11,SPRN_SRR0
+	ld	r10,PACAKBASE(r13)
+	LOAD_HANDLER(r10,unrecov_slb)
+	mtspr	SPRN_SRR0,r10
+	ld	r10,PACAKMSR(r13)
+	mtspr	SPRN_SRR1,r10
+	rfid
+	b	.
+
+unrecov_slb:
+	EXCEPTION_PROLOG_COMMON(0x4100, PACA_EXSLB)
+	DISABLE_INTS
+	bl	.save_nvgprs
+1:	addi	r3,r1,STACK_FRAME_OVERHEAD
+	bl	.unrecoverable_exception
+	b	1b
+
+
+#ifdef CONFIG_PPC_970_NAP
+power4_fixup_nap:
+	andc	r9,r9,r10
+	std	r9,TI_LOCAL_FLAGS(r11)
+	ld	r10,_LINK(r1)		/* make idle task do the */
+	std	r10,_NIP(r1)		/* equivalent of a blr */
+	blr
+#endif
+
+/*
  * Hash table stuff
  */
 	.align	7
-- 
1.7.7.6
