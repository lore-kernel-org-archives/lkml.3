Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaIQQhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:37:18 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44090 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbaIQQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:37:11 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v3 04/21] powerpc/8xx: Remove loading of r10 at end of FixupDAR
Message-Id: <20140917163657.9BC8E1AB033@localhost.localdomain>
Date: Wed, 17 Sep 2014 18:36:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2321f33790a6c5b80322d907a92d5739e7521a13, r10 is not used anymore
after FixupDAR. There is therefore no need to set it up with the value of DAR.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes in v2:
- None

Changes in v3:
- None

 arch/powerpc/kernel/head_8xx.S |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index fbe5d10..e59e39e 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -495,7 +495,7 @@ DataTLBError:
 	mfspr	r10, SPRN_DAR
 	cmpwi	cr0, r10, 0x00f0
 	beq-	FixupDAR	/* must be a buggy dcbX, icbi insn. */
-DARFixed:/* Return from dcbx instruction bug workaround, r10 holds value of DAR */
+DARFixed:/* Return from dcbx instruction bug workaround */
 #ifdef CONFIG_8xx_CPU6
 	lwz	r3, 8(r0)
 #endif
@@ -524,7 +524,7 @@ DARFixed:/* Return from dcbx instruction bug workaround, r10 holds value of DAR
 
 /* This is the procedure to calculate the data EA for buggy dcbx,dcbi instructions
  * by decoding the registers used by the dcbx instruction and adding them.
- * DAR is set to the calculated address and r10 also holds the EA on exit.
+ * DAR is set to the calculated address.
  */
  /* define if you don't want to use self modifying code */
 #define NO_SELF_MODIFYING_CODE
@@ -564,8 +564,7 @@ FixupDAR:/* Entry point for dcbx workaround. */
 	beq+	142f
 	cmpwi	cr0, r10, 1964	/* Is icbi? */
 	beq+	142f
-141:	mfspr	r10, SPRN_DAR	/* r10 must hold DAR at exit */
-	b	DARFixed	/* Nope, go back to normal TLB processing */
+141:	b	DARFixed	/* Nope, go back to normal TLB processing */
 
 144:	mfspr	r10, SPRN_DSISR
 	rlwinm	r10, r10,0,7,5	/* Clear store bit for buggy dcbst insn */
-- 
1.7.1

